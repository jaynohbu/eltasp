using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ELT.CDT;
using ELT.DA;
namespace ELT.BL
{
    public class ReportingBL
    {
        ReportingDA ReportingDA = new ReportingDA();
        public List<AirTransactionItem> GetAirExportTransItems(string ELT_account_number, ReportSearchItem search_items )
        {
            //
            return ReportingDA.GetAirExportTransItems(ELT_account_number,search_items);
        }

        public List<AirTransactionItem> GetAirImportTransItems(string ELT_account_number, ReportSearchItem search_items)
        {
            return ReportingDA.GetAirImportTransItems(ELT_account_number,search_items);
        }

        public List<OceanTransactionItem> GetOceanExportTransItems(string ELT_account_number, ReportSearchItem search_items)
        {
            return ReportingDA.GetOceanExportTransItems(ELT_account_number, search_items);
        }

        public List<OceanTransactionItem> GetOceanImportTransItems(string ELT_account_number, ReportSearchItem search_items)
        {
            return ReportingDA.GetOceanImportTransItems(ELT_account_number, search_items);
        }
       
        public List<Tuple<string,string>> GetBranches(string ELT_account_number)
        {
            var list = ReportingDA.GetBranches(ELT_account_number);
            
            List<Tuple<string,string>> result 
                = new  List<Tuple<string,string>>();
            foreach(var branch in list){
                var b 
                    = new Tuple<string, string>(
                        branch.elt_account_number.ToString(),
                        branch.dba_name);
                
                result.Add(b);

            }
            return result;
        }

        public List<BankRegisterItem> GetBankRegisterItems(string ELT_account_number, AccountingSearchItem search_items)
        {
            return ReportingDA.GetBankRegisterItem(ELT_account_number, search_items);
        }

 
        public List<TrialBalanceItem> GetTrialBalanceItem(string ELT_account_number, AccountingSearchItem search_items)
        {
            return ReportingDA.GetTrialBalanceItem(ELT_account_number, search_items);

        }
        public List<IncomeStatementItem> GetIncomeStatementItem(string ELT_account_number, AccountingSearchItem search_items)
        {
            return ReportingDA.GetIncomeStatementItem(ELT_account_number, search_items);

        }


        public List<PNLTransactionItem> GetPNLTransactionItem(int elt_account_number, ReportSearchItem search_items)
        {
            return ReportingDA.GetPNLTransactionItem(elt_account_number, search_items);

        }

        public void RefreshPNL(int elt_account_number )
        {
             ReportingDA.RefreshPNL(elt_account_number);
        }

        public List<APDisputeTransactionItem> GetAPDisputeTransactionItem()
        {
            return ReportingDA.GetAPDisputeTransactionItem();

        }

        

        public List<BalanceSheetItem> GetBalanceSheetItem(string ELT_account_number, AccountingSearchItem search_items)
        {
            return ReportingDA.GetBalanceSheetItem(ELT_account_number, search_items);

        }

        public List<GLTransactionType> GetAllGLTranType(string elt_account_number)
        {
            return ReportingDA.GetAllGLTranType(elt_account_number);
        }

        public List<GLAccount> GetAllGLAccount(string elt_account_number)
        {
            return ReportingDA.GetAllGLAccount(elt_account_number);
        }
    }
}
