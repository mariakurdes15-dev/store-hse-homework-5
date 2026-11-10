with recursive category_tree as (

    select
        category_id,
        parent_category_id,
        category_name,
        category_name as root_category_name,
        1 as category_level
    from {{ ref('stg_shop__product_categories') }}
    where parent_category_id is null

    union all

    select
        child.category_id,
        child.parent_category_id,
        child.category_name,
        parent.root_category_name,
        parent.category_level + 1
    from {{ ref('stg_shop__product_categories') }} as child
    join category_tree as parent
        on child.parent_category_id = parent.category_id

)

select
    tree.category_id,
    tree.category_name,
    parent.category_name as parent_category_name,
    tree.root_category_name,
    tree.category_level
from category_tree as tree
left join {{ ref('stg_shop__product_categories') }} as parent
    on tree.parent_category_id = parent.category_id
