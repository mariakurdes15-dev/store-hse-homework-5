with actual_counts as (

    select
        customer_id,
        count(*) as actual_orders_count
    from {{ ref('fct_orders') }}
    where is_confirmed = true
    group by customer_id

)

select
    c.customer_id,
    c.confirmed_orders_count,
    coalesce(a.actual_orders_count, 0) as actual_orders_count
from {{ ref('dim_customers') }} as c
left join actual_counts as a
    on c.customer_id = a.customer_id
where c.confirmed_orders_count
      <> coalesce(a.actual_orders_count, 0)
