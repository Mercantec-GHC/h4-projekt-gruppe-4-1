using System.ComponentModel.DataAnnotations;

namespace API.Models
{
    public class Participant
    {
        [Key]
        public String Id { get; set; }
        public string UserId { get; set; } // The ID of the user attending the event
        public User? User { get; set; } // Foreign key relationship to User
        public String EventId { get; set; } // The event the user is attending
        public Event? Event { get; set; } // Foreign key relationship to Event
    }
}