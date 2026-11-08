<%@ Page Title="Wishlist - Poco!" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Wishlist.aspx.cs" Inherits="WishlistPage" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<section class="page-banner"><div class="container"><h1>My Wishlist</h1></div></section>
<section class="container section">
    <asp:Literal ID="litEmpty" runat="server" />
    <div class="grid-4">
        <asp:Repeater ID="rptWish" runat="server"><ItemTemplate><%# Ui.CardV(Container.DataItem) %></ItemTemplate></asp:Repeater>
    </div>
</section>
</asp:Content>
