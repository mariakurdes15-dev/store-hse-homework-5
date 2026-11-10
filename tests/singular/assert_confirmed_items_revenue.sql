select
    sum(line_amount) as actual_revenue
from {{ ref('fct_order_items') }}
where is_confirmed = true
having coalesce(sum(line_amount), 0) <> 91620
