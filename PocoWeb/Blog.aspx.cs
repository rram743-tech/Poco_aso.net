using System;
using System.Data;

public partial class BlogPage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.ActiveNav = "blog";
        if (IsPostBack) return;
        try
        {
            DataTable dt = Db.Table("SELECT * FROM BlogPosts ORDER BY PostedAt DESC");
            rptPosts.DataSource = dt;
            rptPosts.DataBind();
            litEmpty.Text = dt.Rows.Count == 0 ? "<p class=\"empty\">No posts yet.</p>" : "";
        }
        catch (Exception) { litEmpty.Text = "<p class=\"empty\">Posts could not be loaded.</p>"; }
    }
}
