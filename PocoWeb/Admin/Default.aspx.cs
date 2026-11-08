using System;
using System.Data;
using System.Globalization;

public partial class AdminHomePage : System.Web.UI.Page
{
    private static string Box(string label, string value)
    {
        return "<div class=\"stat\"><b>" + value + "</b><span>" + label + "</span></div>";
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Master.ActiveNav = "page";
        try
        {
            DataTable t = Db.Table(
                "SELECT (SELECT COUNT(*) FROM Products) AS Products, (SELECT COUNT(*) FROM Orders) AS Orders, " +
                "(SELECT COUNT(*) FROM Users WHERE Role = N'Customer') AS Customers, " +
                "(SELECT COUNT(*) FROM NewsletterSubscribers) AS Subs, (SELECT COUNT(*) FROM ContactMessages) AS Msgs, " +
                "(SELECT ISNULL(SUM(Total), 0) FROM Orders WHERE Status <> N'Cancelled') AS Revenue");
            DataRow r = t.Rows[0];
            litStats.Text = Box("Products", r["Products"].ToString()) + Box("Orders", r["Orders"].ToString()) +
                            Box("Customers", r["Customers"].ToString()) + Box("Subscribers", r["Subs"].ToString()) +
                            Box("Messages", r["Msgs"].ToString()) + Box("Revenue", Ui.Money((decimal)r["Revenue"]));
        }
        catch (Exception) { litStats.Text = "<p class=\"empty\">Statistics are unavailable.</p>"; }
    }
}
