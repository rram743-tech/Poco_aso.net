using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Web;

public partial class ShopPage : System.Web.UI.Page
{
    private const int PageSize = 12;

    private int cat, size_page, minP, maxP, ceil;
    private string q, sizeFilter, sort, view;

    protected bool ListView { get { return view == "list"; } }
    protected int PriceCeil { get { return ceil; } }
    protected int PriceMin { get { return minP; } }
    protected int PriceMax { get { return maxP; } }

    protected void Page_Load(object sender, EventArgs e)
    {
        Master.ActiveNav = "shop";
        ReadQuery();
        if (!IsPostBack)
        {
            txtQ.Text = q;
            ddlSort.SelectedValue = sort;
            hfMin.Value = minP.ToString(CultureInfo.InvariantCulture);
            hfMax.Value = maxP.ToString(CultureInfo.InvariantCulture);
        }
        try { BindAll(); }
        catch (Exception)
        {
            litEmpty.Text = "<p class=\"empty\">Products could not be loaded. Run Database/PocoDB.sql and check the connection string in Web.config.</p>";
        }
    }

    private void ReadQuery()
    {
        int.TryParse(Request.QueryString["cat"], out cat);
        int.TryParse(Request.QueryString["page"], out size_page);
        if (size_page < 1) size_page = 1;
        q = (Request.QueryString["q"] ?? "").Trim();
        if (q.Length > 80) q = q.Substring(0, 80);
        sizeFilter = (Request.QueryString["size"] ?? "").Trim().ToUpperInvariant();
        if (sizeFilter != "L" && sizeFilter != "M" && sizeFilter != "S" && sizeFilter != "X") sizeFilter = "";
        sort = (Request.QueryString["sort"] ?? "default").ToLowerInvariant();
        List<string> allowed = new List<string>(new string[] { "default", "popularity", "rating", "latest", "price", "price-desc" });
        if (!allowed.Contains(sort)) sort = "default";
        view = Request.QueryString["view"] == "list" ? "list" : "grid";

        ceil = 20;
        try
        {
            object m = Db.Scalar("SELECT MAX(ISNULL(SalePrice, Price)) FROM Products WHERE IsActive = 1");
            if (m != null) ceil = Math.Max(20, (int)Math.Ceiling(Convert.ToDecimal(m)));
        }
        catch (Exception) { }
        if (!int.TryParse(Request.QueryString["min"], out minP)) minP = 0;
        if (!int.TryParse(Request.QueryString["max"], out maxP)) maxP = ceil;
        minP = Math.Max(0, Math.Min(minP, ceil));
        maxP = Math.Max(minP, Math.Min(maxP, ceil));
    }

    private string BuildWhere(List<SqlParameter> ps)
    {
        StringBuilder w = new StringBuilder(" WHERE p.IsActive = 1");
        if (cat > 0) { w.Append(" AND p.CategoryId = @cat"); ps.Add(new SqlParameter("@cat", cat)); }
        if (q.Length > 0) { w.Append(" AND (p.Name LIKE @q OR p.Description LIKE @q)"); ps.Add(new SqlParameter("@q", "%" + q + "%")); }
        if (sizeFilter.Length > 0) { w.Append(" AND (',' + p.Sizes + ',') LIKE @size"); ps.Add(new SqlParameter("@size", "%," + sizeFilter + ",%")); }
        w.Append(" AND ISNULL(p.SalePrice, p.Price) BETWEEN @min AND @max");
        ps.Add(new SqlParameter("@min", minP));
        ps.Add(new SqlParameter("@max", maxP));
        return w.ToString();
    }

    private void BindAll()
    {
        List<SqlParameter> cp = new List<SqlParameter>();
        string where = BuildWhere(cp);
        int total = Convert.ToInt32(Db.Scalar("SELECT COUNT(*) FROM Products p" + where, cp.ToArray()));
        int pages = Math.Max(1, (int)Math.Ceiling(total / (double)PageSize));
        if (size_page > pages) size_page = pages;

        string order;
        switch (sort)
        {
            case "popularity": order = "p.IsPopular DESC, p.Rating DESC, p.Id"; break;
            case "rating": order = "p.Rating DESC, p.Id"; break;
            case "latest": order = "p.CreatedAt DESC, p.Id DESC"; break;
            case "price": order = "ISNULL(p.SalePrice, p.Price), p.Id"; break;
            case "price-desc": order = "ISNULL(p.SalePrice, p.Price) DESC, p.Id"; break;
            default: order = "p.Id"; break;
        }

        List<SqlParameter> lp = new List<SqlParameter>();
        string where2 = BuildWhere(lp);
        lp.Add(new SqlParameter("@off", (size_page - 1) * PageSize));
        lp.Add(new SqlParameter("@take", PageSize));
        DataTable dt = Db.Table("SELECT p.* FROM Products p" + where2 + " ORDER BY " + order +
                                " OFFSET @off ROWS FETCH NEXT @take ROWS ONLY", lp.ToArray());

        rptProducts.DataSource = dt.DefaultView;
        rptProducts.DataBind();
        rptProducts.Visible = dt.Rows.Count > 0;
        litEmpty.Text = dt.Rows.Count == 0 ? "<p class=\"empty\">No products were found matching your selection.</p>" : "";

        if (total == 0) litCount.Text = "Showing 0 results";
        else
        {
            int from = (size_page - 1) * PageSize + 1;
            int to = from + dt.Rows.Count - 1;
            litCount.Text = "Showing " + from + "&ndash;" + to + " of " + total + " results";
        }

        litViewSwitch.Text =
            "<a class=\"vw" + (ListView ? "" : " on") + "\" href=\"" + Url("view", "grid") + "\" title=\"Grid view\">&#9638;</a>" +
            "<a class=\"vw" + (ListView ? " on" : "") + "\" href=\"" + Url("view", "list") + "\" title=\"List view\">&#9776;</a>";

        BuildPager(pages);
        BuildCategories();
        BuildSizes();
        rptDeals.DataSource = Db.Table("SELECT TOP 3 * FROM Products WHERE IsActive = 1 AND IsDeal = 1 ORDER BY Id").DefaultView;
        rptDeals.DataBind();
    }

    private void BuildPager(int pages)
    {
        if (pages <= 1) { litPager.Text = ""; return; }
        StringBuilder sb = new StringBuilder("<nav class=\"pager\">");
        if (size_page > 1) sb.Append("<a href=\"" + Url("page", (size_page - 1).ToString()) + "\">&lsaquo;</a>");
        for (int i = 1; i <= pages; i++)
            sb.Append(i == size_page ? "<span class=\"cur\">" + i + "</span>" : "<a href=\"" + Url("page", i.ToString()) + "\">" + i + "</a>");
        if (size_page < pages) sb.Append("<a href=\"" + Url("page", (size_page + 1).ToString()) + "\">&rsaquo;</a>");
        sb.Append("</nav>");
        litPager.Text = sb.ToString();
    }

    private static string CatIcon(string name)
    {
        switch (name)
        {
            case "Burgers": return "\U0001F354";
            case "Cold Drinks": return "\U0001F379";
            case "Hot Drinks": return "\u2615";
            case "Pasta": return "\U0001F35D";
            case "Pizza": return "\U0001F355";
            default: return "\U0001F37D";
        }
    }

    private void BuildCategories()
    {
        DataTable dt = Db.Table(
            "SELECT c.Id, c.Name, COUNT(p.Id) AS Cnt FROM Categories c " +
            "LEFT JOIN Products p ON p.CategoryId = c.Id AND p.IsActive = 1 " +
            "GROUP BY c.Id, c.Name, c.SortOrder ORDER BY c.SortOrder");
        StringBuilder sb = new StringBuilder();
        foreach (DataRow r in dt.Rows)
        {
            int id = (int)r["Id"];
            sb.Append("<li" + (id == cat ? " class=\"on\"" : "") + "><a href=\"" + Url("cat", id == cat ? "" : id.ToString()) + "\">" +
                      "<span class=\"ci\">" + CatIcon((string)r["Name"]) + "</span>" + Ui.H(r["Name"]) + "<em>(" + r["Cnt"] + ")</em></a></li>");
        }
        litCats.Text = sb.ToString();
    }

    private void BuildSizes()
    {
        StringBuilder sb = new StringBuilder();
        foreach (string s in new string[] { "L", "M", "S", "X" })
            sb.Append("<a class=\"size" + (sizeFilter == s ? " on" : "") + "\" href=\"" + Url("size", sizeFilter == s ? "" : s) + "\">" + s + "</a>");
        litSizes.Text = sb.ToString();
    }

    /// <summary>Builds a Shop.aspx URL from the current filters, overriding one key.</summary>
    private string Url(string key, string value)
    {
        Dictionary<string, string> p = new Dictionary<string, string>();
        if (cat > 0) p["cat"] = cat.ToString();
        if (q.Length > 0) p["q"] = q;
        if (sizeFilter.Length > 0) p["size"] = sizeFilter;
        if (sort != "default") p["sort"] = sort;
        if (view == "list") p["view"] = "list";
        if (minP > 0) p["min"] = minP.ToString();
        if (maxP < ceil) p["max"] = maxP.ToString();
        if (key != "page") p.Remove("page");
        if (string.IsNullOrEmpty(value) || (key == "view" && value == "grid") || (key == "page" && value == "1")) p.Remove(key);
        else p[key] = value;
        StringBuilder sb = new StringBuilder(ResolveUrl("~/Shop.aspx"));
        bool first = true;
        foreach (KeyValuePair<string, string> kv in p)
        {
            sb.Append(first ? "?" : "&amp;");
            sb.Append(kv.Key + "=" + HttpUtility.UrlEncode(kv.Value));
            first = false;
        }
        return sb.ToString();
    }

    private void GoTo(string key, string value)
    {
        Response.Redirect(Url(key, value).Replace("&amp;", "&"));
    }

    protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
    {
        GoTo("sort", ddlSort.SelectedValue == "default" ? "" : ddlSort.SelectedValue);
    }

    protected void btnSearchProducts_Click(object sender, EventArgs e)
    {
        q = (txtQ.Text ?? "").Trim();
        GoTo("q", q);
    }

    protected void btnFilter_Click(object sender, EventArgs e)
    {
        int lo, hi;
        if (!int.TryParse(hfMin.Value, out lo)) lo = 0;
        if (!int.TryParse(hfMax.Value, out hi)) hi = ceil;
        lo = Math.Max(0, Math.Min(lo, ceil));
        hi = Math.Max(lo, Math.Min(hi, ceil));
        minP = lo; maxP = hi;
        GoTo("page", "");
    }
}
