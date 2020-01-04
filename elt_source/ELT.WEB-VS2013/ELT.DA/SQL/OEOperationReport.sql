USE [PRDDB]
GO

/****** Object:  StoredProcedure [Reporting].[OEOperationReport]    Script Date: 03/27/2014 01:29:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Reporting].[OEOperationReport]
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
	                isnull(a.file_no,'') as [File#],
	                b.MBOL_NUM AS [Master],
	                b.HBOL_NUM AS [House],
                	
	                Upper(isnull(b.Shipper_Name,'')) AS [Shipper],
	                 Upper(isnull(b.Consignee_Name,'')) AS [Consignee],
	                 Upper(isnull(b.Agent_Name,'')) AS [Agent],
	                 Upper(isnull(b.Export_carrier,'')) AS [Carrier],	
	                Upper(isnull(b.Loading_port,''))  AS [Origin],
	                 Upper(isnull(b.Unloading_port,'')) AS [Destination],	
	                convert(varchar(10), a.departure_date, 101) AS [Date],	
                	
	                Upper( isnull(b.SalesPerson,'')) AS [Sales Rep.],
	                Upper(isnull(b.CreatedBy,''))  AS [Processed By],
                    isnull(b.pieces,0) AS [Quantity], 
					Case when (isnull(b.scale,'K')<>'L') 
					then (isnull(b.Gross_weight,0)* 2.20462262 )
					ELSE isnull(b.Gross_weight,0) 
					END AS [Gross Wt.],
					isnull(b.measurement,0) AS [Chargeable Wt.],
					isnull(b.Total_weight_charge,0) AS [Freight Charge],
                    isnull(b.Total_other_charge,0) AS [Other Charge]
                    
                     
                    FROM ocean_booking_number a 
                    inner JOIN HBOL_MASTER b 

                    ON a.booking_num = b.booking_num and a.elt_account_number=b.elt_account_number where a.elt_account_number =@EltAccountNumber AND (a.departure_date  >= @StartDate AND a.departure_date < DATEADD(day, 1,@EndDate)) 
                    
                    UNION SELECT
                    newId() AS KeyField,
	                isnull(a.file_no,'') as [File#],
	                a.MBOL_NUM AS [Master],
	                '' AS [House],
                	
	                 Upper(isnull(b.Shipper_Name,'')) AS [Shipper],
	                 Upper(isnull(b.Consignee_Name,'')) AS [Consignee],
	                 Upper(isnull(b.Agent_Name,'') )AS [Agent],
	                 Upper(isnull(b.Export_carrier,'')) AS [Export],
                	
	                 Upper(isnull(b.Loading_port,'') ) AS [Origin],
	                 Upper(isnull(b.Unloading_port,''))  AS [Destination],
                	
	                convert(varchar(10), a.departure_date, 101) AS [Date],
                    
                     Upper(isnull(b.SalesPerson,'') )AS [Sales Rep.],
	                Upper(isnull(b.CreatedBy,'') ) AS [Processed By],
                    isnull(b.pieces,0) AS [Quantity], Case when (isnull(b.scale,'K')<>'L') then (isnull(b.Gross_weight,0) * 2.20462262 )ELSE isnull(b.Gross_weight,0) END AS [Gross Wt.],isnull(b.measurement,0) AS [Chargeable Wt.],isnull(b.Total_weight_charge,0) AS [Freight Charge],
                    isnull(b.Total_other_charge,0) AS [Other Charge]      
                    FROM ocean_booking_number a inner JOIN MBOL_MASTER b 
                    ON a.BOOKING_NUM = b.BOOKING_NUM and a.elt_account_number=b.elt_account_number where a.elt_account_number =@EltAccountNumber AND (a.departure_date  >= @StartDate AND a.departure_date < DATEADD(day, 1,@EndDate)) AND (select COUNT(hbol_num) from hbol_master WHERE elt_account_number=@EltAccountNumber AND booking_num=b.booking_num)=0 
	END       
  ELSE 
	BEGIN 
		SELECT 
					newId() AS KeyField,
	                isnull(a.file_no,'') as [File#],
	                b.MBOL_NUM AS [Master],
	                b.HBOL_NUM AS [House],
                	
	                Upper(isnull(b.Shipper_Name,'')) AS [Shipper],
	                 Upper(isnull(b.Consignee_Name,'')) AS [Consignee],
	                 Upper(isnull(b.Agent_Name,'')) AS [Agent],
	                 Upper(isnull(b.Export_carrier,'')) AS [Carrier],	
	                Upper(isnull(b.Loading_port,''))  AS [Origin],
	                 Upper(isnull(b.Unloading_port,'')) AS [Destination],	
	                convert(varchar(10), a.departure_date, 101) AS [Date],	
                	
	                Upper( isnull(b.SalesPerson,'')) AS [Sales Rep.],
	                Upper(isnull(b.CreatedBy,''))  AS [Processed By],
                    isnull(b.pieces,0) AS [Quantity], Case when (isnull(b.scale,'K')='L') then (isnull(b.Gross_weight,0) * 0.45359237 )ELSE isnull(b.Gross_weight,0) END AS [Gross Wt.],isnull(b.measurement,0) AS [Chargeable Wt.],isnull(b.Total_weight_charge,0) AS [Freight Charge],
                    isnull(b.Total_other_charge,0) AS [Other Charge]
                    
                     
                    FROM ocean_booking_number a 
                    inner JOIN HBOL_MASTER b 

                    ON a.booking_num = b.booking_num and a.elt_account_number=b.elt_account_number where a.elt_account_number =@EltAccountNumber AND (a.departure_date  >= @StartDate AND a.departure_date < DATEADD(day, 1,@EndDate))
                     UNION SELECT
                     newId() AS KeyField,
	                isnull(a.file_no,'') as [File#],
	                a.MBOL_NUM AS [Master],
	                '' AS [House],
                	
	                 Upper(isnull(b.Shipper_Name,'')) AS [Shipper],
	                 Upper(isnull(b.Consignee_Name,'')) AS [Consignee],
	                 Upper(isnull(b.Agent_Name,'') )AS [Agent],
	                 Upper(isnull(b.Export_carrier,'')) AS [Export],
                	
	                 Upper(isnull(b.Loading_port,'') ) AS [Origin],
	                 Upper(isnull(b.Unloading_port,''))  AS [Destination],
                	
	                convert(varchar(10), a.departure_date, 101) AS [Date],
                    
                     Upper(isnull(b.SalesPerson,'') )AS [Sales Rep.],
	                Upper(isnull(b.CreatedBy,'') ) AS [Processed By],
                    isnull(b.pieces,0) AS [Quantity], Case when (isnull(b.scale,'K')='L') then (isnull(b.Gross_weight,0) * 0.45359237 )ELSE isnull(b.Gross_weight,0) END AS [Gross Wt.],isnull(b.measurement,0) AS [Chargeable Wt.],isnull(b.Total_weight_charge,0) AS [Freight Charge],
                    isnull(b.Total_other_charge,0) AS [Other Charge]  

  
    
                    FROM ocean_booking_number a inner JOIN MBOL_MASTER b 
                    ON a.BOOKING_NUM = b.BOOKING_NUM and a.elt_account_number=b.elt_account_number where a.elt_account_number =@EltAccountNumber AND (a.departure_date  >= @StartDate AND a.departure_date < DATEADD(day, 1,@EndDate)) AND (select COUNT(hbol_num) from hbol_master WHERE elt_account_number=@EltAccountNumber AND booking_num=b.booking_num)=0 
	END          
            
END

GO

