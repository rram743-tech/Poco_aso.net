<%@ Page Title="Login - Poco!" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="LoginPage" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<section class="page-banner"><div class="container"><h1>Login</h1></div></section>
<section class="container section">
    <asp:Panel ID="pnlLogin" runat="server" CssClass="form-card narrow" DefaultButton="btnLogin">
        <h3>Welcome back</h3>
        <asp:Literal ID="litError" runat="server" />
        <label for="<%= txtEmail.ClientID %>">Email</label>
        <asp:TextBox ID="txtEmail" runat="server" MaxLength="150" TextMode="Email" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" ValidationGroup="login" Display="Dynamic" CssClass="err" ErrorMessage="Please enter your email." />
        <label for="<%= txtPassword.ClientID %>">Password</label>
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" MaxLength="100" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword" ValidationGroup="login" Display="Dynamic" CssClass="err" ErrorMessage="Please enter your password." />
        <asp:Button ID="btnLogin" runat="server" Text="LOGIN" ValidationGroup="login" OnClick="btnLogin_Click" CssClass="btn block" />
        <p class="alt">New to Poco!? <a href="<%= ResolveUrl("~/Register.aspx") %>">Create an account</a></p>
    </asp:Panel>
</section>
</asp:Content>
