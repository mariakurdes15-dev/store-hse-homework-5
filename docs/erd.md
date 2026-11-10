# ER-диаграмма интернет-магазина

```mermaid
erDiagram
    dim_customers ||--o{ fct_orders : customer_id
    dim_dates ||--o{ fct_orders : order_date
    fct_orders ||--o{ fct_order_items : order_id
    dim_products ||--o{ fct_order_items : product_id
```