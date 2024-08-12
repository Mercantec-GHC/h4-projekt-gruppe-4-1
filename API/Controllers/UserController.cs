using API.Context;
using API.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly AppDBContext _dbContext;

        public UserController(AppDBContext dbContext)
        {
            _dbContext = dbContext;
        }
        /*[HttpGet]
        public async Task<ActionResult<IEnumerable<Users>>> GetAllUsers()
        {
            return await _dbContext.Users.ToListAsync();
        }*/
        [HttpGet]
        public async Task<ActionResult<IEnumerable<UserDTO>>> GetUsers()
        {
            var users = await _dbContext.Users
                .Select(user => new UserDTO
                {
                    Id = user.id,
                    Email = user.Email,
                    Username = user.Username
                })
                .ToListAsync();

            return Ok(users);
        }
        [HttpPost]
        public async Task<ActionResult<Users>> PostCategory(Users users)
        {
            _dbContext.Users.Add(users);
            await _dbContext.SaveChangesAsync();

            return CreatedAtAction(nameof(GetUsers), new { id = users.id }, users);
        }

    }
}
