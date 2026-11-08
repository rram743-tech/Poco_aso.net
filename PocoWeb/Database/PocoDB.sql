/* =====================================================================
   Poco! Food Ordering - SQL Server setup script
   Run in SSMS: File > Open > this file > Execute (F5)
   Safe to re-run: it drops and recreates all tables.
   ===================================================================== */
IF DB_ID(N'PocoDB') IS NULL
    CREATE DATABASE PocoDB;
GO
USE PocoDB;
GO

IF OBJECT_ID(N'dbo.OrderItems')            IS NOT NULL DROP TABLE dbo.OrderItems;
IF OBJECT_ID(N'dbo.Orders')                IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID(N'dbo.Wishlist')              IS NOT NULL DROP TABLE dbo.Wishlist;
IF OBJECT_ID(N'dbo.Products')              IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID(N'dbo.Categories')            IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID(N'dbo.Users')                 IS NOT NULL DROP TABLE dbo.Users;
IF OBJECT_ID(N'dbo.NewsletterSubscribers') IS NOT NULL DROP TABLE dbo.NewsletterSubscribers;
IF OBJECT_ID(N'dbo.ContactMessages')       IS NOT NULL DROP TABLE dbo.ContactMessages;
IF OBJECT_ID(N'dbo.Testimonials')          IS NOT NULL DROP TABLE dbo.Testimonials;
IF OBJECT_ID(N'dbo.BlogPosts')             IS NOT NULL DROP TABLE dbo.BlogPosts;
IF OBJECT_ID(N'dbo.SpecialMenu')           IS NOT NULL DROP TABLE dbo.SpecialMenu;
GO

CREATE TABLE dbo.Categories (
    Id        INT IDENTITY(1,1) CONSTRAINT PK_Categories PRIMARY KEY,
    Name      NVARCHAR(60) NOT NULL CONSTRAINT UQ_Categories_Name UNIQUE,
    SortOrder INT NOT NULL CONSTRAINT DF_Categories_Sort DEFAULT 0
);

CREATE TABLE dbo.Products (
    Id          INT IDENTITY(1,1) CONSTRAINT PK_Products PRIMARY KEY,
    Name        NVARCHAR(120) NOT NULL,
    Description NVARCHAR(400) NOT NULL CONSTRAINT DF_Products_Desc DEFAULT N'',
    Price       DECIMAL(10,2) NOT NULL CONSTRAINT CK_Products_Price CHECK (Price >= 0),
    SalePrice   DECIMAL(10,2) NULL     CONSTRAINT CK_Products_Sale  CHECK (SalePrice IS NULL OR SalePrice >= 0),
    PriceMax    DECIMAL(10,2) NULL,
    Rating      DECIMAL(2,1) NOT NULL CONSTRAINT DF_Products_Rating DEFAULT 0
                CONSTRAINT CK_Products_Rating CHECK (Rating BETWEEN 0 AND 5),
    CategoryId  INT NULL CONSTRAINT FK_Products_Categories REFERENCES dbo.Categories(Id) ON DELETE SET NULL,
    ImageFile   NVARCHAR(120) NULL,
    Sizes       VARCHAR(20) NOT NULL CONSTRAINT DF_Products_Sizes DEFAULT 'L,M,S',
    MenuTab     NVARCHAR(30) NULL,
    IsFeatured  BIT NOT NULL CONSTRAINT DF_Products_Featured DEFAULT 0,
    IsPopular   BIT NOT NULL CONSTRAINT DF_Products_Popular  DEFAULT 0,
    IsDeal      BIT NOT NULL CONSTRAINT DF_Products_Deal     DEFAULT 0,
    IsActive    BIT NOT NULL CONSTRAINT DF_Products_Active   DEFAULT 1,
    CreatedAt   DATETIME2 NOT NULL CONSTRAINT DF_Products_Created DEFAULT SYSDATETIME()
);
CREATE INDEX IX_Products_Category ON dbo.Products(CategoryId);

CREATE TABLE dbo.Users (
    Id           INT IDENTITY(1,1) CONSTRAINT PK_Users PRIMARY KEY,
    FullName     NVARCHAR(100) NOT NULL,
    Email        NVARCHAR(150) NOT NULL CONSTRAINT UQ_Users_Email UNIQUE,
    Phone        NVARCHAR(30) NULL,
    PasswordHash NVARCHAR(200) NOT NULL,
    Role         NVARCHAR(20) NOT NULL CONSTRAINT DF_Users_Role DEFAULT N'Customer'
                 CONSTRAINT CK_Users_Role CHECK (Role IN (N'Customer', N'Admin')),
    IsActive     BIT NOT NULL CONSTRAINT DF_Users_Active DEFAULT 1,
    CreatedAt    DATETIME2 NOT NULL CONSTRAINT DF_Users_Created DEFAULT SYSDATETIME()
);

CREATE TABLE dbo.Wishlist (
    UserId    INT NOT NULL CONSTRAINT FK_Wishlist_Users    REFERENCES dbo.Users(Id)    ON DELETE CASCADE,
    ProductId INT NOT NULL CONSTRAINT FK_Wishlist_Products REFERENCES dbo.Products(Id) ON DELETE CASCADE,
    AddedAt   DATETIME2 NOT NULL CONSTRAINT DF_Wishlist_Added DEFAULT SYSDATETIME(),
    CONSTRAINT PK_Wishlist PRIMARY KEY (UserId, ProductId)
);

CREATE TABLE dbo.Orders (
    Id            INT IDENTITY(1,1) CONSTRAINT PK_Orders PRIMARY KEY,
    UserId        INT NOT NULL CONSTRAINT FK_Orders_Users REFERENCES dbo.Users(Id),
    FullName      NVARCHAR(100) NOT NULL,
    Phone         NVARCHAR(30) NOT NULL,
    Address       NVARCHAR(300) NOT NULL,
    Notes         NVARCHAR(400) NULL,
    PaymentMethod NVARCHAR(40) NOT NULL,
    Subtotal      DECIMAL(10,2) NOT NULL,
    DeliveryFee   DECIMAL(10,2) NOT NULL,
    Total         DECIMAL(10,2) NOT NULL,
    Status        NVARCHAR(20) NOT NULL CONSTRAINT DF_Orders_Status DEFAULT N'Pending'
                  CONSTRAINT CK_Orders_Status CHECK (Status IN (N'Pending', N'Preparing', N'On the way', N'Delivered', N'Cancelled')),
    CreatedAt     DATETIME2 NOT NULL CONSTRAINT DF_Orders_Created DEFAULT SYSDATETIME()
);
CREATE INDEX IX_Orders_User ON dbo.Orders(UserId);

CREATE TABLE dbo.OrderItems (
    Id          INT IDENTITY(1,1) CONSTRAINT PK_OrderItems PRIMARY KEY,
    OrderId     INT NOT NULL CONSTRAINT FK_OrderItems_Orders   REFERENCES dbo.Orders(Id)   ON DELETE CASCADE,
    ProductId   INT NULL     CONSTRAINT FK_OrderItems_Products REFERENCES dbo.Products(Id) ON DELETE SET NULL,
    ProductName NVARCHAR(120) NOT NULL,
    UnitPrice   DECIMAL(10,2) NOT NULL,
    Quantity    INT NOT NULL CONSTRAINT CK_OrderItems_Qty CHECK (Quantity > 0)
);

CREATE TABLE dbo.NewsletterSubscribers (
    Id           INT IDENTITY(1,1) CONSTRAINT PK_Newsletter PRIMARY KEY,
    Email        NVARCHAR(150) NOT NULL CONSTRAINT UQ_Newsletter_Email UNIQUE,
    SubscribedAt DATETIME2 NOT NULL CONSTRAINT DF_Newsletter_At DEFAULT SYSDATETIME()
);

CREATE TABLE dbo.ContactMessages (
    Id        INT IDENTITY(1,1) CONSTRAINT PK_Contact PRIMARY KEY,
    Name      NVARCHAR(100) NOT NULL,
    Email     NVARCHAR(150) NOT NULL,
    Subject   NVARCHAR(150) NULL,
    Message   NVARCHAR(2000) NOT NULL,
    CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_Contact_At DEFAULT SYSDATETIME()
);

CREATE TABLE dbo.Testimonials (
    Id         INT IDENTITY(1,1) CONSTRAINT PK_Testimonials PRIMARY KEY,
    Name       NVARCHAR(80) NOT NULL,
    RoleTitle  NVARCHAR(80) NOT NULL,
    Rating     DECIMAL(2,1) NOT NULL CONSTRAINT CK_Testimonials_Rating CHECK (Rating BETWEEN 0 AND 5),
    Quote      NVARCHAR(400) NOT NULL,
    AvatarFile NVARCHAR(120) NULL,
    SortOrder  INT NOT NULL CONSTRAINT DF_Testimonials_Sort DEFAULT 0
);

CREATE TABLE dbo.BlogPosts (
    Id        INT IDENTITY(1,1) CONSTRAINT PK_BlogPosts PRIMARY KEY,
    Title     NVARCHAR(150) NOT NULL,
    Excerpt   NVARCHAR(500) NOT NULL,
    ImageFile NVARCHAR(120) NULL,
    PostedAt  DATETIME2 NOT NULL CONSTRAINT DF_Blog_At DEFAULT SYSDATETIME()
);

CREATE TABLE dbo.SpecialMenu (
    Id          INT IDENTITY(1,1) CONSTRAINT PK_SpecialMenu PRIMARY KEY,
    Name        NVARCHAR(100) NOT NULL,
    Ingredients NVARCHAR(200) NOT NULL,
    Price       DECIMAL(10,2) NOT NULL,
    SortOrder   INT NOT NULL CONSTRAINT DF_Special_Sort DEFAULT 0
);
GO

/* ---------------------------- SAMPLE DATA ---------------------------- */
INSERT dbo.Categories (Name, SortOrder) VALUES
 (N'Burgers',1),(N'Cold Drinks',2),(N'Hot Drinks',3),(N'Pasta',4),(N'Pizza',5),(N'Uncategorized',6);

DECLARE @Bur INT=(SELECT Id FROM dbo.Categories WHERE Name=N'Burgers');
DECLARE @Cold INT=(SELECT Id FROM dbo.Categories WHERE Name=N'Cold Drinks');
DECLARE @Hot INT=(SELECT Id FROM dbo.Categories WHERE Name=N'Hot Drinks');
DECLARE @Pas INT=(SELECT Id FROM dbo.Categories WHERE Name=N'Pasta');
DECLARE @Piz INT=(SELECT Id FROM dbo.Categories WHERE Name=N'Pizza');

INSERT dbo.Products (Name, Description, Price, SalePrice, PriceMax, Rating, CategoryId, ImageFile, Sizes, MenuTab, IsFeatured, IsPopular, IsDeal) VALUES
(N'Water Bottle', N'Investing in a reusable water bottle that you can refill throughout the day.', 10.18, NULL, NULL, 3.5, @Cold, N'water-bottle.png', 'L,M,S', NULL, 1, 0, 1),
(N'Vegge Lover', N'Extra-virgin olive oil, garlic, mozzarella cheese, onions, mushrooms, green olives.', 14.90, NULL, NULL, 4.0, @Piz, N'vegge-lover.png', 'L,M,S,X', NULL, 1, 0, 1),
(N'Tropicana Juice', N'View great tasting Tropicana Orange Juice and Juice Drink Products.', 11.11, NULL, NULL, 4.5, @Cold, N'tropicana-juice.png', 'L,M,S', NULL, 1, 0, 1),
(N'Trio Cheese', N'Mouth watering pepperoni, cabanossi, mushroom, capsicum, black olives and stretchy mozzarella.', 16.93, NULL, NULL, 4.0, @Piz, N'trio-cheese.png', 'L,M,S,X', NULL, 1, 1, 0),
(N'Trio Cafe', N'Trio Cafe is Family owned establishment located in Boston, serving fresh coffee daily.', 12.18, NULL, NULL, 4.0, @Cold, N'trio-cafe.png', 'L,M,S', N'Dersest', 0, 1, 0),
(N'Tagliatelle Molto', N'A mighty meaty double helping of all the reasons you love our burger.', 15.61, NULL, NULL, 4.5, @Pas, N'tagliatelle-molto.png', 'L,M,S', N'Salats', 0, 1, 0),
(N'Supreme Pizza', N'Ricotta, sun dried tomatoes, garlic, mozzarella cheese, topped with fresh basil.', 11.75, 6.00, NULL, 4.5, @Piz, N'supreme-pizza.png', 'L,M,S,X', NULL, 0, 1, 0),
(N'Black Coffee', N'Browse unique Coca-Cola products, clothing, & accessories, or customize Coke bottles and gifts.', 11.76, NULL, NULL, 4.0, @Hot, N'black-coffee.png', 'L,M,S', N'Dersest', 0, 1, 0),
(N'Blueberry Shake', N'Iced coffee is a type of coffee beverage served chilled, brewed variously with the fundamental ingredients.', 10.68, NULL, NULL, 3.5, @Cold, N'blueberry-shake.png', 'L,M,S', N'Dersest', 0, 1, 0),
(N'Bolognese Pasta', N'A mighty meaty double helping of all the reasons you love our burger.', 10.41, 8.00, NULL, 3.5, @Pas, N'bolognese-pasta.png', 'L,M,S', N'Salats', 0, 0, 0),
(N'Apricot Chicken', N'Crispy bacon, tasty ham, pineapple, onion and stretchy mozzarella cheese.', 18.30, NULL, NULL, 3.5, @Piz, N'apricot-chicken.png', 'L,M,S,X', NULL, 0, 0, 0),
(N'Bacon Burger', N'A mighty meaty double helping of all the reasons you love our burger.', 10.95, NULL, NULL, 3.5, @Bur, N'bacon-burger.png', 'L,M,S', N'Burger', 0, 0, 0),
(N'BBQ chicken breast', N'A mighty meaty double helping of all the reasons you love our burger.', 12.61, 8.00, NULL, 3.0, @Pas, N'bbq-chicken-breast.png', 'L,M,S', N'Salats', 0, 0, 0),
(N'Cheese Butter', N'A mighty meaty double helping of all the reasons you love our burger.', 12.50, NULL, NULL, 4.0, @Bur, N'cheese-butter.png', 'L,M,S', N'Burger', 0, 0, 0),
(N'Chicken Burger', N'A mighty meaty double helping of all the reasons you love our burger.', 11.40, NULL, NULL, 3.5, @Bur, N'chicken-burger.png', 'L,M,S', N'Burger', 0, 0, 0),
(N'Chicken Hawaii', N'Extra-virgin olive oil, mozzarella cheese, ham, pineapple and fresh tomatoes.', 13.20, NULL, NULL, 3.5, @Piz, N'chicken-hawaii.png', 'L,M,S,X', N'Pizza', 0, 0, 0),
(N'Pepperoni Pizza', N'Extra-virgin olive oil, garlic, mozzarella cheese, onions, mushrooms, green olives, black olives, fresh tomatoes.', 19.75, NULL, NULL, 3.0, @Piz, N'pepperoni-pizza.png', 'L,M,S,X', N'Pizza', 0, 0, 0),
(N'Pizzaro Coffee', N'Browse unique Coca-Cola products, clothing, & accessories, or customize Coke bottles and gifts', 11.50, NULL, NULL, 4.0, @Cold, N'pizzaro-coffee.png', 'L,M,S', N'Pizza', 0, 0, 0),
(N'Penne Funghi Chicken', N'A mighty meaty double helping of all the reasons you love our burger.', 14.40, NULL, NULL, 3.5, @Pas, N'penne-funghi-chicken.png', 'L,M,S', N'Pizza', 0, 0, 0),
(N'Primo Meat', N'Mouth watering pepperoni, cabanossi, mushroom, capsicum, black olives and stretchy mozzarella,', 9.00, NULL, 19.75, 3.5, @Piz, N'primo-meat.png', 'L,M,S,X', N'Pizza', 0, 0, 0),
(N'Plain Tea', N'Iced coffee is a type of coffee beverage served chilled, brewed variously with the fundamental...', 18.31, NULL, NULL, 4.0, @Hot, N'plain-tea.png', 'L,M,S', N'Pizza', 0, 0, 0),
(N'Pepperoni Calzone', N'Piled with shrimp, calamari, clams, mussels, surimi and stretchy mozzarella, seasoned with tangy lemon pepper.', 15.80, 12.00, NULL, 4.0, @Piz, N'pepperoni-calzone.png', 'L,M,S,X', N'Pizza', 0, 0, 0);

INSERT dbo.SpecialMenu (Name, Ingredients, Price, SortOrder) VALUES
 (N'Pizza Hut',      N'Shrimp, Squid, Pineapple', 4.95, 1),
 (N'Pepperoni Pizza',N'Shrimp, Squid, Pineapple', 5.95, 2),
 (N'Apricot Chicken',N'Shrimp, Squid, Pineapple', 5.65, 3),
 (N'Summer Pizza',   N'Shrimp, Squid, Pineapple', 8.95, 4);

INSERT dbo.Testimonials (Name, RoleTitle, Rating, Quote, AvatarFile, SortOrder) VALUES
 (N'CLARA',         N'Design',    3.0, N'I am completely blown away. I would also like to say thank you to all your staff. It''s really wonderful.', N'avatar1.png', 1),
 (N'JOHN DOE',      N'Design',    5.0, N'I am completely blown away. I would also like to say thank you to all your staff. It''s really wonderful.', N'avatar2.png', 2),
 (N'NINA MARGARET', N'CEO,apple', 4.0, N'Forget the trendy pizza shops, This hidden spot makes the best New York-style pizza slice in naples', N'avatar3.png', 3),
 (N'CLARA',         N'Design',    4.0, N'Fast delivery and the pizza arrived piping hot. Will definitely order again!', N'avatar1.png', 4),
 (N'JOHN DOE',      N'Design',    5.0, N'The burgers are juicy and the staff are always friendly. Best fast food in town.', N'avatar2.png', 5),
 (N'NINA MARGARET', N'CEO,apple', 4.5, N'Great value, generous portions and a lovely menu for the whole family.', N'avatar3.png', 6);

INSERT dbo.BlogPosts (Title, Excerpt, ImageFile) VALUES
 (N'How to make a perfect New York-style pizza', N'Thin crust, crisp edges and a generous layer of mozzarella. Our chefs share the secrets behind the classic slice.', N'trio-cheese.png'),
 (N'Five burgers you must try this season', N'From the classic bacon burger to the crispy chicken stack, here are the burgers our customers keep coming back for.', N'bacon-burger.png'),
 (N'Why fresh ingredients matter', N'Every pizza starts with extra-virgin olive oil, fresh basil and ripe tomatoes. Here is how we source our produce.', N'vegge-lover.png');
GO

/* Admin account: created automatically by the website on first start
   (email / password come from <appSettings> in Web.config).            */
SELECT 'PocoDB created. Categories: ' + CAST((SELECT COUNT(*) FROM dbo.Categories) AS VARCHAR(10))
     + ', Products: ' + CAST((SELECT COUNT(*) FROM dbo.Products) AS VARCHAR(10)) AS Result;
GO
