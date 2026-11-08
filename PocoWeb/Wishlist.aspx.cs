using System;
using System.Data;

public partial class WishlistPage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.ActiveNav = "shop";
        if (IsPostBack) return;
        try
        {
            DataTable dt = Db.Table(
                "SELECT p.* FROM Wishlist w INNER JOIN Products p ON p.Id = w.ProductId " +
                "WHERE w.UserId = @u AND p.IsActive = 1 ORDER BY w.AddedAt DESC", Db.P("@u", Auth.UserId));
            rptWish.DataSource = dt.DefaultView;
            rptWish.DataBind();
            litEmpty.Text = dt.Rows.Count == 0
                ? "<div class=\"empty-box\"><p>Your wishlist is empty. Tap the heart on any dish to save it here.</p><a class=\"btn\" href=\"" + ResolveUrl("~/Shop.aspx") + "\">BROWSE THE SHOP</a></div>"
                : "";
        }
        catch (Exception) { litEmpty.Text = "<p class=\"empty\">Your wishlist could not be loaded.</p>"; }
    }
}
