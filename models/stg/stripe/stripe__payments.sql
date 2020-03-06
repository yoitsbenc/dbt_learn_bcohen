with source as (
	select * from {{source('stripe', 'payment')}}
),

renamed as (
select
  id
  , "orderID"
  , "paymentMethod"
  , amount/100 as amount
  , created
 from
  source
)

select * from renamed
