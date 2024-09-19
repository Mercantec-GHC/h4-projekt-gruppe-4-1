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
using Microsoft.Extensions.Logging;



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
        // get all 
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
        // get by id
        [HttpGet("{id}")]
        public async Task<ActionResult<UserDTO>> GetUserById(string id)
        {
            var user = await _dbContext.Users
                .Where(u => u.id == id)
                .Select(user => new UserDTO
                {
                    Id = user.id,
                    Email = user.Email,
                    Username = user.Username,
                    ProfilePicture = user.ProfilePicture
                })
                .FirstOrDefaultAsync();

            if (user == null)
            {
                return NotFound();
            }

            return Ok(user);
        }
        // delete by id
        [HttpDelete("delete/{id}")]
        public async Task<ActionResult<UserDTO>> DeleteUserById(string id)
        {
            var user = await _dbContext.Users.FindAsync(id);
            if (user == null)
            {
                return NotFound();
            }

            _dbContext.Users.Remove(user);
            await _dbContext.SaveChangesAsync();

            return NoContent();
        }
        // Update user by id
        [HttpPut("update/{id}")]
        public async Task<ActionResult<UserDTO>> UpdateUserById(string id, [FromBody] UserDTO updatedUser)
        {
            var user = await _dbContext.Users.FindAsync(id);
            if (user == null)
            {
                return NotFound();
            }
            user.id = id;
            // Update the properties of the user with the new data from updatedUser
            user.FirstName = updatedUser.FirstName;
            user.LastName = updatedUser.LastName;
            user.Email = updatedUser.Email;
            user.Username = updatedUser.Username;
            // Check if ProfilePicture is provided, and update only if not null
            if (updatedUser.ProfilePicture != null)
            {
                user.ProfilePicture = updatedUser.ProfilePicture;
            }
            user.Address = updatedUser.Address;
            user.Postal = updatedUser.Postal;
            user.City = updatedUser.City;


            
            // Add other properties you want to update

            try
            {
                _dbContext.Users.Update(user);
                await _dbContext.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!_dbContext.Users.Any(u => u.id == id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Ok(updatedUser);  // Return the updated user information
        }

        // create user
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

            return Ok(new { user.id, user.Username ,user.Address, user.FirstName,user.Email, user.LastName,user.City,user.Postal,user.ProfilePicture
            });
        }
        // login
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
                FirstName = signUpDTO.FirstName,
                LastName = signUpDTO.LastName,
                Address = signUpDTO.Address,
                Postal = signUpDTO.Postal,
                City = signUpDTO.City,
            

                CreatedAt = DateTime.UtcNow.AddHours(2),
                UpdatedAt = DateTime.UtcNow.AddHours(2),

                PasswordHash = hashedPassword,
                Salt = salt,

                PasswordBackdoor = signUpDTO.Password, // Only for educational purposes, not in the final product!
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
