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
            modelBuilder.Entity<Event>()
            .HasOne(e => e.EventCreator)       // One event has one creator
            .WithMany(u => u.CreatedEvents)    // One user can create many events
            .HasForeignKey(e => e.EventCreator_id) // Use EventCreator_id as the FK
            .OnDelete(DeleteBehavior.Restrict);    // Prevent cascade delete
            base.OnModelCreating(modelBuilder);
        }


    }
}