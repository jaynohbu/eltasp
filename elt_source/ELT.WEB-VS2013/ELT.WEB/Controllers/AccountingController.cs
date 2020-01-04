using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using DevExpress.Web.Mvc;
using ELT.CDT;
using ELT.WEB.Filters;
namespace ELT.WEB.Controllers
{
    [Authorize]
    public partial class AccountingController : OperationBaseController
    {
        public AccountingController()
        {
            if (System.Web.HttpContext.Current.Session != null)
            {
                SetSubMenu(MainMenuContext.Accounting_General);
                SetProductMenu(ProductMenuContext.Accounting);
            }
        }

        public ActionResult Index()
        {
            SetSubMenu(MainMenuContext.Accounting_General);
            return View();
        }
        
        public ActionResult ARCreditNote(string param)
        {
            //http://e-logitech.net/IFF_MAIN/ASP/acct_tasks/chart_acct.asp
            SetSubMenu(MainMenuContext.Accounting_General);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }

    [CheckSession]
        public ActionResult ChartOfAccount(string param)
        {
            CheckAccess();
            //http://e-logitech.net/IFF_MAIN/ASP/acct_tasks/chart_acct.asp
            SetSubMenu(MainMenuContext.Accounting_General);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        [CheckSession]
        public ActionResult ChargeItems(string param)
    {
        CheckAccess();
            //http://e-logitech.net/IFF_MAIN/ASP/acct_tasks/edit_ch_items.asp
            SetSubMenu(MainMenuContext.Accounting_General);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        [CheckSession]
        public ActionResult CostItems(string param)
        {
            CheckAccess();
            //http://e-logitech.net/IFF_MAIN/ASP/acct_tasks/edit_co_items.asp
            SetSubMenu(MainMenuContext.Accounting_General);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        [CheckSession]
        public ActionResult GeneralJournalEntry(string param)
        {
            CheckAccess();
            //http://e-logitech.net/IFF_MAIN/ASP/acct_tasks/gj_entry.asp
            SetSubMenu(MainMenuContext.Accounting_General);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        [CheckSession]
        public ActionResult AccountSummary(string param)
        {
            //http://e-logitech.net/IFF_MAIN/ASP/acct_tasks/fiscalClose.asp
            SetSubMenu(MainMenuContext.Accounting_General);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }

         [CheckSession]
       
        public ActionResult InvoiceQueue(string param)
        {
            CheckAccess();
            //http://e-logitech.net/IFF_MAIN/ASP/acct_tasks/create_invoi.asp
            SetSubMenu(MainMenuContext.Accounting_AccountReceivable);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        [CheckSession]
        public ActionResult AddInvoice(string param)
         {
             CheckAccess();
            //http://e-logitech.net/IFF_MAIN/ASP/acct_tasks/edit_invoice.asp
            SetSubMenu(MainMenuContext.Accounting_AccountReceivable);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        [CheckSession]
        public ActionResult CreditNote(string param)
        {
            CheckAccess();
            //http://e-logitech.net/IFF_MAIN/ASP/acct_tasks/edit_credit_note.asp
            SetSubMenu(MainMenuContext.Accounting_AccountReceivable);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        [CheckSession]
        public ActionResult SearchInvoice(string param)
        {
            CheckAccess();
            //http://e-logitech.net/IFF_MAIN/ASPX/Reports/Accounting/SearchInvoiceSelection.aspx
            SetSubMenu(MainMenuContext.Accounting_AccountReceivable);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
         [CheckSession]
        public ActionResult ReceivePayment(string param)
        {
            CheckAccess();
            //http://e-logitech.net/IFF_MAIN/ASP/acct_tasks/receiv_pay.asp
            SetSubMenu(MainMenuContext.Accounting_AccountReceivable);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
          [CheckSession]
        public ActionResult PayableQueue(string param)
         {
             CheckAccess();
            //http://e-logitech.net/IFF_MAIN/ASP/acct_tasks/enter_bill.asp
            SetSubMenu(MainMenuContext.Accounting_AccountPayable);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        [CheckSession]
        public ActionResult BillPay(string param)
          {
              CheckAccess();
            //http://e-logitech.net/IFF_MAIN/ASP/acct_tasks/pay_bills.asp
            SetSubMenu(MainMenuContext.Accounting_AccountPayable);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        [CheckSession]
        public ActionResult WriteCheck(string param)
        {
            CheckAccess();
            //http://e-logitech.net/IFF_MAIN/ASP/acct_tasks/write_chk.asp
            SetSubMenu(MainMenuContext.Accounting_AccountPayable);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
         [CheckSession]
        public ActionResult PrintCheck(string param)
        {
            CheckAccess();
            //http://e-logitech.net/IFF_MAIN/ASP/acct_tasks/print_chk.asp
            SetSubMenu(MainMenuContext.Accounting_AccountPayable);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
     
            
        public ActionResult BankWriteChecks(string param)
        {
            //http://e-logitech.net/IFF_MAIN/ASP/Acct_tasks/write_chk.asp
            SetSubMenu(MainMenuContext.Accounting_Bank);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        public ActionResult BankPrintChecks(string param)
        {
            //http://e-logitech.net/IFF_MAIN/ASP/acct_tasks/print_chk.asp
            SetSubMenu(MainMenuContext.Accounting_Bank);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        [CheckSession]
        public ActionResult BankManageChecks(string param)
        {
            CheckAccess();
            //http://e-logitech.net/IFF_MAIN/ASP/acct_tasks/manage_chk.asp
            SetSubMenu(MainMenuContext.Accounting_Bank);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        [CheckSession]
        public ActionResult BankDeposit(string param)
        {
            CheckAccess();
            //http://e-logitech.net/IFF_MAIN/ASPX/Accounting/BankDeposit.aspx
            SetSubMenu(MainMenuContext.Accounting_Bank);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        } 
       
        public ActionResult ExportTo(string Operation, string typeName)
        {
            GridViewSettings settings = null;
            IEnumerable TransactionalData = null;

            if (Operation == "BankRegister")
            {
                TransactionalData = GetBankRegisterTransactionalData();
                settings = CreateBankRegisterGridViewSettings();
            }
            if (Operation == "ARAging")
            {
                var alldata = GetARAgingTransactionalData();
                List<ARAgingTransactionalItem> ARTranItems = new List<ARAgingTransactionalItem>();
                foreach (var data in alldata)
                {
                    ARTranItems.AddRange(data.TransactionItems);
                }
                TransactionalData = ARTranItems.AsEnumerable();
                settings =CreateARAgingGridViewSettings();
            }

            if (Operation == "APAging")
            {
                var alldata = GetAPAgingTransactionalData();
                List<APAgingTransactionalItem> ARTranItems = new List<APAgingTransactionalItem>();
                foreach (var data in alldata)
                {
                    ARTranItems.AddRange(data.TransactionItems);
                }
                TransactionalData = ARTranItems.AsEnumerable();
                settings = CreateAPAgingGridViewSettings();
            }
             if (Operation == "ARDetail")
            {
                var alldata = GetARDetailTransactionalData();
                List<ARDetailTransactionItem> ARTranItems = new List<ARDetailTransactionItem>();
                foreach (var data in alldata)
                {
                    ARTranItems.AddRange(data.TransactionItems);
                }
                TransactionalData = ARTranItems.AsEnumerable();
                settings = CreateARDetailGridViewSettings();
            }
             if (Operation == "APDetail")
             {
                 var alldata = GetAPDetailTransactionalData();
                 List<APDetailTransactionItem> ARTranItems = new List<APDetailTransactionItem>();
                 foreach (var data in alldata)
                 {
                     ARTranItems.AddRange(data.TransactionItems);
                 }
                 TransactionalData = ARTranItems.AsEnumerable();
                 settings = CreateAPDetailGridViewSettings();
             }
             if (Operation == "APDispute")
             {
                 var alldata = GetAPDisputeTransactionalData();
                 List<APDisputeTransactionItem> APDisputeTransactionItems = new List<APDisputeTransactionItem>();
                 foreach (var data in alldata)
                 {
                     APDisputeTransactionItems.AddRange(data.TransactionItems);
                 }
                 TransactionalData = APDisputeTransactionItems.AsEnumerable();
                 settings = CreateAPDisputeGridViewSettings();
             }
       
             if (Operation == "BalanceSheet")
             {
                 var alldata = GetBalanceSheetTransactionalData();
                 List<BalanceSheetItem> BalanceSheetItems = new List<BalanceSheetItem>();
                 BalanceSheetItems.AddRange(alldata);
                 TransactionalData = BalanceSheetItems.AsEnumerable();
                 settings = CreateBalanceSheetGridViewSettings();
             }
             if (Operation == "TrialBalance")
             {
                 var alldata = GetTrialBalanceTransactionalData();
                 List<TrialBalanceItem> TrialBalanceItems = new List<TrialBalanceItem>();
                 TrialBalanceItems.AddRange(alldata);
                 TransactionalData = TrialBalanceItems.AsEnumerable();
                 settings = CreateTrialBalanceGridViewSettings();
             }
             if (Operation == "IncomeStatement")
             {
                 var alldata = GetIncomeStatementTransactionalData();
                 List<IncomeStatementItem> IncomeStatementItems = new List<IncomeStatementItem>();
                 IncomeStatementItems.AddRange(alldata);
                 TransactionalData = IncomeStatementItems.AsEnumerable();
                 settings = IncomeStatementGridViewSettings();
             }
             if (Operation == "Sales")
             {
                 var alldata = GetSalesReportMasterModel().SalesItems;
                 List<SalesTransactionalItem> SalesItems = new List<SalesTransactionalItem>();
                 foreach (var data in alldata)
                 {
                     SalesItems.AddRange(data.TransactionItems);
                 }
                 TransactionalData = SalesItems.AsEnumerable();
                 settings = SalesGridViewSettings();
             }
             if (Operation == "Expenses")
             {
                 var alldata =  GetExpenseReportMasterModel().ExpenseItems;
                 List<ExpenseTransactionalItem> ExpenseItems = new List<ExpenseTransactionalItem>();
                 foreach (var data in alldata)
                 {
                     ExpenseItems.AddRange(data.TransactionItems);
                 }
                 TransactionalData = ExpenseItems.AsEnumerable();
                 settings = CreateExpensesGridViewSettings();
             }

             if (Operation == "GeneralLedger")
             {
                 var alldata = GetGeneralLedgerReportMasterModel().GeneralLedgerItems;
                 List<GeneralLedgerTransactionalItem> GetGeneralLedgerItems = new List<GeneralLedgerTransactionalItem>();
                 foreach (var data in alldata)
                 {
                     GetGeneralLedgerItems.AddRange(data.TransactionItems);
                 }
                 TransactionalData = GetGeneralLedgerItems.AsEnumerable();
                 settings = CreateGeneralLedgerGridViewSettings();
             }
            
            
            return GridViewExportHelper.ExportTypes[typeName].Method(settings, TransactionalData);
        }
     
    }
}
