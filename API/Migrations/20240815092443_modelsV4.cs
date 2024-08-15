using System;
using Microsoft.EntityFrameworkCore.Migrations;
using MySql.EntityFrameworkCore.Metadata;

#nullable disable

namespace API.Migrations
{
    /// <inheritdoc />
    public partial class modelsV4 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Category",
                table: "ParticipatedEvent",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "Date",
                table: "ParticipatedEvent",
                type: "datetime(6)",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<string>(
                name: "Description",
                table: "ParticipatedEvent",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<string>(
                name: "ImageURL",
                table: "ParticipatedEvent",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<string>(
                name: "Place_id",
                table: "ParticipatedEvent",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<string>(
                name: "Type",
                table: "ParticipatedEvent",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<string>(
                name: "User_id",
                table: "ParticipatedEvent",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "created_at",
                table: "ParticipatedEvent",
                type: "datetime(6)",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<DateTime>(
                name: "last_login",
                table: "ParticipatedEvent",
                type: "datetime(6)",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<DateTime>(
                name: "updated_at",
                table: "ParticipatedEvent",
                type: "datetime(6)",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<string>(
                name: "Category",
                table: "OrganizedEvent",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "Date",
                table: "OrganizedEvent",
                type: "datetime(6)",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<string>(
                name: "Description",
                table: "OrganizedEvent",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<string>(
                name: "ImageURL",
                table: "OrganizedEvent",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<string>(
                name: "Place_id",
                table: "OrganizedEvent",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<string>(
                name: "Type",
                table: "OrganizedEvent",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<string>(
                name: "User_id",
                table: "OrganizedEvent",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "created_at",
                table: "OrganizedEvent",
                type: "datetime(6)",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<DateTime>(
                name: "last_login",
                table: "OrganizedEvent",
                type: "datetime(6)",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<DateTime>(
                name: "updated_at",
                table: "OrganizedEvent",
                type: "datetime(6)",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.CreateTable(
                name: "Participant",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySQL:ValueGenerationStrategy", MySQLValueGenerationStrategy.IdentityColumn),
                    User_id = table.Column<string>(type: "longtext", nullable: false),
                    User_FirstName = table.Column<string>(type: "longtext", nullable: false),
                    User_LastName = table.Column<string>(type: "longtext", nullable: false),
                    OrganizedEventid = table.Column<string>(type: "varchar(255)", nullable: true),
                    ParticipatedEventid = table.Column<string>(type: "varchar(255)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Participant", x => x.id);
                    table.ForeignKey(
                        name: "FK_Participant_OrganizedEvent_OrganizedEventid",
                        column: x => x.OrganizedEventid,
                        principalTable: "OrganizedEvent",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_Participant_ParticipatedEvent_ParticipatedEventid",
                        column: x => x.ParticipatedEventid,
                        principalTable: "ParticipatedEvent",
                        principalColumn: "id");
                })
                .Annotation("MySQL:Charset", "utf8mb4");

            migrationBuilder.CreateIndex(
                name: "IX_Participant_OrganizedEventid",
                table: "Participant",
                column: "OrganizedEventid");

            migrationBuilder.CreateIndex(
                name: "IX_Participant_ParticipatedEventid",
                table: "Participant",
                column: "ParticipatedEventid");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Participant");

            migrationBuilder.DropColumn(
                name: "Category",
                table: "ParticipatedEvent");

            migrationBuilder.DropColumn(
                name: "Date",
                table: "ParticipatedEvent");

            migrationBuilder.DropColumn(
                name: "Description",
                table: "ParticipatedEvent");

            migrationBuilder.DropColumn(
                name: "ImageURL",
                table: "ParticipatedEvent");

            migrationBuilder.DropColumn(
                name: "Place_id",
                table: "ParticipatedEvent");

            migrationBuilder.DropColumn(
                name: "Type",
                table: "ParticipatedEvent");

            migrationBuilder.DropColumn(
                name: "User_id",
                table: "ParticipatedEvent");

            migrationBuilder.DropColumn(
                name: "created_at",
                table: "ParticipatedEvent");

            migrationBuilder.DropColumn(
                name: "last_login",
                table: "ParticipatedEvent");

            migrationBuilder.DropColumn(
                name: "updated_at",
                table: "ParticipatedEvent");

            migrationBuilder.DropColumn(
                name: "Category",
                table: "OrganizedEvent");

            migrationBuilder.DropColumn(
                name: "Date",
                table: "OrganizedEvent");

            migrationBuilder.DropColumn(
                name: "Description",
                table: "OrganizedEvent");

            migrationBuilder.DropColumn(
                name: "ImageURL",
                table: "OrganizedEvent");

            migrationBuilder.DropColumn(
                name: "Place_id",
                table: "OrganizedEvent");

            migrationBuilder.DropColumn(
                name: "Type",
                table: "OrganizedEvent");

            migrationBuilder.DropColumn(
                name: "User_id",
                table: "OrganizedEvent");

            migrationBuilder.DropColumn(
                name: "created_at",
                table: "OrganizedEvent");

            migrationBuilder.DropColumn(
                name: "last_login",
                table: "OrganizedEvent");

            migrationBuilder.DropColumn(
                name: "updated_at",
                table: "OrganizedEvent");
        }
    }
}
