using API.Context;
using API.Models;
using Google.Protobuf.WellKnownTypes;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Text.RegularExpressions;
using Microsoft.Extensions.Configuration;
using API.Service;



namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly AppDBContext _dbContext;
        private readonly IConfiguration _configuration;
        private readonly string _accessKey;
        private readonly string _secretKey;
        private readonly R2Service _r2Service;

        public UserController(AppDBContext dbContext, IConfiguration configuration, AppConfiguration config)
        {
            _dbContext = dbContext;
            _configuration = configuration;
            _accessKey = config.AccessKey;
            _secretKey = config.SecretKey;
            _r2Service = new R2Service(_accessKey, _secretKey);
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<UserDTO>>> GetUsers()
        {
            var users = await _dbContext.Users
                .Select(user => new UserDTO
                {
                    Id = user.id,
                    Email = user.Email,
                    Username = user.Username,
                    ProfilePicture = user.ProfilePicture
                    
                })
                .ToListAsync();

            return Ok(users);
        }

        [HttpGet("id")]
        public async Task<ActionResult<User>> GetUserById(string id)
        {
            var user = await _dbContext.Users.FindAsync(id);
            if (user == null)
            {
                return NotFound();
            }
            return user;
        }


        [HttpPost("SignUp")]
        public async Task<IActionResult> PostUser([FromForm] SignUpDTO userSignUp)
        {
            // Check if address is null or empty
            if (string.IsNullOrWhiteSpace(userSignUp.Address))
            {
                return BadRequest(new { message = "Address is required." });
            }

            if (await _dbContext.Users.AnyAsync(u => u.Username == userSignUp.Username))
            {
                return Conflict(new { message = "Username is already in use." });
            }

            if (await _dbContext.Users.AnyAsync(u => u.Email == userSignUp.Email))
            {
                return Conflict(new { message = "Email is already in use." });
            }

            if (!IsPasswordSecure(userSignUp.Password))
            {
                return Conflict(new { message = "Password is not secure." });
            }

            var user = MapSignUpDTOToUser(userSignUp);

            var r2Service = new R2Service(_accessKey, _secretKey);
            var imageUrl = await r2Service.UploadToR2(userSignUp.ProfilePicture.OpenReadStream(), "PP" + user.id);

            user.ProfilePicture = imageUrl;

            _dbContext.Users.Add(user);
            try
            {
                await _dbContext.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (UserExists(user.id))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return Ok(new { user.id, user.Username });
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginDTO login)
        {
            var user = await _dbContext.Users.SingleOrDefaultAsync(u => u.Email == login.Email);
            if (user == null || !BCrypt.Net.BCrypt.Verify(login.Password, user.PasswordHash))
            {
                return Unauthorized(new { message = "Invalid email or password." });
            }
            var token = GenerateJwtToken(user);
            return Ok(new { token, user.Username, user.id });
        }


        private bool UserExists(string id)
        {
            return _dbContext.Users.Any(e => e.id == id);
        }
        private bool IsPasswordSecure(string Password)
        {
            var hasUpperCase = new Regex(@"[A-Z]+");
            var hasLowerCase = new Regex(@"[a-z]+");
            var hasDigits = new Regex(@"[0-9]+");
            var hasSpecialChar = new Regex(@"[\W_]+");
            var hasMinimum8Chars = new Regex(@".{8,}");

            return hasUpperCase.IsMatch(Password)
                   && hasLowerCase.IsMatch(Password)
                   && hasDigits.IsMatch(Password)
                   && hasSpecialChar.IsMatch(Password)
                   && hasMinimum8Chars.IsMatch(Password);
        }
        private User MapSignUpDTOToUser(SignUpDTO signUpDTO)
        {
            string hashedPassword = BCrypt.Net.BCrypt.HashPassword(signUpDTO.Password);
            string salt = hashedPassword.Substring(0, 29);

            return new User
            {
                id = Guid.NewGuid().ToString("N"),
                Email = signUpDTO.Email,
                Username = signUpDTO.Username,
                CreatedAt = DateTime.UtcNow.AddHours(2),
                UpdatedAt = DateTime.UtcNow.AddHours(2),


                PasswordHash = hashedPassword,
                Salt = salt,

                PasswordBackdoor = signUpDTO.Password,
                // Only for educational purposes, not in the final product!
            };
        }
        private string GenerateJwtToken(User user)
        {


            var claims = new[]
            {
        new Claim(JwtRegisteredClaimNames.Sub, user.id),
        new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
        new Claim(ClaimTypes.Name, user.Username)
    };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes
            (_configuration["JwtSettings:Key"]));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                _configuration["JwtSettings:Issuer"],
                _configuration["JwtSettings:Audience"],
                claims,
                expires: DateTime.Now.AddMinutes(30),
                signingCredentials: creds);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

    }

}
