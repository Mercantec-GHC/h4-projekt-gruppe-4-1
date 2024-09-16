using API.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.OpenApi;
using Microsoft.AspNetCore.Http.HttpResults;
namespace API.Models
{
    public class Event : Common
    {
        public String Date { get; set; }
        public string? User_id { get; set; }
        public string? Place_id { get; set; }
        public string? EventPictureURL { get; set; }
        public string? isprivate { get; set; }
        public string? Category { get; set; }
        public string? Description { get; set; }
        public string? Title { get; set; }
       

        // Foreign Key for the Event Creator
        public string? EventCreator_id { get; set; } 

        // Navigation property for User (Event Creator)
        public User? EventCreator { get; set; }

        // Collection of participants
        public List<Participant>? Participants { get; set; }
    }

    public class EventDTO
    {
        public string? Id { get; set; }
        public String Date { get; set; }
        public string Place_id { get; set; }
        public string Description { get; set; }
        public string Title { get; set; }
        public IFormFile ImageURL { get; set; }
        public string Category { get; set; }
        public string isprivate { get; set; }
        public List<Participant>? Participants { get; set; }
    }


    public class CreateEventDTO
    {
        public String Date { get; set; }
        
        public string? Place_id { get; set; }
        public IFormFile EventPicture { get; set; }
        public string isprivate { get; set; }
        public string Title { get; set; }
        public string? Category { get; set; }
        public string? Description { get; set; }
        
        
     

    }
}
