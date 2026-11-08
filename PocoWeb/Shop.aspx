<%@ Page Title="Shop - Poco!" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Shop.aspx.cs" Inherits="ShopPage" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<section class="shop container">
    <div class="shop-main">
        <div class="shop-bar">
            <span class="result-count"><asp:Literal ID="litCount" runat="server" /></span>
            <div class="shop-tools">
                <asp:Literal ID="litViewSwitch" runat="server" />
                <asp:DropDownList ID="ddlSort" runat="server" AutoPostBack="true" CssClass="sort" OnSelectedIndexChanged="ddlSort_SelectedIndexChanged">
                    <asp:ListItem Value="default" Text="Default sorting" />
                    <asp:ListItem Value="popularity" Text="Sort by popularity" />
                    <asp:ListItem Value="rating" Text="Sort by average rating" />
                    <asp:ListItem Value="latest" Text="Sort by latest" />
                    <asp:ListItem Value="price" Text="Sort by price: low to high" />
                    <asp:ListItem Value="price-desc" Text="Sort by price: high to low" />
                </asp:DropDownList>
            </div>
        </div>

        <asp:Literal ID="litEmpty" runat="server" />
        <asp:Repeater ID="rptProducts" runat="server">
            <HeaderTemplate><div class="<%# ListView ? "grid-1" : "grid-3" %>"></HeaderTemplate>
            <ItemTemplate><%# ListView ? Ui.CardH(Container.DataItem) : Ui.CardV(Container.DataItem) %></ItemTemplate>
            <FooterTemplate></div></FooterTemplate>
        </asp:Repeater>
        <asp:Literal ID="litPager" runat="server" />
    </div>

    <aside class="shop-side">
        <div class="side-box cats">
            <h3>Categories</h3>
            <ul><asp:Literal ID="litCats" runat="server" /></ul>
        </div>

        <asp:Panel ID="pnlSearchBox" runat="server" DefaultButton="btnSearchProducts" CssClass="side-search">
            <asp:TextBox ID="txtQ" runat="server" MaxLength="80" placeholder="Search products..." />
            <asp:LinkButton ID="btnSearchProducts" runat="server" CausesValidation="false" OnClick="btnSearchProducts_Click" CssClass="s-btn" aria-label="Search">
                <svg viewBox="0 0 24 24" width="22" height="22"><path fill="currentColor" d="M15.5 14h-.8l-.3-.3A6.5 6.5 0 1 0 14 15.5l.3.3v.8l5 5 1.5-1.5-5-5zm-6 0a4.5 4.5 0 1 1 0-9 4.5 4.5 0 0 1 0 9z"/></svg></asp:LinkButton>
        </asp:Panel>

        <h3 class="side-h">Filter by price</h3>
        <div class="price-filter" id="priceFilter" data-max="<%= PriceCeil %>">
            <div class="range-wrap"><div class="range-track"></div><div class="range-fill" id="rangeFill"></div>
                <input type="range" id="rangeMin" min="0" max="<%= PriceCeil %>" step="1" value="<%= PriceMin %>" />
                <input type="range" id="rangeMax" min="0" max="<%= PriceCeil %>" step="1" value="<%= PriceMax %>" /></div>
            <p>Price: &pound;<span id="lblMin"><%= PriceMin %></span> &mdash; &pound;<span id="lblMax"><%= PriceMax %></span></p>
            <asp:HiddenField ID="hfMin" runat="server" />
            <asp:HiddenField ID="hfMax" runat="server" />
            <asp:Button ID="btnFilter" runat="server" Text="FILTER" CausesValidation="false" OnClick="btnFilter_Click" CssClass="btn small" />
        </div>

        <h3 class="side-h">Filter by size</h3>
        <div class="sizes"><asp:Literal ID="litSizes" runat="server" /></div>

        <h3 class="side-h">Best Deals</h3>
        <asp:Repeater ID="rptDeals" runat="server"><ItemTemplate><%# Ui.CardS(Container.DataItem) %></ItemTemplate></asp:Repeater>
    </aside>
</section>
</asp:Content>
