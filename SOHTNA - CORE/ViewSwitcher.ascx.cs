using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TimeAttendance.WebForms
{
    public partial class ViewSwitcher
    {
        protected string CurrentView { get; private set; }

        protected string AlternateView { get; private set; }

        protected string SwitchUrl { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Mobile/Desktop view switching is not currently configured
            CurrentView = "Desktop";
            AlternateView = "Mobile";
            this.Visible = false;
        }
    }
}