using System.ComponentModel.DataAnnotations.Schema;

namespace API.Models
{
    public class User : Common
    {
        
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string Email { get; set; }
    
        public string Username { get; set; }
        public string PasswordHash { get; set; }   
        public string PasswordBackdoor { get; set; }
        public string Salt { get; set; }
        

    }
    public class UserDTO
    {
        public string? Id { get; set; }
        public string Email { get; set; }
        public string Username { get; set; }
    }

    public class LoginDTO
    {
        public string Email { get; set; }
        public string Password { get; set; }
    }

    public class SignUpDTO
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
    }
}
