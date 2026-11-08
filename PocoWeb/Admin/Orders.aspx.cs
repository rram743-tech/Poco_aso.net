using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class AdminOrdersPage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.ActiveNav = "page";
        if (!IsPostBack) BindOrders();
    }

    private void BindOrders()
    {
        DataTable dt = Db.Table("SELECT * FROM Orders ORDER BY CreatedAt DESC");
        rptOrders.DataSource = dt;
        rptOrders.DataBind();
        litEmpty.Text = dt.Rows.Count == 0 ? "<p class=\"empty\">No orders yet.</p>" : "";
        foreach (RepeaterItem item in rptOrders.Items)
        {
            HiddenField hf = (HiddenField)item.FindControl("hfStatus");
            DropDownList dd = (DropDownList)item.FindControl("ddlStatus");
            ListItem li = dd.Items.FindByValue(hf.Value);
            if (li != null) dd.SelectedValue = li.Value;
        }
    }

    protected void rptOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "save") return;
        int id;
        if (!int.TryParse(Convert.ToString(e.CommandArgument), out id)) return;
        DropDownList dd = (DropDownList)e.Item.FindControl("ddlStatus");
        try
        {
            Db.Exec("UPDATE Orders SET Status = @s WHERE Id = @id", Db.P("@s", dd.SelectedValue), Db.P("@id", id));
            Ui.Flash("Order #" + id + " is now \"" + dd.SelectedValue + "\".", true);
        }
        catch (Exception) { Ui.Flash("The order could not be updated.", false); }
        Response.Redirect("~/Admin/Orders.aspx");
    }
}
