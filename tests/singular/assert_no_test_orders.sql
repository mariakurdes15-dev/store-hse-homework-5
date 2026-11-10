select
    f.order_id
from {{ ref('fct_orders') }} as f
join {{ ref('stg_shop__orders') }} as s
    on f.order_id = s.order_id
where s.is_test_order = true
