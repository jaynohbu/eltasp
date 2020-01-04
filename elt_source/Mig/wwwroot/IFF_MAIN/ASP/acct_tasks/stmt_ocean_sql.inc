<%
function get_ocean_smtp_sql
	SQL= "select "&_
	"a.hbol_num as hawb_num,a.agent_name,a.export_carrier as by_1,a.loading_port as departure_airport,a.departure_date as flight_date_1,"&_
	"a.unloading_port as dest_airport,cast(a.forward_agent_info as varchar) as account_info,a.total_weight_charge as total_weight_charge_hawb,a.prepaid_other_charge as ppo_1,"&_
	"a.of_cost as af_cost,a.agent_profit,a.agent_profit_share,a.other_agent_profit_carrier,other_agent_profit_agent,b.coll_prepaid,'A' as carrier_agent,"&_
	"sum(b.charge_amt) as chg from hbol_master a LEFT OUTER JOIN hbol_other_charge b on (a.elt_account_number=b.elt_account_number) "&_
	"and (a.hbol_num=b.hbol_num) where a.elt_account_number = " & elt_account_number & " and a.booking_num='" & MAWB & "' and a.agent_no=" & AgentNo

	SQL=SQL & " group by "&_
	"a.hbol_num,a.agent_name,a.export_carrier,a.loading_port,a.departure_date,a.unloading_port,cast(a.forward_agent_info as varchar),a.prepaid_other_charge,a.total_weight_charge,"&_
	"a.of_cost,a.agent_profit,a.agent_profit_share,a.other_agent_profit_carrier,a.other_agent_profit_agent,b.coll_prepaid "&_
	" order by a.hbol_num,b.carrier_agent"
	get_ocean_smtp_sql = SQL
end function
%>

