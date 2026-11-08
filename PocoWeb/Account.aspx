<%@ Page Title="My Account - Poco!" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Account.aspx.cs" Inherits="AccountPage" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<section class="page-banner"><div class="container"><h1>My Account</h1><p><asp:Literal ID="litWelcome" runat="server" /></p></div></section>
<section class="container section">
    <h2 class="menu-cat">My orders</h2>
    <asp:Literal ID="litOrders" runat="server" />
</section>
</asp:Content>
