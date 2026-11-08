using System;
using System.Data;
using System.Globalization;

public partial class ProductPage : System.Web.UI.Page
{
    private int id;
    private DataRowView product;

    protected void Page_Load(object sender, EventArgs e)
    {
        Master.ActiveNav = "shop";
        int.TryParse(Request.QueryString["id"], out id);
        DataTable dt = null;
        try { dt = Db.Table("SELECT p.*, c.Name AS CategoryName FROM Products p LEFT JOIN Categories c ON c.Id = p.CategoryId WHERE p.Id = @id AND p.IsActive = 1", Db.P("@id", id)); }
        catch (Exception) { }

        if (dt == null || dt.Rows.Count == 0)
        {
            pnlProduct.Visible = false;
            litMissing.Text = "<p class=\"empty\">Sorry, this product could not be found. <a href=\"" + ResolveUrl("~/Shop.aspx") + "\">Back to shop</a></p>";
            return;
        }
        product = dt.DefaultView[0];
        Title = Convert.ToString(product["Name"]) + " - Poco!";

        if (!IsPostBack)
        {
            imgProduct.ImageUrl = Ui.ImgUrl(product["ImageFile"]);
            imgProduct.AlternateText = Convert.ToString(product["Name"]);
            litName.Text = Ui.H(product["Name"]);
            litStars.Text = Ui.Stars((decimal)product["Rating"]);
            litPrice.Text = Ui.PriceHtml(product);
            litDesc.Text = Ui.H(product["Description"]);
            litSizes.Text = "<b>Sizes:</b> " + Ui.H(Convert.ToString(product["Sizes"]).Replace(",", ", "));
            litCrumb.Text = "<p class=\"crumb\"><a href=\"" + ResolveUrl("~/Shop.aspx") + "\">Shop</a> / " + Ui.H(product["CategoryName"]) + "</p>";
            UpdateWishButton();

            DataTable rel = Db.Table("SELECT TOP 4 * FROM Products WHERE IsActive = 1 AND Id <> @id AND CategoryId = @c ORDER BY Id",
                Db.P("@id", id), Db.P("@c", product["CategoryId"] == DBNull.Value ? (object)DBNull.Value : product["CategoryId"]));
            rptRelated.DataSource = rel.DefaultView;
            rptRelated.DataBind();
            pnlRelated.Visible = rel.Rows.Count > 0;
        }
    }

    private void UpdateWishButton()
    {
        bool on = false;
        if (Auth.IsLoggedIn)
            on = Db.Scalar("SELECT 1 FROM Wishlist WHERE UserId = @u AND ProductId = @p", Db.P("@u", Auth.UserId), Db.P("@p", id)) != null;
        btnWish.Text = on ? "REMOVE FROM WISHLIST" : "ADD TO WISHLIST";
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        int qty;
        if (!int.TryParse(txtQty.Text, NumberStyles.Integer, CultureInfo.InvariantCulture, out qty) || qty < 1) qty = 1;
        CartHelper.Add(id, qty);
        Ui.Flash(Convert.ToString(product["Name"]) + " was added to your cart.", true);
        Response.Redirect(Request.RawUrl);
    }

    protected void btnWish_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Actions.ashx?do=wish&id=" + id + "&ret=" + Server.UrlEncode(Request.RawUrl));
    }
}
