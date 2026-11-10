{{
    config(
        materialized='incremental',
        incremental_strategy='append',
        distributed_by='order_id'
    )
}}

select
    order_id,
    customer_id,
    order_date,
    order_amount,
    is_confirmed
from {{ ref('fct_orders') }}

{% if is_incremental() %}

where order_id > (
    select coalesce(max(order_id), 0)
    from {{ this }}
)

{% endif %}
