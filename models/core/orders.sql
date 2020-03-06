{{ config(materialized='table') }}

select
  o.order_id
  , o.customer_id
  , sum(p.amount) as amount
from
  {{ ref('jaffle_shop__orders') }} as o
  left join {{ ref('stripe__payments') }} as p on o.order_id = p."orderID"
group by 1, 2
