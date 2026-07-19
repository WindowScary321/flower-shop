# Database Entity-Relationship Diagram (ERD)

This document visualizes the database schema for the Flower Shop project.

```mermaid
erDiagram
    Categories {
        int CategoryId PK "IDENTITY(1,1)"
        nvarchar CategoryName "NOT NULL"
        nvarchar Description
    }

    Flowers {
        int FlowerId PK "IDENTITY(1,1)"
        nvarchar FlowerName "NOT NULL"
        int CategoryId FK "NOT NULL"
        nvarchar Unit "NOT NULL"
        float Price "NOT NULL, CHECK (Price > 0)"
        int Quantity "NOT NULL, CHECK (Quantity >= 0)"
        nvarchar Image "URL"
        nvarchar Description
        int Discount "DEFAULT 0, CHECK (Discount >= 0 AND Discount <= 100)"
        bit Status "DEFAULT 1"
    }

    Accounts {
        int AccountId PK "IDENTITY(1,1)"
        varchar Username "NOT NULL, UNIQUE"
        varchar Password "NOT NULL"
        nvarchar FullName "NOT NULL"
        varchar Email "NOT NULL, UNIQUE"
        varchar Phone "NOT NULL"
        varchar Role "CHECK (Role IN ('customer', 'employee', 'admin'))"
        bit Status "DEFAULT 1"
    }

    Orders {
        int OrderId PK "IDENTITY(1,1)"
        int AccountId FK "NOT NULL"
        datetime OrderDate "DEFAULT GETDATE()"
        float TotalAmount "NOT NULL"
        nvarchar ShippingAddress "NOT NULL"
        varchar ShippingPhone "NOT NULL"
        nvarchar PaymentMethod "CHECK (PaymentMethod IN ('COD', 'QR'))"
        nvarchar Status "CHECK (Status IN ('Chờ xử lý', 'Đang giao', 'Hoàn thành', 'Đã hủy'))"
    }

    OrderDetails {
        int OrderDetailId PK "IDENTITY(1,1)"
        int OrderId FK "NOT NULL"
        int FlowerId FK "NOT NULL"
        int Quantity "NOT NULL, CHECK (Quantity > 0)"
        float Price "NOT NULL, CHECK (Price > 0)"
    }

    %% Relationships
    Categories ||--o{ Flowers : "has"
    Accounts ||--o{ Orders : "places"
    Orders ||--|{ OrderDetails : "contains"
    Flowers ||--o{ OrderDetails : "included in"
```

## Description
- **Categories**: Stores flower categories.
- **Flowers**: Stores flower products, linked to Categories.
- **Accounts**: Stores user accounts including customers, employees, and admins.
- **Orders**: Stores order information placed by Accounts.
- **OrderDetails**: Stores line items for each Order, linking Orders to Flowers.
