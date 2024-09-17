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
                .ValueGeneratedOnAdd(); 


            modelBuilder.Entity<Event>()
            .HasOne(e => e.EventCreator)       
            .WithMany(u => u.CreatedEvents)    
            .HasForeignKey(e => e.EventCreator_id) 
            .OnDelete(DeleteBehavior.Restrict);    
            base.OnModelCreating(modelBuilder);


            modelBuilder.Entity<Participant>()
            .HasOne(p => p.Event)
            .WithMany(e => e.Participants)
            .HasForeignKey(p => p.EventId);

            
            modelBuilder.Entity<Participant>()
                .HasOne(p => p.User)
                .WithMany(u => u.ParticipatedEvents)
                .HasForeignKey(p => p.UserId);

            base.OnModelCreating(modelBuilder);
        }


    }
}