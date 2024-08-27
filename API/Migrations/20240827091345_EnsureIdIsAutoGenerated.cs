﻿using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations
{
    /// <inheritdoc />
    public partial class EnsureIdIsAutoGenerated : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Events_Users_ParticipatedEvent_EventCreatorid",
                table: "Events");

            migrationBuilder.DropIndex(
                name: "IX_Events_ParticipatedEvent_EventCreatorid",
                table: "Events");

            migrationBuilder.DropColumn(
                name: "Discriminator",
                table: "Events");

            migrationBuilder.DropColumn(
                name: "ParticipatedEvent_EventCreatorid",
                table: "Events");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Discriminator",
                table: "Events",
                type: "varchar(21)",
                maxLength: 21,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "ParticipatedEvent_EventCreatorid",
                table: "Events",
                type: "varchar(255)",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Events_ParticipatedEvent_EventCreatorid",
                table: "Events",
                column: "ParticipatedEvent_EventCreatorid");

            migrationBuilder.AddForeignKey(
                name: "FK_Events_Users_ParticipatedEvent_EventCreatorid",
                table: "Events",
                column: "ParticipatedEvent_EventCreatorid",
                principalTable: "Users",
                principalColumn: "id");
        }
    }
}
