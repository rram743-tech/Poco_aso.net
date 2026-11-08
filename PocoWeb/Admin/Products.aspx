<%@ Page Title="Products - Admin" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Products.aspx.cs" Inherits="AdminProductsPage" MaintainScrollPositionOnPostBack="true" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<section class="page-banner"><div class="container"><h1>Manage Products</h1></div></section>
<section class="container section">
    <div class="admin-nav">
        <a class="btn outline" href="<%= ResolveUrl("~/Admin/Default.aspx") %>">&lsaquo; DASHBOARD</a>
        <a class="btn outline" href="<%= ResolveUrl("~/Admin/Orders.aspx") %>">ORDERS</a>
    </div>

    <asp:Panel ID="pnlEdit" runat="server" CssClass="form-card wide" DefaultButton="btnSave">
        <h3><asp:Literal ID="litFormTitle" runat="server" Text="Add a product" /></h3>
        <asp:HiddenField ID="hfId" runat="server" Value="0" />
        <asp:HiddenField ID="hfImage" runat="server" />
        <div class="form-grid">
            <div><label for="<%= txtName.ClientID %>">Name</label>
                <asp:TextBox ID="txtName" runat="server" MaxLength="120" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName" ValidationGroup="prod" Display="Dynamic" CssClass="err" ErrorMessage="Name is required." /></div>
            <div><label for="<%= ddlCategory.ClientID %>">Category</label>
                <asp:DropDownList ID="ddlCategory" runat="server" /></div>
            <div><label for="<%= txtPrice.ClientID %>">Price (&pound;)</label>
                <asp:TextBox ID="txtPrice" runat="server" MaxLength="10" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPrice" ValidationGroup="prod" Display="Dynamic" CssClass="err" ErrorMessage="Price is required." />
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPrice" ValidationGroup="prod" Display="Dynamic" CssClass="err" ValidationExpression="^\d{1,6}(\.\d{1,2})?$" ErrorMessage="Use a number like 12.50." /></div>
            <div><label for="<%= txtSale.ClientID %>">Sale price (optional)</label>
                <asp:TextBox ID="txtSale" runat="server" MaxLength="10" />
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtSale" ValidationGroup="prod" Display="Dynamic" CssClass="err" ValidationExpression="^\d{1,6}(\.\d{1,2})?$" ErrorMessage="Use a number like 8.00." /></div>
            <div><label for="<%= txtMax.ClientID %>">Upper price for ranges (optional)</label>
                <asp:TextBox ID="txtMax" runat="server" MaxLength="10" />
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtMax" ValidationGroup="prod" Display="Dynamic" CssClass="err" ValidationExpression="^\d{1,6}(\.\d{1,2})?$" ErrorMessage="Use a number like 19.75." /></div>
            <div><label for="<%= txtRating.ClientID %>">Rating (0 - 5)</label>
                <asp:TextBox ID="txtRating" runat="server" MaxLength="3" Text="4" />
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtRating" ValidationGroup="prod" Display="Dynamic" CssClass="err" ValidationExpression="^([0-4](\.\d)?|5(\.0)?)$" ErrorMessage="Rating must be between 0 and 5." /></div>
            <div><label for="<%= txtSizes.ClientID %>">Sizes (comma separated: L,M,S,X)</label>
                <asp:TextBox ID="txtSizes" runat="server" MaxLength="20" Text="L,M,S" />
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtSizes" ValidationGroup="prod" Display="Dynamic" CssClass="err" ValidationExpression="^[LMSX](,[LMSX])*$" ErrorMessage="Use letters L, M, S, X separated by commas." /></div>
            <div><label for="<%= ddlTab.ClientID %>">Menus of the day tab</label>
                <asp:DropDownList ID="ddlTab" runat="server">
                    <asp:ListItem Value="" Text="(none)" /><asp:ListItem>Pizza</asp:ListItem><asp:ListItem>Sushi</asp:ListItem>
                    <asp:ListItem>Salats</asp:ListItem><asp:ListItem>Burger</asp:ListItem><asp:ListItem>Dersest</asp:ListItem>
                </asp:DropDownList></div>
        </div>
        <label for="<%= txtDesc.ClientID %>">Description</label>
        <asp:TextBox ID="txtDesc" runat="server" TextMode="MultiLine" Rows="3" MaxLength="400" />
        <label for="<%= fuImage.ClientID %>">Image (PNG, JPG, WEBP - max 2 MB)</label>
        <asp:FileUpload ID="fuImage" runat="server" accept=".png,.jpg,.jpeg,.webp" />
        <div class="checks">
            <asp:CheckBox ID="chkFeatured" runat="server" Text="Best pizza section" />
            <asp:CheckBox ID="chkPopular" runat="server" Text="Popular dishes" />
            <asp:CheckBox ID="chkDeal" runat="server" Text="Best deals (sidebar)" />
            <asp:CheckBox ID="chkActive" runat="server" Text="Active (visible)" Checked="true" />
        </div>
        <div class="form-actions">
            <asp:Button ID="btnSave" runat="server" Text="SAVE PRODUCT" ValidationGroup="prod" OnClick="btnSave_Click" CssClass="btn" />
            <asp:Button ID="btnCancel" runat="server" Text="CLEAR FORM" CausesValidation="false" OnClick="btnCancel_Click" CssClass="btn outline" />
        </div>
    </asp:Panel>

    <div class="table-wrap">
    <table class="cart-table admin-table">
        <thead><tr><th></th><th>Name</th><th>Category</th><th>Price</th><th>Flags</th><th></th></tr></thead>
        <tbody>
        <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
            <ItemTemplate>
                <tr class='<%# (bool)Eval("IsActive") ? "" : "off" %>'>
                    <td class="ct-img"><img src="<%# Ui.ImgUrl(Eval("ImageFile")) %>" alt="" /></td>
                    <td><b><%# Ui.H(Eval("Name")) %></b></td>
                    <td><%# Ui.H(Eval("CategoryName")) %></td>
                    <td><%# Ui.PriceHtml((System.Data.DataRowView)Container.DataItem) %></td>
                    <td><small><%# ((bool)Eval("IsFeatured") ? "Best " : "") + ((bool)Eval("IsPopular") ? "Popular " : "") + ((bool)Eval("IsDeal") ? "Deal " : "") + ((bool)Eval("IsActive") ? "" : "Hidden") %></small></td>
                    <td class="row-actions">
                        <asp:LinkButton runat="server" CommandName="edit" CommandArgument='<%# Eval("Id") %>' CausesValidation="false" CssClass="lnk">Edit</asp:LinkButton>
                        <asp:LinkButton runat="server" CommandName="delete" CommandArgument='<%# Eval("Id") %>' CausesValidation="false" CssClass="lnk danger"
                            OnClientClick="return confirm('Delete this product permanently?');">Delete</asp:LinkButton>
                    </td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        </tbody>
    </table>
    </div>
</section>
</asp:Content>
