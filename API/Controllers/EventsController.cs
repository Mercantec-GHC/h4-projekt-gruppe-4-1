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
                    isprivate = events.isprivate,
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
        public async Task<IActionResult> PostUser([FromForm] CreateEventDTO eventCreate)
        {

            var events = new Event
            {
                id = Guid.NewGuid().ToString("N"),
                Date = eventCreate.Date,

                Place_id = eventCreate.Place_id,
             
                isprivate = eventCreate.isprivate,
                Description = eventCreate.Description,

                Category = eventCreate.Category,



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

