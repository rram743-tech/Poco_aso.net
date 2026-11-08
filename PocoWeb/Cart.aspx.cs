using System;
using System.Data;
using System.Globalization;
using System.Web.UI.WebControls;

public partial class CartPage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.ActiveNav = "shop";
        if (!IsPostBack) BindCart();
    }

    private void BindCart()
    {
        DataTable lines = new DataTable();
        try { lines = CartHelper.Lines(); } catch (Exception) { }
        bool has = lines.Rows.Count > 0;
        pnlCart.Visible = has;
        litEmpty.Text = has ? "" : "<div class=\"empty-box\"><p>Your cart is currently empty.</p><a class=\"btn\" href=\"" + ResolveUrl("~/Shop.aspx") + "\">RETURN TO SHOP</a></div>";
        if (!has) return;
        rptCart.DataSource = lines;
        rptCart.DataBind();
        decimal sub = CartHelper.Subtotal(lines);
        decimal del = CartHelper.DeliveryFor(sub);
        litSub.Text = Ui.Money(sub);
        litDel.Text = del == 0 ? "Free" : Ui.Money(del);
        litTotal.Text = Ui.Money(sub + del);
    }

    private void ApplyQuantities()
    {
        foreach (RepeaterItem item in rptCart.Items)
        {
            HiddenField hf = item.FindControl("hfId") as HiddenField;
            TextBox tb = item.FindControl("txtQty") as TextBox;
            if (hf == null || tb == null) continue;
            int id, qty;
            if (!int.TryParse(hf.Value, out id)) continue;
            if (!int.TryParse(tb.Text, NumberStyles.Integer, CultureInfo.InvariantCulture, out qty)) continue;
            CartHelper.Set(id, Math.Max(0, Math.Min(99, qty)));
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        ApplyQuantities();
        Ui.Flash("Cart updated.", true);
        Response.Redirect("~/Cart.aspx");
    }

    protected void btnCheckout_Click(object sender, EventArgs e)
    {
        ApplyQuantities();
        Response.Redirect("~/Checkout.aspx");
    }

    protected void rptCart_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "remove")
        {
            int id;
            if (int.TryParse(Convert.ToString(e.CommandArgument), out id)) CartHelper.Remove(id);
            Ui.Flash("Item removed from your cart.", true);
            Response.Redirect("~/Cart.aspx");
        }
    }
}
