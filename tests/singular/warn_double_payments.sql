{{ config(severity='warn') }}
select
    order_id,
    order_amount,
    paid_amount,
    successful_payments_count
from {{ ref('fct_orders') }}
where paid_amount > order_amount
  and successful_payments_count > 1
