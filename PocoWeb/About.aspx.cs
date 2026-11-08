using System;

public partial class AboutPage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.ActiveNav = "about";
        if (IsPostBack) return;
        try
        {
            rptTesti.DataSource = Db.Table("SELECT TOP 3 * FROM Testimonials ORDER BY SortOrder");
            rptTesti.DataBind();
        }
        catch (Exception) { }
    }
}
