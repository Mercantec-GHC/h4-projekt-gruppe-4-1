using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace API.Migrations
{
    /// <inheritdoc />
    public partial class initeventdto : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Events_Users_EventCreatorid",
                table: "Events");

            migrationBuilder.DropTable(
                name: "Participant");

            migrationBuilder.DropIndex(
                name: "IX_Events_EventCreatorid",
                table: "Events");

            migrationBuilder.DropColumn(
                name: "Date",
                table: "Events");

            migrationBuilder.DropColumn(
                name: "EventCreator_id",
                table: "Events");

            migrationBuilder.DropColumn(
                name: "EventCreatorid",
                table: "Events");

            migrationBuilder.DropColumn(
                name: "ImageURL",
                table: "Events");

            migrationBuilder.DropColumn(
                name: "Place_id",
                table: "Events");

            migrationBuilder.DropColumn(
                name: "User_id",
                table: "Events");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "Date",
                table: "Events",
                type: "timestamp with time zone",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<string>(
                name: "EventCreator_id",
                table: "Events",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "EventCreatorid",
                table: "Events",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ImageURL",
                table: "Events",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Place_id",
                table: "Events",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "User_id",
                table: "Events",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateTable(
                name: "Participant",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Eventid = table.Column<string>(type: "text", nullable: true),
                    User_FirstName = table.Column<string>(type: "text", nullable: false),
                    User_LastName = table.Column<string>(type: "text", nullable: false),
                    User_id = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Participant", x => x.id);
                    table.ForeignKey(
                        name: "FK_Participant_Events_Eventid",
                        column: x => x.Eventid,
                        principalTable: "Events",
                        principalColumn: "id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Events_EventCreatorid",
                table: "Events",
                column: "EventCreatorid");

            migrationBuilder.CreateIndex(
                name: "IX_Participant_Eventid",
                table: "Participant",
                column: "Eventid");

            migrationBuilder.AddForeignKey(
                name: "FK_Events_Users_EventCreatorid",
                table: "Events",
                column: "EventCreatorid",
                principalTable: "Users",
                principalColumn: "id");
        }
    }
}
