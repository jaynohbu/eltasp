using FreightEasy.DataManager;

namespace FreightEasy.OceanExport
{
    public class AgentCredit : FreightEasyData
    {
        public AgentCredit()
        {
        }
        public AgentCredit GetAllRecords(string elt_account_number, string booking_num)
        {

            string SQL_1 = @"SELECT a.elt_account_number,a.booking_num,b.file_no,
                a.shipper_acct_num,a.shipper_name,
                a.consignee_acct_num,a.consignee_name,
                b.origin_port_id,b.dest_port_id,a.pieces,
                CASE WHEN ISNULL(a.scale,'K') LIKE '%k%' THEN ROUND(a.gross_weight*2.20462262,0) ELSE a.gross_weight END AS chargeable_weight
                FROM mbol_master a LEFT OUTER JOIN ocean_booking_number b 
                ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num)
                WHERE a.elt_account_number=" + elt_account_number
                + " AND a.booking_num=N'" + booking_num + "'";

            this.AddToDataSet("MasterGroup", SQL_1);

            string SQL_2 = @"SELECT a.elt_account_number,a.booking_num,b.agent_name,b.agent_no,
                SUM(CASE WHEN ISNULL(b.scale,'K') LIKE '%k%' THEN ROUND(b.gross_weight*2.20462262,0) ELSE b.gross_weight END) AS chargeable_weight
                FROM mbol_master a  
                LEFT OUTER JOIN hbol_master b ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num)
                WHERE a.elt_account_number=" + elt_account_number
                + " AND a.booking_num=N'" + booking_num + "' GROUP BY a.elt_account_number,a.booking_num,b.agent_name,b.agent_no";

            this.AddToDataSet("AgentGroup", SQL_2);

            string SQL_3 = @"SELECT a.elt_account_number,a.booking_num,b.hbol_num,b.agent_name,b.agent_no,
                CASE WHEN ISNULL(b.scale,'K') LIKE '%k%' THEN b.gross_weight*2.20462262 ELSE b.gross_weight END AS chargeable_weight
                FROM mbol_master a LEFT OUTER JOIN hbol_master b ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num)
                WHERE a.elt_account_number=" + elt_account_number + " AND a.booking_num=N'" + booking_num + "'";

            this.AddToDataSet("HouseGroup", SQL_3);

            string SQL_4 = @"SELECT a.elt_account_number,b.booking_num,a.hbol_num,
                NULL AS item_code,NULL AS tran_no,'FREIGHT CHARGE' AS Charge,a.total_weight_charge AS [Charge Amt],
                c.item_desc AS Credit,a.cost_amt AS [Credit Amt]
                FROM hawb_weight_charge a 
                LEFT OUTER JOIN item_cost c ON (a.elt_account_number=c.elt_account_number AND a.cost_code=c.item_no) 
                WHERE a.elt_account_number=" + elt_account_number + " AND a.booking_num=N'" + booking_num + "'" + @" UNION 
                
                SELECT a.elt_account_number,b.mawb_num,a.hawb_num,
                a.charge_code AS item_code,tran_no,charge_desc AS Charge,a.amt_hawb AS [Charge Amt],
                c.item_desc AS Credit,a.cost_amt AS [Credit Amt]
                FROM hawb_other_charge a LEFT OUTER JOIN hawb_master b 
                ON (a.elt_account_number=b.elt_account_number AND a.hawb_num=b.hawb_num)
                LEFT OUTER JOIN item_cost c ON (a.elt_account_number=c.elt_account_number AND a.cost_code=c.item_no) 
                WHERE b.mawb_num IS NOT NULL AND a.elt_account_number=" + elt_account_number + " AND b.mawb_num=N'" + booking_num + "'" + @" UNION 
                
                SELECT a.elt_account_number,a.mawb_num,NULL AS hawb_num,
                -1 AS item_code,NULL AS tran_no,'Freight Charge' AS Charge,a.total_charge AS [Charge Amt],
                c.item_desc AS Credit,a.cost_amt AS [Credit Amt]
                FROM mawb_weight_charge a LEFT OUTER JOIN mawb_master b
                ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num)
                LEFT OUTER JOIN item_cost c ON (a.elt_account_number=c.elt_account_number AND a.cost_code=c.item_no) 
                WHERE a.elt_account_number=" + elt_account_number + " AND b.mawb_num=N'" + booking_num + "'" + @" UNION
                
                SELECT a.elt_account_number,a.mawb_num,NULL AS hawb_num,
                a.charge_code AS item_code,tran_no,a.charge_desc AS Charge,a.amt_MAWB AS [Charge Amt],
                c.item_desc AS Credit,a.cost_amt AS [Credit Amt]
                FROM mawb_other_charge a LEFT OUTER JOIN mawb_master b
                ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num)
                LEFT OUTER JOIN item_cost c ON (a.elt_account_number=c.elt_account_number AND a.cost_code=c.item_no) 
                WHERE a.elt_account_number=" + elt_account_number + " AND b.mawb_num=N'" + booking_num + "'";

            this.AddToDataSet("ItemGroup", SQL_4);

            this.AddRelation("Relation_1", "MasterGroup", "elt_account_number,mawb_num", "AgentGroup", "elt_account_number,mawb_num");
            this.AddRelation("Relation_2", "AgentGroup", "elt_account_number,mawb_num,agent_no", "HouseGroup", "elt_account_number,mawb_num,agent_no");
            this.AddRelation("Relation_3", "HouseGroup", "elt_account_number,hawb_num,mawb_num", "ItemGroup", "elt_account_number,hawb_num,mawb_num");

            return this;

        }
    }
}

