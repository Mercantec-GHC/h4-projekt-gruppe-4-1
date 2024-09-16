using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations
{
    /// <inheritdoc />
    public partial class nullable123 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Events_Users_EventCreatorid",
                table: "Events");

            migrationBuilder.DropIndex(
                name: "IX_Events_EventCreatorid",
                table: "Events");

            migrationBuilder.DropColumn(
                name: "EventCreatorid",
                table: "Events");

            migrationBuilder.AlterColumn<string>(
                name: "Address",
                table: "Users",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.CreateIndex(
                name: "IX_Events_EventCreator_id",
                table: "Events",
                column: "EventCreator_id");

            migrationBuilder.AddForeignKey(
                name: "FK_Events_Users_EventCreator_id",
                table: "Events",
                column: "EventCreator_id",
                principalTable: "Users",
                principalColumn: "id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Events_Users_EventCreator_id",
                table: "Events");

            migrationBuilder.DropIndex(
                name: "IX_Events_EventCreator_id",
                table: "Events");

            migrationBuilder.AlterColumn<string>(
                name: "Address",
                table: "Users",
                type: "text",
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AddColumn<string>(
                name: "EventCreatorid",
                table: "Events",
                type: "text",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Events_EventCreatorid",
                table: "Events",
                column: "EventCreatorid");

            migrationBuilder.AddForeignKey(
                name: "FK_Events_Users_EventCreatorid",
                table: "Events",
                column: "EventCreatorid",
                principalTable: "Users",
                principalColumn: "id");
        }
    }
}
