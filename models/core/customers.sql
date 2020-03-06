with customers as (
    select
        id as customer_id,
        first_name,
        last_name
    from raw.jaffle_shop.customers
),
orders as (
    select
        o.id as order_id,
        o.user_id as customer_id,
        o.order_date,
        o.status,
	p.amount/100::decimal(15,2) as amount
    from raw.jaffle_shop.orders as o
    left join raw.stripe.payment as p on o.id = p."orderID"
),
customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
	sum(amount) as lifetime_value
    from orders
    group by 1
),
final as (
    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
	zeroifnull(customer_orders.lifetime_value) as lifetime_value
    from customers
    left join customer_orders using (customer_id)
)
select * from final
