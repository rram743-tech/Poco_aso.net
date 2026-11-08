<%@ WebHandler Language="C#" Class="Actions" %>
using System;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

public class Actions : IHttpHandler, IRequiresSessionState
{
    public bool IsReusable { get { return false; } }

    public void ProcessRequest(HttpContext ctx)
    {
        string what = ctx.Request.QueryString["do"] ?? "";
        int id;
        int.TryParse(ctx.Request.QueryString["id"], out id);
        string ret = ctx.Request.QueryString["ret"];
        if (!Auth.IsSafeLocalUrl(ret)) ret = "~/Default.aspx";

        try
        {
            switch (what)
            {
                case "cart":
                    object ok = Db.Scalar("SELECT Name FROM Products WHERE Id = @id AND IsActive = 1", Db.P("@id", id));
                    if (ok == null) { Ui.Flash("That product is no longer available.", false); break; }
                    CartHelper.Add(id, 1);
                    Ui.Flash(Convert.ToString(ok) + " was added to your cart.", true);
                    break;

                case "remove":
                    CartHelper.Remove(id);
                    Ui.Flash("Item removed from your cart.", true);
                    break;

                case "wish":
                    if (!Auth.IsLoggedIn)
                    {
                        ctx.Response.Redirect("~/Login.aspx?ReturnUrl=" + HttpUtility.UrlEncode(ret));
                        return;
                    }
                    int removed = Db.Exec("DELETE FROM Wishlist WHERE UserId = @u AND ProductId = @p",
                        Db.P("@u", Auth.UserId), Db.P("@p", id));
                    if (removed == 0)
                    {
                        Db.Exec("IF EXISTS (SELECT 1 FROM Products WHERE Id = @p) INSERT Wishlist (UserId, ProductId) VALUES (@u, @p)",
                            Db.P("@u", Auth.UserId), Db.P("@p", id));
                        Ui.Flash("Added to your wishlist.", true);
                    }
                    else Ui.Flash("Removed from your wishlist.", true);
                    break;

                case "logout":
                    FormsAuthentication.SignOut();
                    ctx.Session.Abandon();
                    ctx.Response.Redirect("~/Default.aspx");
                    return;
            }
        }
        catch (System.Threading.ThreadAbortException) { throw; }
        catch (Exception)
        {
            Ui.Flash("Something went wrong. Please try again.", false);
        }
        ctx.Response.Redirect(ret);
    }
}
