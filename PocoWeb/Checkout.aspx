<%@ Page Title="Checkout - Poco!" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Checkout.aspx.cs" Inherits="CheckoutPage" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<section class="page-banner"><div class="container"><h1>Checkout</h1></div></section>
<section class="container section checkout-grid">
    <asp:Panel ID="pnlForm" runat="server" CssClass="form-card" DefaultButton="btnPlace">
        <h3>Delivery details</h3>
        <label for="<%= txtName.ClientID %>">Full name</label>
        <asp:TextBox ID="txtName" runat="server" MaxLength="100" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName" ValidationGroup="co" Display="Dynamic" CssClass="err" ErrorMessage="Full name is required." />
        <label for="<%= txtPhone.ClientID %>">Phone</label>
        <asp:TextBox ID="txtPhone" runat="server" MaxLength="30" TextMode="Phone" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPhone" ValidationGroup="co" Display="Dynamic" CssClass="err" ErrorMessage="Phone number is required." />
        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPhone" ValidationGroup="co" Display="Dynamic" CssClass="err"
            ValidationExpression="^[0-9+()\-\s]{7,20}$" ErrorMessage="Enter a valid phone number." />
        <label for="<%= txtAddress.ClientID %>">Delivery address</label>
        <asp:TextBox ID="txtAddress" runat="server" MaxLength="300" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAddress" ValidationGroup="co" Display="Dynamic" CssClass="err" ErrorMessage="Delivery address is required." />
        <label for="<%= txtNotes.ClientID %>">Order notes (optional)</label>
        <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" Rows="3" MaxLength="400" />
        <label>Payment method</label>
        <asp:RadioButtonList ID="rblPay" runat="server" RepeatLayout="Flow" CssClass="radios">
            <asp:ListItem Text="Cash on delivery" Value="Cash on delivery" Selected="True" />
            <asp:ListItem Text="Pay at pickup" Value="Pay at pickup" />
        </asp:RadioButtonList>
        <asp:Button ID="btnPlace" runat="server" Text="PLACE ORDER" ValidationGroup="co" OnClick="btnPlace_Click" CssClass="btn block" />
    </asp:Panel>

    <div class="totals">
        <h3>Your order</h3>
        <asp:Repeater ID="rptSummary" runat="server">
            <ItemTemplate><div><span><%# Ui.H(Eval("Name")) %> &times; <%# Eval("Qty") %></span><b><%# Ui.Money((decimal)Eval("LineTotal")) %></b></div></ItemTemplate>
        </asp:Repeater>
        <div><span>Subtotal</span><b><asp:Literal ID="litSub" runat="server" /></b></div>
        <div><span>Delivery</span><b><asp:Literal ID="litDel" runat="server" /></b></div>
        <div class="grand"><span>Total</span><b><asp:Literal ID="litTotal" runat="server" /></b></div>
    </div>
</section>
</asp:Content>
