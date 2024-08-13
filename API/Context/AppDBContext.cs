using Microsoft.EntityFrameworkCore;
using API.Models;


namespace API.Context
{
    public class AppDBContext : DbContext
    {
        public AppDBContext(DbContextOptions<AppDBContext> options)
            : base(options)
        {

        }

        public DbSet<Users> Users {  get; set; }

    }
}