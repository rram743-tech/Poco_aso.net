<%@ Page Title="Poco! - Pizza, Burgers & More" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="HomePage" MaintainScrollPositionOnPostBack="true" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;700;800;900&family=Playfair+Display:ital,wght@1,600&display=swap" rel="stylesheet" />
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <!-- HERO SLIDER -->
    <section class="hero" id="hero">
        <div class="slide active s-burger">
            <div class="container hero-in">
                <div class="hero-text">
                    <h1><span class="dark">AMERICAN</span><span class="glow">BURGER</span></h1>
                    <h4>Medium 2-topping* pizza</h4>
                    <p class="note">*Additional charge for premium toppings. Minimum of 2 required.</p>
                    <div class="hero-cta">
                        <a class="btn" href="<%= ResolveUrl("~/Shop.aspx?cat=" + CategoryId("Burgers")) %>">ORDER NOW</a>
                        <span class="hero-price">$12.99 <sup>$19.99</sup></span>
                    </div>
                </div>
            </div>
            <img class="hero-pic" src="https://static.vecteezy.com/system/resources/previews/041/290/641/non_2x/ai-generated-fresh-burger-isolated-on-transparent-background-free-png.png" alt="American burger" />
        </div>
        <div class="slide s-pizza">
            <div class="container hero-in">
                <div class="hero-pizza-text">
                    <span class="script">Super Delicious</span>
                    <strong>Pizza</strong>
                    <a class="btn" href="<%= ResolveUrl("~/Shop.aspx?cat=" + CategoryId("Pizza")) %>">ORDER NOW</a>
                </div>
            </div>
            <img class="hero-pic left" src="https://papaspizzacompany.com/wp-content/uploads/2016/08/product-9.png" alt="Super delicious pizza" />
        </div>

        <div class="slide pizza-hero">
            <div class="pizza-hero-content">
                <p class="pizza-hero-deal">Today's Best Deal</p>
                <h1 class="pizza-hero-title">ITALIAN FOOD</h1>
                <p class="pizza-hero-subtitle">SUPER DELICIOUS</p>
            </div>
            <div class="pizza-food-doodle" aria-hidden="true">&#x2667; &#x25C9; &#x2667;</div>
            <div class="pizza-stage">
                <div class="pizza-glow"></div>
                <img class="pizza-image" src="https://static.vecteezy.com/system/resources/previews/074/602/254/non_2x/vegetable-pizza-with-assorted-toppings-free-png.png" alt="Vegetable pizza with assorted toppings" draggable="false" />
            </div>
            <span class="pizza-ingredient pizza-leaf pizza-leaf-one" aria-hidden="true">&#x1F33F;</span>
            <span class="pizza-ingredient pizza-leaf pizza-leaf-two" aria-hidden="true">&#x1F33F;</span>
            <span class="pizza-ingredient pizza-leaf pizza-leaf-three" aria-hidden="true">&#x1F33F;</span>
            <span class="pizza-ingredient pizza-leaf pizza-leaf-four" aria-hidden="true">&#x1F33F;</span>
            <span class="pizza-ingredient pizza-tomato pizza-tomato-one" aria-hidden="true"></span>
            <span class="pizza-ingredient pizza-tomato pizza-tomato-two" aria-hidden="true"></span>
        </div>

        <div class="slide pizza-hero">
            <div class="pizza-hero-content">
                <p class="pizza-hero-deal">Today's Best Deal</p>
                <h1 class="pizza-hero-title">ITALIAN FOOD</h1>
                <p class="pizza-hero-subtitle">SUPER DELICIOUS</p>
            </div>
            <div class="pizza-food-doodle" aria-hidden="true">&#x2667; &#x25C9; &#x2667;</div>
            <div class="pizza-stage">
                <div class="pizza-glow"></div>
                <img class="pizza-image" src="https://static.vecteezy.com/system/resources/previews/068/847/037/non_2x/delicious-pizza-with-mushrooms-olives-tomato-and-peppers-pizza-toppings-transparent-close-up-studio-food-photo-shoot-png.png" alt="Pizza with mushrooms, olives, tomatoes and peppers" loading="lazy" draggable="false" />
            </div>
            <span class="pizza-ingredient pizza-leaf pizza-leaf-one" aria-hidden="true">&#x1F33F;</span>
            <span class="pizza-ingredient pizza-leaf pizza-leaf-two" aria-hidden="true">&#x1F33F;</span>
            <span class="pizza-ingredient pizza-leaf pizza-leaf-three" aria-hidden="true">&#x1F33F;</span>
            <span class="pizza-ingredient pizza-leaf pizza-leaf-four" aria-hidden="true">&#x1F33F;</span>
            <span class="pizza-ingredient pizza-tomato pizza-tomato-one" aria-hidden="true"></span>
            <span class="pizza-ingredient pizza-tomato pizza-tomato-two" aria-hidden="true"></span>
        </div>

        <div class="hero-dots">
            <button type="button" class="on" aria-label="American burger slide"></button>
            <button type="button" aria-label="Super delicious pizza slide"></button>
            <button type="button" aria-label="Vegetable pizza slide"></button>
            <button type="button" aria-label="Mushroom pizza slide"></button>
        </div>
    </section>

    <!-- PROMO PANELS -->
    <section class="promos">
        <div class="promo green">
            <div class="promo-text"><span class="script">Fash Food</span><strong>Meals</strong><small>NEW PHENOMENON<br />BURGER TASTE</small><b class="pp y">$19.90</b>
                <a class="btn white" href="<%= ResolveUrl("~/Shop.aspx") %>">ORDER NOW</a></div>
            <img src="https://static.vecteezy.com/system/resources/previews/066/929/324/non_2x/concept-of-fast-food-free-png.png"N alt="Fast food meals" />
        </div>
        <div class="promo orange">
            <div class="promo-text"><span class="script">House</span><strong>Burgers</strong><small>NEW PHENOMENON<br />BURGER TASTE</small><b class="pp y">$12.90</b>
                <a class="btn white" href="<%= ResolveUrl("~/Shop.aspx?cat=" + CategoryId("Burgers")) %>">ORDER NOW</a></div>
            <img src="https://static.vecteezy.com/system/resources/previews/041/290/641/non_2x/ai-generated-fresh-burger-isolated-on-transparent-background-free-png.png" alt="House burgers" />
        </div>
        <div class="promo yellow">
            <div class="promo-text"><span class="script">Hot Fresh</span><strong class="red">Salats</strong><small>NEW PHENOMENON<br />BURGER TASTE</small><b class="pp">$10.90</b>
                <a class="btn white" href="<%= ResolveUrl("~/Shop.aspx") %>">ORDER NOW</a></div>
            <img src="https://static.vecteezy.com/system/resources/previews/066/666/758/non_2x/fresh-and-colorful-vegetable-salad-with-flying-tomato-cucumber-onion-isolated-png.png" alt="Hot fresh salads" />
        </div>
    </section>

    <!-- BEST PIZZA -->
    <section class="section">
        <div class="container">
            <div class="sec-head"><h2>Best pizza</h2><a class="see-all" href="<%= ResolveUrl("~/Shop.aspx") %>">See all <i>&rsaquo;</i></a></div>
            <div class="grid-4">
                <asp:Repeater ID="rptBest" runat="server"><ItemTemplate><%# Ui.CardV(Container.DataItem) %></ItemTemplate></asp:Repeater>
            </div>
        </div>
    </section>

    <!-- EXPLORE THE NEW TASTE -->
    <section class="explore">
        <div class="explore-left">
            <div>
                <h2>Explore the new taste</h2>
                <p>Enjoy our luscious dishes wherever you want</p>
                <a class="btn" href="<%= ResolveUrl("~/Menu.aspx") %>">ORDER NOW</a>
            </div>
        </div>
        <div class="explore-right">
            <ul class="menu-list">
                <asp:Repeater ID="rptSpecial" runat="server">
                    <ItemTemplate>
                        <li><div class="ml-top"><h4><%# Ui.H(Eval("Name")) %></h4><span class="ml-line"></span><b>$<%# ((decimal)Eval("Price")).ToString("0.00", System.Globalization.CultureInfo.InvariantCulture) %></b></div>
                            <small><%# Ui.H(Eval("Ingredients")) %></small></li>
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
        </div>
    </section>

    <!-- POPULAR DISHES -->
    <section class="section">
        <div class="container">
            <div class="sec-head"><h2>Popular dishes</h2><a class="see-all" href="<%= ResolveUrl("~/Shop.aspx") %>">See all <i>&rsaquo;</i></a></div>
            <div class="carousel-wrap">
                <button type="button" class="car-btn prev" id="popPrev" aria-label="Previous">&lsaquo;</button>
                <div class="carousel" id="popTrack">
                    <asp:Repeater ID="rptPopular" runat="server"><ItemTemplate><div class="car-item"><%# Ui.CardV(Container.DataItem) %></div></ItemTemplate></asp:Repeater>
                </div>
                <button type="button" class="car-btn next" id="popNext" aria-label="Next">&rsaquo;</button>
            </div>
        </div>
    </section>

    <!-- DELIVERY -->
    <section class="delivery">
        <div class="container d-grid">
            <div class="d-left"><h2>Choose what you want, select a pick up time</h2>
                <p>As well known and we are very busy all days advice you. advice you to call us of before arriving, so we can guarantee your seat.</p>
                <a class="btn" href="<%= ResolveUrl("~/Shop.aspx") %>">ORDER NOW</a></div>
            <div class="d-img">
                <div class="bike-anim-container">
                    <div class="motorcycle">
                        <div class="wheel front"></div>
                        <div class="wheel back"></div>
                        <div class="engine"></div>
                        <div class="frame-body"></div>
                        <div class="fuel-tank"></div>
                        <div class="seat"></div>
                        <div class="handlebar"></div>
                        <div class="exhaust"></div>
                        <div class="headlight"></div>
                        <div class="pizza-box"></div>
                        <div class="rider">
                            <div class="helmet"></div>
                            <div class="body"></div>
                            <div class="arm front-arm"></div>
                            <div class="arm back-arm"></div>
                            <div class="leg front-leg"></div>
                            <div class="leg back-leg"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="d-right"><h2>Earn points every time you order online</h2>
                <p>As well known and we are very busy all days advice you. advice you to call us of before arriving, so we can guarantee your seat.</p>
                <a class="btn" href="<%= ResolveUrl("~/Register.aspx") %>">ORDER NOW</a></div>
        </div>
    </section>

    <!-- ABOUT OUR FOOD -->
    <section class="about-food">
        <div class="af-img"><img src="<%= ResolveUrl("~/Images/about-burger.png") %>" alt="Burger with fries" /></div>
        <div class="af-text">
            <span class="script y">About Our Food</span>
            <h2>From Texas with American Love</h2>
            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
            <a class="btn" href="<%= ResolveUrl("~/About.aspx") %>">ORDER NOW</a>
        </div>
    </section>

    <!-- MENUS OF THE DAY -->
    <section class="section" id="menus">
        <div class="container">
            <h2 class="center">Menus Of The Day</h2>
            <div class="tabs">
                <asp:Repeater ID="rptTabs" runat="server" OnItemCommand="rptTabs_ItemCommand">
                    <ItemTemplate>
                        <asp:LinkButton runat="server" CommandName="tab" CausesValidation="false"
                            CommandArgument='<%# Eval("Tab") %>' CssClass='<%# (string)Eval("Tab") == ActiveTab ? "tab on" : "tab" %>'><%# Eval("Label") %></asp:LinkButton>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="grid-2">
                <asp:Repeater ID="rptMenuDay" runat="server"><ItemTemplate><%# Ui.CardH(Container.DataItem) %></ItemTemplate></asp:Repeater>
            </div>
            <asp:Literal ID="litNoItems" runat="server" />
        </div>
    </section>

    <!-- TESTIMONIALS -->
    <section class="testimonials">
        <div class="container">
            <h2 class="center">What your client says</h2>
            <div class="t-view"><div class="t-track" id="tTrack">
                <asp:Repeater ID="rptTesti" runat="server">
                    <ItemTemplate>
                        <div class="t-item"><div class="t-card">
                            <div class="t-top">
                                <span class="t-avatar"><img src="<%# Ui.AvatarUrl(Eval("AvatarFile")) %>" alt="" /><i>&#10077;</i></span>
                                <span class="t-who"><b><%# Ui.H(Eval("Name")) %></b><small><%# Ui.H(Eval("RoleTitle")) %></small></span>
                                <%# Ui.Stars((decimal)Eval("Rating")) %>
                            </div>
                            <p>&ldquo;<%# Ui.H(Eval("Quote")) %>&rdquo;</p>
                        </div></div>
                    </ItemTemplate>
                </asp:Repeater>
            </div></div>
            <div class="t-dots" id="tDots"></div>
        </div>
    </section>

</asp:Content>
