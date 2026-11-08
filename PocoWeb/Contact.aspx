<%@ Page Title="Contact - Poco!" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Contact.aspx.cs" Inherits="ContactPage" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<section class="page-banner"><div class="container"><h1>Contact Us</h1><p>Questions, bookings or feedback? Send us a message.</p></div></section>
<section class="container section contact-grid">
    <div class="contact-info">
        <h3>Address</h3><p>570 8th Ave, New York, NY 10018, United States</p>
        <h3>Book a table</h3><p><a href="tel:+18504354155">(850) 435-4155</a></p>
        <h3>Opening hours</h3><p>Monday &ndash; Friday: 8am &ndash; 4pm<br />Saturday: 9am &ndash; 5pm</p>
    </div>
    <asp:Panel ID="pnlForm" runat="server" CssClass="form-card" DefaultButton="btnSend">
        <h3>Send a message</h3>
        <label for="<%= txtName.ClientID %>">Your name</label>
        <asp:TextBox ID="txtName" runat="server" MaxLength="100" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName" ValidationGroup="contact" Display="Dynamic" CssClass="err" ErrorMessage="Please enter your name." />
        <label for="<%= txtEmail.ClientID %>">Email</label>
        <asp:TextBox ID="txtEmail" runat="server" MaxLength="150" TextMode="Email" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" ValidationGroup="contact" Display="Dynamic" CssClass="err" ErrorMessage="Please enter your email." />
        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail" ValidationGroup="contact" Display="Dynamic" CssClass="err"
            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" ErrorMessage="Please enter a valid email address." />
        <label for="<%= txtSubject.ClientID %>">Subject</label>
        <asp:TextBox ID="txtSubject" runat="server" MaxLength="150" />
        <label for="<%= txtMessage.ClientID %>">Message</label>
        <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="6" MaxLength="2000" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtMessage" ValidationGroup="contact" Display="Dynamic" CssClass="err" ErrorMessage="Please enter a message." />
        <asp:Button ID="btnSend" runat="server" Text="SEND MESSAGE" ValidationGroup="contact" OnClick="btnSend_Click" CssClass="btn" />
    </asp:Panel>
</section>
</asp:Content>
