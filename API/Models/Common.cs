using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace API.Models
{
    public class Common
    {
        [Key]
        public string id { get; set; } // Kan erstattes med "int Id"
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
};