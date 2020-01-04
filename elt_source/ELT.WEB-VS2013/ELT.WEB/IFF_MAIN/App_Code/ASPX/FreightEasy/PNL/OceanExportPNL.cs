using FreightEasy.DataManager;
using System;

namespace FreightEasy.PNL
{
    [Serializable]
    public class OceanExportPNL : FreightEasyData
    {
        public OceanExportPNL()
        {
        }

        public OceanExportPNL GetAllRecords(string elt_account_number, string mawb_num, string start_date, string end_date)
        {

            string SQL_1 = @"SELECT  
                a.elt_account_number,a.booking_num,a.shipper_acct_num,a.shipper_name,
                a.loading_port,a.unloading_port,a.gross_weight,

                CASE WHEN COUNT(b.hbol_num)>0 THEN ISNULL(SUM(b.total_weight_charge),0)+ISNULL(SUM(c.charge_amt),0)
                ELSE ISNULL(a.total_weight_charge,0)+(SELECT ISNULL(SUM(charge_amt),0) FROM mbol_other_charge WHERE elt_account_number=a.elt_account_number AND booking_num=a.booking_num) 
                END AS Revenue,

                CASE WHEN COUNT(b.hbol_num)>0 THEN ISNULL(SUM(b.total_other_cost),0) 
                ELSE ISNULL(a.total_other_cost,0) END AS Expense,

                CASE WHEN COUNT(b.hbol_num)>0 THEN ISNULL(SUM(b.total_weight_charge),0)+ISNULL(SUM(c.charge_amt),0)-ISNULL(SUM(b.total_other_cost),0)
                ELSE ISNULL(a.total_weight_charge,0)+(SELECT ISNULL(SUM(charge_amt),0) FROM mbol_other_charge WHERE elt_account_number=a.elt_account_number AND booking_num=a.booking_num)-ISNULL(a.total_other_cost,0)
                END AS Profit
       
                From mbol_master a LEFT OUTER JOIN hbol_master b ON
                (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num)
                LEFT OUTER JOIN hbol_other_charge c ON
                (b.elt_account_number=c.elt_account_number AND b.hbol_num=c.hbol_num)
                WHERE a.elt_account_number=" + elt_account_number;

            if (mawb_num != "" && mawb_num != null)
            {
                SQL_1 = SQL_1 + " AND a.booking_num=N'" + mawb_num + "'";
            }

            if (start_date != "" && start_date != null)
            {
                SQL_1 = SQL_1 + " AND a.createddate>'" + start_date + "'";
                SQL_1 = SQL_1 + " AND a.createddate<'" + end_date + "'";
            }

            SQL_1 = SQL_1 + @" GROUP BY a.elt_account_number,a.booking_num,a.shipper_acct_num,a.shipper_name,a.loading_port,a.unloading_port,a.gross_weight,a.total_weight_charge,a.total_other_cost";

            string SQL_2 = @"SELECT 
                a.elt_account_number,a.booking_num,b.hbol_num,
                b.shipper_name,b.shipper_acct_num,
                b.agent_name,agent_no,b.gross_weight,
                ISNULL(b.total_weight_charge,0)+ISNULL(SUM(c.charge_amt),0) AS Revenue,ISNULL(b.total_other_cost,0) AS Expense,
                ISNULL(b.total_weight_charge,0)+ISNULL(SUM(c.charge_amt),0)-ISNULL(b.total_other_cost,0) AS Profit
                FROM mbol_master a  
                LEFT OUTER JOIN hbol_master  b ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num)
                LEFT OUTER JOIN hbol_other_charge c ON (b.elt_account_number=c.elt_account_number AND b.hbol_num=c.hbol_num)
                WHERE a.elt_account_number=" + elt_account_number;
            SQL_2 = SQL_2 + " GROUP BY a.elt_account_number,a.booking_num,b.hbol_num,b.shipper_name,b.shipper_acct_num,b.agent_name,agent_no,b.gross_weight,b.scale,b.total_weight_charge,b.createdDate,b.ModifiedBy,b.total_other_cost";

            string SQL_3 = @"
                SELECT elt_account_number,booking_num,hbol_num,'Revenue' AS item_type,
                'Freight Charge' AS item_desc,ISNULL(total_weight_charge,0) AS item_amount,NULL AS vendor FROM hbol_master
                WHERE ISNULL(booking_num,'')<>'' AND ISNULL(total_weight_charge,0)<>0 AND elt_account_number=" + elt_account_number + @" UNION 
                
                SELECT a.elt_account_number,b.booking_num,a.hbol_num,
                'Revenue' AS item_type,charge_desc AS item_desc,a.charge_amt AS item_amount,
                NULL AS vendor_no FROM hbol_other_charge a LEFT OUTER JOIN hbol_master b 
                ON (a.elt_account_number=b.elt_account_number AND a.hbol_num=b.hbol_num) 
                WHERE ISNULL(b.booking_num,'')<>'' AND ISNULL(a.charge_amt,0)<> 0 AND a.elt_account_number=" + elt_account_number + @" UNION 
                
                SELECT a.elt_account_number,b.booking_num,a.hbol_num,
                'Expense' AS item_type,a.cost_desc AS item_desc,a.cost_amt AS item_amount,
                a.vendor_no FROM hbol_other_cost a LEFT OUTER JOIN hbol_master b 
                ON (a.elt_account_number=b.elt_account_number AND a.hbol_num=b.hbol_num) 
                WHERE ISNULL(b.booking_num,'')<>'' AND a.elt_account_number=" + elt_account_number + @" UNION

                SELECT a.elt_account_number,a.booking_num,b.hbol_num,
                'Revenue' AS item_type,'Freight Charge' AS item_desc,ISNULL(a.total_weight_charge,0) AS item_amount,
                NULL AS vendor_no FROM mbol_master a LEFT OUTER JOIN hbol_master b
                ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num) 
                WHERE ISNULL(b.hbol_num,'')='' AND ISNULL(a.total_weight_charge,0)<> 0 AND a.elt_account_number=" + elt_account_number + @" UNION
                
                SELECT a.elt_account_number,a.booking_num,b.hbol_num,
                'Revenue' AS item_type,a.charge_desc AS item_desc,a.charge_amt AS item_amount,
                NULL AS vendor_no FROM mbol_other_charge a LEFT OUTER JOIN hbol_master b
                ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num) 
                WHERE ISNULL(b.hbol_num,'')='' AND ISNULL(a.charge_amt,0)<> 0 AND a.elt_account_number=" + elt_account_number + @" UNION
            
                SELECT a.elt_account_number,a.booking_num,b.hbol_num,
                'Expense' AS item_type,a.cost_desc AS item_desc,a.cost_amt AS item_amount,
                a.vendor_no FROM mbol_other_cost a LEFT OUTER JOIN hbol_master b 
                ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num) 
                WHERE ISNULL(b.booking_num,'')='' AND a.elt_account_number=" + elt_account_number;

            this.AddToDataSet("MasterBL", SQL_1);
            this.AddToDataSet("HouseBL", SQL_2);
            this.AddToDataSet("ItemList", SQL_3);

            this.AddRelation("ConsolidationRelation", "MasterBL", "elt_account_number,booking_num", "HouseBL", "elt_account_number,booking_num");
            this.AddRelation("OtherChargeRelation", "HouseBL", "elt_account_number,booking_num,hbol_num", "ItemList", "elt_account_number,booking_num,hbol_num");
            return this;
        }
    }
}
