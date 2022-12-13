with cul_customers as (

    select
        customer_id,
        customer_name,
        customer_address

    from snowflake_demo_01.jm_culina_mssql1_dbo.culina_customers

),

cul_orders as (

    select
        order_id,
        order_desc,
		customer_id,
		dispatch_date,
		delivery_date,
		dispatch_id,
		pick_confirmation,
		additional_info

    from snowflake_demo_01.jm_culina_mssql1_dbo.culina_orders

),

final as (

    select 
		co.order_id,
		co.order_desc,
		cc.customer_name,
		cc.customer_address,
		co.dispatch_date,
		co.delivery_date,
	case
		when co.delivery_date < co.dispatch_date then 'Y'
		else 'N'
	end
	as delivery_error,
		co.dispatch_id,
	case
		when co.dispatch_id is not null and co.pick_confirmation is null then 'YY'
		when co.dispatch_id is null and co.pick_confirmation is null then null
		else co.pick_confirmation
	end
	as pick_confirm,
		co.additional_info
	from cul_orders co, cul_customers cc
	where co.customer_id = cc.customer_id

)

select * from final
