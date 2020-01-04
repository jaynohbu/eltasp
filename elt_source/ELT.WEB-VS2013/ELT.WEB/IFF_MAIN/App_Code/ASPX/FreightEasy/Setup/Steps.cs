using FreightEasy.DataManager;

namespace FreightEasy.GLAccounts
{
    public class Steps : FreightEasyData
    {
        public Steps()
        {
        }

        public Steps GetAllSetupSteps(string elt_account_number)
        {
            string txtSQL = @"SELECT * FROM setup_master";
            this.AddToDataSet("Steps", txtSQL);
            return this;
        }
    }
}

