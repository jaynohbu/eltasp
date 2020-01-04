using FreightEasy.DataManager;

namespace FreightEasy.PNL
{
    public class AirExportPNL : FreightEasyData
    {
        public AirExportPNL()
        {
        }

        public AirExportPNL GetAllRecords(string elt_account_number, string mawb_num, string start_date, string end_date)
        {

            string SQL_1 = @"SELECT a.elt_account_number,a.mawb_num,a.shipper_name,a.shipper_account_number,
                a.dep_airport_code,a.to_1,a.to_2,a.total_gross_weight,a.total_chargeable_weight,a.weight_scale,
                CASE WHEN COUNT(hawb_num)>0 THEN SUM(b.Prepaid_Total+b.Collect_Total) 
                    ELSE a.Prepaid_Total+a.Collect_Total END AS Revenue,
                CASE WHEN COUNT(hawb_num)>0 THEN ISNULL(SUM(b.total_other_cost),0) 
                    ELSE ISNULL(a.total_other_cost,0) END AS Expense,
                CASE WHEN COUNT(hawb_num)>0 THEN SUM(b.Prepaid_Total+b.Collect_Total)-ISNULL(SUM(b.total_other_cost),0) 
                    ELSE a.Prepaid_Total+a.Collect_Total-ISNULL(a.total_other_cost,0) END AS Profit,
                a.createddate,a.createdby
                FROM mawb_master a LEFT OUTER JOIN hawb_master b
                ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num)
                WHERE a.elt_account_number=" + elt_account_number;

            if (mawb_num != "" && mawb_num != null)
            {
                SQL_1 = SQL_1 + " AND a.mawb_num=N'" + mawb_num + "'";
            }

            if (start_date != "" && start_date != null)
            {
                SQL_1 = SQL_1 + " AND a.createddate>'" + start_date + "'";
                SQL_1 = SQL_1 + " AND a.createddate<'" + end_date + "'";
            }

            SQL_1 = SQL_1 + @" GROUP BY a.elt_account_number,a.mawb_num,a.shipper_name,a.shipper_account_number,
                a.dep_airport_code,a.to_1,a.to_2,a.total_gross_weight,a.total_chargeable_weight,a.weight_scale,a.createddate,a.createdby,a.Prepaid_Total,a.Collect_Total,a.total_other_cost";

            string SQL_2 = @"SELECT a.elt_account_number,a.mawb_num,b.hawb_num,
                b.shipper_name,b.shipper_account_number,
                b.agent_name,agent_no,b.total_chargeable_weight,b.weight_scale,
                b.Prepaid_Total+b.Collect_Total AS Revenue,ISNULL(b.total_other_cost,0) AS Expense,
                b.Prepaid_Total+b.Collect_Total-ISNULL(b.total_other_cost,0) AS Profit,
                b.createddate,b.modifiedby
                FROM mawb_master a  
                LEFT OUTER JOIN hawb_master  b ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num)
                WHERE a.elt_account_number=" + elt_account_number;

            string SQL_3 = @"SELECT a.elt_account_number,b.mawb_num,a.hawb_num,
                'Revenue' AS item_type,'Freight Charge' AS item_desc,a.total_charge AS item_amount,
                NULL AS vendor_no FROM hawb_weight_charge a LEFT OUTER JOIN hawb_master b 
                ON (a.elt_account_number=b.elt_account_number AND a.hawb_num=b.hawb_num) 
                WHERE ISNULL(b.mawb_num,'')<>'' AND a.elt_account_number=" + elt_account_number + @" UNION

                SELECT a.elt_account_number,b.mawb_num,a.hawb_num,
                'Revenue' AS item_type,charge_desc AS item_desc,a.amt_hawb AS item_amount,
                NULL AS vendor_no FROM hawb_other_charge a LEFT OUTER JOIN hawb_master b 
                ON (a.elt_account_number=b.elt_account_number AND a.hawb_num=b.hawb_num) 
                WHERE ISNULL(b.mawb_num,'')<>'' AND a.elt_account_number=" + elt_account_number + @" UNION

                SELECT a.elt_account_number,b.mawb_num,a.hawb_num,
                'Expense' AS item_type,a.cost_desc AS item_desc,a.cost_amt AS item_amount,
                a.vendor_no FROM hawb_other_cost a LEFT OUTER JOIN hawb_master b 
                ON (a.elt_account_number=b.elt_account_number AND a.hawb_num=b.hawb_num) 
                WHERE ISNULL(b.mawb_num,'')<>'' AND a.elt_account_number=" + elt_account_number + @" UNION

                SELECT a.elt_account_number,a.mawb_num,b.hawb_num,
                'Revenue' AS item_type,'Freight Charge' AS item_desc,a.total_charge AS item_amount,
                NULL AS vendor_no FROM mawb_weight_charge a LEFT OUTER JOIN hawb_master b
                ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num) 
                WHERE ISNULL(b.hawb_num,'')='' AND a.elt_account_number=" + elt_account_number + @" UNION

                SELECT a.elt_account_number,a.mawb_num,b.hawb_num,
                'Revenue' AS item_type,a.charge_desc AS item_desc,a.amt_MAWB AS item_amount,
                NULL AS vendor_no FROM mawb_other_charge a LEFT OUTER JOIN hawb_master b
                ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num) 
                WHERE ISNULL(b.hawb_num,'')='' AND a.elt_account_number=" + elt_account_number + @" UNION

                SELECT a.elt_account_number,a.mawb_num,b.hawb_num,
                'Expense' AS item_type,a.cost_desc AS item_desc,a.cost_amt AS item_amount,
                a.vendor_no FROM mawb_other_cost a LEFT OUTER JOIN hawb_master b
                ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num) 
                WHERE ISNULL(b.hawb_num,'')='' AND a.elt_account_number=" + elt_account_number;
            
            this.AddToDataSet("MasterBL", SQL_1);
            this.AddToDataSet("HouseBL", SQL_2);
            this.AddToDataSet("ItemList", SQL_3);

            this.AddRelation("ConsolidationRelation", "MasterBL", "elt_account_number,mawb_num", "HouseBL", "elt_account_number,mawb_num");
            this.AddRelation("OtherChargeRelation", "HouseBL", "elt_account_number,mawb_num,hawb_num", "ItemList", "elt_account_number,mawb_num,hawb_num");
            return this;
        }
    }
}
