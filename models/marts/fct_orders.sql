{{ config(
    materialized='table',
    distributed_by='order_id',
    appendoptimized=true,
    orientation='column',
    compresstype='zlib',
    compresslevel=5
) }}
with item_counts as (

    select
        order_id,
        count(distinct product_id) as items_count

    from {{ ref('stg_shop__order_items') }}

    group by order_id

)

select
    o.order_id,
    o.customer_id,
    o.order_date,
    o.ordered_at,
    o.order_status,
    o.order_amount,
    o.paid_amount,
    o.refunded_amount,
    o.net_paid_amount,
    o.successful_payments_count,
    o.first_paid_at,
    o.is_confirmed,

    coalesce(ic.items_count, 0) as items_count

from {{ ref('int_orders_with_payments') }} as o

left join item_counts as ic
    on o.order_id = ic.order_id

where not o.is_test_order
