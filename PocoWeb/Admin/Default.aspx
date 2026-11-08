<%@ Page Title="Admin - Poco!" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="AdminHomePage" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<section class="page-banner"><div class="container"><h1>Admin Panel</h1><p>Manage products, orders and customers.</p></div></section>
<section class="container section">
    <div class="admin-nav">
        <a class="btn" href="<%= ResolveUrl("~/Admin/Products.aspx") %>">PRODUCTS</a>
        <a class="btn" href="<%= ResolveUrl("~/Admin/Orders.aspx") %>">ORDERS</a>
    </div>
    <div class="stats">
        <asp:Literal ID="litStats" runat="server" />
    </div>
</section>
</asp:Content>
