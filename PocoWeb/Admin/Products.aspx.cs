using System;
using System.Data;
using System.Globalization;
using System.IO;
using System.Web.UI.WebControls;

public partial class AdminProductsPage : System.Web.UI.Page
{
    private static readonly string[] AllowedExt = { ".png", ".jpg", ".jpeg", ".webp" };

    protected void Page_Load(object sender, EventArgs e)
    {
        Master.ActiveNav = "page";
        if (!IsPostBack)
        {
            LoadCategories();
            BindList();
        }
    }

    private void LoadCategories()
    {
        ddlCategory.DataSource = Db.Table("SELECT Id, Name FROM Categories ORDER BY SortOrder");
        ddlCategory.DataTextField = "Name";
        ddlCategory.DataValueField = "Id";
        ddlCategory.DataBind();
    }

    private void BindList()
    {
        rptProducts.DataSource = Db.Table(
            "SELECT p.*, c.Name AS CategoryName FROM Products p LEFT JOIN Categories c ON c.Id = p.CategoryId ORDER BY p.Id DESC").DefaultView;
        rptProducts.DataBind();
    }

    private static decimal? Dec(string s)
    {
        decimal d;
        if (string.IsNullOrWhiteSpace(s)) return null;
        return decimal.TryParse(s.Trim(), NumberStyles.Number, CultureInfo.InvariantCulture, out d) ? (decimal?)d : null;
    }

    private void ClearForm()
    {
        hfId.Value = "0"; hfImage.Value = "";
        txtName.Text = txtPrice.Text = txtSale.Text = txtMax.Text = txtDesc.Text = "";
        txtRating.Text = "4"; txtSizes.Text = "L,M,S";
        ddlTab.SelectedIndex = 0;
        chkFeatured.Checked = chkPopular.Checked = chkDeal.Checked = false;
        chkActive.Checked = true;
        litFormTitle.Text = "Add a product";
    }

    protected void btnCancel_Click(object sender, EventArgs e) { ClearForm(); }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        decimal? price = Dec(txtPrice.Text), sale = Dec(txtSale.Text), max = Dec(txtMax.Text), rating = Dec(txtRating.Text);
        if (price == null) { Ui.Flash("Enter a valid price.", false); return; }
        if (sale != null && sale.Value >= price.Value) { Ui.Flash("The sale price must be lower than the regular price.", false); return; }
        if (max != null && max.Value < price.Value) { Ui.Flash("The upper price must be at least the regular price.", false); return; }

        string image = hfImage.Value;
        if (fuImage.HasFile)
        {
            string ext = Path.GetExtension(fuImage.FileName).ToLowerInvariant();
            if (Array.IndexOf(AllowedExt, ext) < 0) { Ui.Flash("Only PNG, JPG or WEBP images are allowed.", false); return; }
            if (fuImage.PostedFile.ContentLength > 2 * 1024 * 1024) { Ui.Flash("The image must be smaller than 2 MB.", false); return; }
            image = Guid.NewGuid().ToString("N") + ext;
            fuImage.SaveAs(Server.MapPath("~/Images/products/" + image));
        }

        int id = int.Parse(hfId.Value, CultureInfo.InvariantCulture);
        object cat = string.IsNullOrEmpty(ddlCategory.SelectedValue) ? null : (object)int.Parse(ddlCategory.SelectedValue, CultureInfo.InvariantCulture);
        System.Data.SqlClient.SqlParameter[] ps = new System.Data.SqlClient.SqlParameter[]
        {
            Db.P("@n", txtName.Text.Trim()), Db.P("@d", txtDesc.Text.Trim()), Db.P("@p", price.Value),
            Db.P("@s", sale.HasValue ? (object)sale.Value : null), Db.P("@m", max.HasValue ? (object)max.Value : null),
            Db.P("@r", rating.HasValue ? rating.Value : 0m), Db.P("@c", cat),
            Db.P("@i", string.IsNullOrEmpty(image) ? null : image), Db.P("@z", txtSizes.Text.Trim().ToUpperInvariant()),
            Db.P("@t", string.IsNullOrEmpty(ddlTab.SelectedValue) ? null : ddlTab.SelectedValue),
            Db.P("@f", chkFeatured.Checked), Db.P("@po", chkPopular.Checked), Db.P("@de", chkDeal.Checked), Db.P("@a", chkActive.Checked),
            Db.P("@id", id)
        };
        try
        {
            if (id == 0)
                Db.Exec("INSERT Products (Name, Description, Price, SalePrice, PriceMax, Rating, CategoryId, ImageFile, Sizes, MenuTab, IsFeatured, IsPopular, IsDeal, IsActive) " +
                        "VALUES (@n, @d, @p, @s, @m, @r, @c, @i, @z, @t, @f, @po, @de, @a)", ps);
            else
                Db.Exec("UPDATE Products SET Name=@n, Description=@d, Price=@p, SalePrice=@s, PriceMax=@m, Rating=@r, CategoryId=@c, ImageFile=@i, " +
                        "Sizes=@z, MenuTab=@t, IsFeatured=@f, IsPopular=@po, IsDeal=@de, IsActive=@a WHERE Id=@id", ps);
            Ui.Flash("Product saved.", true);
            Response.Redirect("~/Admin/Products.aspx");
        }
        catch (System.Threading.ThreadAbortException) { throw; }
        catch (Exception) { Ui.Flash("The product could not be saved. Check the values and try again.", false); }
    }

    protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int id;
        if (!int.TryParse(Convert.ToString(e.CommandArgument), out id)) return;
        if (e.CommandName == "edit")
        {
            DataTable dt = Db.Table("SELECT * FROM Products WHERE Id = @id", Db.P("@id", id));
            if (dt.Rows.Count == 0) return;
            DataRow r = dt.Rows[0];
            hfId.Value = id.ToString(CultureInfo.InvariantCulture);
            hfImage.Value = r["ImageFile"] == DBNull.Value ? "" : (string)r["ImageFile"];
            txtName.Text = (string)r["Name"];
            txtDesc.Text = (string)r["Description"];
            txtPrice.Text = ((decimal)r["Price"]).ToString("0.00", CultureInfo.InvariantCulture);
            txtSale.Text = r["SalePrice"] == DBNull.Value ? "" : ((decimal)r["SalePrice"]).ToString("0.00", CultureInfo.InvariantCulture);
            txtMax.Text = r["PriceMax"] == DBNull.Value ? "" : ((decimal)r["PriceMax"]).ToString("0.00", CultureInfo.InvariantCulture);
            txtRating.Text = ((decimal)r["Rating"]).ToString("0.0", CultureInfo.InvariantCulture);
            txtSizes.Text = (string)r["Sizes"];
            ListItem cat = r["CategoryId"] == DBNull.Value ? null : ddlCategory.Items.FindByValue(r["CategoryId"].ToString());
            if (cat != null) ddlCategory.SelectedValue = cat.Value;
            ListItem tab = r["MenuTab"] == DBNull.Value ? null : ddlTab.Items.FindByValue((string)r["MenuTab"]);
            ddlTab.SelectedIndex = tab == null ? 0 : ddlTab.Items.IndexOf(tab);
            chkFeatured.Checked = (bool)r["IsFeatured"];
            chkPopular.Checked = (bool)r["IsPopular"];
            chkDeal.Checked = (bool)r["IsDeal"];
            chkActive.Checked = (bool)r["IsActive"];
            litFormTitle.Text = "Edit product #" + id;
        }
        else if (e.CommandName == "delete")
        {
            try
            {
                Db.Exec("DELETE FROM Products WHERE Id = @id", Db.P("@id", id));
                Ui.Flash("Product deleted.", true);
            }
            catch (Exception) { Ui.Flash("The product could not be deleted.", false); }
            Response.Redirect("~/Admin/Products.aspx");
        }
    }
}
