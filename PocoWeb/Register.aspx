<%@ Page Title="Register - Poco!" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="RegisterPage" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<section class="page-banner"><div class="container"><h1>Create Account</h1></div></section>
<section class="container section">
    <asp:Panel ID="pnlReg" runat="server" CssClass="form-card narrow" DefaultButton="btnRegister">
        <h3>Join Poco!</h3>
        <asp:Literal ID="litError" runat="server" />
        <label for="<%= txtName.ClientID %>">Full name</label>
        <asp:TextBox ID="txtName" runat="server" MaxLength="100" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName" ValidationGroup="reg" Display="Dynamic" CssClass="err" ErrorMessage="Please enter your name." />
        <label for="<%= txtEmail.ClientID %>">Email</label>
        <asp:TextBox ID="txtEmail" runat="server" MaxLength="150" TextMode="Email" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" ValidationGroup="reg" Display="Dynamic" CssClass="err" ErrorMessage="Please enter your email." />
        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail" ValidationGroup="reg" Display="Dynamic" CssClass="err"
            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" ErrorMessage="Please enter a valid email address." />
        <label for="<%= txtPhone.ClientID %>">Phone (optional)</label>
        <asp:TextBox ID="txtPhone" runat="server" MaxLength="30" TextMode="Phone" />
        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPhone" ValidationGroup="reg" Display="Dynamic" CssClass="err"
            ValidationExpression="^[0-9+()\-\s]{7,20}$" ErrorMessage="Enter a valid phone number." />
        <label for="<%= txtPassword.ClientID %>">Password (min. 6 characters)</label>
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" MaxLength="100" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword" ValidationGroup="reg" Display="Dynamic" CssClass="err" ErrorMessage="Please choose a password." />
        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPassword" ValidationGroup="reg" Display="Dynamic" CssClass="err"
            ValidationExpression="^.{6,100}$" ErrorMessage="Password must be at least 6 characters." />
        <label for="<%= txtConfirm.ClientID %>">Confirm password</label>
        <asp:TextBox ID="txtConfirm" runat="server" TextMode="Password" MaxLength="100" />
        <asp:CompareValidator runat="server" ControlToValidate="txtConfirm" ControlToCompare="txtPassword" ValidationGroup="reg" Display="Dynamic" CssClass="err" ErrorMessage="Passwords do not match." />
        <asp:Button ID="btnRegister" runat="server" Text="CREATE ACCOUNT" ValidationGroup="reg" OnClick="btnRegister_Click" CssClass="btn block" />
        <p class="alt">Already registered? <a href="<%= ResolveUrl("~/Login.aspx") %>">Login</a></p>
    </asp:Panel>
</section>
</asp:Content>
