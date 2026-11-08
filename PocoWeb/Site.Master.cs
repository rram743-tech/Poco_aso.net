using System;
using System.Web;
using System.Web.UI;

public partial class SiteMaster : MasterPage
{
    public string ActiveNav { get; set; }

    protected string Cls(string key)
    {
        return string.Equals(ActiveNav, key, StringComparison.OrdinalIgnoreCase) ? "active" : "";
    }

    protected int CartCount { get { return CartHelper.Count; } }

    protected override void OnPreRender(EventArgs e)
    {
        base.OnPreRender(e);
        string flash = Session["flash"] as string;
        if (!string.IsNullOrEmpty(flash))
        {
            Session["flash"] = null;
            int bar = flash.IndexOf('|');
            string kind = bar > 0 ? flash.Substring(0, bar) : "ok";
            string text = bar > 0 ? flash.Substring(bar + 1) : flash;
            litFlash.Text = "<div class=\"toast " + (kind == "err" ? "err" : "ok") + "\" id=\"toast\">" + Ui.H(text) + "</div>";
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string q = (txtSearch.Text ?? "").Trim();
        Response.Redirect("~/Shop.aspx" + (q.Length > 0 ? "?q=" + Server.UrlEncode(q) : ""));
    }

    protected void btnJoin_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        Subscribe(txtJoin.Text);
        txtJoin.Text = "";
    }

    protected void btnFoot_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        Subscribe(txtFoot.Text);
        txtFoot.Text = "";
    }

    private void Subscribe(string email)
    {
        email = (email ?? "").Trim();
        try
        {
            int added = Db.Exec("IF NOT EXISTS (SELECT 1 FROM NewsletterSubscribers WHERE Email = @e) " +
                                "INSERT NewsletterSubscribers (Email) VALUES (@e)", Db.P("@e", email));
            Ui.Flash(added > 0 ? "Thank you for subscribing!" : "You are already subscribed.", true);
        }
        catch (Exception)
        {
            Ui.Flash("We could not save your subscription. Please try again later.", false);
        }
        Response.Redirect(Request.RawUrl);
    }
}
