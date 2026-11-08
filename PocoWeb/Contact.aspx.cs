using System;

public partial class ContactPage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.ActiveNav = "contact";
    }

    protected void btnSend_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        string msg = txtMessage.Text.Trim();
        if (msg.Length > 2000) msg = msg.Substring(0, 2000);
        try
        {
            Db.Exec("INSERT ContactMessages (Name, Email, Subject, Message) VALUES (@n, @e, @s, @m)",
                Db.P("@n", txtName.Text.Trim()), Db.P("@e", txtEmail.Text.Trim()),
                Db.P("@s", txtSubject.Text.Trim()), Db.P("@m", msg));
            Ui.Flash("Thank you! Your message has been sent.", true);
            Response.Redirect("~/Contact.aspx");
        }
        catch (System.Threading.ThreadAbortException) { throw; }
        catch (Exception)
        {
            Ui.Flash("Your message could not be sent. Please try again later.", false);
        }
    }
}
