using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class HomePage : System.Web.UI.Page
{
    private static readonly string[][] Tabs = new string[][]
    {
        new string[] { "Pizza", "PIZZA" }, new string[] { "Sushi", "SUSHI" }, new string[] { "Salats", "SALATS" },
        new string[] { "Burger", "BURGER" }, new string[] { "Dersest", "DERSEST" }
    };

    protected string ActiveTab
    {
        get { return (ViewState["tab"] as string) ?? "Pizza"; }
        set { ViewState["tab"] = value; }
    }

    protected int CategoryId(string name)
    {
        try
        {
            object o = Db.Scalar("SELECT Id FROM Categories WHERE Name = @n", Db.P("@n", name));
            return o == null ? 0 : Convert.ToInt32(o);
        }
        catch (Exception) { return 0; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Master.ActiveNav = "home";
        if (!IsPostBack) BindAll();
    }

    private void BindAll()
    {
        try
        {
            rptBest.DataSource = Db.Table("SELECT * FROM Products WHERE IsActive = 1 AND IsFeatured = 1 ORDER BY Id").DefaultView;
            rptBest.DataBind();
            rptSpecial.DataSource = Db.Table("SELECT * FROM SpecialMenu ORDER BY SortOrder");
            rptSpecial.DataBind();
            rptPopular.DataSource = Db.Table("SELECT * FROM Products WHERE IsActive = 1 AND IsPopular = 1 ORDER BY Id").DefaultView;
            rptPopular.DataBind();
            rptTesti.DataSource = Db.Table("SELECT * FROM Testimonials ORDER BY SortOrder");
            rptTesti.DataBind();
            BindTabs();
        }
        catch (Exception)
        {
            Ui.Flash("Database is not available. Run Database/PocoDB.sql and check the connection string in Web.config.", false);
        }
    }

    private void BindTabs()
    {
        DataTable t = new DataTable();
        t.Columns.Add("Tab"); t.Columns.Add("Label");
        foreach (string[] x in Tabs) t.Rows.Add(x[0], x[1]);
        rptTabs.DataSource = t;
        rptTabs.DataBind();

        DataTable items = Db.Table("SELECT * FROM Products WHERE IsActive = 1 AND MenuTab = @t ORDER BY Id", Db.P("@t", ActiveTab));
        rptMenuDay.DataSource = items.DefaultView;
        rptMenuDay.DataBind();
        litNoItems.Text = items.Rows.Count == 0 ? "<p class=\"empty\">No dishes in this category yet. Please check another tab.</p>" : "";
    }

    protected void rptTabs_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "tab")
        {
            ActiveTab = Convert.ToString(e.CommandArgument);
            BindTabs();
        }
    }
}
