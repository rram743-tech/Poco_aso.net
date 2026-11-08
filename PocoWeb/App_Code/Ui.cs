using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Text;
using System.Web;

public static class Ui
{
    private const string BasketSvg =
        "<svg viewBox=\"0 0 24 24\" width=\"18\" height=\"18\" aria-hidden=\"true\"><path fill=\"currentColor\" d=\"M17.21 9l-4.38-6.56c-.19-.28-.51-.42-.83-.42-.32 0-.64.14-.83.43L6.79 9H2c-.55 0-1 .45-1 1 0 .09.01.18.04.27l2.54 9.27c.23.84 1 1.46 1.92 1.46h13c.92 0 1.69-.62 1.93-1.46l2.54-9.27L23 10c0-.55-.45-1-1-1h-4.79zM9 9l3-4.4L15 9H9zm3 8c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z\"/></svg>";

    public const string HeartSvg =
        "<svg viewBox=\"0 0 24 24\" width=\"20\" height=\"20\" aria-hidden=\"true\"><path fill=\"currentColor\" d=\"M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z\"/></svg>";

    public static string H(object o)
    {
        return HttpUtility.HtmlEncode(Convert.ToString(o, CultureInfo.InvariantCulture));
    }

    public static string Money(decimal d)
    {
        return "\u00A3" + d.ToString("0.00", CultureInfo.InvariantCulture);
    }

    public static string Stars(decimal rating)
    {
        StringBuilder sb = new StringBuilder("<span class=\"stars\" title=\"" + rating.ToString("0.0", CultureInfo.InvariantCulture) + " out of 5\">");
        for (int i = 1; i <= 5; i++)
        {
            if (rating >= i) sb.Append("<i class=\"on\">&#9733;</i>");
            else if (rating >= i - 0.5m) sb.Append("<i class=\"half\">&#9733;</i>");
            else sb.Append("<i>&#9733;</i>");
        }
        sb.Append("</span>");
        return sb.ToString();
    }

    public static string ImgUrl(object file)
    {
        string f = file == null || file == DBNull.Value ? "" : Convert.ToString(file);
        if (string.IsNullOrEmpty(f)) f = "noimage.png";
        return VirtualPathUtility.ToAbsolute("~/Images/products/" + f);
    }

    public static string AvatarUrl(object file)
    {
        string f = file == null || file == DBNull.Value ? "" : Convert.ToString(file);
        if (string.IsNullOrEmpty(f)) f = "avatar1.png";
        return VirtualPathUtility.ToAbsolute("~/Images/" + f);
    }

    public static string PriceHtml(DataRowView r)
    {
        decimal price = (decimal)r["Price"];
        if (r["SalePrice"] != DBNull.Value)
            return "<del>" + Money(price) + "</del> <ins>" + Money((decimal)r["SalePrice"]) + "</ins>";
        if (r["PriceMax"] != DBNull.Value)
            return Money(price) + "&ndash;" + Money((decimal)r["PriceMax"]);
        return Money(price);
    }

    public static decimal EffPrice(DataRowView r)
    {
        return r["SalePrice"] != DBNull.Value ? (decimal)r["SalePrice"] : (decimal)r["Price"];
    }

    private static HashSet<int> WishSet()
    {
        HttpContext ctx = HttpContext.Current;
        HashSet<int> set = ctx.Items["wishset"] as HashSet<int>;
        if (set != null) return set;
        set = new HashSet<int>();
        if (Auth.IsLoggedIn)
        {
            try
            {
                DataTable dt = Db.Table("SELECT ProductId FROM Wishlist WHERE UserId = @u", Db.P("@u", Auth.UserId));
                foreach (DataRow r in dt.Rows) set.Add((int)r["ProductId"]);
            }
            catch (Exception) { }
        }
        ctx.Items["wishset"] = set;
        return set;
    }

    public static int WishCount { get { return WishSet().Count; } }

    private static string ActionUrl(string what, int id)
    {
        string ret = HttpUtility.UrlEncode(HttpContext.Current.Request.RawUrl);
        return VirtualPathUtility.ToAbsolute("~/Actions.ashx") + "?do=" + what + "&id=" + id + "&ret=" + ret;
    }

    private static string ProductUrl(int id)
    {
        return VirtualPathUtility.ToAbsolute("~/Product.aspx") + "?id=" + id;
    }

    private static string Heart(int id)
    {
        bool on = WishSet().Contains(id);
        return "<a class=\"wish" + (on ? " on" : "") + "\" href=\"" + ActionUrl("wish", id) + "\" title=\"" +
               (on ? "Remove from wishlist" : "Add to wishlist") + "\">" + HeartSvg + "</a>";
    }

    private static string Cart(int id)
    {
        return "<a class=\"cartbtn\" href=\"" + ActionUrl("cart", id) + "\" title=\"Add to cart\">" + BasketSvg + "</a>";
    }

    /// <summary>Vertical product card (home sliders, shop grid, wishlist).</summary>
    public static string CardV(object dataItem)
    {
        DataRowView r = (DataRowView)dataItem;
        int id = (int)r["Id"];
        StringBuilder sb = new StringBuilder();
        sb.Append("<article class=\"pcard\">");
        if (r["SalePrice"] != DBNull.Value) sb.Append("<span class=\"badge-sale\">Sale!</span>");
        sb.Append(Heart(id));
        sb.Append("<a class=\"pimg\" href=\"" + ProductUrl(id) + "\"><img src=\"" + ImgUrl(r["ImageFile"]) + "\" alt=\"" + H(r["Name"]) + "\" /></a>");
        sb.Append("<div class=\"pbody\">" + Stars((decimal)r["Rating"]));
        sb.Append("<h3><a href=\"" + ProductUrl(id) + "\">" + H(r["Name"]) + "</a></h3>");
        sb.Append("<p>" + H(r["Description"]) + "</p>");
        sb.Append("<div class=\"pfoot\"><span class=\"price\">" + PriceHtml(r) + "</span>" + Cart(id) + "</div>");
        sb.Append("</div></article>");
        return sb.ToString();
    }

    /// <summary>Horizontal product card (menus of the day, list view).</summary>
    public static string CardH(object dataItem)
    {
        DataRowView r = (DataRowView)dataItem;
        int id = (int)r["Id"];
        StringBuilder sb = new StringBuilder();
        sb.Append("<article class=\"hcard\"><div class=\"hcard-in\">");
        sb.Append("<a class=\"himg\" href=\"" + ProductUrl(id) + "\"><img src=\"" + ImgUrl(r["ImageFile"]) + "\" alt=\"" + H(r["Name"]) + "\" /></a>");
        sb.Append("<div class=\"hbody\"><h3><a href=\"" + ProductUrl(id) + "\">" + H(r["Name"]) + "</a></h3>" + Stars((decimal)r["Rating"]));
        sb.Append("<p>" + H(r["Description"]) + "</p><span class=\"price\">" + PriceHtml(r) + "</span></div>");
        sb.Append(Cart(id));
        sb.Append("</div></article>");
        return sb.ToString();
    }

    /// <summary>Small card for the "Best Deals" sidebar.</summary>
    public static string CardS(object dataItem)
    {
        DataRowView r = (DataRowView)dataItem;
        int id = (int)r["Id"];
        return "<a class=\"scard\" href=\"" + ProductUrl(id) + "\"><span class=\"simg\"><img src=\"" + ImgUrl(r["ImageFile"]) + "\" alt=\"\" /></span>" +
               "<span class=\"sbody\">" + Stars((decimal)r["Rating"]) + "<b>" + H(r["Name"]) + "</b><span class=\"price\">" + PriceHtml(r) + "</span></span></a>";
    }

    public static void Flash(string message, bool ok)
    {
        HttpContext.Current.Session["flash"] = (ok ? "ok|" : "err|") + message;
    }
}
