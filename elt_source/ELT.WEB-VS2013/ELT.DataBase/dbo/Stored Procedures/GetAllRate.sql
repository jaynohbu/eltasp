

CREATE PROCEDURE [dbo].[GetAllRate]
	@elt_account_number decimal,
	@rate_type int  =0,
	@org_account_number int = 0 
AS
BEGIN		
	if @rate_type =4 --Customer Selling Rate
		SELECT	 a.*,b.dba_name FROM all_rate_table a,organization b 
		WHERE   a.elt_account_number=b.elt_account_number 
		and a.elt_account_number = @elt_account_number  
		AND  a.customer_no=b.org_account_number AND a.rate_type=@rate_type
		AND ((customer_no = @org_account_number) or (@org_account_number =0))	 
		ORDER BY b.dba_name,origin_port,dest_port,kg_lb,airline,item_no,weight_break
	 
	 if @rate_type =3 --Airline Buying Rate
	 begin 
		SELECT a.*,b.dba_name FROM all_rate_table a left outer join organization b
				ON a.elt_account_number=b.elt_account_number AND a.airline=b.carrier_code 
           		WHERE a.elt_account_number = @elt_account_number
			   AND a.rate_type=@rate_type					
			   ORDER BY origin_port,dest_port,kg_lb,airline,item_no,weight_break
	 end 
	 
	  if @rate_type = 1 --Agent Buying Rate
	 begin 
    		SELECT	 a.*,b.dba_name FROM all_rate_table a,organization b 
			 WHERE   a.elt_account_number=b.elt_account_number 
			 and a.elt_account_number = @elt_account_number AND  a.agent_no=b.org_account_number
			  AND a.rate_type=@rate_type
			  AND ((agent_no  = @org_account_number) or (@org_account_number =0))	 
			  ORDER BY b.dba_name,origin_port,dest_port,kg_lb,airline,item_no,weight_break
	 end 
		if @rate_type = 5 --IATA Rate	
	 begin  
 		SELECT a.*,b.dba_name FROM all_rate_table a left outer join organization b
				 ON a.elt_account_number=b.elt_account_number AND a.airline=b.carrier_code
			   WHERE a.elt_account_number = @elt_account_number 
           		AND a.rate_type=@rate_type 						
			 ORDER BY origin_port,dest_port,kg_lb,airline,item_no,weight_break
		end 

end
