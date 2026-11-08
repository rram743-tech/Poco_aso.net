using System;
using System.Data;
using System.Text;

public partial class MenuPage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.ActiveNav = "menu";
        try
        {
            DataTable dt = Db.Table(
                "SELECT c.Id AS CatId, c.Name AS CategoryName, p.Id, p.Name, p.Description, p.Price, p.SalePrice, p.PriceMax " +
                "FROM Categories c INNER JOIN Products p ON p.CategoryId = c.Id AND p.IsActive = 1 " +
                "ORDER BY c.SortOrder, p.Name");
            StringBuilder sb = new StringBuilder();
            int current = -1;
            foreach (DataRowView r in dt.DefaultView)
            {
                int cat = (int)r["CatId"];
                if (cat != current)
                {
                    if (current != -1) sb.Append("</ul>");
                    sb.Append("<h2 class=\"menu-cat\">" + Ui.H(r["CategoryName"]) + "</h2><ul class=\"menu-full\">");
                    current = cat;
                }
                sb.Append("<li><div class=\"ml-top\"><h4><a href=\"" + ResolveUrl("~/Product.aspx") + "?id=" + r["Id"] + "\">" + Ui.H(r["Name"]) + "</a></h4>" +
                          "<span class=\"ml-line\"></span><b class=\"price\">" + Ui.PriceHtml(r) + "</b>" +
                          "<a class=\"cartbtn mini\" href=\"" + ResolveUrl("~/Actions.ashx") + "?do=cart&amp;id=" + r["Id"] + "&amp;ret=" + Server.UrlEncode(Request.RawUrl) + "\" title=\"Add to cart\">+</a></div>" +
                          "<small>" + Ui.H(r["Description"]) + "</small></li>");
            }
            if (current != -1) sb.Append("</ul>");
            litMenu.Text = sb.Length == 0 ? "<p class=\"empty\">The menu is empty at the moment.</p>" : sb.ToString();
        }
        catch (Exception)
        {
            litMenu.Text = "<p class=\"empty\">The menu could not be loaded. Please check the database connection.</p>";
        }
    }
}
