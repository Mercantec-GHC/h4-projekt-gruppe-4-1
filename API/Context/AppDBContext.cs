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

        public DbSet<User> Users {  get; set; }
        public DbSet<Event> Events { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<User>()
                .HasKey(u => u.id);

            modelBuilder.Entity<User>()
                .Property(u => u.id)
                .ValueGeneratedOnAdd(); // Ensure EF Core knows the ID is auto-generated
        }

    }
}