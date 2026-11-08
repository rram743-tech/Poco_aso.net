<%@ Page Title="Menu - Poco!" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Menu.aspx.cs" Inherits="MenuPage" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<section class="page-banner"><div class="container"><h1>Our Menu</h1><p>Freshly made pizza, burgers, pasta and drinks.</p></div></section>
<section class="container section">
    <asp:Literal ID="litMenu" runat="server" />
</section>
</asp:Content>
