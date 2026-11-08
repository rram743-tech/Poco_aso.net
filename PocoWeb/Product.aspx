<%@ Page Title="Product - Poco!" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Product.aspx.cs" Inherits="ProductPage" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<section class="container product-page">
    <asp:Literal ID="litMissing" runat="server" />
    <asp:Panel ID="pnlProduct" runat="server" CssClass="pd">
        <div class="pd-img"><asp:Image ID="imgProduct" runat="server" /></div>
        <div class="pd-info">
            <asp:Literal ID="litCrumb" runat="server" />
            <h1><asp:Literal ID="litName" runat="server" /></h1>
            <asp:Literal ID="litStars" runat="server" />
            <p class="pd-price"><asp:Literal ID="litPrice" runat="server" /></p>
            <p class="pd-desc"><asp:Literal ID="litDesc" runat="server" /></p>
            <p class="pd-sizes"><asp:Literal ID="litSizes" runat="server" /></p>
            <asp:Panel ID="pnlBuy" runat="server" DefaultButton="btnAdd" CssClass="pd-buy">
                <asp:TextBox ID="txtQty" runat="server" Text="1" MaxLength="2" CssClass="qty" TextMode="Number" />
                <asp:Button ID="btnAdd" runat="server" Text="ADD TO CART" OnClick="btnAdd_Click" CssClass="btn" ValidationGroup="buy" />
                <asp:LinkButton ID="btnWish" runat="server" OnClick="btnWish_Click" CausesValidation="false" CssClass="btn outline" />
            </asp:Panel>
            <asp:RangeValidator runat="server" ControlToValidate="txtQty" Type="Integer" MinimumValue="1" MaximumValue="99" ValidationGroup="buy"
                Display="Dynamic" CssClass="err" ErrorMessage="Quantity must be between 1 and 99." />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtQty" ValidationGroup="buy" Display="Dynamic" CssClass="err" ErrorMessage="Enter a quantity." />
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlRelated" runat="server" Visible="false">
        <div class="sec-head"><h2>Related products</h2></div>
        <div class="grid-4">
            <asp:Repeater ID="rptRelated" runat="server"><ItemTemplate><%# Ui.CardV(Container.DataItem) %></ItemTemplate></asp:Repeater>
        </div>
    </asp:Panel>
</section>
</asp:Content>
