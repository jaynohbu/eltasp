



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
