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


namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EventController : ControllerBase
    {
        private readonly AppDBContext _dbContext;
        private readonly IConfiguration _configuration;

        public EventController(AppDBContext dbContext, IConfiguration configuration)
        {
            _dbContext = dbContext;
            _configuration = configuration;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<EventDTO>>> GetEvents()
        {
            var events = await _dbContext.Events
                .Select(events => new EventDTO
                {
                    id = events.id,
                    Date = events.Date,
                    Place_id = events.Place_id,
                    Description = events.Description,
                    Category = events.Category
                })
                .ToListAsync();

            return Ok(events);
        }




        [HttpGet("{id}")]
        public async Task<ActionResult<Event>> GetEventById(string id)
        {

            var events = await _dbContext.Events.FindAsync(id);

            if (events == null)
            {
                return NotFound();
            }

            return Ok(events);
        }


        [HttpPost("Create")]
        public async Task<ActionResult<Event>> PostEvent(CreateEventDTO eventCreate)
        {

            var events = new Event
            {
                id = Guid.NewGuid().ToString("N"),
                Date = eventCreate.Date,
                
                Place_id= eventCreate.Place_id,
                ImageURL = eventCreate.ImageURL,
                Type = eventCreate.Type,
                Description = eventCreate.Description,
                
                Category = eventCreate.Category,
                
               

            };


            _dbContext.Events.Add(events);

            try
            {
              
                await _dbContext.SaveChangesAsync();
            }
            catch (DbUpdateException ex)
            {
                
                return StatusCode(500, new { message = "An error occurred while saving the event.", details = ex.Message });
            }

            
            return CreatedAtAction(nameof(GetEventById), new { id = events.id }, events);
        }

     
    }
}

        