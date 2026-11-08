<%@ Page Title="Blog - Poco!" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Blog.aspx.cs" Inherits="BlogPage" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<section class="page-banner"><div class="container"><h1>Our Blog</h1><p>News, recipes and stories from the Poco! kitchen.</p></div></section>
<section class="container section">
    <div class="grid-3">
        <asp:Repeater ID="rptPosts" runat="server">
            <ItemTemplate>
                <article class="post">
                    <div class="post-img"><img src="<%# Ui.ImgUrl(Eval("ImageFile")) %>" alt="" /></div>
                    <small><%# ((DateTime)Eval("PostedAt")).ToString("dd MMM yyyy", System.Globalization.CultureInfo.InvariantCulture) %></small>
                    <h3><%# Ui.H(Eval("Title")) %></h3>
                    <p><%# Ui.H(Eval("Excerpt")) %></p>
                    <a class="btn small" href="<%= ResolveUrl("~/Shop.aspx") %>">ORDER NOW</a>
                </article>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <asp:Literal ID="litEmpty" runat="server" />
</section>
</asp:Content>
