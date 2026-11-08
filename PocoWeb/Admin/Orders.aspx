<%@ Page Title="Orders - Admin" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Orders.aspx.cs" Inherits="AdminOrdersPage" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<section class="page-banner"><div class="container"><h1>Manage Orders</h1></div></section>
<section class="container section">
    <div class="admin-nav">
        <a class="btn outline" href="<%= ResolveUrl("~/Admin/Default.aspx") %>">&lsaquo; DASHBOARD</a>
        <a class="btn outline" href="<%= ResolveUrl("~/Admin/Products.aspx") %>">PRODUCTS</a>
    </div>
    <asp:Literal ID="litEmpty" runat="server" />
    <div class="table-wrap">
    <table class="cart-table admin-table">
        <thead><tr><th>#</th><th>Date</th><th>Customer</th><th>Address</th><th>Total</th><th>Status</th><th></th></tr></thead>
        <tbody>
        <asp:Repeater ID="rptOrders" runat="server" OnItemCommand="rptOrders_ItemCommand">
            <ItemTemplate>
                <tr>
                    <td><b>#<%# Eval("Id") %></b></td>
                    <td><%# ((DateTime)Eval("CreatedAt")).ToString("dd MMM yyyy HH:mm", System.Globalization.CultureInfo.InvariantCulture) %></td>
                    <td><%# Ui.H(Eval("FullName")) %><br /><small><%# Ui.H(Eval("Phone")) %></small></td>
                    <td><small><%# Ui.H(Eval("Address")) %></small></td>
                    <td><b><%# Ui.Money((decimal)Eval("Total")) %></b></td>
                    <td>
                        <asp:HiddenField ID="hfStatus" runat="server" Value='<%# Eval("Status") %>' />
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="status-dd">
                            <asp:ListItem>Pending</asp:ListItem><asp:ListItem>Preparing</asp:ListItem><asp:ListItem>On the way</asp:ListItem>
                            <asp:ListItem>Delivered</asp:ListItem><asp:ListItem>Cancelled</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td><asp:LinkButton runat="server" CommandName="save" CommandArgument='<%# Eval("Id") %>' CausesValidation="false" CssClass="lnk">Save</asp:LinkButton></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        </tbody>
    </table>
    </div>
</section>
</asp:Content>
