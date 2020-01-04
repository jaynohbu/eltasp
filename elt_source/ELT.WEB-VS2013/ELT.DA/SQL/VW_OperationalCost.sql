USE [PreDB]
GO

/****** Object:  View [dbo].[VW_OperationalCost]    Script Date: 6/25/2014 5:06:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/* Shippment Freight Cost from MASTER doens't matter whether it is House attached or not*/
CREATE VIEW [dbo].[VW_OperationalCost]
AS
SELECT 'E' AS ImportExport, Induced, AirOcean, Master_House, elt_account_number, MBL_NUM, HBL_NUM, item_Code, Cost_Desc, Bill_From, Amount,ORIGIN,DEST,[Date]


FROM     (SELECT 'Y' AS Induced, 'A' AS AirOcean, 'M' AS Master_House, a.elt_account_number, a.MAWB_NUM AS MBL_NUM, '' AS HBL_NUM, 0 AS item_Code, 'Freight Cost' AS Cost_Desc, MM.airline_vendor_num AS Bill_From, 
                                    MM.total_chargeable_weight * ISNULL
                                        ((SELECT TOP (1) rate
                                          FROM      dbo.all_rate_table AS b with(nolock) 
                                          WHERE   (airline = MM.airline_vendor_num) AND (rate_type = 3) AND (weight_break >= MM.total_chargeable_weight) AND (kg_lb = a.Kg_Lb) AND (elt_account_number = a.elt_account_number)
                                          ORDER BY weight_break DESC), 0) AS Amount
										,MM.DEP_AIRPORT_CODE AS ORIGIN
										,MM.to_1 AS DEST
										 ,c.ETD_DATE1 AS [Date]
                  FROM      dbo.MAWB_Weight_Charge AS a with(nolock)  INNER JOIN
                                    dbo.MAWB_MASTER AS MM with(nolock)  ON MM.MAWB_NUM = a.MAWB_NUM AND a.elt_account_number = MM.elt_account_number
									inner join [MAWB_NUMBER] c  with(nolock)  on MM.MAWB_NUM=c.mawb_no and MM.elt_account_number=c.elt_account_number
                ) AS A_1
WHERE  (Amount <> 0)


UNION

/*Airline MAWB Other Cost  doens't matter whether it is House attached or not*/ 
SELECT 'E' AS ImportExport,'Y' AS Induced, 'A' AS AirOcean, 'M' AS Master_House, MC.[elt_account_number], MC.[MAWB_NUM] AS MBL_NUM, '' AS HBL_NUM, CONVERT(int, MC.[charge_code]) AS Item_Code, [Charge_Desc] AS Cost_Desc, 
MM.airline_vendor_num as Bill_FROM, CONVERT(decimal, [Amt_MAWB]) AS Amount
,MM.DEP_AIRPORT_CODE AS ORIGIN
,MM.to_1 AS DEST
,c.ETA_DATE1 AS [Date]
FROM     [MAWB_Other_Charge] MC with(nolock)  INNER JOIN
                  mawb_master MM with(nolock)  ON MM.MAWB_NUM = MC.MAWB_NUM AND MM.elt_account_number = MC.elt_account_number
				  inner join [MAWB_NUMBER] c with(nolock)  on MM.MAWB_NUM=c.mawb_no and MM.elt_account_number=c.elt_account_number
WHERE  MC.CHARGE_CODE <> 0 and MC.Carrier_Agent='C' and MM.airline_vendor_num <> 0 and [Amt_MAWB] > 0


UNION
/*HOUSE OTHER COST*/
  SELECT 'E' AS ImportExport, 'N'as Induced, 'A' as AirOcean, 'H' as MasterHouse, a.elt_account_number,b.mawb_num as MBL_NUM,a.hawb_num as HBL_NUM,
                a.item_no as item_Code,a.cost_desc ,
                a.vendor_no AS Bill_FROM, a.cost_amt AS Amount 
				,b.DEP_AIRPORT_CODE AS ORIGIN
				,b.to_1 AS DEST
				,c.ETD_DATE1 AS [Date]
				FROM hawb_other_cost a INNER JOIN hawb_master b with(nolock) 
                ON (a.elt_account_number=b.elt_account_number AND a.hawb_num=b.hawb_num) 
				inner join [MAWB_NUMBER] c with(nolock)  on b.MAWB_NUM=c.mawb_no and b.elt_account_number=c.elt_account_number
                WHERE ISNULL(b.mawb_num,'')<>'' 


UNION
/*MASTER OTHER COST - IT IS ONLY AFFECTD WHEN DIRECT SHIPMENT */
SELECT 'E' AS ImportExport, 'N'as Induced, 'A' as AirOcean, 'M' as MasterHouse, a.elt_account_number,a.mawb_num AS MBL_NUM,'' as HBL_NUM,
	a.item_no as item_Code, a.cost_desc ,
	a.vendor_no AS Bill_FROM, a.cost_amt AS Amount
	,MM.DEP_AIRPORT_CODE AS ORIGIN
				,MM.to_1 AS DEST
				,c.ETD_DATE1 AS [Date]
	 FROM mawb_other_cost a with(nolock)   INNER JOIN
                  mawb_master MM with(nolock)  ON MM.MAWB_NUM = a.MAWB_NUM AND MM.elt_account_number = MM.elt_account_number
				  inner join [MAWB_NUMBER] c with(nolock)  on MM.MAWB_NUM=c.mawb_no and MM.elt_account_number=c.elt_account_number
	WHERE a.mawb_num NOT IN 
	(SELECT DISTINCT MAWB_NUM
	FROM      HAWB_Master with(nolock) 
	WHERE   MAWB_NUM IS NOT NULL)

UNION
	---------------import
	--ARN
SELECT  
       B.[import_export] AS ImportExport,
	   'N'as Induced,
       B.[air_ocean] AS AirOcean,      
	   case when isnull(B.hawb_num,'')='' then 'M' else 'H' end as Master_House,
	    A.[elt_account_number],
		B.[mawb_num] AS MBL_NUM, B.[mawb_num] AS HBL_NUM,   
		[item_no] as Item_Code,
		[item_desc]  as Cost_Desc,
		[Customer_Number]   AS Bill_From,
		[cost_amount] as Amount,
        [Origin],
        [Dest],	
		B.[invoice_date] as [Date]
  FROM [invoice_cost_item] A with(nolock)  INNER JOIN [VW_ArrivalNotice] B with(nolock)  ON A.elt_account_number = B.elt_account_number AND A.INVOICE_NO =B.INVOICE_NO

  ---AGENT DEBIT ON MASTER
UNION
  SELECT   
  'I' as import_export, 
  'N' as Induced,    
  iType as air_ocean,
  'M' as    Master_House,
   elt_account_number,  
   mawb_num AS MBL_NUM,    
   '' AS HBL_NUM,                        
'-1' as Item_Code,
'Agent Debit' as Cost_Desc,                                 
agent_org_acct as Bill_From, 
agent_debit_amt as Amount,
dep_code as [Origin], 
arr_code as [Dest],  
process_dt as [Date]
FROM import_mawb with(nolock)  WHERE agent_debit_amt > 0









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
         Begin Table = "A_1"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 275
            End
            DisplayFlags = 280
            TopColumn = 0
         End
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
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_OperationalCost'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_OperationalCost'
GO

