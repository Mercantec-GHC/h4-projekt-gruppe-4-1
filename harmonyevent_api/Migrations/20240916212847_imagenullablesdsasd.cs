using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace API.Migrations
{
    /// <inheritdoc />
    public partial class imagenullablesdsasd : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Participant_Users_UserId",
                table: "Participant");

            migrationBuilder.RenameColumn(
                name: "UserId",
                table: "Participant",
                newName: "Userid");

            migrationBuilder.RenameIndex(
                name: "IX_Participant_UserId",
                table: "Participant",
                newName: "IX_Participant_Userid");

            migrationBuilder.AlterColumn<string>(
                name: "Userid",
                table: "Participant",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.AddColumn<string>(
                name: "UserId",
                table: "Participant",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateIndex(
                name: "IX_Participant_UserId",
                table: "Participant",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_Participant_Users_UserId",
                table: "Participant",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Participant_Users_Userid",
                table: "Participant",
                column: "Userid",
                principalTable: "Users",
                principalColumn: "id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Participant_Users_UserId",
                table: "Participant");

            migrationBuilder.DropForeignKey(
                name: "FK_Participant_Users_Userid",
                table: "Participant");

            migrationBuilder.DropIndex(
                name: "IX_Participant_UserId",
                table: "Participant");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "Participant");

            migrationBuilder.RenameColumn(
                name: "Userid",
                table: "Participant",
                newName: "UserId");

            migrationBuilder.RenameIndex(
                name: "IX_Participant_Userid",
                table: "Participant",
                newName: "IX_Participant_UserId");

            migrationBuilder.AlterColumn<string>(
                name: "UserId",
                table: "Participant",
                type: "text",
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Participant_Users_UserId",
                table: "Participant",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
