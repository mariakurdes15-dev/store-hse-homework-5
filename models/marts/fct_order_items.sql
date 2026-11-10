{{ config(
    materialized='table',
    distributed_by='order_id',
    appendoptimized=true,
    orientation='column',
    compresstype='zlib',
    compresslevel=5
) }}
select
    i.order_item_id,
    i.order_id,
    i.product_id,
    o.customer_id,
    o.order_date,

    i.quantity,
    i.unit_price,
    i.discount_amount,
    i.line_amount,

    o.is_confirmed

from {{ ref('stg_shop__order_items') }} as i

join {{ ref('fct_orders') }} as o
    on i.order_id = o.order_id
