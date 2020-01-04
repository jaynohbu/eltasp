using FreightEasy.DataManager;

namespace FreightEasy.Accounting
{
    public class Invoices : FreightEasyData
    {
        public Invoices()
        {
        }

        public Invoices GetAllRecords(string elt_account_number)
        {
            string txtSQL = @"select invoice_no,customer_name,mawb_num,hawb_num,entry_date,invoice_type,
                import_export,air_ocean,ref_no,ref_no_our,total_pieces,total_gross_weight,total_charge_weight,
                agent_profit,sale_tax,total_cost,subtotal,lock_ap,balance,pay_status,arrival_dept
                from invoice where elt_account_number="
                + elt_account_number;
            this.AddToDataSet("Invoices", txtSQL);
            return this;
        }
    }
}
