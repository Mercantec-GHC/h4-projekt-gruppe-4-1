using Mysqlx.Crud;
using System.ComponentModel.DataAnnotations.Schema;

namespace API.Models
{
    public class User : Common
    {
        
        public String? FirstName { get; set; }
        public String? LastName { get; set; }

        public String? Email { get; set; }
        public String? Username { get; set; }
      
        public int Password { get; set; }
        public String? Address { get; set; }

        public String? Postal { get; set; }
        public String? City { get; set; }

        public String PasswordHash { get; set; }   
        public String PasswordBackdoor { get; set; }

        public String Salt { get; set; }


        public String? ProfilePicture { get; set; }
        public List<Event> ? CreatedEvents { get; set; }
        public List<Participant> Participants { get; set; }

        public ICollection<Participant> ParticipatedEvents { get; set; }

    }
    public class UserDTO
    {
        public String? FirstName { get; set; }
        public String? LastName { get; set; }
        public String Id { get; set; }
        public String Email { get; set; }
        public String Username { get; set; }
        public String ProfilePicture { get; set; }
        public String? Address { get; set; }
        public String? Postal { get; set; }
        public String? City { get; set; }

    }

    public class LoginDTO
    {
        public String Email { get; set; }
        public String Password { get; set; }
    }


    public class SignUpDTO
    {
        public String FirstName { get; set; }
        public String LastName { get; set; }
        public String Email { get; set; }
        public String Username { get; set; }
        
        public String Address { get; set; }
        public String Postal { get; set; }
        public String City { get; set; }
        public IFormFile ProfilePicture { get; set; }
        public string Password { get;  set; }
    }

}
