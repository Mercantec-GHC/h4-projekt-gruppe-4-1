using API.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.OpenApi;
using Microsoft.AspNetCore.Http.HttpResults;
namespace API.Models
{
    public class Event : Common
    {
        
        public DateTime Date { get; set; }
        public string User_id { get; set; }
        public string Place_id { get; set; }
        public string ImageURL { get; set; }
        public string Type { get; set; }
        public string Category { get; set; }
        public string Description { get; set; }
        public string EventCreator_id { get; set; }
        public User EventCreator { get; set; }
        public List<Participant> Participants { get; set; }




    } 

public static class EventEndpoints
{
	public static void MapEventEndpoints (this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/Event").WithTags(nameof(Event));

        group.MapGet("/", async (AppDBContext db) =>
        {
            return await db.Events.ToListAsync();
        })
        .WithName("GetAllEvents")
        .WithOpenApi();

        group.MapGet("/{id}", async Task<Results<Ok<Event>, NotFound>> (string id, AppDBContext db) =>
        {
            return await db.Events.AsNoTracking()
                .FirstOrDefaultAsync(model => model.id == id)
                is Event model
                    ? TypedResults.Ok(model)
                    : TypedResults.NotFound();
        })
        .WithName("GetEventById")
        .WithOpenApi();

        group.MapPut("/{id}", async Task<Results<Ok, NotFound>> (string id, Event @event, AppDBContext db) =>
        {
            var affected = await db.Events
                .Where(model => model.id == id)
                .ExecuteUpdateAsync(setters => setters
                  .SetProperty(m => m.Date, @event.Date)
                  .SetProperty(m => m.User_id, @event.User_id)
                  .SetProperty(m => m.Place_id, @event.Place_id)
                  .SetProperty(m => m.ImageURL, @event.ImageURL)
                  .SetProperty(m => m.Type, @event.Type)
                  .SetProperty(m => m.Category, @event.Category)
                  .SetProperty(m => m.Description, @event.Description)
                  .SetProperty(m => m.EventCreator_id, @event.EventCreator_id)
                  .SetProperty(m => m.id, @event.id)
                  .SetProperty(m => m.CreatedAt, @event.CreatedAt)
                  .SetProperty(m => m.UpdatedAt, @event.UpdatedAt)
                  );
            return affected == 1 ? TypedResults.Ok() : TypedResults.NotFound();
        })
        .WithName("UpdateEvent")
        .WithOpenApi();

        group.MapPost("/", async (Event @event, AppDBContext db) =>
        {
            db.Events.Add(@event);
            await db.SaveChangesAsync();
            return TypedResults.Created($"/api/Event/{@event.id}",@event);
        })
        .WithName("CreateEvent")
        .WithOpenApi();

        group.MapDelete("/{id}", async Task<Results<Ok, NotFound>> (string id, AppDBContext db) =>
        {
            var affected = await db.Events
                .Where(model => model.id == id)
                .ExecuteDeleteAsync();
            return affected == 1 ? TypedResults.Ok() : TypedResults.NotFound();
        })
        .WithName("DeleteEvent")
        .WithOpenApi();
    }
}}
