<%@ Page Title="Cart - Poco!" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Cart.aspx.cs" Inherits="CartPage" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<section class="page-banner"><div class="container"><h1>Your Cart</h1></div></section>
<section class="container section">
    <asp:Literal ID="litEmpty" runat="server" />
    <asp:Panel ID="pnlCart" runat="server">
        <div class="table-wrap">
        <table class="cart-table">
            <thead><tr><th></th><th>Product</th><th>Price</th><th>Quantity</th><th>Total</th><th></th></tr></thead>
            <tbody>
            <asp:Repeater ID="rptCart" runat="server" OnItemCommand="rptCart_ItemCommand">
                <ItemTemplate>
                    <tr>
                        <td class="ct-img"><img src="<%# Ui.ImgUrl(Eval("ImageFile")) %>" alt="" /></td>
                        <td><a href="<%# ResolveUrl("~/Product.aspx") %>?id=<%# Eval("Id") %>"><%# Ui.H(Eval("Name")) %></a></td>
                        <td><%# Ui.Money((decimal)Eval("UnitPrice")) %></td>
                        <td>
                            <asp:HiddenField ID="hfId" runat="server" Value='<%# Eval("Id") %>' />
                            <asp:TextBox ID="txtQty" runat="server" Text='<%# Eval("Qty") %>' CssClass="qty" MaxLength="2" TextMode="Number" />
                        </td>
                        <td><b><%# Ui.Money((decimal)Eval("LineTotal")) %></b></td>
                        <td><asp:LinkButton runat="server" CommandName="remove" CommandArgument='<%# Eval("Id") %>' CausesValidation="false" CssClass="remove" ToolTip="Remove">&times;</asp:LinkButton></td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
            </tbody>
        </table>
        </div>
        <div class="cart-actions">
            <a class="btn outline" href="<%= ResolveUrl("~/Shop.aspx") %>">CONTINUE SHOPPING</a>
            <asp:Button ID="btnUpdate" runat="server" Text="UPDATE CART" CssClass="btn" CausesValidation="false" OnClick="btnUpdate_Click" />
        </div>
        <div class="totals">
            <h3>Cart totals</h3>
            <div><span>Subtotal</span><b><asp:Literal ID="litSub" runat="server" /></b></div>
            <div><span>Delivery</span><b><asp:Literal ID="litDel" runat="server" /></b></div>
            <div class="grand"><span>Total</span><b><asp:Literal ID="litTotal" runat="server" /></b></div>
            <small>Free delivery on orders over &pound;30.</small>
            <asp:Button ID="btnCheckout" runat="server" Text="PROCEED TO CHECKOUT" CssClass="btn block" CausesValidation="false" OnClick="btnCheckout_Click" />
        </div>
    </asp:Panel>
</section>
</asp:Content>
