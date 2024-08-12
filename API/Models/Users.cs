namespace API.Models
{
    public class Users : Common
    {
        public string Email { get; set; }
        public string Username { get; set; }
        public string PasswordHash { get; set; }      
        public string PasswordBackdoor { get; set; } 
    }
}
