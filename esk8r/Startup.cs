using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(esk8r.Startup))]
namespace esk8r
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
