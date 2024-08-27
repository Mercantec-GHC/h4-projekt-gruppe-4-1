using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace API.Models
{
    public class Common
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public string? id { get; set; }
        public DateTime created_at { get; set; }
        public DateTime updated_at { get; set;}
        public DateTime last_login { get; set; }
     
        

    }
}
