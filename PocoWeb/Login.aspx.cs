using System;
using System.Data;

public partial class LoginPage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.ActiveNav = "page";
        if (!IsPostBack && Auth.IsLoggedIn) Response.Redirect("~/Account.aspx");
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        try
        {
            DataTable dt = Db.Table("SELECT Id, FullName, PasswordHash, Role FROM Users WHERE Email = @e AND IsActive = 1", Db.P("@e", txtEmail.Text.Trim()));
            if (dt.Rows.Count == 1 && Auth.VerifyPassword(txtPassword.Text, (string)dt.Rows[0]["PasswordHash"]))
            {
                DataRow u = dt.Rows[0];
                Auth.SignIn((int)u["Id"], (string)u["Role"], (string)u["FullName"]);
                string ret = Request.QueryString["ReturnUrl"];
                if (Auth.IsSafeLocalUrl(ret)) Response.Redirect(ret, false);
                else Response.Redirect((string)u["Role"] == "Admin" ? "~/Admin/Default.aspx" : "~/Default.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
            litError.Text = "<div class=\"alert err\">Incorrect email or password.</div>";
        }
        catch (Exception)
        {
            litError.Text = "<div class=\"alert err\">Login is unavailable right now. Please check the database connection.</div>";
        }
    }
}
