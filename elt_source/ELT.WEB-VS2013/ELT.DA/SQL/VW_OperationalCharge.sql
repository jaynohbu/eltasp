USE [PreDB]
GO

/****** Object:  View [dbo].[VW_OperationalCharge]    Script Date: 6/25/2014 5:06:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[VW_OperationalCharge]
AS
/*Direct Shippment Other Charge*/ 


SELECT 'E' AS ImportExport, 'A' AS AirOcean, 'M' AS Master_House, MC.[elt_account_number], MC.[MAWB_NUM] AS MBL_NUM, '' AS HBL_NUM, CONVERT(int, MC.[charge_code]) AS Item_Code, [Charge_Desc], 
                  CASE WHEN MC.[Coll_Prepaid] = 'C' THEN CONVERT(int, MM.Consignee_acct_num) ELSE CONVERT(int, MM.[Shipper_account_number]) END AS Bill_To, CONVERT(decimal, [Amt_MAWB]) AS Amount
				
      ,MM.DEP_AIRPORT_CODE AS ORIGIN
      ,MM.to_1 AS DEST
	  ,c.ETD_DATE1 AS [Date]
FROM     [MAWB_Other_Charge] MC  with(nolock)  INNER JOIN
                  mawb_master MM with(nolock)  ON MM.MAWB_NUM = MC.MAWB_NUM AND MM.elt_account_number = MC.elt_account_number
				  inner join [MAWB_NUMBER] c  with(nolock)  on MM.MAWB_NUM=c.mawb_no and MM.elt_account_number=c.elt_account_number
WHERE  MC.CHARGE_CODE <> 0 AND MM.MAWB_NUM NOT IN
                      (SELECT DISTINCT MAWB_NUM
                       FROM      HAWB_Master with(nolock) 
                       WHERE   MAWB_NUM IS NOT NULL)
UNION
/*Direct Shippment Freight Charge*/ 

SELECT 'E' AS ImportExport, 'A' AS AirOcean, 'M' AS Master_House , a.elt_account_number, a.mawb_num AS MBL_NUM, '' AS HBL_NUM, 0 AS item_Code, 'Freight Charge' AS Charge_Desc, 
                  CASE WHEN ISNULL(MM.COLL_1, '') = 'Y' THEN CONVERT(int, MM.Consignee_acct_num) ELSE CONVERT(int, MM.[Shipper_account_number]) END AS Bill_To, CONVERT(decimal, a.total_charge) AS Amount
			,MM.DEP_AIRPORT_CODE AS ORIGIN
			,MM.to_1 AS DEST
			,c.ETD_DATE1 AS [Date]
FROM     mawb_weight_charge a with(nolock)  INNER JOIN
                  mawb_master MM with(nolock)  ON MM.MAWB_NUM = a.MAWB_NUM AND a.elt_account_number = MM.elt_account_number 
				  inner join [MAWB_NUMBER] c with(nolock)  on MM.MAWB_NUM=c.mawb_no and MM.elt_account_number=c.elt_account_number
				  
				
WHERE          MM.MAWB_NUM NOT IN
                      (SELECT DISTINCT MAWB_NUM
                       FROM      HAWB_Master with(nolock) 
                       WHERE   MAWB_NUM IS NOT NULL)
UNION
/*House Bound Other Charge - ignore in Master*/ 

SELECT 'E' AS ImportExport,'A' AS AirOcean, 'H' AS Master_House, a.elt_account_number, b.mawb_num AS MBL_NUM, a.hawb_num AS HBL_NUM, a.charge_code AS item_Code, 
                  charge_desc AS Charge_Desc, CASE WHEN a.Coll_Prepaid = 'C' THEN CONVERT(int, b.Agent_No) ELSE CONVERT(int, b.Shipper_account_number) END AS Bill_To, CONVERT(decimal, a.amt_hawb) AS Amount
				,b.DEP_AIRPORT_CODE AS ORIGIN
				,b.to_1 AS DEST
				,c.ETD_DATE1 AS [Date]
FROM     hawb_other_charge a  with(nolock)  INNER JOIN
                  hawb_master b with(nolock)  ON (a.elt_account_number = b.elt_account_number AND a.hawb_num = b.hawb_num)
				  inner join [MAWB_NUMBER] c  with(nolock)  on b.MAWB_NUM=c.mawb_no and b.elt_account_number=c.elt_account_number
WHERE  ISNULL(b.mawb_num, '') <> '' 
UNION
/*House Bound Fright Charge*/


 SELECT 'E' AS ImportExport, 'A' AS AirOcean, 'H' AS Master_House, a.elt_account_number, b.mawb_num AS MBL_NUM, a.hawb_num AS HBL_NUM, 0 AS item_Code, 'Freight Charge' AS Charge_Desc, 
                  CASE WHEN ISNULL(b.COLL_1, '') = 'Y' THEN CONVERT(int, b.Agent_No) ELSE CONVERT(int, b.Shipper_account_number) END AS Bill_To, CONVERT(decimal, a.total_charge) AS Amount
				,b.DEP_AIRPORT_CODE AS ORIGIN
				,b.to_1 AS DEST
				,d.ETD_DATE1 AS [Date]
FROM     hawb_weight_charge a with(nolock)  inner JOIN
                  hawb_master b with(nolock)  ON (a.elt_account_number = b.elt_account_number AND a.hawb_num = b.hawb_num)
		inner join MAWB_MASTER c with(nolock)  on (b.elt_account_number=c.elt_account_number AND b.MAWB_NUM=c.MAWB_NUM)
		inner join [MAWB_NUMBER] d with(nolock)  on b.MAWB_NUM=d.mawb_no and b.elt_account_number=d.elt_account_number
WHERE  ISNULL(b.mawb_num, '') <> '' 

UNION
--------------------------OCEAN EXPORT------------------------------------------------------------------

/*Direct Shippment Freight Charge*/ 

SELECT 'E' AS ImportExport, 'O' AS AirOcean, 'M' AS Master_House, a.elt_account_number, a.mbol_num AS MBL_NUM, '' AS HBL_NUM, 0 AS item_Code, 'Freight Charge' AS Charge_Desc, 
                  CASE WHEN ISNULL(a.weight_cp, '') = 'C' THEN CONVERT(int, a.Consignee_acct_num) ELSE CONVERT(int, a.Shipper_acct_num) END AS Bill_To, CONVERT(decimal, a.total_weight_charge) AS Amount
				,c.origin_port_id AS ORIGIN
				,c.dest_port_id AS DEST
				,a.departure_date as [Date]
FROM    mbol_master a with(nolock)  inner join ocean_booking_number c with(nolock)  on a.booking_num=c.booking_num
WHERE    a.mbol_num NOT IN
                      (SELECT DISTINCT mbol_num
                       FROM      hbol_master  with(nolock) 
                       WHERE   mbol_num IS NOT NULL) 

UNION
/*Direct Shippment Other Charge*/ 
SELECT 'E' AS ImportExport, 'O' AS AirOcean, 'M' AS Master_House, MC.[elt_account_number], MC.mbol_num AS MBL_NUM, '' AS HBL_NUM, CONVERT(int, MC.[charge_code]) AS Item_Code, [Charge_Desc], 
                  CASE WHEN MC.[Coll_Prepaid] = 'C' THEN CONVERT(int, MM.Consignee_acct_num) ELSE CONVERT(int, MM.Shipper_acct_num) END AS Bill_To, CONVERT(decimal, MC.charge_amt) AS Amount
				,c.origin_port_id AS ORIGIN
				,c.dest_port_id AS DEST
				,MM.departure_date as [Date]
FROM     mbol_other_charge MC with(nolock)  INNER JOIN
                  mbol_master MM with(nolock)  ON MM.mbol_num = MC.mbol_num AND MM.elt_account_number = MC.elt_account_number
				  INNER JOIN  ocean_booking_number c with(nolock)  on MM.booking_num=c.booking_num
WHERE  MC.CHARGE_CODE <> 0  AND MM.mbol_num NOT IN
                      (SELECT DISTINCT mbol_num
                       FROM      hbol_master with(nolock) 
                       WHERE   mbol_num IS NOT NULL)


UNION

/*House Bound Other Charge - ignore in Master*/ 

SELECT 'E' AS ImportExport,'O' AS AirOcean, 'H' AS Master_House, a.elt_account_number, b.mbol_num AS MBL_NUM, a.hbol_num AS HBL_NUM, a.charge_code AS item_Code, 
                  charge_desc AS Charge_Desc, CASE WHEN a.Coll_Prepaid = 'C' THEN CONVERT(int, b.Agent_No) ELSE CONVERT(int, b.Shipper_acct_num) END AS Bill_To, CONVERT(decimal, a.charge_amt) AS Amount
				,c.origin_port_id AS ORIGIN
				,c.dest_port_id AS DEST
				,b.departure_date AS [Date]
FROM     hbol_other_charge a with(nolock)  INNER JOIN
                  hbol_master b with(nolock)  ON (a.elt_account_number = b.elt_account_number AND a.hbol_num = b.hbol_num) 
				  inner join  mbol_master MM  with(nolock)  ON MM.mbol_num = b.mbol_num 
				  inner join 				  
				  ocean_booking_number c with(nolock)  on MM.booking_num=c.booking_num
WHERE  ISNULL(b.mbol_num, '') <> '' 


UNION
/*House Bound Fright Charge*/

 SELECT 'E' AS ImportExport, 'O' AS AirOcean, 'H' AS Master_House, a.elt_account_number, a.mbol_num AS MBL_NUM, a.hbol_num AS HBL_NUM, 0 AS item_Code, 'Freight Charge' AS Charge_Desc, 
                  CASE WHEN ISNULL(a.weight_cp, '') = 'C' THEN CONVERT(int, a.agent_no) ELSE CONVERT(int, a.Shipper_acct_num) END AS Bill_To, CONVERT(decimal, a.total_weight_charge) AS Amount
					,c.origin_port_id AS ORIGIN
					,c.dest_port_id AS DEST
					,a.departure_date AS [Date]
FROM     
                  hbol_master a with(nolock) 
				    inner join  mbol_master MM  with(nolock) ON MM.mbol_num = a.mbol_num 
				  inner join 				  
				  ocean_booking_number c with(nolock)  on MM.booking_num=c.booking_num
WHERE  ISNULL(a.mbol_num, '') <> '' 

UNION


SELECT  
      B.[import_export] AS ImportExport,
       B.[air_ocean] AS AirOcean,      
	   case when isnull(B.hawb_num,'')='' then 'M' else 'H' end as Master_House,
	    A.[elt_account_number],
		B.[mawb_num] AS MBL_NUM, B.[mawb_num] AS HBL_NUM,   
		[item_no] as Item_Code,
		[item_desc]  as Charge_Desc,
		[Customer_Number]   AS Bill_To,
		[charge_amount] as Amount,
        [Origin],
        [Dest],			
		B.[invoice_date] as [Date]
  FROM [invoice_charge_item] A with(nolock)  INNER JOIN [VW_ArrivalNotice] B with(nolock)  ON A.elt_account_number = B.elt_account_number AND A.INVOICE_NO =B.INVOICE_NO 
 












GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_OperationalCharge'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_OperationalCharge'
GO

