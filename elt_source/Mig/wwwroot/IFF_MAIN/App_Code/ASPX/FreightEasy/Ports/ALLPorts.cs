using FreightEasy.DataManager;

namespace FreightEasy.Ports
{
    public class ALLPorts : FreightEasyData
    {
        public ALLPorts()
        {
        }

        public ALLPorts GetAllPorts(string elt_account_number, string tableName)
        {
            string AllPortsSQL = @"SELECT port_code,port_desc,port_city,port_code+' - '+port_desc as port_display 
            FROM port WHERE elt_account_number=" + elt_account_number + " ORDER BY port_desc";

            this.AddToDataSet(tableName, AllPortsSQL);
            return this;
        }
    }
}
