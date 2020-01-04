-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Reporting].[AEOperationReport]
	@Unit VARCHAR(10),
	@StartDate datetime,
	@EndDate datetime,	
	@EltAccountNumber int 
AS
BEGIN

	SET NOCOUNT ON;
IF @Unit='LB'
	BEGIN
		SELECT 
			newId() AS KeyField,
			isnull(b.file#,'') as [File#], 
			a.MAWB_NUM AS [Master], 
			a.HAWB_NUM AS [House], 
			Upper(isnull(a.Shipper_Name,''))  AS [Shipper],
			Upper(isnull(a.Consignee_Name,''))  AS [Consignee],
			Upper(isnull(a.Agent_Name,''))  AS [Agent],
			Upper(isnull(a.by_1,'') ) AS [Carrier],
			Upper(isnull(a.Departure_Airport,''))  AS [Origin],
			Upper(isnull(a.Dest_Airport,''))  AS [Destination],
			convert(varchar(10), a.export_date, 101) AS [Date],
			Upper(isnull(a.SalesPerson,'')) As [Sales Rep.],
			Upper(isnull(a.CreatedBy,'')) As [Processed By],		    
			isnull(a.Total_Pieces,0) AS [Quantity],		    
			CASE WHEN ( isnull(g.kg_lb,'L') = 'K' ) then ( isnull(a.Total_Gross_Weight,0) * 2.20462262 )  ELSE  isnull(a.Total_Gross_Weight,0) END AS [Gross Wt.]
		    
			,CASE WHEN ( isnull(g.kg_lb,'L') = 'K' ) then ( isnull(a.Total_Chargeable_Weight,0) * 2.20462262 )  ELSE  isnull(a.Total_Chargeable_Weight,0)END AS [Chargeable Wt.]
			,isnull(a.Total_Weight_Charge_HAWB,0) AS [Freight Charge], 
			isnull(a.Total_Other_Charges,0) AS [Other Charge] 
			FROM HAWB_master a left outer join mawb_number b 
			on a.elt_account_number = b.elt_account_number and a.mawb_num = b.mawb_no 
		   
			INNER JOIN hawb_weight_charge g
			On a.elt_account_number=g.elt_account_number and a.HAWB_NUM =g.HAWB_NUM where a.elt_account_number =@EltAccountNumber AND (a.export_date >= @StartDate AND a.export_date < DATEADD(day, 1,@EndDate)) and a.is_dome='N'
			
			UNION SELECT
			newId() AS KeyField,
			isnull(d.file#,'') as [File#],
			c.MAWB_NUM AS [Master],
			'' AS [House],
			Upper(isnull(c.Shipper_Name,''))  AS [Shipper],
			Upper(isnull(c.Consignee_Name,''))  AS [Consignee], 
			Upper(isnull(e.dba_name,''))  AS [Agent],
			Upper(isnull(c.by_1,''))  AS [Carrier],
			Upper(isnull(c.Departure_Airport,''))  AS [Origin], 
			Upper(isnull(c.Dest_Airport,''))  AS [Destination], 
			convert(varchar(10), d.ETD_DATE1, 101) AS [Date],
			Upper(isnull(c.SalesPerson,'')) As [Sales Rep.],
			Upper(isnull(c.CreatedBy,'')) As [Processed By],
			isnull(c.Total_Pieces,0) AS [Quantity], CASE WHEN ( isnull(f.kg_lb,'L') = 'K' ) then ( isnull(c.Total_Gross_Weight,0) * 2.20462262 )  ELSE  isnull(c.Total_Gross_Weight,0) END AS [Gross Wt.],CASE WHEN ( isnull(f.kg_lb,'L') = 'K' ) then ( isnull(c.Total_Chargeable_Weight,0) * 2.20462262 )  ELSE  isnull(c.Total_Chargeable_Weight,0)END AS [Chargeable Wt.],isnull(c.Total_Weight_Charge_HAWB,0) AS [Freight Charge],
			isnull(c.Total_Other_Charges,0) AS [Other Charge]
			FROM MAWB_master c left outer JOIN MAWB_NUMBER d 
			ON c.elt_account_number=d.elt_account_number and c.MAWB_NUM = d.MAWB_NO 
		   
			INNER JOIN organization e 
			ON e.elt_account_number=d.elt_account_number and e.org_account_number=c.master_agent 
		  
			INNER JOIN mawb_weight_charge f
			On e.elt_account_number=f.elt_account_number and c.MAWB_NUM =f.MAWB_NUM 
			WHERE d.elt_account_number =@EltAccountNumber AND ( d.ETD_DATE1 >= @StartDate AND  d.ETD_DATE1 < DATEADD(day, 1,@EndDate)) and (select COUNT(hawb_num) from hawb_master WHERE elt_account_number=@EltAccountNumber AND mawb_num=c.mawb_num)=0 and c.is_dome='N' 
	END       
  ELSE 
	BEGIN 
		SELECT 
		newId() AS KeyField,
		isnull(b.file#,'') as [File#], 
		a.MAWB_NUM AS [Master], 
		a.HAWB_NUM AS [House], 
		Upper(isnull(a.Shipper_Name,''))  AS [Shipper],
		Upper(isnull(a.Consignee_Name,''))  AS [Consignee],
		Upper(isnull(a.Agent_Name,''))  AS [Agent],
		Upper(isnull(a.by_1,'') ) AS [Carrier],
		Upper(isnull(a.Departure_Airport,''))  AS [Origin],
		Upper(isnull(a.Dest_Airport,''))  AS [Destination],
		convert(varchar(10), a.export_date, 101) AS [Date],
		Upper(isnull(a.SalesPerson,'')) As [Sales Rep.],
		Upper(isnull(a.CreatedBy,'')) As [Processed By],
		isnull(a.Total_Pieces,0) AS [Quantity],CASE WHEN ( isnull(g.kg_lb,'L') <>'K' ) then ( isnull(a.Total_Gross_Weight,0) * 0.45359237 )  ELSE  isnull(a.Total_Gross_Weight,0) END AS [Gross Wt.],CASE WHEN (isnull(g.kg_lb,'L')<> 'K' ) then ( isnull(a.Total_Chargeable_Weight,0) * 0.45359237 )  ELSE  isnull(a.Total_Chargeable_Weight,0)END AS [Chargeable Wt.],isnull(a.Total_Weight_Charge_HAWB,0) AS [Freight Charge], 
		isnull(a.Total_Other_Charges,0) AS [Other Charge] 
		FROM HAWB_master a left outer join mawb_number b 
		on a.elt_account_number = b.elt_account_number and a.mawb_num = b.mawb_no 

		INNER JOIN hawb_weight_charge g
		On a.elt_account_number=g.elt_account_number and a.HAWB_NUM =g.HAWB_NUM where a.elt_account_number =@EltAccountNumber AND (a.export_date >= @StartDate AND a.export_date < DATEADD(day, 1,@EndDate)) and a.is_dome='N'
		
		UNION SELECT
		newId() AS KeyField,
		isnull(d.file#,'') as [File#],
		c.MAWB_NUM AS [Master],
		'' AS [House],
		Upper(isnull(c.Shipper_Name,''))  AS [Shipper],
		Upper(isnull(c.Consignee_Name,''))  AS [Consignee], 
		Upper(isnull(e.dba_name,''))  AS [Agent],
		Upper(isnull(c.by_1,''))  AS [Carrier],
		Upper(isnull(c.Departure_Airport,''))  AS [Origin], 
		Upper(isnull(c.Dest_Airport,''))  AS [Destination], 
		convert(varchar(10), d.ETD_DATE1, 101) AS [Date],
		Upper(isnull(c.SalesPerson,'')) As [Sales Rep.],
		Upper(isnull(c.CreatedBy,'')) As [Processed By],
		isnull(c.Total_Pieces,0) AS [Quantity], CASE WHEN ( isnull(f.kg_lb,'L') <> 'K' ) then ( isnull(c.Total_Gross_Weight,0) * 0.45359237 )  ELSE  isnull(c.Total_Gross_Weight,0) END AS [Gross Wt.],CASE WHEN ( isnull(f.kg_lb,'L') <>'K' ) then ( isnull(c.Total_Chargeable_Weight,0) * 0.45359237 )  ELSE  isnull(c.Total_Chargeable_Weight,0)END AS [Chargeable Wt.],isnull(c.Total_Weight_Charge_HAWB,0) AS [Freight Charge],
		isnull(c.Total_Other_Charges,0) AS [Other Charge]
		FROM MAWB_master c left outer JOIN MAWB_NUMBER d 
		ON c.elt_account_number=d.elt_account_number and c.MAWB_NUM = d.MAWB_NO 

		INNER JOIN organization e 
		ON e.elt_account_number=d.elt_account_number and e.org_account_number=c.master_agent 

		INNER JOIN mawb_weight_charge f
		On e.elt_account_number=f.elt_account_number and c.MAWB_NUM =f.MAWB_NUM 
		WHERE d.elt_account_number =@EltAccountNumber AND ( d.ETD_DATE1 >= @StartDate AND  d.ETD_DATE1 < DATEADD(day, 1,@EndDate)) and (select COUNT(hawb_num) from hawb_master WHERE elt_account_number=@EltAccountNumber AND mawb_num=c.mawb_num)=0 and c.is_dome='N' 

	END          
            
END
