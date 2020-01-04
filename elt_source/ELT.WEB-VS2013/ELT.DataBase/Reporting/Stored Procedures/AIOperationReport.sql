-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Reporting].[AIOperationReport]
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
                isnull(b.File_No,'') as [File#],

                a.MAWB_NUM as [Master], 
                isnull(a.HAWB_NUM,'') as [House], 
                 
                Upper(isnull(a.Shipper_name,'')) as [Shipper], 
                Upper(isnull(a.consignee_name,'')) as [Consignee], 
                Upper(isnull( b.export_agent_name,'') )as[Agent],
                Upper(isnull( b.carrier,'') )as [Carrier],


                Upper(isnull( a.dep_port,'')) as [Origin], 
                Upper(isnull(a.arr_port,'')) as [Destination],

                convert(varchar(10), a.eta , 101) as[Date], 


                Upper(isnull( a.SalesPerson,'')) as [Sales Rep.],
                Upper(isnull(a.CreatedBy,'')) as [Processed By],
                isnull(a.pieces,0) as [Quantity], case when (isnull(a.scale1,'LB')='KG') then (isnull(a.gross_wt,0)*2.20462262) Else isnull(a.gross_wt,0) End as [Gross Wt.], case when(isnull(a.scale1,'LB')='KG') then (isnull(a.chg_wt,0)*2.20462262) Else isnull(a.chg_wt,0) End as [Chargeable Wt.],isnull(a.freight_collect,0) as [Freight Charge],
                isnull(a.oc_collect,0) as[Other Charge],
                isnull(a.sec,1) as[sec]
                
                from import_hawb a 

                left outer join import_mawb b
                on a.mawb_num=b.mawb_num
                where a.itype='A'and a.elt_account_number = @EltAccountNumber and a.elt_account_number = b.elt_account_number  AND (CAST(CASE WHEN ISDATE(a.eta)=1 THEN a.eta END AS DATETIME)>=CONVERT(DATETIME,@StartDate)AND CAST(CASE WHEN ISDATE(a.eta)=1 THEN a.eta END AS DATETIME)<CONVERT(DATETIME,@EndDate)) ORDER BY [Agent]
	END       
  ELSE 
	BEGIN 
		SELECT 
				newId() AS KeyField,
                isnull(b.File_No,'') as [File#],

                a.MAWB_NUM as [Master], 
                isnull(a.HAWB_NUM,'') as [House], 
                 
                Upper(isnull(a.Shipper_name,'')) as [Shipper], 
                Upper(isnull(a.consignee_name,'')) as [Consignee], 
                Upper(isnull( b.export_agent_name,'') )as[Agent],
                Upper(isnull( b.carrier,'') )as [Carrier],


                Upper(isnull( a.dep_port,'')) as [Origin], 
                Upper(isnull(a.arr_port,'')) as [Destination],

                convert(varchar(10), a.eta , 101) as[Date], 


                Upper(isnull( a.SalesPerson,'')) as [Sales Rep.],
                Upper(isnull(a.CreatedBy,'')) as [Processed By],
                isnull(a.pieces,0) as [Quantity], case when (isnull(a.scale1,'LB')<>'KG') then (isnull(a.gross_wt,0)*0.45359237) Else isnull(a.gross_wt,0) End as [Gross Wt.], case when(isnull(a.scale2,'LB')<>'KG') then (isnull(a.chg_wt,0)*0.45359237) Else isnull(a.chg_wt,0) End as [Chargeable Wt.],isnull(a.freight_collect,0) as [Freight Charge],
                isnull(a.oc_collect,0) as[Other Charge],
                isnull(a.sec,1) as[sec]
                
                from import_hawb a 

                left outer join import_mawb b
                on a.mawb_num=b.mawb_num
                where a.itype='A'and a.elt_account_number = @EltAccountNumber and a.elt_account_number = b.elt_account_number  AND (CAST(CASE WHEN ISDATE(a.eta)=1 THEN a.eta END AS DATETIME)>=CONVERT(DATETIME,@StartDate)AND CAST(CASE WHEN ISDATE(a.eta)=1 THEN a.eta END AS DATETIME)<CONVERT(DATETIME,@EndDate)) ORDER BY [Agent]
	END          
            
END
