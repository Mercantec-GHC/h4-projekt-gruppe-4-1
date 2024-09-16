using API.Context;
using API.Models;

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
    public class EventController : ControllerBase
    {
        private readonly AppDBContext _dbContext;
        private readonly IConfiguration _configuration;
        private readonly string _accessKey;
        private readonly string _secretKey;
        private readonly R2Service _r2Service;
        public EventController(AppDBContext dbContext, IConfiguration configuration, AppConfiguration config)
        {
            _dbContext = dbContext;
            _configuration = configuration;
            _accessKey = config.AccessKey;
            _secretKey = config.SecretKey;
            _r2Service = new R2Service(_accessKey, _secretKey);
        }
        // get all
        [HttpGet]
        
        public async Task<ActionResult<IEnumerable<EventDTO>>> GetEvents()
        {
            var events = await _dbContext.Events
                .Select(events => new EventDTO
                {
                    Id = events.id,
                    Date = events.Date,
                    Place_id = events.Place_id,
                    ImageURL = events.EventPictureURL,
                    Description = events.Description,
                    Category = events.Category,
                    Title = events.Title,
                    isprivate = events.isprivate,
                    Participants = events.Participants
                })
                .ToListAsync();

            return Ok(events);
        }



        // get from id
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
        // delete from id
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteEventById(string id)
        {
            var events = await _dbContext.Events.FindAsync(id);

            if (events == null)
            {
                return NotFound();
            }

            _dbContext.Events.Remove(events);
            await _dbContext.SaveChangesAsync();

            return NoContent();
        }
        // update by id
        [HttpPut("{id}")]
        public async Task<ActionResult> UpdateEvent(string id, [FromBody] EventDTO updatedEvent)
        {
            
            var existingEvent = await _dbContext.Events.FindAsync(id);
            if (existingEvent == null)
            {
                return NotFound();
            }

            
            existingEvent.Date = updatedEvent.Date;
            existingEvent.Place_id = updatedEvent.Place_id;
            existingEvent.EventPictureURL = updatedEvent.ImageURL;
            existingEvent.Description = updatedEvent.Description;
            existingEvent.Category = updatedEvent.Category;
            existingEvent.Title = updatedEvent.Title;
            existingEvent.isprivate = updatedEvent.isprivate;

            try
            {
                // Save the updated event to the database
                await _dbContext.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!EventExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent(); // Return 204 No Content when successful
        }

        private bool EventExists(string id)
        {
            return _dbContext.Events.Any(e => e.id == id);
        }

        [HttpPost("{eventId}/attend")]
        [Authorize]  // Ensure user is authenticated
        public async Task<IActionResult> AttendEvent(String eventId)
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (userId == null)
            {
                return Unauthorized("User ID not found in JWT");
            }

            // Check if the event exists
            var eventToAttend = await _dbContext.Events
                .Include(e => e.Participants) // Include participants to avoid loading twice
                .FirstOrDefaultAsync(e => e.id == eventId);

            if (eventToAttend == null)
            {
                return NotFound("Event not found");
            }

            // Check if the user is already a participant
            if (eventToAttend.Participants.Any(p => p.UserId == userId))
            {
                return BadRequest("User is already attending the event");
            }

            // Add the participant to the event
            var participant = new Participant
            {
                UserId = userId,
                EventId = eventId
            };

            eventToAttend.Participants.Add(participant);
            await _dbContext.SaveChangesAsync();

            return Ok("You are now attending the event");
        }

        // create event
        [HttpPost("Create")]
        
        public async Task<IActionResult> PostUser([FromForm] CreateEventDTO eventCreate)
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            var events = new Event
            {
                id = Guid.NewGuid().ToString("N"),
                Date = eventCreate.Date,

                Place_id = eventCreate.Place_id,
                Title = eventCreate.Title,
                isprivate = eventCreate.isprivate,
                Description = eventCreate.Description,

                Category = eventCreate.Category,
                EventCreator_id = userId



            };


           
            var r2Service = new R2Service(_accessKey, _secretKey);
            var imageUrl = await r2Service.UploadToR2(eventCreate.EventPicture.OpenReadStream(), "PP" + events.id);

            events.EventPictureURL = imageUrl;
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

