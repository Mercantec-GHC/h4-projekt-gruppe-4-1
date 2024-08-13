﻿namespace API.Models
{
    public class Users : Common
    {
        public string Email { get; set; }
    
        public string Username { get; set; }
        public string PasswordHash { get; set; }   
        public string PasswordBackdoor { get; set; }

    }
    public class UserDTO
    {
        public string Id { get; set; }
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
        public string Email { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
    }
}
