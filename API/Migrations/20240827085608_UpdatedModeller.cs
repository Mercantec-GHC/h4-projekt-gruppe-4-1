using System;
using Microsoft.EntityFrameworkCore.Migrations;
using MySql.EntityFrameworkCore.Metadata;

#nullable disable

namespace API.Migrations
{
    /// <inheritdoc />
    public partial class UpdatedModeller : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterDatabase()
                .Annotation("MySQL:Charset", "utf8mb4");

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    id = table.Column<string>(type: "varchar(255)", nullable: false),
                    FirstName = table.Column<string>(type: "longtext", nullable: true),
                    LastName = table.Column<string>(type: "longtext", nullable: true),
                    Email = table.Column<string>(type: "longtext", nullable: false),
                    Username = table.Column<string>(type: "longtext", nullable: false),
                    PasswordHash = table.Column<string>(type: "longtext", nullable: false),
                    PasswordBackdoor = table.Column<string>(type: "longtext", nullable: false),
                    Salt = table.Column<string>(type: "longtext", nullable: false),
                    created_at = table.Column<DateTime>(type: "datetime(6)", nullable: false),
                    updated_at = table.Column<DateTime>(type: "datetime(6)", nullable: false),
                    last_login = table.Column<DateTime>(type: "datetime(6)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.id);
                })
                .Annotation("MySQL:Charset", "utf8mb4");

            migrationBuilder.CreateTable(
                name: "Events",
                columns: table => new
                {
                    id = table.Column<string>(type: "varchar(255)", nullable: false),
                    Date = table.Column<DateTime>(type: "datetime(6)", nullable: false),
                    User_id = table.Column<string>(type: "longtext", nullable: false),
                    Place_id = table.Column<string>(type: "longtext", nullable: false),
                    ImageURL = table.Column<string>(type: "longtext", nullable: false),
                    Type = table.Column<string>(type: "longtext", nullable: false),
                    Category = table.Column<string>(type: "longtext", nullable: false),
                    Description = table.Column<string>(type: "longtext", nullable: false),
                    EventCreator_id = table.Column<string>(type: "longtext", nullable: false),
                    Discriminator = table.Column<string>(type: "varchar(21)", maxLength: 21, nullable: false),
                    EventCreatorid = table.Column<string>(type: "varchar(255)", nullable: true),
                    ParticipatedEvent_EventCreatorid = table.Column<string>(type: "varchar(255)", nullable: true),
                    created_at = table.Column<DateTime>(type: "datetime(6)", nullable: false),
                    updated_at = table.Column<DateTime>(type: "datetime(6)", nullable: false),
                    last_login = table.Column<DateTime>(type: "datetime(6)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Events", x => x.id);
                    table.ForeignKey(
                        name: "FK_Events_Users_EventCreatorid",
                        column: x => x.EventCreatorid,
                        principalTable: "Users",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_Events_Users_ParticipatedEvent_EventCreatorid",
                        column: x => x.ParticipatedEvent_EventCreatorid,
                        principalTable: "Users",
                        principalColumn: "id");
                })
                .Annotation("MySQL:Charset", "utf8mb4");

            migrationBuilder.CreateTable(
                name: "Participant",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySQL:ValueGenerationStrategy", MySQLValueGenerationStrategy.IdentityColumn),
                    User_id = table.Column<string>(type: "longtext", nullable: false),
                    User_FirstName = table.Column<string>(type: "longtext", nullable: false),
                    User_LastName = table.Column<string>(type: "longtext", nullable: false),
                    Eventid = table.Column<string>(type: "varchar(255)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Participant", x => x.id);
                    table.ForeignKey(
                        name: "FK_Participant_Events_Eventid",
                        column: x => x.Eventid,
                        principalTable: "Events",
                        principalColumn: "id");
                })
                .Annotation("MySQL:Charset", "utf8mb4");

            migrationBuilder.CreateIndex(
                name: "IX_Events_EventCreatorid",
                table: "Events",
                column: "EventCreatorid");

            migrationBuilder.CreateIndex(
                name: "IX_Events_ParticipatedEvent_EventCreatorid",
                table: "Events",
                column: "ParticipatedEvent_EventCreatorid");

            migrationBuilder.CreateIndex(
                name: "IX_Participant_Eventid",
                table: "Participant",
                column: "Eventid");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Participant");

            migrationBuilder.DropTable(
                name: "Events");

            migrationBuilder.DropTable(
                name: "Users");
        }
    }
}
