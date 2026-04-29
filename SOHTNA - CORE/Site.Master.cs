using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TimeAttendance.WebForms
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                System.Reflection.Assembly asm = System.Reflection.Assembly.GetExecutingAssembly();
                lblMasterVersion.Text = string.Format("v{0}", asm.GetName().Version.ToString());
            }
        }

        protected void btnMasterLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }
    }
}