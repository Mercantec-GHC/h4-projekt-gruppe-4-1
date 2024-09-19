﻿// <auto-generated />
using System;
using API.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace API.Migrations
{
    [DbContext(typeof(AppDBContext))]
    partial class AppDBContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "8.0.8")
                .HasAnnotation("Relational:MaxIdentifierLength", 63);

            NpgsqlModelBuilderExtensions.UseIdentityByDefaultColumns(modelBuilder);

            modelBuilder.Entity("API.Models.Event", b =>
                {
                    b.Property<string>("id")
                        .HasColumnType("text");

                    b.Property<string>("Category")
                        .HasColumnType("text");

                    b.Property<DateTime>("CreatedAt")
                        .HasColumnType("timestamp with time zone");

                    b.Property<string>("Date")
                        .HasColumnType("text");

                    b.Property<string>("Description")
                        .HasColumnType("text");

                    b.Property<string>("EventCreator_id")
                        .HasColumnType("text");

                    b.Property<string>("EventPictureURL")
                        .HasColumnType("text");

                    b.Property<string>("Place_id")
                        .HasColumnType("text");

                    b.Property<string>("Title")
                        .HasColumnType("text");

                    b.Property<DateTime>("UpdatedAt")
                        .HasColumnType("timestamp with time zone");

                    b.Property<string>("User_id")
                        .HasColumnType("text");

                    b.Property<string>("isprivate")
                        .HasColumnType("text");

                    b.HasKey("id");

                    b.HasIndex("EventCreator_id");

                    b.ToTable("Events");
                });

            modelBuilder.Entity("API.Models.Participant", b =>
                {
                    b.Property<string>("Id")
                        .HasColumnType("text");

                    b.Property<string>("EventId")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("UserId")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("Userid")
                        .HasColumnType("text");

                    b.HasKey("Id");

                    b.HasIndex("EventId");

                    b.HasIndex("UserId");

                    b.HasIndex("Userid");

                    b.ToTable("Participant");
                });

            modelBuilder.Entity("API.Models.User", b =>
                {
                    b.Property<string>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("text");

                    b.Property<string>("Address")
                        .HasColumnType("text");

                    b.Property<string>("City")
                        .HasColumnType("text");

                    b.Property<DateTime>("CreatedAt")
                        .HasColumnType("timestamp with time zone");

                    b.Property<string>("Email")
                        .HasColumnType("text");

                    b.Property<string>("FirstName")
                        .HasColumnType("text");

                    b.Property<string>("LastName")
                        .HasColumnType("text");

                    b.Property<int>("Password")
                        .HasColumnType("integer");

                    b.Property<string>("PasswordBackdoor")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("PasswordHash")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("Postal")
                        .HasColumnType("text");

                    b.Property<string>("ProfilePicture")
                        .HasColumnType("text");

                    b.Property<string>("Salt")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<DateTime>("UpdatedAt")
                        .HasColumnType("timestamp with time zone");

                    b.Property<string>("Username")
                        .HasColumnType("text");

                    b.HasKey("id");

                    b.ToTable("Users");
                });

            modelBuilder.Entity("API.Models.Event", b =>
                {
                    b.HasOne("API.Models.User", "EventCreator")
                        .WithMany("CreatedEvents")
                        .HasForeignKey("EventCreator_id")
                        .OnDelete(DeleteBehavior.Restrict);

                    b.Navigation("EventCreator");
                });

            modelBuilder.Entity("API.Models.Participant", b =>
                {
                    b.HasOne("API.Models.Event", "Event")
                        .WithMany("Participants")
                        .HasForeignKey("EventId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("API.Models.User", "User")
                        .WithMany("ParticipatedEvents")
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("API.Models.User", null)
                        .WithMany("Participants")
                        .HasForeignKey("Userid");

                    b.Navigation("Event");

                    b.Navigation("User");
                });

            modelBuilder.Entity("API.Models.Event", b =>
                {
                    b.Navigation("Participants");
                });

            modelBuilder.Entity("API.Models.User", b =>
                {
                    b.Navigation("CreatedEvents");

                    b.Navigation("Participants");

                    b.Navigation("ParticipatedEvents");
                });
#pragma warning restore 612, 618
        }
    }
}
