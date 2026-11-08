using System;
using System.Data;
using System.Globalization;
using System.Text;

public partial class AccountPage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.ActiveNav = "page";
        litWelcome.Text = "Welcome back, " + Ui.H(Auth.DisplayName) + ".";
        try
        {
            DataTable orders = Db.Table("SELECT * FROM Orders WHERE UserId = @u ORDER BY CreatedAt DESC", Db.P("@u", Auth.UserId));
            if (orders.Rows.Count == 0)
            {
                litOrders.Text = "<div class=\"empty-box\"><p>You have not placed any orders yet.</p><a class=\"btn\" href=\"" + ResolveUrl("~/Shop.aspx") + "\">START ORDERING</a></div>";
                return;
            }
            StringBuilder sb = new StringBuilder();
            foreach (DataRow o in orders.Rows)
            {
                sb.Append("<div class=\"order-card\"><div class=\"order-head\"><b>Order #" + o["Id"] + "</b><span>" +
                          ((DateTime)o["CreatedAt"]).ToString("dd MMM yyyy HH:mm", CultureInfo.InvariantCulture) +
                          "</span><span class=\"status s-" + Ui.H(((string)o["Status"]).Replace(" ", "").ToLowerInvariant()) + "\">" + Ui.H(o["Status"]) + "</span></div><ul>");
                DataTable items = Db.Table("SELECT * FROM OrderItems WHERE OrderId = @o", Db.P("@o", o["Id"]));
                foreach (DataRow i in items.Rows)
                    sb.Append("<li><span>" + Ui.H(i["ProductName"]) + " &times; " + i["Quantity"] + "</span><b>" +
                              Ui.Money((decimal)i["UnitPrice"] * (int)i["Quantity"]) + "</b></li>");
                sb.Append("</ul><div class=\"order-foot\"><span>Delivery: " + Ui.Money((decimal)o["DeliveryFee"]) + " &middot; " + Ui.H(o["PaymentMethod"]) +
                          "</span><b>Total: " + Ui.Money((decimal)o["Total"]) + "</b></div></div>");
            }
            litOrders.Text = sb.ToString();
        }
        catch (Exception) { litOrders.Text = "<p class=\"empty\">Your orders could not be loaded.</p>"; }
    }
}
