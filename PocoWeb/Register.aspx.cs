using System;

public partial class RegisterPage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.ActiveNav = "page";
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        string email = txtEmail.Text.Trim();
        try
        {
            if (Db.Scalar("SELECT 1 FROM Users WHERE Email = @e", Db.P("@e", email)) != null)
            {
                litError.Text = "<div class=\"alert err\">An account with this email already exists.</div>";
                return;
            }
            object id = Db.Scalar(
                "INSERT Users (FullName, Email, Phone, PasswordHash) VALUES (@n, @e, @p, @h); SELECT CAST(SCOPE_IDENTITY() AS INT);",
                Db.P("@n", txtName.Text.Trim()), Db.P("@e", email),
                Db.P("@p", string.IsNullOrWhiteSpace(txtPhone.Text) ? null : txtPhone.Text.Trim()),
                Db.P("@h", Auth.HashPassword(txtPassword.Text)));
            Auth.SignIn(Convert.ToInt32(id), "Customer", txtName.Text.Trim());
            Ui.Flash("Welcome to Poco!, " + txtName.Text.Trim() + "! Your account was created.", true);
            Response.Redirect("~/Default.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
        catch (Exception)
        {
            litError.Text = "<div class=\"alert err\">Registration is unavailable right now. Please check the database connection.</div>";
        }
    }
}
