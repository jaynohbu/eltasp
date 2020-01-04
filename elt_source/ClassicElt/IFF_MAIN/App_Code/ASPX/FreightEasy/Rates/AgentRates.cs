using FreightEasy.DataManager;

namespace FreightEasy.Rates
{
    public class AgentRates : FreightEasyData
    {
        public AgentRates()
        {
        }

        public AgentRates GetAllRecords(string elt_account_number, string rate_type)
        {
            string RoutesSQL = @"select distinct a.elt_account_number,a.rate_type,a.agent_no,
            b.dba_name,a.origin_port,a.dest_port,a.kg_lb from all_rate_table a left outer join 
            (select distinct dba_name,elt_account_number,org_account_number from organization) b 
            on (a.elt_account_number=b.elt_account_number 
            and a.agent_no=b.org_account_number) where a.elt_account_number="
                + elt_account_number + " and a.rate_type='" + rate_type + "'";
            string AirlineSQL = @"select distinct a.elt_account_number,a.rate_type,a.agent_no,a.origin_port,
            a.dest_port,a.kg_lb,a.airline,a.share,a.fl_rate,a.sec_rate,a.include_fl_rate,a.include_sec_rate 
            from all_rate_table a 
            left outer join (select distinct dba_name,carrier_code,elt_account_number from organization) b 
            on a.elt_account_number=b.elt_account_number 
            and a.airline=b.carrier_code where a.elt_account_number="
                + elt_account_number + " and a.rate_type='" + rate_type + "'";
            string WeightSQL = @"select a.elt_account_number,a.rate_type,a.agent_no,a.origin_port,
            a.dest_port,a.kg_lb,a.airline,a.share,a.fl_rate,a.sec_rate,a.include_fl_rate,a.include_sec_rate,
            weight_break=case a.item_no when 0 then 'Min($)' when 1 then '+Min'  
            else cast(a.weight_break as NVARCHAR) end,a.item_no,a.rate
            from all_rate_table a left outer join 
            (select distinct dba_name,carrier_code,elt_account_number from organization) b 
            on a.elt_account_number=b.elt_account_number and a.airline=b.carrier_code 
            where a.elt_account_number=" + elt_account_number +
            " and a.rate_type='" + rate_type + "' order by origin_port,dest_port,kg_lb,airline,item_no";

            this.AddToDataSet("Routes", RoutesSQL);
            this.AddToDataSet("Airline", AirlineSQL);
            this.AddToDataSet("Weight Breaks", WeightSQL);

            this.AddRelation("Rate31", "Routes", "origin_port,dest_port,kg_lb,agent_no", "airline",
                "origin_port,dest_port,kg_lb,agent_no");
            this.AddRelation("Rate32", "Airline", "origin_port,dest_port,kg_lb,agent_no,airline",
                "weight breaks", "origin_port,dest_port,kg_lb,agent_no,airline");

            return this;
        }

        // update keys: elt_account_number, rate_type, origin_port, dest_port, kg_lb, airline, item_no
        public void UpdateRecord(RateEntity re)
        {
            // To do: Update databse
            string updateCommand = "";

            if (re.item_no == 0) re.weight_break = "0";
            if (re.item_no == 1) re.weight_break = "1";

            if (re.item_no >= 0)
            {
                updateCommand = @"UPDATE all_rate_table SET "
                    + " weight_break=" + re.weight_break + ","
                    + " rate=" + re.rate
                    + " WHERE elt_account_number=" + re.elt_account_number
                    + " AND rate_type=" + re.rate_type
                    + " AND agent_no=" + re.agent_no
                    + " AND origin_port='" + re.origin_port + "'"
                    + " AND dest_port='" + re.dest_port + "'"
                    + " AND kg_lb='" + re.kg_lb + "'"
                    + " AND airline='" + re.airline + "'"
                    + " AND item_no=" + re.item_no;
            }
            else
            {
                updateCommand = @"UPDATE all_rate_table SET "
                    + " share=" + re.share + ","
                    + " fl_rate=" + re.fl_rate + ","
                    + " sec_rate=" + re.sec_rate + ","
                    + " include_fl_rate='" + re.include_fl_rate + "',"
                    + " include_sec_rate='" + re.include_sec_rate + "'"
                    + " WHERE elt_account_number=" + re.elt_account_number
                    + " AND rate_type=" + re.rate_type
                    + " AND agent_no=" + re.agent_no
                    + " AND origin_port='" + re.origin_port + "'"
                    + " AND dest_port='" + re.dest_port + "'"
                    + " AND kg_lb='" + re.kg_lb + "'"
                    + " AND airline='" + re.airline + "'";
            }

            this.DataTransaction(updateCommand);
        }

        public void DeleteRecord(RateEntity re)
        {
            // To do: delete from databse
            string deleteCommand = @"DELETE FROM all_rate_table "
                + " WHERE elt_account_number=" + re.elt_account_number
                + " AND rate_type=" + re.rate_type
                + " AND origin_port='" + re.origin_port + "'"
                + " AND dest_port='" + re.dest_port + "'"
                + " AND kg_lb='" + re.kg_lb + "'"
                + " AND agent_no=" + re.agent_no;

            if (re.airline != null)
            {
                deleteCommand = deleteCommand + " AND airline='" + re.airline + "'";
            }
            if (re.item_no >= 0)
            {
                deleteCommand = deleteCommand + " AND item_no=" + re.item_no;
            }
            this.DataTransaction(deleteCommand);
        }

        public void InsertRecord(RateEntity re)
        {
            // To do: insert into databse

            if (re.item_no == 0) re.weight_break = "0";
            if (re.item_no == 1) re.weight_break = "1";

            if (re.elt_account_number > 0 && re.item_no >= 0 && re.rate_type > 0  && re.airline != null
                && re.origin_port != null && re.dest_port != null && re.kg_lb != null &&
                re.item_no != null && re.weight_break != null && re.agent_no > 0)
            {

                string insertCommand = @"IF NOT EXISTS 
                    (SELECT * FROM all_rate_table WHERE elt_account_number="
                    + re.elt_account_number + " AND rate_type=" + re.rate_type
                    + " AND agent_no=" + re.agent_no
                    + " AND origin_port='" + re.origin_port
                    + "' AND dest_port='" + re.dest_port
                    + "' AND kg_lb='" + re.kg_lb
                    + "' AND airline=" + re.airline
                    + " AND item_no=" + re.item_no
                    + ") INSERT INTO all_rate_table VALUES("
                    + re.elt_account_number + ","
                    + re.item_no + ","
                    + re.rate_type + ","
                    + re.agent_no + ",0,'"
                    + re.airline + "','"
                    + re.origin_port + "','"
                    + re.dest_port + "',"
                    + re.weight_break + ","
                    + re.rate + ",'"
                    + re.kg_lb + "',"
                    + re.share + ",null,"
                    + re.fl_rate + ","
                    + re.sec_rate + ",'"
                    + re.include_fl_rate + "','"
                    + re.include_sec_rate + "')";
                this.DataTransaction(insertCommand);
            }
        }
    }
}
