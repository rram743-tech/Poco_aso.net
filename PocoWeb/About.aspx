<%@ Page Title="About - Poco!" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="About.aspx.cs" Inherits="AboutPage" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<section class="page-banner"><div class="container"><h1>About Poco!</h1><p>Pizza, burgers and a lot of American love.</p></div></section>

<section class="about-food">
    <div class="af-img"><img src="<%= ResolveUrl("~/Images/about-burger.png") %>" alt="Burger with fries" /></div>
    <div class="af-text">
        <span class="script y">About Our Food</span>
        <h2>From Texas with American Love</h2>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
        <a class="btn" href="<%= ResolveUrl("~/Shop.aspx") %>">ORDER NOW</a>
    </div>
</section>

<section class="testimonials">
    <div class="container">
        <h2 class="center">What your client says</h2>
        <div class="grid-3 t-static">
            <asp:Repeater ID="rptTesti" runat="server">
                <ItemTemplate>
                    <div class="t-card">
                        <div class="t-top">
                            <span class="t-avatar"><img src="<%# Ui.AvatarUrl(Eval("AvatarFile")) %>" alt="" /><i>&#10077;</i></span>
                            <span class="t-who"><b><%# Ui.H(Eval("Name")) %></b><small><%# Ui.H(Eval("RoleTitle")) %></small></span>
                            <%# Ui.Stars((decimal)Eval("Rating")) %>
                        </div>
                        <p>&ldquo;<%# Ui.H(Eval("Quote")) %>&rdquo;</p>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</section>
</asp:Content>
