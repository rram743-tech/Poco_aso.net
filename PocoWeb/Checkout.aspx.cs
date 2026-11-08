using System;
using System.Data;
using System.Data.SqlClient;

public partial class CheckoutPage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.ActiveNav = "shop";
        DataTable lines = CartHelper.Lines();
        if (lines.Rows.Count == 0)
        {
            Ui.Flash("Your cart is empty.", false);
            Response.Redirect("~/Cart.aspx");
            return;
        }
        if (!IsPostBack)
        {
            rptSummary.DataSource = lines;
            rptSummary.DataBind();
            decimal sub = CartHelper.Subtotal(lines);
            decimal del = CartHelper.DeliveryFor(sub);
            litSub.Text = Ui.Money(sub);
            litDel.Text = del == 0 ? "Free" : Ui.Money(del);
            litTotal.Text = Ui.Money(sub + del);

            DataTable u = Db.Table("SELECT FullName, Phone FROM Users WHERE Id = @id", Db.P("@id", Auth.UserId));
            if (u.Rows.Count > 0)
            {
                txtName.Text = Convert.ToString(u.Rows[0]["FullName"]);
                txtPhone.Text = Convert.ToString(u.Rows[0]["Phone"]);
            }
        }
    }

    protected void btnPlace_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        DataTable lines = CartHelper.Lines();
        if (lines.Rows.Count == 0) { Response.Redirect("~/Cart.aspx"); return; }

        decimal sub = CartHelper.Subtotal(lines);
        decimal del = CartHelper.DeliveryFor(sub);
        int orderId;

        using (SqlConnection c = new SqlConnection(Db.ConnStr))
        {
            c.Open();
            SqlTransaction tx = c.BeginTransaction();
            try
            {
                SqlCommand cmd = new SqlCommand(
                    "INSERT Orders (UserId, FullName, Phone, Address, Notes, PaymentMethod, Subtotal, DeliveryFee, Total) " +
                    "VALUES (@u, @n, @p, @a, @no, @pm, @s, @d, @t); SELECT CAST(SCOPE_IDENTITY() AS INT);", c, tx);
                cmd.Parameters.AddWithValue("@u", Auth.UserId);
                cmd.Parameters.AddWithValue("@n", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@p", txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@a", txtAddress.Text.Trim());
                cmd.Parameters.AddWithValue("@no", string.IsNullOrWhiteSpace(txtNotes.Text) ? (object)DBNull.Value : txtNotes.Text.Trim());
                cmd.Parameters.AddWithValue("@pm", rblPay.SelectedValue);
                cmd.Parameters.AddWithValue("@s", sub);
                cmd.Parameters.AddWithValue("@d", del);
                cmd.Parameters.AddWithValue("@t", sub + del);
                orderId = (int)cmd.ExecuteScalar();

                foreach (DataRow r in lines.Rows)
                {
                    SqlCommand ic = new SqlCommand(
                        "INSERT OrderItems (OrderId, ProductId, ProductName, UnitPrice, Quantity) VALUES (@o, @pid, @pn, @up, @q)", c, tx);
                    ic.Parameters.AddWithValue("@o", orderId);
                    ic.Parameters.AddWithValue("@pid", (int)r["Id"]);
                    ic.Parameters.AddWithValue("@pn", (string)r["Name"]);
                    ic.Parameters.AddWithValue("@up", (decimal)r["UnitPrice"]);
                    ic.Parameters.AddWithValue("@q", (int)r["Qty"]);
                    ic.ExecuteNonQuery();
                }
                tx.Commit();
            }
            catch (Exception)
            {
                try { tx.Rollback(); } catch (Exception) { }
                Ui.Flash("Your order could not be placed. Please try again.", false);
                return;
            }
        }

        CartHelper.Clear();
        Ui.Flash("Thank you! Your order #" + orderId + " has been placed.", true);
        Response.Redirect("~/Account.aspx");
    }
}
