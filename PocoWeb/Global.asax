<%@ Application Language="C#" %>
<script runat="server">
    void Application_Start(object sender, EventArgs e)
    {
        try { Db.EnsureAdmin(); }
        catch (Exception) { /* database not ready yet - run Database/PocoDB.sql first */ }
    }

    void Application_PostAuthenticateRequest(object sender, EventArgs e)
    {
        System.Web.Security.FormsIdentity id = Context.User != null
            ? Context.User.Identity as System.Web.Security.FormsIdentity : null;
        if (id != null && id.Ticket != null)
        {
            string[] parts = (id.Ticket.UserData ?? "").Split('|');
            Context.User = new System.Security.Principal.GenericPrincipal(id, new string[] { parts[0] });
        }
    }
</script>
