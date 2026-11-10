
{{ config(distributed_replicated=true) }}

with confirmed_orders as (

    select
        customer_id,
        order_id,
        first_paid_at,
        order_amount,

        row_number() over (
            partition by customer_id
            order by first_paid_at, order_id
        ) as purchase_number

    from {{ ref('fct_orders') }}

    where is_confirmed = true

),

customer_stats as (

    select
        customer_id,
        count(*) as confirmed_orders_count,
        sum(order_amount) as confirmed_revenue

    from confirmed_orders

    group by customer_id

),

first_purchases as (

    select
        customer_id,
        order_id as first_confirmed_order_id,
        first_paid_at as first_confirmed_at

    from confirmed_orders

    where purchase_number = 1

)

select
    c.customer_id,
    c.registered_at,
    c.registration_date,
    c.city,
    c.acquisition_channel,

    fp.first_confirmed_order_id,
    fp.first_confirmed_at,

    coalesce(cs.confirmed_orders_count, 0)
        as confirmed_orders_count,

    coalesce(cs.confirmed_revenue, 0)
        as confirmed_revenue,

    case
        when coalesce(cs.confirmed_orders_count, 0) > 0
        then true
        else false
    end as is_buyer

from {{ ref('stg_shop__customers') }} as c

left join customer_stats as cs
    on c.customer_id = cs.customer_id

left join first_purchases as fp
    on c.customer_id = fp.customer_id
