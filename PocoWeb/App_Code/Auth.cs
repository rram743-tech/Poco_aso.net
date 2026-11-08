using System;
using System.Security.Cryptography;
using System.Web;
using System.Web.Security;

public static class Auth
{
    private const int Iterations = 10000;

    public static string HashPassword(string password)
    {
        byte[] salt = new byte[16];
        using (RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider()) { rng.GetBytes(salt); }
        byte[] hash;
        using (Rfc2898DeriveBytes kdf = new Rfc2898DeriveBytes(password, salt, Iterations)) { hash = kdf.GetBytes(32); }
        return Iterations + "." + Convert.ToBase64String(salt) + "." + Convert.ToBase64String(hash);
    }

    public static bool VerifyPassword(string password, string stored)
    {
        if (string.IsNullOrEmpty(stored)) return false;
        string[] p = stored.Split('.');
        if (p.Length != 3) return false;
        int iter;
        if (!int.TryParse(p[0], out iter)) return false;
        byte[] salt = Convert.FromBase64String(p[1]);
        byte[] expected = Convert.FromBase64String(p[2]);
        byte[] actual;
        using (Rfc2898DeriveBytes kdf = new Rfc2898DeriveBytes(password, salt, iter)) { actual = kdf.GetBytes(expected.Length); }
        int diff = 0;
        for (int i = 0; i < expected.Length; i++) diff |= expected[i] ^ actual[i];
        return diff == 0;
    }

    public static void SignIn(int userId, string role, string name)
    {
        FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
            1, userId.ToString(), DateTime.Now, DateTime.Now.AddHours(2), false, role + "|" + name);
        HttpCookie cookie = new HttpCookie(FormsAuthentication.FormsCookieName, FormsAuthentication.Encrypt(ticket));
        cookie.HttpOnly = true;
        HttpContext.Current.Response.Cookies.Add(cookie);
    }

    public static bool IsLoggedIn
    {
        get { return HttpContext.Current.User != null && HttpContext.Current.User.Identity.IsAuthenticated; }
    }

    public static int UserId
    {
        get
        {
            int id;
            if (IsLoggedIn && int.TryParse(HttpContext.Current.User.Identity.Name, out id)) return id;
            return 0;
        }
    }

    public static bool IsAdmin
    {
        get { return IsLoggedIn && HttpContext.Current.User.IsInRole("Admin"); }
    }

    public static string DisplayName
    {
        get
        {
            FormsIdentity fi = IsLoggedIn ? HttpContext.Current.User.Identity as FormsIdentity : null;
            if (fi == null || fi.Ticket == null) return "";
            string[] p = (fi.Ticket.UserData ?? "").Split('|');
            return p.Length > 1 ? p[1] : "";
        }
    }

    public static bool IsSafeLocalUrl(string url)
    {
        return !string.IsNullOrEmpty(url) && url.StartsWith("/") && !url.StartsWith("//") && !url.StartsWith("/\\");
    }
}
