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

    public class EventDTO
    {
        public string? Id { get; set; }
        public DateTime Date { get; set; }
        public string Place_id { get; set; }
        public string Description { get; set; }
        public string Category { get; set; }
    }


    public class CreateEventDTO
    {
        public string Type { get; set; }
        public string Category { get; set; }
        public string Description { get; set; }
    }
}
