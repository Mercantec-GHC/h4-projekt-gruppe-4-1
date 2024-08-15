using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations
{
    /// <inheritdoc />
    public partial class modelsV3 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "FirstName",
                table: "Users",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<string>(
                name: "LastName",
                table: "Users",
                type: "longtext",
                nullable: false);

            migrationBuilder.CreateTable(
                name: "OrganizedEvent",
                columns: table => new
                {
                    id = table.Column<string>(type: "varchar(255)", nullable: false),
                    Usersid = table.Column<string>(type: "varchar(255)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OrganizedEvent", x => x.id);
                    table.ForeignKey(
                        name: "FK_OrganizedEvent_Users_Usersid",
                        column: x => x.Usersid,
                        principalTable: "Users",
                        principalColumn: "id");
                })
                .Annotation("MySQL:Charset", "utf8mb4");

            migrationBuilder.CreateTable(
                name: "ParticipatedEvent",
                columns: table => new
                {
                    id = table.Column<string>(type: "varchar(255)", nullable: false),
                    Usersid = table.Column<string>(type: "varchar(255)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ParticipatedEvent", x => x.id);
                    table.ForeignKey(
                        name: "FK_ParticipatedEvent_Users_Usersid",
                        column: x => x.Usersid,
                        principalTable: "Users",
                        principalColumn: "id");
                })
                .Annotation("MySQL:Charset", "utf8mb4");

            migrationBuilder.CreateIndex(
                name: "IX_OrganizedEvent_Usersid",
                table: "OrganizedEvent",
                column: "Usersid");

            migrationBuilder.CreateIndex(
                name: "IX_ParticipatedEvent_Usersid",
                table: "ParticipatedEvent",
                column: "Usersid");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "OrganizedEvent");

            migrationBuilder.DropTable(
                name: "ParticipatedEvent");

            migrationBuilder.DropColumn(
                name: "FirstName",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "LastName",
                table: "Users");
        }
    }
}
