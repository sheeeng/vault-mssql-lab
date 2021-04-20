using Microsoft.EntityFrameworkCore;

namespace ProjectAcme.Models
{
  public class ProjectContext : DbContext
  {
    public ProjectContext(DbContextOptions<ProjectContext> options) : base(options)
    {
    }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
      optionsBuilder.UseSqlServer(Startup.Configuration.GetSection("ConnectionStrings")["Database"]);
    }

    public DbSet<Project> Projects { get; set; }
  }
}
