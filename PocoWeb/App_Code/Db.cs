using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public static class Db
{
    public static string ConnStr
    {
        get { return ConfigurationManager.ConnectionStrings["PocoDb"].ConnectionString; }
    }

    public static SqlParameter P(string name, object value)
    {
        return new SqlParameter(name, value ?? DBNull.Value);
    }

    public static DataTable Table(string sql, params SqlParameter[] ps)
    {
        using (SqlConnection c = new SqlConnection(ConnStr))
        using (SqlCommand cmd = new SqlCommand(sql, c))
        {
            if (ps != null) cmd.Parameters.AddRange(ps);
            DataTable dt = new DataTable();
            using (SqlDataAdapter da = new SqlDataAdapter(cmd)) { da.Fill(dt); }
            return dt;
        }
    }

    public static object Scalar(string sql, params SqlParameter[] ps)
    {
        using (SqlConnection c = new SqlConnection(ConnStr))
        using (SqlCommand cmd = new SqlCommand(sql, c))
        {
            if (ps != null) cmd.Parameters.AddRange(ps);
            c.Open();
            object o = cmd.ExecuteScalar();
            return o == DBNull.Value ? null : o;
        }
    }

    public static int Exec(string sql, params SqlParameter[] ps)
    {
        using (SqlConnection c = new SqlConnection(ConnStr))
        using (SqlCommand cmd = new SqlCommand(sql, c))
        {
            if (ps != null) cmd.Parameters.AddRange(ps);
            c.Open();
            return cmd.ExecuteNonQuery();
        }
    }

    public static void EnsureAdmin()
    {
        object n = Scalar("SELECT COUNT(*) FROM Users WHERE Role = N'Admin'");
        if (n != null && Convert.ToInt32(n) > 0) return;
        string email = ConfigurationManager.AppSettings["AdminEmail"];
        string pass = ConfigurationManager.AppSettings["AdminPassword"];
        if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(pass)) return;
        Exec("IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = @e) " +
             "INSERT Users (FullName, Email, PasswordHash, Role) VALUES (N'Administrator', @e, @h, N'Admin')",
             P("@e", email), P("@h", Auth.HashPassword(pass)));
    }
}
