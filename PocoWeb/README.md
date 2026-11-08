# Poco! - ASP.NET Web Forms + C# + SQL Server

Pizza / burger ordering website rebuilt from the screenshots in ASP-DOC.docx.
Project type: **ASP.NET Web Forms "Web Site" project** (no .csproj, so no .designer.cs files are needed).

## 1. Requirements
- Visual Studio 2019 / 2022 with the **ASP.NET and web development** workload (.NET Framework 4.8)
- SQL Server Express / Developer / LocalDB and SQL Server Management Studio (SSMS)

## 2. Create the database (SSMS)
1. Open SSMS and connect to your server (for example `.\SQLEXPRESS`).
2. `File > Open > File...` and choose `Database/PocoDB.sql`.
3. Press **Execute (F5)**. It creates `PocoDB`, all tables, relationships, constraints and sample data
   (22 products, 6 categories, testimonials, blog posts, special menu).

## 3. Connection string (Web.config)
Edit `<connectionStrings>` in `Web.config` and set `Data Source` to your instance:

| SQL Server | Data Source |
|---|---|
| SQL Express (default) | `.\SQLEXPRESS` |
| LocalDB | `(localdb)\MSSQLLocalDB` |
| Default instance | `localhost` or `.` |
| SQL login instead of Windows login | replace `Integrated Security=True` with `User ID=xx;Password=xx` |

Credentials live only in Web.config; no page contains a connection string.

## 4. Run
1. Double-click `PocoWeb.sln` (or in Visual Studio: `File > Open > Web Site...` and select the `PocoWeb` folder).
2. Press **F5** (IIS Express). The home page opens.
3. The admin account is created automatically on first start:
   **admin@poco.com / Admin@123** (change it in `Web.config` appSettings before first run, or register a normal customer account on the Register page).

If the site shows "Database is not available", re-check steps 2 and 3.

## 5. Pages and features
| Page | What it does |
|---|---|
| `Default.aspx` | Home: hero slider, 3 promo panels, Best pizza, Explore the new taste (menu list from DB), Popular dishes carousel, delivery section, About Our Food, Menus of the Day (working category tabs), testimonials slider |
| `Shop.aspx` | Product grid/list, search, category filter with counts, price range filter, size filter, sorting, pagination (12 per page), Best Deals sidebar |
| `Product.aspx` | Product details, quantity, add to cart, wishlist toggle, related products |
| `Menu.aspx` | Full menu grouped by category with add-to-cart |
| `Cart.aspx` | Update quantities, remove items, totals, delivery fee (free over 30 GBP) |
| `Checkout.aspx` | Login required; delivery form with validation; saves Order + OrderItems in one SQL transaction |
| `Account.aspx` | Order history of the signed-in customer |
| `Wishlist.aspx` | Saved products (login required) |
| `Login.aspx`, `Register.aspx` | Authentication (PBKDF2-hashed passwords, forms-auth cookie, roles) |
| `About.aspx`, `Blog.aspx`, `Contact.aspx` | Content pages; Contact saves messages to DB |
| Newsletter boxes (above footer and in footer) | Save subscribers to DB (duplicates handled) |
| `Actions.ashx` | Add to cart, remove from cart, wishlist toggle, logout |
| `Admin/Default.aspx` | Dashboard statistics |
| `Admin/Products.aspx` | Full CRUD for products incl. image upload, sale price, flags, menu tab |
| `Admin/Orders.aspx` | View all orders and change status |

Security: all SQL is parameterized; passwords hashed (PBKDF2 + salt); `/Admin` restricted to the Admin role;
checkout/account/wishlist require login; redirect targets are validated; cart prices are always re-read from the database.

## 6. Screenshot checklist (17 of 17 addressed)
| # | Screenshot | Implemented in |
|---|---|---|
| 1 | Footer (address, book a table, hours, newsletter, payment bar) | `Site.Master` |
| 2 | "Join For Hot Offers" newsletter + footer logo | `Site.Master` |
| 3 | "Super Delicious Pizza" banner | `Default.aspx` hero slide 2 |
| 4 | "Best pizza" cards | `Default.aspx` |
| 5 | Fast Food Meals / House Burgers / Hot Fresh Salats panels | `Default.aspx` |
| 6 | "What your client says" slider | `Default.aspx`, `About.aspx` |
| 7 | "Popular dishes" carousel | `Default.aspx` |
| 8 | Delivery section (pick up time / earn points) | `Default.aspx` |
| 9 | "About Our Food - From Texas with American Love" | `Default.aspx`, `About.aspx` |
| 10 | Hero bottom with order button and price | `Default.aspx` hero slide 1 |
| 11 | Header (logo, nav, phone, icons) + "American Burger" hero | `Site.Master`, `Default.aspx` |
| 12 | "Explore the new taste" + price list | `Default.aspx` |
| 13 | Horizontal product cards (Pepperoni Pizza, Pizzaro Coffee...) | `Default.aspx` Menus of the Day |
| 14 | "Menus Of The Day" tabs + cards | `Default.aspx` |
| 15 | Shop grid + Best Deals sidebar | `Shop.aspx` |
| 16 | Shop: price filter, size filter, Best Deals | `Shop.aspx` |
| 17 | Shop: result count, sorting, grid/list, categories, search | `Shop.aspx` |

## 7. Notes
- Product, banner, logo and icon images were cropped from your screenshots into `Images/`. Replace them with original high-resolution files if you have them.
- The "Sushi" tab in Menus of the Day is empty by default (no sushi dish appears in the screenshots). Assign any product to it in Admin > Products.
- Fonts (Outfit, Kaushan Script) load from Google Fonts, so the first load needs internet access. They are close matches to the template fonts.
- Folder `Images/products` must be writable for admin image uploads.
