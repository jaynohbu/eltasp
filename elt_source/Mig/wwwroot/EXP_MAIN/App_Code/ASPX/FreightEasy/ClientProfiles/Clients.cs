using FreightEasy.DataManager;

namespace FreightEasy.ClientProfiles
{

    public class Clients : FreightEasyData
    {
        public Clients()
        {
        }

        public Clients GetClientsByType(string elt_account_number, string bizType)
        {
            string clientSQL = "";

            if (bizType == "Airlines")
            {
                clientSQL = @"(select 'All' as airline_display, '-1' as carrier_code,'All' as dba_name)
                    UNION (SELECT distinct carrier_code+' - '+dba_name as airline_display,carrier_code,dba_name 
                    FROM organization WHERE elt_account_number=" + elt_account_number 
                    + @" AND is_carrier='Y' AND ISNULL(carrier_code,'') <> '' 
                    AND account_status='A') ORDER BY carrier_code";
                this.AddToDataSet(bizType, clientSQL);
            }

            if (bizType == "Customers")
            {
                clientSQL = @"SELECT dba_name, org_account_number
                    FROM organization WHERE elt_account_number=" + elt_account_number
                    + " AND (is_shipper='Y' OR is_consignee='Y') ORDER BY dba_name";
                this.AddToDataSet(bizType, clientSQL);
            }

            if (bizType == "Shippers")
            {
                clientSQL = @"SELECT dba_name, org_account_number
                    FROM organization WHERE elt_account_number=" + elt_account_number
                    + " AND is_shipper='Y' ORDER BY dba_name";
                this.AddToDataSet(bizType, clientSQL);
            }

            if (bizType == "Consignees")
            {
                clientSQL = @"SELECT dba_name, org_account_number
                    FROM organization WHERE elt_account_number=" + elt_account_number
                    + " AND (is_shipper='Y' OR is_consignee='Y') ORDER BY dba_name";
                this.AddToDataSet(bizType, clientSQL);
            }

            return this;
        }
    }
}
