using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;

public static class CartHelper
{
    public const decimal DeliveryFee = 2.50m;
    public const decimal FreeDeliveryFrom = 30m;

    private static Dictionary<int, int> Get()
    {
        Dictionary<int, int> cart = HttpContext.Current.Session["cart"] as Dictionary<int, int>;
        if (cart == null)
        {
            cart = new Dictionary<int, int>();
            HttpContext.Current.Session["cart"] = cart;
        }
        return cart;
    }

    public static void Add(int productId, int qty)
    {
        if (qty < 1) return;
        Dictionary<int, int> cart = Get();
        int cur;
        cart.TryGetValue(productId, out cur);
        cart[productId] = Math.Min(99, cur + qty);
    }

    public static void Set(int productId, int qty)
    {
        Dictionary<int, int> cart = Get();
        if (qty <= 0) cart.Remove(productId);
        else cart[productId] = Math.Min(99, qty);
    }

    public static void Remove(int productId) { Get().Remove(productId); }
    public static void Clear() { Get().Clear(); }

    public static int Count
    {
        get
        {
            int n = 0;
            foreach (KeyValuePair<int, int> kv in Get()) n += kv.Value;
            return n;
        }
    }

    public static decimal DeliveryFor(decimal subtotal)
    {
        if (subtotal <= 0 || subtotal >= FreeDeliveryFrom) return 0m;
        return DeliveryFee;
    }

    /// <summary>Cart lines with current prices from the database (never trusts client prices).</summary>
    public static DataTable Lines()
    {
        Dictionary<int, int> cart = Get();
        DataTable result = new DataTable();
        result.Columns.Add("Id", typeof(int));
        result.Columns.Add("Name", typeof(string));
        result.Columns.Add("ImageFile", typeof(string));
        result.Columns.Add("UnitPrice", typeof(decimal));
        result.Columns.Add("Qty", typeof(int));
        result.Columns.Add("LineTotal", typeof(decimal));
        if (cart.Count == 0) return result;

        List<SqlParameter> ps = new List<SqlParameter>();
        List<string> names = new List<string>();
        int i = 0;
        foreach (int id in cart.Keys)
        {
            string pn = "@p" + i++;
            names.Add(pn);
            ps.Add(new SqlParameter(pn, id));
        }
        DataTable dt = Db.Table(
            "SELECT Id, Name, ImageFile, ISNULL(SalePrice, Price) AS UnitPrice FROM Products WHERE IsActive = 1 AND Id IN (" +
            string.Join(",", names.ToArray()) + ")", ps.ToArray());

        List<int> alive = new List<int>();
        foreach (DataRow r in dt.Rows)
        {
            int id = (int)r["Id"];
            int qty = cart[id];
            decimal price = (decimal)r["UnitPrice"];
            result.Rows.Add(id, r["Name"], r["ImageFile"], price, qty, price * qty);
            alive.Add(id);
        }
        foreach (int id in new List<int>(cart.Keys)) { if (!alive.Contains(id)) cart.Remove(id); }
        return result;
    }

    public static decimal Subtotal(DataTable lines)
    {
        decimal s = 0m;
        foreach (DataRow r in lines.Rows) s += (decimal)r["LineTotal"];
        return s;
    }
}
