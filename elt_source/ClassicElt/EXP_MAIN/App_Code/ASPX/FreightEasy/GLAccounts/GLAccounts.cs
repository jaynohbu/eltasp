using FreightEasy.DataManager;

namespace FreightEasy.GLAccounts
{
    public class GLAccounts : FreightEasyData
    {
        public GLAccounts()
        {
        }

        public GLAccounts GetAllChartOfAccounts(string elt_account_number)
        {
            string txtSQL = @"select gl_account_number,gl_account_desc,gl_master_type,gl_account_type,
                gl_account_balance,gl_account_status,gl_account_cdate,gl_last_modified,control_no,
                gl_default from gl where elt_account_number=" + elt_account_number 
                + " order by gl_account_number";
            this.AddToDataSet("COA", txtSQL);
            return this;
        }
    }
}
