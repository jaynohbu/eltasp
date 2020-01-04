using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Reflection;
using ELT.COMMON;
using ELT.CDT;
using System.Web;

namespace ELT.DA
{
    public class GlDA : DABase
    {
        const string CONST__MASTER_ASSET_NAME = "ASSET";
        const string CONST__CURRENT_ASSET = "Current Asset";
        const string CONST__ACCOUNT_RECEIVABLE = "Accounts Receivable";
        const string CONST__FIXED_ASSET = "Fixed Asset";
        const string CONST__OTHER_ASSET = "Other Asset";
        const string CONST__BANK = "Cash in Bank";
        const string CONST__MASTER_LIABILITY_NAME = "LIABILITY";
        const string CONST__CURRENT_LIB = "Current Liability";
        const string CONST__ACCOUNT_PAYABLE = "Accounts Payable";
        const string CONST__LONG_TERM_LIB = "Long-Term Liability";
        const string CONST__MASTER_EQUITY_NAME = "EQUITY";
        const string CONST__EQUITY = "Equity";
        const string CONST__EQUITY_RETAINED_EARNINGS = "Equity-Retained Earnings";
        const string CONST__MASTER_REVENUE_NAME = "REVENUE";
        const string CONST__REVENUE = "Revenue";
        const string CONST__OTHER_REVENUE = "Other Revenue";
        const string CONST__MASTER_EXPENSE_NAME = "EXPENSE";
        const string CONST__EXPENSE = "Expense";
        const string CONST__COST_OF_SALES = "Cost of Sales";
        const string CONST__OTHER_EXPENSE = "Other Expense";
        protected DataSet ds_AS = new DataSet();
        protected DataSet ds_LE = new DataSet();
        string ParentTable = "HEADER";
        string ChildTable = "DETAIL";
        string sHeaderName = "HEADER";
        string sDetailName = "DETAIL";
        string keyColName = "Customer_Name";
        string elt_account_number=string.Empty ;      
      
        string ConnectStr;
        DataSet ds=null;
        string strCode;
        static public double vRevenue, vExpense, NetIncome, TotalLE, lSubTotal, aSubTotal, vTotal_Balance;
        static public string windowName;
        string strCommandText;
        string strCommandDetailText;
        int iCnt = 0;
        string nBranch;


        protected string vType = "";
        protected string xType = "";
        protected string vNum = "";
        protected string IDNum = "";
        protected string md;
  
        protected DataTable dt = new DataTable();
        protected DataTable cdt = new DataTable();


        public DataSet PerformGet(string strCode, string nBranch)
        {
            ds = new DataSet();
            this.strCode = strCode;
            this.nBranch = nBranch;

            strCommandText = Convert.ToString(HttpContext.Current.Session[sHeaderName]);
            strCommandDetailText = Convert.ToString(HttpContext.Current.Session[sDetailName]);
            
            switch (strCode)
            {
                case "sales":
                    PerformGetData(strCommandText, strCommandDetailText);
                    iCnt = performDetailDataRefine();
                    if (nBranch != "0")
                    {
                        DataColumn[] relComsP = new DataColumn[2];
                        DataColumn[] relComsC = new DataColumn[2];
                        relComsP[0] = ds.Tables[ParentTable].Columns[keyColName];
                        relComsP[1] = ds.Tables[ParentTable].Columns["Customer_Number"];
                        relComsC[0] = ds.Tables[ChildTable].Columns[keyColName];
                        relComsC[1] = ds.Tables[ChildTable].Columns["Customer_Number"];
                        if (ds.Relations.Count < 1) ds.Relations.Add(relComsP, relComsC);
                    }
                    else
                    {
                        DataColumn[] relComsP = new DataColumn[3];
                        DataColumn[] relComsC = new DataColumn[3];
                        relComsP[0] = ds.Tables[ParentTable].Columns["elt_account_number"];
                        relComsP[1] = ds.Tables[ParentTable].Columns[keyColName];
                        relComsP[2] = ds.Tables[ParentTable].Columns["Customer_Number"];
                        relComsC[0] = ds.Tables[ChildTable].Columns["elt_account_number"];
                        relComsC[1] = ds.Tables[ChildTable].Columns[keyColName];
                        relComsC[2] = ds.Tables[ChildTable].Columns["Customer_Number"];
                        if (ds.Relations.Count < 1) ds.Relations.Add(relComsP, relComsC);
                    }

                    break;
                case "ardet":
                    PerformGetDataARDetail(strCommandText, strCommandDetailText, nBranch);
                    break;
                case "apdet":
                    string strCommandTextUP = "";
                    if (HttpContext.Current.Session["APUnposted"].ToString() != "")
                    {
                        strCommandTextUP = HttpContext.Current.Session["APUnposted"].ToString();
                    }
                    PerformGetDataAPDetail(strCommandText, strCommandDetailText, nBranch, strCommandTextUP);
                    break;
                case "expns":
                    PerformGetData(strCommandText, strCommandDetailText);
                    add_total("Amount", ParentTable);
                    if (nBranch != "0")
                    {
                        DataColumn[] relComsP = new DataColumn[1];
                        DataColumn[] relComsC = new DataColumn[1];
                        relComsP[0] = ds.Tables[ParentTable].Columns[keyColName];
                        relComsC[0] = ds.Tables[ChildTable].Columns[keyColName];
                        if (ds.Relations.Count < 1) ds.Relations.Add(relComsP, relComsC);
                    }
                    else
                    {
                        DataColumn[] relComsP = new DataColumn[2];
                        DataColumn[] relComsC = new DataColumn[2];
                        relComsP[0] = ds.Tables[ParentTable].Columns["elt_account_number"];
                        relComsP[1] = ds.Tables[ParentTable].Columns[keyColName];
                        relComsC[0] = ds.Tables[ChildTable].Columns["elt_account_number"];
                        relComsC[1] = ds.Tables[ChildTable].Columns[keyColName];
                        if (ds.Relations.Count < 1) ds.Relations.Add(relComsP, relComsC);
                    }

                    performDetailDataRefineEX();
                    break;
                case "trial":
                    PerformGetData(strCommandText, strCommandDetailText);

                    break;
                case "bal":
                    PerformGetBalanceSheetData(strCommandText, strCommandDetailText);
                    keyColName = "Type";     
                    break;

                case "incom":
                    PerformGetDataINCOM(strCommandDetailText);
                    performDetailDataRefineINCOM();

                    if (nBranch != "0")
                    {
                        if (ds.Relations.Count < 1)
                        {
                            ds.Relations.Add(ds.Tables[ParentTable].Columns[keyColName], ds.Tables[ChildTable].Columns[keyColName]);
                        }
                    }
                    else
                    {
                        ds.Relations.Add(ds.Tables[ParentTable].Columns[keyColName], ds.Tables[ChildTable].Columns[keyColName]);
                    }
                    break;

                case "genl":
                    PerformGetDataGENL(strCommandText, strCommandDetailText, nBranch);
                    break;
                case "chkr":
                    PerformGetDataCHKR(strCommandText, strCommandDetailText, nBranch);                 
                    break;
                case "araging":
                    PerformARAgingRecords();
                    break;
                case "apaging":
                    PerformAPAgingRecords();
                    break;
                case "apdispute":
                    PerformAPDisputeRecords();
                    break;
                case "AEPNL":
                    PerformAEPNLRecords();
                    break;
                case "OEPNL":
                    PerformOEPNLRecords();
                    break;
            }
            HttpContext.Current.Session["Accounting_DataSet"] = "yes";
            return ds;          
        }
        private void PerformAPDisputeRecords()
        {
            if (HttpContext.Current.Session["APDisputeDS"] != null)
            {
              ds=  (DataSet)HttpContext.Current.Session["APDisputeDS"];
                
            }
        }
        private void PerformAEPNLRecords()
        {
            if (HttpContext.Current.Session["AEPNLDS"] != null)
            {
                ds = (DataSet)HttpContext.Current.Session["AEPNLDS"];

            }
        }
        private void PerformOEPNLRecords()
        {
            if (HttpContext.Current.Session["OEPNLDS"] != null)
            {
                ds = (DataSet)HttpContext.Current.Session["OEPNLDS"];

            }
        }
        private void PerformGetBalanceSheetData(string strCommandText, string strCommandDetailText)
        {
            PerformGetData(strCommandText, strCommandDetailText);
            performDetailDataRefineBalanceSheet();
            keyColName = "gl_account_type";
            if (nBranch != "0")
            {
                DataColumn[] relComsP = new DataColumn[2];
                DataColumn[] relComsC = new DataColumn[2];

                relComsP[0] = ds.Tables[ParentTable].Columns["Type"];
                relComsP[1] = ds.Tables[ParentTable].Columns[keyColName];
                relComsC[0] = ds.Tables[ChildTable].Columns["Type"];
                relComsC[1] = ds.Tables[ChildTable].Columns[keyColName];

                if (ds.Relations.Count < 1)
                {
                    ds.Relations.Add(ds.Tables["HEAD"].Columns["Type"], ds.Tables[ParentTable].Columns["Type"]);
                    ds.Relations.Add(relComsP, relComsC);
                }

                relComsP[0] = ds_AS.Tables[ParentTable].Columns["Type"];
                relComsP[1] = ds_AS.Tables[ParentTable].Columns[keyColName];
                relComsC[0] = ds_AS.Tables[ChildTable].Columns["Type"];
                relComsC[1] = ds_AS.Tables[ChildTable].Columns[keyColName];
                if (ds_AS.Relations.Count < 1)
                {
                    ds_AS.Relations.Add(ds_AS.Tables["HEAD"].Columns["Type"], ds_AS.Tables[ParentTable].Columns["Type"]);
                    ds_AS.Relations.Add(relComsP, relComsC);
                }

                relComsP[0] = ds_LE.Tables[ParentTable].Columns["Type"];
                relComsP[1] = ds_LE.Tables[ParentTable].Columns[keyColName];
                relComsC[0] = ds_LE.Tables[ChildTable].Columns["Type"];
                relComsC[1] = ds_LE.Tables[ChildTable].Columns[keyColName];
                if (ds_LE.Relations.Count < 1)
                {
                    ds_LE.Relations.Add(ds_LE.Tables["HEAD"].Columns["Type"], ds_LE.Tables[ParentTable].Columns["Type"]);
                    ds_LE.Relations.Add(relComsP, relComsC);
                }
            }
            else
            {
                DataColumn[] relComsP = new DataColumn[2];
                DataColumn[] relComsC = new DataColumn[2];

                relComsP[0] = ds.Tables[ParentTable].Columns["Type"];
                relComsP[1] = ds.Tables[ParentTable].Columns[keyColName];
                relComsC[0] = ds.Tables[ChildTable].Columns["Type"];
                relComsC[1] = ds.Tables[ChildTable].Columns[keyColName];

                if (ds.Relations.Count < 1)
                {
                    ds.Relations.Add(ds.Tables["HEAD"].Columns["Type"], ds.Tables[ParentTable].Columns["Type"]);
                    ds.Relations.Add(relComsP, relComsC);
                }

                relComsP[0] = ds_AS.Tables[ParentTable].Columns["Type"];
                relComsP[1] = ds_AS.Tables[ParentTable].Columns[keyColName];
                relComsC[0] = ds_AS.Tables[ChildTable].Columns["Type"];
                relComsC[1] = ds_AS.Tables[ChildTable].Columns[keyColName];
                if (ds_AS.Relations.Count < 1)
                {
                    ds_AS.Relations.Add(ds_AS.Tables["HEAD"].Columns["Type"], ds_AS.Tables[ParentTable].Columns["Type"]);
                    ds_AS.Relations.Add(relComsP, relComsC);
                }

                relComsP[0] = ds_LE.Tables[ParentTable].Columns["Type"];
                relComsP[1] = ds_LE.Tables[ParentTable].Columns[keyColName];
                relComsC[0] = ds_LE.Tables[ChildTable].Columns["Type"];
                relComsC[1] = ds_LE.Tables[ChildTable].Columns[keyColName];
                if (ds_LE.Relations.Count < 1)
                {
                    ds_LE.Relations.Add(ds_LE.Tables["HEAD"].Columns["Type"], ds_LE.Tables[ParentTable].Columns["Type"]);
                    ds_LE.Relations.Add(relComsP, relComsC);
                }
            }
        }    
        private void performDetailDataRefineBalanceSheet()
        {
            string tmpkey = "";
            double tmpAmount = 0;
            vRevenue = vExpense = NetIncome = TotalLE = lSubTotal = aSubTotal = 0;

            foreach (DataRow eRow in ds.Tables[ParentTable].Rows)
            {
                tmpkey = eRow["Type"].ToString().Trim();
                tmpAmount = double.Parse(eRow["Amount"].ToString()) + double.Parse(eRow["Begin_Balance"].ToString());
                switch (tmpkey)
                {
                    case CONST__MASTER_ASSET_NAME:
                        eRow["Amount"] = tmpAmount.ToString();
                        aSubTotal = aSubTotal + tmpAmount;
                        break;
                    case CONST__MASTER_LIABILITY_NAME:
                        tmpAmount = tmpAmount * -1;
                        eRow["Amount"] = tmpAmount.ToString();
                        lSubTotal = lSubTotal + tmpAmount;
                        break;
                    case CONST__MASTER_EQUITY_NAME:
                        tmpAmount = tmpAmount * -1;
                        eRow["Amount"] = tmpAmount.ToString();
                        vRevenue = vRevenue + double.Parse(tmpAmount.ToString());
                        break;
                    default:
                        break;
                }
            }

            foreach (DataRow eRow in ds.Tables[ChildTable].Rows)
            {
                tmpkey = eRow["Type"].ToString().Trim();
                tmpAmount = double.Parse(eRow["Amount"].ToString()) + double.Parse(eRow["Begin_Balance"].ToString());
                switch (tmpkey)
                {
                    case CONST__MASTER_ASSET_NAME:
                        eRow["Amount"] = tmpAmount.ToString();
                        break;
                    case CONST__MASTER_LIABILITY_NAME:
                        tmpAmount = tmpAmount * -1;
                        eRow["Amount"] = tmpAmount.ToString();
                        break;
                    case CONST__MASTER_REVENUE_NAME:
                        tmpAmount = tmpAmount * -1;
                        eRow["Amount"] = tmpAmount.ToString();
                        break;
                    case CONST__MASTER_EXPENSE_NAME:
                        tmpAmount = tmpAmount * -1;
                        eRow["Amount"] = tmpAmount.ToString();
                        break;
                    default:
                        break;
                }

            }


            NetIncome = vRevenue + vExpense;
            TotalLE = lSubTotal + NetIncome;


            DataTable dt = new DataTable("HEAD");
            DataRow dr;

            dt.Columns.Add(new DataColumn("Type", typeof(string)));
            dt.Columns.Add(new DataColumn("Amount", typeof(System.Decimal)));

            dr = dt.NewRow();
            dr[0] = CONST__MASTER_ASSET_NAME;
            dr[1] = double.Parse(aSubTotal.ToString());
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr[0] = CONST__MASTER_LIABILITY_NAME;
            dr[1] = lSubTotal.ToString();
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr[0] = CONST__MASTER_EQUITY_NAME;
            dr[1] = NetIncome.ToString();
            dt.Rows.Add(dr);

            ds.Tables.Add(dt);

            ds_AS = ds.Copy();
            ds_LE = ds.Copy();

            for (int i = ds_AS.Tables["HEAD"].Rows.Count - 1; i >= 0; i--)
            {
                DataRow eRow = ds_AS.Tables["HEAD"].Rows[i];
                if (eRow["Type"].ToString() != CONST__MASTER_ASSET_NAME)
                {
                    ds_AS.Tables["HEAD"].Rows.Remove(eRow);
                }
            }

            for (int i = ds_AS.Tables[ParentTable].Rows.Count - 1; i >= 0; i--)
            {
                DataRow eRow = ds_AS.Tables[ParentTable].Rows[i];
                if (eRow["Type"].ToString() != CONST__MASTER_ASSET_NAME)
                {
                    ds_AS.Tables[ParentTable].Rows.Remove(eRow);
                }
            }

            for (int i = ds_AS.Tables[ChildTable].Rows.Count - 1; i >= 0; i--)
            {
                DataRow eRow = ds_AS.Tables[ChildTable].Rows[i];
                if (eRow["Type"].ToString() != CONST__MASTER_ASSET_NAME)
                {
                    ds_AS.Tables[ChildTable].Rows.Remove(eRow);
                }
            }

            for (int i = ds_LE.Tables["HEAD"].Rows.Count - 1; i >= 0; i--)
            {
                DataRow eRow = ds_LE.Tables["HEAD"].Rows[i];
                if (eRow["Type"].ToString() == CONST__MASTER_ASSET_NAME)
                {
                    ds_LE.Tables["HEAD"].Rows.Remove(eRow);
                }
            }

            for (int i = ds_LE.Tables[ParentTable].Rows.Count - 1; i >= 0; i--)
            {
                DataRow eRow = ds_LE.Tables[ParentTable].Rows[i];
                if (eRow["Type"].ToString() == CONST__MASTER_ASSET_NAME)
                {
                    ds_LE.Tables[ParentTable].Rows.Remove(eRow);
                }
            }

            for (int i = ds_LE.Tables[ChildTable].Rows.Count - 1; i >= 0; i--)
            {
                DataRow eRow = ds_LE.Tables[ChildTable].Rows[i];
                if (eRow["Type"].ToString() == CONST__MASTER_ASSET_NAME)
                {
                    ds_LE.Tables[ChildTable].Rows.Remove(eRow);
                }
            }
        }
        private void PerformGetDataCHKR(string strCommandText, string strCommandDetailText, string nBranch)
        {
            ConnectStr = GetConnectionString(AppConstants.DB_CONN_PROD);
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;

            Con.Open();

            Cmd.CommandText = strCommandText;

            SqlDataReader reader = Cmd.ExecuteReader();

            double vStartBal = 0;

            if (reader.Read())
            {
                if (reader["Balance"].ToString() != "")
                {
                    vStartBal = double.Parse(reader["Balance"].ToString());
                }
            }
            reader.Close();

            Cmd.CommandText = strCommandDetailText;

            reader = Cmd.ExecuteReader();


            int iCount = 0;
            while (reader.Read()) { iCount++; };
            reader.Close();

            iCount += 2048;

            string[] aFielde = new string[iCount];
            string[] aField0 = new string[iCount];
            string[] aField0C = new string[iCount]; // Complete
            string[] aField0V = new string[iCount]; // Void
            string[] aField1 = new string[iCount];
            string[] aField2 = new string[iCount];
            string[] aField22 = new string[iCount]; // Print Check As
            string[] aField3 = new string[iCount];
            string[] aField4 = new string[iCount];
            string[] aField5 = new string[iCount];
            string[] aField6 = new string[iCount];
            string[] aField7 = new string[iCount];
            string[] aField8 = new string[iCount];
            string[] aField9 = new string[iCount];
            string[] aLink = new string[iCount];

            int tIndex = 1;

            double vAMT = 0;
            string
                    CurrBranch = "", iType = "";

            reader = Cmd.ExecuteReader();

            aField6[0] = vStartBal.ToString();

            while (reader.Read())
            {
                CurrBranch = reader["elt_account_number"].ToString();
                aFielde[tIndex] = CurrBranch;
                aField1[tIndex] = String.Format("{0:MM/dd/yyyy}", reader["Date"]);
                aField0[tIndex] = reader["Check_No"].ToString();
                aField0C[tIndex] = reader["Clear"].ToString();
                aField0V[tIndex] = reader["Void"].ToString();
                aField2[tIndex] = reader["Description"].ToString();
                aField22[tIndex] = reader["PrintCheckAs"].ToString();
                aField3[tIndex] = reader["Type"].ToString();
                aField8[tIndex] = reader["gl_account_name"].ToString();
                aField9[tIndex] = reader["Memo"].ToString();

                vAMT = double.Parse(reader["Amount"].ToString());
                # region
                if (vAMT > 0)
                {
                    aField5[tIndex] = vAMT.ToString();
                }
                else
                {
                    aField4[tIndex] = (vAMT * -1).ToString();
                }
                aField6[tIndex] = (double.Parse(aField6[tIndex - 1]) + vAMT).ToString();

                aField7[tIndex] = reader["tran_num"].ToString();
                iType = reader["air_ocean"].ToString();

                if (aField3[tIndex] == "PMT")
                {
                    aLink[tIndex] = "/ASP/acct_tasks/receiv_pay.asp?PaymentNo=" + aField7[tIndex];
                }
                else if (aField3[tIndex] == "INV")
                {
                    aLink[tIndex] = "/ASP/acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" + aField7[tIndex];
                }
                else if (aField3[tIndex] == "ARN")
                {
                    if (iType == "A")
                    {
                        aLink[tIndex] = "/ASP/air_import/arrival_notice.asp?iType=A&edit=yes&InvoiceNo=" + aField7[tIndex];
                    }
                    else
                    {
                        aLink[tIndex] = "/ASP/ocean_import/arrival_notice.asp?iType=O&edit=yes&InvoiceNo=" + aField7[tIndex];
                    }
                }
                else if (aField3[tIndex] == "BILL")
                {
                    aLink[tIndex] = "/ASP/acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" + aField7[tIndex];
                }
                else if (aField3[tIndex] == "CHK")
                {
                    aLink[tIndex] = "/ASP/acct_tasks/write_chk.asp?EditCheck=yes&CheckQueueID=" + aField7[tIndex];
                }
                else if (aField3[tIndex] == "BP-CHK")
                {
                    aLink[tIndex] = "/ASP/acct_tasks/pay_bills.asp?EditCheck=yes&CheckQueueID=" + aField7[tIndex];
                }
                else if (aField3[tIndex] == "Cash" || aField3[tIndex] == "Credit Card" || aField3[tIndex] == "Bank to Bank")
                {
                    aLink[tIndex] = "/ASP/acct_tasks/pay_bills.asp?EditCheck=yes&CheckQueueID=" + aField7[tIndex];
                }
                else if (aField3[tIndex] == "GJE")
                {
                    aLink[tIndex] = "/ASP/acct_tasks/gj_entry.asp?View=yes&EntryNo=" + aField7[tIndex];
                }
                else if (aField3[tIndex] == "DEPOSIT")
                {
                    aLink[tIndex] = "../../Accounting/BankDeposit.aspx?EntryNo=" + aField7[tIndex];
                }
                #endregion //
                if (CurrBranch != elt_account_number) { aLink[tIndex] += "&Branch=" + CurrBranch; }

                tIndex += 1;

            }

            reader.Close();
            Con.Close();
            // DataTable

            # region // ParentTable
            DataTable cdt = new DataTable(ParentTable);
            DataRow cdr;

            cdt.Columns.Add(new DataColumn("elt_account_number", typeof(string)));
            cdt.Columns.Add(new DataColumn("Date", typeof(string)));
            cdt.Columns.Add(new DataColumn("Bank_Account", typeof(string)));
            cdt.Columns.Add(new DataColumn("Check_No", typeof(string)));
            cdt.Columns.Add(new DataColumn("Clear", typeof(string)));
            cdt.Columns.Add(new DataColumn("Void", typeof(string)));
            cdt.Columns.Add(new DataColumn("Type", typeof(string)));
            cdt.Columns.Add(new DataColumn("Description", typeof(string)));
            cdt.Columns.Add(new DataColumn("PrintCheckAs", typeof(string)));
            cdt.Columns.Add(new DataColumn("Memo", typeof(string)));
            cdt.Columns.Add(new DataColumn("Debit(+)", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Credit(-)", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Balance", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Link", typeof(string)));

            for (int i = 0; i <= tIndex; i++)
            {
                CurrBranch = aFielde[i];

                cdr = cdt.NewRow();
                cdr[0] = CurrBranch;
                if (aField3[i] != null) cdr["Date"] = aField1[i];
                cdr["Bank_Account"] = (aField8[i] == null ? "" : aField8[i]);
                cdr["Check_No"] = (aField0[i] == null ? "" : aField0[i]);
                cdr["Check_No"] = (cdr["Check_No"].ToString() == "0" ? "" : cdr["Check_No"].ToString());
                cdr["Clear"] = (aField0C[i] == null ? "" : aField0C[i]);
                cdr["Void"] = (aField0V[i] == null ? "" : aField0V[i]);
                cdr["Description"] = (aField2[i] == null ? "" : aField2[i]);
                cdr["PrintCheckAs"] = (aField22[i] == null ? "" : aField22[i]);
                cdr["Type"] = (aField3[i] == null ? "" : aField3[i]);
                if (aField5[i] != null) cdr["Debit(+)"] = double.Parse(aField5[i]);
                if (aField4[i] != null) cdr["Credit(-)"] = double.Parse(aField4[i]);
                if (aField6[i] != null) cdr["Balance"] = double.Parse(aField6[i]);
                cdr["Link"] = (aLink[i] == null ? "" : aLink[i]);
                cdr["Memo"] = (aField9[i] == null ? "" : aField9[i]);
                cdt.Rows.Add(cdr);
            }

            ds.Tables.Add(cdt);

            #endregion


        }
        private void PerformGetDataGENL(string strCommandText, string strCommandDetailText, string nBranch)
        {
            ConnectStr = GetConnectionString(AppConstants.DB_CONN_PROD);
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;

            Con.Open();

            Cmd.CommandText = strCommandText;

            SqlDataReader reader = Cmd.ExecuteReader();

            int iGlBalanceCount = 0;
            while (reader.Read()) { iGlBalanceCount++; };
            reader.Close();

            string[] Glkey = new string[iGlBalanceCount];
            string[] GlBalance = new string[iGlBalanceCount];
            string[] GlStartText = new string[iGlBalanceCount];

            reader = Cmd.ExecuteReader();
            int k = 0;
            while (reader.Read())
            {
                if (reader["GL_Number"].ToString() != "" && reader["GL_Number"].ToString() != "0")
                {
                    Glkey[k] = reader["elt_account_number"].ToString() + "^" + reader["GL_Number"].ToString();
                    GlBalance[k] = reader["Balance"].ToString();
                    if (reader["customer_name"].ToString() == "")
                    {
                        GlStartText[k] = reader["GL_Name"].ToString();
                    }
                    else
                    {
                        GlStartText[k] = reader["customer_name"].ToString();
                    }

                    k++;
                }
            }
            reader.Close();

            Cmd.CommandText = strCommandDetailText;

            reader = Cmd.ExecuteReader();


            //**********************************************// refer from old program logic

            int iCount = 0;
            while (reader.Read()) { iCount++; };
            reader.Close();

            iCount += 2048;

            string[] aField0 = new string[iCount];
            string[] aField1 = new string[iCount];
            string[] aFieldN = new string[iCount];
            string[] aField2 = new string[iCount];
            string[] aField3 = new string[iCount];
            string[] aField4 = new string[iCount];
            string[] aField5 = new string[iCount];
            string[] aField6 = new string[iCount];
            string[] aField7 = new string[iCount];
            string[] aField8 = new string[iCount];
            string[] aField8_d = new string[iCount];
            string[] aField8_c = new string[iCount];
            string[] aField9 = new string[iCount];
            string[] aField10 = new string[iCount];
            string[] aLink = new string[iCount];

            int tIndex = 0;

            double
                    vSubTotal = 0,
                    vSubTotal_d = 0,
                    vSubTotal_c = 0,
                    vSubBal = 0,
                    Debit = 0,
                    Credit = 0;
            string
                    LastGlAccount = "",
                    CurrBranch = "",
                    cGlName = "",
                    cGlAccount = "",
                    vTranType = "",
                    iType = "",
                    vGlStartText = "";

            reader = Cmd.ExecuteReader();

            while (reader.Read())
            {
                cGlName = reader["GL_Name"].ToString();

                if (reader["GL_Number"].ToString() != "")
                {
                    cGlAccount = reader["GL_Number"].ToString();
                }
                else
                {
                    cGlAccount = "0";
                }

                CurrBranch = reader["elt_account_number"].ToString();

                if (LastGlAccount != cGlAccount)
                {
                    #region
                    if (tIndex != 0)
                    {
                        aField7[tIndex] = "Total";
                        aField8[tIndex] = vSubTotal.ToString();
                        aField8_d[tIndex] = vSubTotal_d.ToString();
                        aField8_c[tIndex] = vSubTotal_c.ToString();
                        aField9[tIndex] = vSubBal.ToString();
                        tIndex += 2;
                    }
                    #endregion

                    aField1[tIndex] = cGlName;
                    aFieldN[tIndex] = cGlAccount;
                    aField0[tIndex] = CurrBranch;

                    LastGlAccount = cGlAccount;

                    vSubTotal = 0;
                    vSubTotal_d = 0;
                    vSubTotal_c = 0;

                    int iii = Array.IndexOf(Glkey, CurrBranch + "^" + cGlAccount);
                    if (iii >= 0)
                    {
                        vSubBal = double.Parse(GlBalance[iii].ToString());
                        vGlStartText = GlStartText[iii];
                    }
                    else
                    {
                        vSubBal = 0;
                        vGlStartText = "";
                    }

                    aField9[tIndex] = vSubBal.ToString();
                    aField5[tIndex] = vGlStartText;

                    tIndex++;
                }

                vTranType = reader["Type"].ToString();
                iType = reader["air_ocean"].ToString();

                if (vTranType != "INIT" && vTranType != "")
                {
                    # region // Sorry !!!

                    aField2[tIndex] = vTranType;
                    aField3[tIndex] = String.Format("{0:MM/dd/yyyy}", reader["Date"]);
                    aField4[tIndex] = reader["Num"].ToString();
                    aField5[tIndex] = reader["Company_Name"].ToString();
                    aField6[tIndex] = reader["Memo"].ToString();
                    aField7[tIndex] = reader["Split"].ToString();
                    aField10[tIndex] = reader["Check_No"].ToString();

                    Debit = double.Parse(reader["debit_amount"].ToString());
                    Credit = double.Parse(reader["credit_amount"].ToString());

                    if (Debit == 0)
                    {
                        aField8[tIndex] = Credit.ToString();
                    }
                    else
                    {
                        aField8[tIndex] = Debit.ToString();
                    }

                    aField8_d[tIndex] = Debit.ToString();
                    aField8_c[tIndex] = Credit.ToString();

                    vSubTotal = vSubTotal + double.Parse(aField8[tIndex]);
                    vSubTotal_d = vSubTotal_d + double.Parse(aField8_d[tIndex]);
                    vSubTotal_c = vSubTotal_c + double.Parse(aField8_c[tIndex]);
                    vSubBal = vSubBal + double.Parse(aField8[tIndex]);
                    aField9[tIndex] = vSubBal.ToString();

                    if (aField2[tIndex] == "PMT")
                    {
                        aLink[tIndex] = "/ASP/acct_tasks/receiv_pay.asp?PaymentNo=" + aField4[tIndex];
                    }
                    else if (aField2[tIndex] == "INV")
                    {
                        aLink[tIndex] = "/ASP/acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" + aField4[tIndex];
                    }
                    else if (aField2[tIndex] == "ARN")
                    {
                        if (iType == "A")
                        {
                            aLink[tIndex] = "/ASP/air_import/arrival_notice.asp?iType=A&edit=yes&InvoiceNo=" + aField4[tIndex];
                        }
                        else
                        {
                            aLink[tIndex] = "/ASP/ocean_import/arrival_notice.asp?iType=O&edit=yes&InvoiceNo=" + aField4[tIndex];
                        }
                    }
                    else if (aField2[tIndex] == "BILL")
                    {
                        aLink[tIndex] = "/ASP/acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" + aField4[tIndex];
                    }
                    else if (aField2[tIndex] == "CHK")
                    {
                        aLink[tIndex] = "/ASP/acct_tasks/write_chk.asp?EditCheck=yes&CheckQueueID=" + aField4[tIndex];
                    }
                    else if (aField2[tIndex] == "BP-CHK")
                    {
                        aLink[tIndex] = "/ASP/acct_tasks/pay_bills.asp?EditCheck=yes&CheckQueueID=" + aField4[tIndex];
                    }
                    else if (aField2[tIndex] == "Cash" || aField2[tIndex] == "Credit Card" || aField2[tIndex] == "Bank to Bank")
                    {
                        aLink[tIndex] = "/ASP/acct_tasks/pay_bills.asp?EditCheck=yes&CheckQueueID=" + aField4[tIndex];
                    }
                    else if (aField2[tIndex] == "GJE")
                    {
                        aLink[tIndex] = "/ASP/acct_tasks/gj_entry.asp?View=yes&EntryNo=" + aField4[tIndex];
                    }
                    else if (aField2[tIndex] == "DEPOSIT")
                    {
                        aLink[tIndex] = "../../Accounting/BankDeposit.aspx?EntryNo=" + aField4[tIndex];
                    }


                    if (CurrBranch != elt_account_number) { aLink[tIndex] += "&Branch=" + CurrBranch; }

                    tIndex += 1;

                    #endregion
                }
                else
                {
                    aField9[tIndex] = vSubBal.ToString();
                }

            }

            reader.Close();
            Con.Close();

            aField7[tIndex] = "Total";
            aField8[tIndex] = vSubTotal.ToString();
            aField8_d[tIndex] = vSubTotal_d.ToString();
            aField8_c[tIndex] = vSubTotal_c.ToString();
            aField9[tIndex] = vSubBal.ToString();

            bool viewChild = true;

            if (iGlBalanceCount > 1) // 특정 GL 만 볼경우는 Max Check 를 안함
            {
                viewChild = performMAXRecords(tIndex, 1000);
            }

            // DataTable

            #region // Parent table

            keyColName = "GL_Name";

            string cName = "";
            string cNumber = "";

            DataTable dt = new DataTable(ParentTable);
            DataRow dr;

            dt.Columns.Add(new DataColumn("elt_account_number", typeof(string)));
            dt.Columns.Add(new DataColumn("GL_Number", typeof(string)));
            dt.Columns.Add(new DataColumn(keyColName, typeof(string)));
            dt.Columns.Add(new DataColumn("Start Balance", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("Debit", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("Credit", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("Amount", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("Balance", typeof(System.Decimal)));

            bool dispOK = false;

            for (int i = 0; i <= tIndex; i++)
            {
                if (aField0[i] != null)
                {
                    CurrBranch = aField0[i];

                }

                if (aFieldN[i] != null)
                {
                    cName = aField1[i];
                    cNumber = aFieldN[i];
                }

                if (cNumber != "" && (aField8[i] != null || aField9[i] != null))
                {
                    if (aField8[i] == null) aField8[i] = "0";
                    if (aField9[i] == null) aField9[i] = "0";

                    //if (double.Parse(aField8[i]) != 0 || double.Parse(aField9[i]) != 0)
                    // {
                    dispOK = true;
                    // }

                    if (aField7[i] == "Total" && dispOK)
                    {
                        dr = dt.NewRow();
                        dr[0] = CurrBranch;
                        dr[1] = cNumber;
                        dr[2] = cName;
                        try
                        {
                            dr[3] = double.Parse(aField9[i]) - double.Parse(aField8_d[i]) - double.Parse(aField8_c[i]);
                        }
                        catch (Exception e)
                        {
                        }
                        if (aField8_d[i] != null) dr[4] = double.Parse(aField8_d[i]); // debit
                        if (aField8_c[i] != null) dr[5] = double.Parse(aField8_c[i]); // credit
                        if (aField8[i] != null) dr[6] = double.Parse(aField8[i]);
                        if (aField9[i] != null) dr[7] = double.Parse(aField9[i]); // balance

                        dt.Rows.Add(dr);
                        dispOK = false;
                    }
                }
            }

            ds.Tables.Add(dt);

            #endregion

            if (!viewChild) return;

            # region // Child table

            DataTable cdt = new DataTable(ChildTable);
            DataRow cdr;

            cdt.Columns.Add(new DataColumn("elt_account_number", typeof(string)));
            cdt.Columns.Add(new DataColumn("GL_Number", typeof(string)));
            cdt.Columns.Add(new DataColumn(keyColName, typeof(string)));
            cdt.Columns.Add(new DataColumn("Type", typeof(string)));
            cdt.Columns.Add(new DataColumn("Date", typeof(string)));
            cdt.Columns.Add(new DataColumn("Num", typeof(string)));
            cdt.Columns.Add(new DataColumn("Company_Name", typeof(string)));
            cdt.Columns.Add(new DataColumn("Memo", typeof(string)));
            cdt.Columns.Add(new DataColumn("Split", typeof(string)));
            cdt.Columns.Add(new DataColumn("Debit", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Credit", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Amount", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Balance", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Link", typeof(string)));

            double current_balance = 0;

            for (int i = 0; i <= tIndex; i++)
            {
                if (aField0[i] != null)
                {
                    CurrBranch = aField0[i];
                }

                if (aFieldN[i] != null)
                {
                    cName = aField1[i];
                    cNumber = aFieldN[i];
                }

                if (aField7[i] != "Total" && cNumber != "" &&
                    (aField8[i] != null || aField9[i] != null))
                {
                    string temp_company_name = aField5[i];
                    if (temp_company_name == null) temp_company_name = "";

                    if (!temp_company_name.Contains("_Fiscal Closing"))
                    {

                        if (aField8[i] == null) aField8[i] = "0";
                        if (aField9[i] == null) aField9[i] = "0";

                        cdr = cdt.NewRow();
                        cdr[0] = CurrBranch;
                        cdr["GL_Number"] = cNumber;
                        cdr[keyColName] = cName;
                        cdr["Type"] = (aField2[i] == null ? "" : aField2[i]);
                        if (aField3[i] != null) cdr["Date"] = aField3[i];

                        cdr["Num"] = (aField4[i] == null ? "" : aField4[i]);
                        if (aField10[i] != null)
                        {
                            if (aField10[i] != "0" && aField10[i] != "")
                            {
                                cdr["Num"] = cdr["Num"] + " (" + aField10[i] + ")";
                            }
                        }
                        cdr["Company_Name"] = (aField5[i] == null ? "" : aField5[i]);
                        cdr["Memo"] = (aField6[i] == null ? "" : aField6[i]);
                        cdr["Split"] = (aField7[i] == null ? "" : aField7[i]);

                        if (aField8_d[i] != null) cdr[9] = double.Parse(aField8_d[i]);
                        if (aField8_c[i] != null) cdr[10] = double.Parse(aField8_c[i]);
                        if (aField8[i] != null) cdr[11] = double.Parse(aField8[i]);
                        // if (aField9[i] != null) cdr[12] = double.Parse(aField9[i]);

                        string temp_debit_amt = (aField8_d[i] == null ? "0" : aField8_d[i]);
                        string temp_credit_amt = (aField8_c[i] == null ? "0" : aField8_c[i]);

                        current_balance = current_balance + double.Parse(temp_debit_amt) + double.Parse(temp_credit_amt);
                        cdr[12] = current_balance;
                        cdr[13] = (aLink[i] == null ? "" : aLink[i]);

                        cdt.Rows.Add(cdr);
                    }
                }
            }

            ds.Tables.Add(cdt);

            #endregion

            if (nBranch != "0")
            {
                DataColumn[] relComsP = new DataColumn[2];
                DataColumn[] relComsC = new DataColumn[2];
                relComsP[0] = ds.Tables[ParentTable].Columns["GL_Number"];
                relComsP[1] = ds.Tables[ParentTable].Columns["GL_Name"];
                relComsC[0] = ds.Tables[ChildTable].Columns["GL_Number"];
                relComsC[1] = ds.Tables[ChildTable].Columns["GL_Name"];
                if (ds.Relations.Count < 1) ds.Relations.Add(relComsP, relComsC);
            }
            else
            {
                DataColumn[] relComsP = new DataColumn[3];
                DataColumn[] relComsC = new DataColumn[3];
                relComsP[0] = ds.Tables[ParentTable].Columns["elt_account_number"];
                relComsP[1] = ds.Tables[ParentTable].Columns["GL_Number"];
                relComsP[2] = ds.Tables[ParentTable].Columns["GL_Name"];
                relComsC[0] = ds.Tables[ChildTable].Columns["elt_account_number"];
                relComsC[1] = ds.Tables[ChildTable].Columns["GL_Number"];
                relComsC[2] = ds.Tables[ChildTable].Columns["GL_Name"];

                if (ds.Relations.Count < 1) ds.Relations.Add(relComsP, relComsC);
            }
        }
        private void PerformGetDataINCOM(string strCommandDetailText)
        {
            ConnectStr = GetConnectionString(AppConstants.DB_CONN_PROD);
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand cmdDetail = new SqlCommand();

            cmdDetail.Connection = Con;

            SqlDataAdapter Adap = new SqlDataAdapter();
            Con.Open();

            if (strCommandDetailText != "")
            {
                cmdDetail.CommandText = strCommandDetailText;
                Adap.SelectCommand = cmdDetail;
                Adap.Fill(ds, ChildTable);
            }

            Con.Close();

        }
        private void performDetailDataRefineINCOM()
        {
            keyColName = "Area";
            string tmpkey = "";
            double tmpAmount = 0;
            double rSubTotal = 0, eSubTotal = 0, cSubTotal = 0, GrossProfit = 0, NetIncome = 0;
            foreach (DataRow eRow in ds.Tables[ChildTable].Rows)
            {
                tmpkey = eRow["Type"].ToString().Trim();
                tmpAmount = double.Parse(eRow["Amount"].ToString());
                switch (tmpkey)
                {
                    case CONST__REVENUE:
                        eRow["Area"] = "        " + CONST__REVENUE;
                        tmpAmount = tmpAmount * -1;
                        eRow["Amount"] = tmpAmount.ToString();
                        rSubTotal = rSubTotal + tmpAmount;
                        break;
                    case CONST__OTHER_REVENUE:
                        eRow["Area"] = "        " + CONST__REVENUE;
                        tmpAmount = tmpAmount * -1;
                        eRow["Amount"] = tmpAmount.ToString();
                        rSubTotal = rSubTotal + tmpAmount;
                        break;

                    case CONST__EXPENSE:
                        eRow["Area"] = "        " + CONST__EXPENSE;
                        eSubTotal = eSubTotal + tmpAmount;
                        break;
                    case CONST__OTHER_EXPENSE:
                        eRow["Area"] = "        " + CONST__EXPENSE;
                        eSubTotal = eSubTotal + tmpAmount;
                        break;

                    case CONST__COST_OF_SALES:
                        eRow["Area"] = "        " + CONST__COST_OF_SALES;
                        cSubTotal = cSubTotal + tmpAmount;
                        break;
                    default:
                        break;
                }
            }
            GrossProfit = rSubTotal - cSubTotal;
            NetIncome = GrossProfit - eSubTotal;
            #region // Parent table

            DataTable dt = new DataTable(ParentTable);
            DataRow dr;

            dt.Columns.Add(new DataColumn(keyColName, typeof(string)));
            dt.Columns.Add(new DataColumn("Amount", typeof(System.Decimal)));

            dr = dt.NewRow();
            dr[0] = "ORDINARY INCOME/EXPENSE";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr[0] = "        " + CONST__REVENUE;
            dr[1] = double.Parse(rSubTotal.ToString());
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr[0] = "        " + CONST__COST_OF_SALES;
            dr[1] = double.Parse(cSubTotal.ToString());
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr[0] = "GROSS PROFIT";
            dr[1] = double.Parse(GrossProfit.ToString());
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr[0] = "        " + CONST__EXPENSE;
            dr[1] = double.Parse(eSubTotal.ToString());
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr[0] = "NET ORDINARY INCOME";
            dr[1] = double.Parse(NetIncome.ToString());
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr[0] = "NET INCOME";
            dr[1] = double.Parse(NetIncome.ToString());
            dt.Rows.Add(dr);

            ds.Tables.Add(dt);

            #endregion
        }
        private void performDetailDataRefineBS()
        {
            string tmpkey = "";
            double tmpAmount = 0;
            vRevenue = vExpense = NetIncome = TotalLE = lSubTotal = aSubTotal = 0;
            foreach (DataRow eRow in ds.Tables[ParentTable].Rows)
            {
                tmpkey = eRow["Type"].ToString().Trim();
                tmpAmount = double.Parse(eRow["Amount"].ToString()) + double.Parse(eRow["Begin_Balance"].ToString());
                switch (tmpkey)
                {
                    case CONST__MASTER_ASSET_NAME:
                        eRow["gl_account_type"] = "Assets";
                        eRow["Type"] = "Current Assets";
                        eRow["Amount"] = tmpAmount.ToString();
                        aSubTotal = aSubTotal + tmpAmount;
                        break;
                    case CONST__MASTER_LIABILITY_NAME:
                        eRow["gl_account_type"] = "Liabilities";
                        eRow["Type"] = "Current Liabilities";
                        tmpAmount = tmpAmount * -1;
                        eRow["Amount"] = tmpAmount.ToString();
                        lSubTotal = lSubTotal + tmpAmount;
                        break;
                    case CONST__MASTER_REVENUE_NAME:
                        eRow["gl_account_type"] = "Equity : Net Income";
                        tmpAmount = tmpAmount * -1;
                        eRow["Amount"] = tmpAmount.ToString();
                        vRevenue = vRevenue + double.Parse(tmpAmount.ToString());
                        break;
                    case CONST__MASTER_EXPENSE_NAME:
                        eRow["gl_account_type"] = "Equity : Net Income";
                        tmpAmount = tmpAmount * -1;
                        eRow["Amount"] = tmpAmount.ToString();
                        vExpense = vExpense + double.Parse(tmpAmount.ToString());
                        break;
                    default:
                        break;
                }
            }

            foreach (DataRow eRow in ds.Tables[ChildTable].Rows)
            {
                tmpkey = eRow["Type"].ToString().Trim();
                tmpAmount = double.Parse(eRow["Amount"].ToString()) + double.Parse(eRow["Begin_Balance"].ToString());
                switch (tmpkey)
                {
                    case CONST__MASTER_ASSET_NAME:
                        eRow["Sub_Area"] = "Assets";
                        eRow["Type"] = "Current Assets";
                        eRow["Amount"] = tmpAmount.ToString();
                        break;
                    case CONST__MASTER_LIABILITY_NAME:
                        eRow["Sub_Area"] = "Liabilities";
                        eRow["Type"] = "Current Liabilities";
                        tmpAmount = tmpAmount * -1;
                        eRow["Amount"] = tmpAmount.ToString();
                        break;
                    case CONST__MASTER_REVENUE_NAME:
                        eRow["Sub_Area"] = "Equity : Net Income";
                        tmpAmount = tmpAmount * -1;
                        eRow["Amount"] = tmpAmount.ToString();
                        break;
                    case CONST__MASTER_EXPENSE_NAME:
                        eRow["Sub_Area"] = "Equity : Net Income";
                        tmpAmount = tmpAmount * -1;
                        eRow["Amount"] = tmpAmount.ToString();
                        break;
                    default:
                        break;
                }

            }

            NetIncome = vRevenue + vExpense;
            TotalLE = lSubTotal + NetIncome;

            DataTable dt = new DataTable("HEAD");
            DataRow dr;

            dt.Columns.Add(new DataColumn("Area", typeof(string)));
            dt.Columns.Add(new DataColumn("Amount", typeof(System.Decimal)));

            dr = dt.NewRow();
            dr[0] = "ASSETS";
            dr[1] = double.Parse(aSubTotal.ToString());
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr[0] = "LIABILITIES & EQUITY";
            dr[1] = TotalLE.ToString();
            dt.Rows.Add(dr);

            ds.Tables.Add(dt);

            DataTable cdt = new DataTable("HEAD2");
            DataRow cdr;

            cdt.Columns.Add(new DataColumn("Area", typeof(string)));
            cdt.Columns.Add(new DataColumn("Sub_Area", typeof(string)));
            cdt.Columns.Add(new DataColumn("Amount", typeof(System.Decimal)));


            cdr = cdt.NewRow();
            cdr[0] = "ASSETS";
            cdr[1] = "Assets";
            cdr[2] = double.Parse(aSubTotal.ToString());
            cdt.Rows.Add(cdr);

            cdr = cdt.NewRow();
            cdr[0] = "LIABILITIES & EQUITY";
            cdr[1] = "Liabilities";
            cdr[2] = double.Parse(lSubTotal.ToString());
            cdt.Rows.Add(cdr);

            cdr = cdt.NewRow();
            cdr[0] = "LIABILITIES & EQUITY";
            cdr[1] = "Equity : Net Income";
            cdr[2] = double.Parse(NetIncome.ToString());

            cdt.Rows.Add(cdr);

            ds.Tables.Add(cdt);



        }
        private void performDetailDataRefineEX()
        {
            string tmpkey = "";
            double tmpBalance = 0;

            foreach (DataRow eRow in ds.Tables[ChildTable].Rows)
            {
                if (tmpkey != eRow["Customer_Name"].ToString().Trim())
                {
                    tmpkey = eRow["Customer_Name"].ToString().Trim();
                    tmpBalance = 0;
                }

                tmpBalance = double.Parse(eRow["Amount"].ToString()) + tmpBalance;
                eRow["Balance"] = tmpBalance;

                if (eRow["Type"].ToString() == "BILL")
                {
                    if (elt_account_number != eRow["elt_account_number"].ToString())
                    {
                        eRow["Link"] = "/ASP/acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" + eRow["Num"].ToString() + "&Branch=" + elt_account_number;
                    }
                    else
                    {
                        eRow["Link"] = "/ASP/acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" + eRow["Num"].ToString();

                    }
                }
                else
                {
                    if (elt_account_number != eRow["elt_account_number"].ToString())
                    {
                        eRow["Link"] = "/ASP/acct_tasks/write_chk.asp?EditCheck=yes&CheckQueueID=" + eRow["Num"].ToString() + "&Branch=" + elt_account_number;
                    }
                    else
                    {

                        eRow["Link"] = "/ASP/acct_tasks/write_chk.asp?EditCheck=yes&CheckQueueID=" + eRow["Num"].ToString();
                    }
                }
            }

        }
        private void PerformGetDataAPDetail(string strCommandText, string strCommandDetailText, string nBranch, string strCommandTextUP)
        {
            ConnectStr = GetConnectionString(AppConstants.DB_CONN_PROD);
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;

            Con.Open();

            Cmd.CommandText = strCommandDetailText;

            SqlDataReader reader = Cmd.ExecuteReader();

            //**********************************************// refer from old program logic        

            double
                    vOpenAmount = 0,
                    vTotal1 = 0,
                    vTotal = 0,
                    vSubTotal = 0,
                    vSubBal = 0,
                    vTotalBalance = 0,
                    Debit = 0, Credit = 0,
                    DebitTotal = 0,
                    CreditTotal = 0, vStart = 0;

            string LastCustomer = "";

            int iCount = 0;
            while (reader.Read()) { iCount++; };
            reader.Close();

            iCount += 2048;

            string[] aFieldN = new string[iCount];
            string[] aField0 = new string[iCount];
            string[] aField1 = new string[iCount];
            string[] aField2 = new string[iCount];
            string[] aField3 = new string[iCount];
            string[] aField4 = new string[iCount];
            string[] aField5 = new string[iCount];
            string[] aField6 = new string[iCount];
            string[] aField7 = new string[iCount];
            string[] aField8 = new string[iCount];
            string[] aField9 = new string[iCount];

            string[] aLink = new string[iCount];
            string[] aField_Billed = new string[iCount];
            string[] aField_Paid = new string[iCount];
            string[] aField_Start = new string[iCount];

            int tIndex = 0;
            string CurrBranch = "";
            string LastBranch = "";
            string cNumber = "";
            string vTranType = "";
            string iType = "";
            string cName = "";
            string bID = "";

            reader = Cmd.ExecuteReader();

            aField1[tIndex] = "Posted Transactions";
            tIndex += 1;

            while (reader.Read())
            {
                CurrBranch = reader["elt_account_number"].ToString();
                if (nBranch == "0" && tIndex == 1)
                {
                    aField0[tIndex] = CurrBranch;
                    tIndex += 1;
                    LastBranch = CurrBranch;
                }
                cName = reader["Customer_Name"].ToString().Trim();
                cNumber = reader["Customer_Number"].ToString();

                if (int.Parse(cNumber) > 300000) { cNumber = "0"; }

                if ((LastCustomer != reader["Customer_Number"].ToString().Trim()) || (nBranch == "0" && CurrBranch != LastBranch))
                {
                    if ((tIndex != 1 && nBranch != "0") || (tIndex != 1 && nBranch == "0"))
                    {
                        aField5[tIndex] = "Sub Total";
                        aField6[tIndex] = vSubTotal.ToString();
                        aField7[tIndex] = aField7[tIndex - 1];

                        aField_Billed[tIndex] = CreditTotal.ToString();
                        aField_Paid[tIndex] = DebitTotal.ToString();
                        aField_Start[tIndex] = vStart.ToString();

                        vTotalBalance = vTotalBalance + double.Parse(vSubBal.ToString());
                        tIndex = tIndex + 1;
                    }

                    if (nBranch == "0" && CurrBranch != LastBranch)
                    {
                        aField0[tIndex] = CurrBranch;
                        tIndex = tIndex + 1;
                        LastBranch = CurrBranch;
                    }

                    aFieldN[tIndex] = cNumber;
                    aField1[tIndex] = cName;
                    LastCustomer = cNumber;

                    vSubTotal = DebitTotal = CreditTotal = vStart = 0;
                    if (reader["Type"].ToString() == "SSS")
                    {
                        vSubBal = 0;
                        vSubBal = Double.Parse(reader["balance"].ToString());
                        aField7[tIndex] = vSubBal.ToString();
                        aField_Start[tIndex] = vSubBal.ToString();
                        vStart = vSubBal;
                        if (aField7[tIndex] == "") { aField7[tIndex] = "0"; }
                        tIndex += 1;
                        continue;
                    }
                    else
                    {
                        vSubBal = 0;
                    }
                }

                vTranType = reader["Type"].ToString();
                iType = reader["Air_Ocean"].ToString();

                if (vTranType != "INIT")
                {
                    aField2[tIndex] = vTranType;
                    aField3[tIndex] = String.Format("{0:MM/dd/yyyy}", reader["Date"]);
                    aField4[tIndex] = reader["Num"].ToString();
                    aField8[tIndex] = reader["Memo"].ToString();
                    aField9[tIndex] = reader["Check_No"].ToString();

                    Debit = double.Parse(reader["debit_amount"].ToString());
                    Credit = double.Parse(reader["credit_amount"].ToString());

                    aField_Billed[tIndex] = Credit.ToString();
                    if (aField_Billed[tIndex].ToString().Trim().Equals("")) aField_Billed[tIndex] = "0";

                    aField_Paid[tIndex] = Debit.ToString();
                    if (aField_Paid[tIndex].ToString().Trim().Equals("")) aField_Paid[tIndex] = "0";

                    aField6[tIndex] = (Debit + Credit).ToString();

                    vSubTotal = vSubTotal + double.Parse(aField6[tIndex]);

                    DebitTotal = DebitTotal + double.Parse(aField_Paid[tIndex]);
                    CreditTotal = CreditTotal + double.Parse(aField_Billed[tIndex]);

                    vSubBal = vSubBal + double.Parse(aField6[tIndex]);
                    aField7[tIndex] = vSubBal.ToString();
                    vTotal1 = vTotal1 + double.Parse(aField6[tIndex]);

                    if (aField2[tIndex] == "BILL")
                    {
                        if (CurrBranch != elt_account_number)
                        {

                            aLink[tIndex] = "/ASP/acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" + aField4[tIndex] + "&Branch=" + CurrBranch + "&BCustomer=" + cName;


                        }
                        else
                        {
                            aLink[tIndex] = "/ASP/acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" + aField4[tIndex];


                        }

                       
                    }
                    else if (aField2[tIndex] == "GJE")
                    {
                        aLink[tIndex] = "/ASP/acct_tasks/gj_entry.asp?View=yes&EntryNo=" + aField4[tIndex];
                    }
                    else if (aField2[tIndex] == "DEPOSIT")
                    {
                        aLink[tIndex] = "../../Accounting/BankDeposit.aspx?EntryNo=" + aField4[tIndex];
                    }
                    else
                    {
                        if (CurrBranch != elt_account_number)
                        {
                            aLink[tIndex] = "/ASP/acct_tasks/pay_bills.asp?EditCheck=yes&CheckQueueID=" + aField4[tIndex] + "&Branch=" + CurrBranch;
                        }
                        else
                        {
                            aLink[tIndex] = "/ASP/acct_tasks/pay_bills.asp?EditCheck=yes&CheckQueueID=" + aField4[tIndex];
                        }
                    }
                    tIndex += 1;
                }


            }

            reader.Close();


            aField5[tIndex] = "Sub Total";
            aField6[tIndex] = vSubTotal.ToString();
            aField_Billed[tIndex] = CreditTotal.ToString();
            aField_Paid[tIndex] = DebitTotal.ToString();
            aField_Start[tIndex] = vStart.ToString();

            if (tIndex > 0)
            {
                aField7[tIndex] = aField7[tIndex - 1];
            }
            else
            {
                aField7[tIndex] = "0";
            }

            tIndex += 1;
            aField1[tIndex] = "Posted Transactions Total";
            tIndex += 1;

            vTotalBalance = vTotalBalance + double.Parse(vSubBal.ToString());

            double vTotal2 = 0;
            string LastVendor = "";
            int vMark = tIndex;
            double vUnPostBalance = 0;
            double vTotalUnPostBalance = 0;

            if (strCommandTextUP != "")
            {

                #region // Include Unposeted

                vTotal2 = 0;
                LastVendor = "";
                aField1[tIndex] = "Unposted Transactions";
                tIndex += 1;
                vMark = tIndex;
                vUnPostBalance = 0;
                vTotalUnPostBalance = 0;

                Cmd.CommandText = strCommandTextUP;
                reader = Cmd.ExecuteReader();

                tIndex += 1;

                while (reader.Read())
                {
                    CurrBranch = reader["elt_account_number"].ToString();

                    cName = reader["Customer_Name"].ToString().Trim();
                    cNumber = reader["Customer_Number"].ToString().Trim();
                    if (LastVendor != reader["Customer_Name"].ToString().Trim())
                    {
                        if (tIndex != vMark)
                        {
                            aField5[tIndex] = "Sub Total";
                            aField6[tIndex] = vSubTotal.ToString();
                            aField7[tIndex] = vUnPostBalance.ToString();

                            aField_Billed[tIndex] = vSubTotal.ToString();

                            tIndex += 1;
                        }

                        aField0[tIndex] = CurrBranch;
                        aField1[tIndex] = cName;
                        aFieldN[tIndex] = cNumber;

                        LastVendor = cName;
                        vSubTotal = 0;
                        vUnPostBalance = 0;
                    }

                    aField2[tIndex] = "BILL";

                    aField3[tIndex] = String.Format("{0:MM/dd/yyyy}", reader["Date"]);
                    aField4[tIndex] = reader["Num"].ToString();
                    aField8[tIndex] = reader["Memo"].ToString();

                    double Amount = (double.Parse(reader["Amount"].ToString())) * -1;
                    aField6[tIndex] = Amount.ToString();

                    aField_Billed[tIndex] = Amount.ToString();

                    vUnPostBalance = vUnPostBalance + Amount;
                    vTotalUnPostBalance = vTotalUnPostBalance + Amount;
                    aField7[tIndex] = vUnPostBalance.ToString();

                    aLink[tIndex] = "/ASP/acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" + aField4[tIndex];

                    if (aField4[tIndex] == "0")
                    {

                        if (reader["air_ocean"].ToString() == "A" && reader["debit_no"].ToString() != "")
                        {
                            aField2[tIndex] = "ADN";
                            aLink[tIndex] = "/ASP/air_import/air_import2.asp?iType=A&Edit=yes&MAWB=" + reader["mb_no"].ToString();
                            aField4[tIndex] = reader["mb_no"].ToString();
                        }
                        else if (reader["air_ocean"].ToString() == "O" && reader["debit_no"].ToString() != "")
                        {
                            aField2[tIndex] = "ADN";

                            aLink[tIndex] = "/ASP/ocean_import/ocean_import2.asp?iType=O&Edit=yes&MAWB=" + reader["mb_no"].ToString();
                            aField4[tIndex] = reader["mb_no"].ToString();
                        }
                        else
                        {

                            aLink[tIndex] = "/ASP/acct_tasks/enter_bill.asp?ViewBill=yes&item_id=" + reader["item_id"].ToString() + "&vendor_number=" + reader["vendor_number"].ToString();
                            aField4[tIndex] = "Direct Entry";
                        }
                    }

                    vSubTotal = vSubTotal + Amount;
                    vTotal2 = vTotal2 + Amount;
                    tIndex += 1;

                }

                reader.Close();
                Con.Close();

                if (tIndex > vMark)
                {
                    aField5[tIndex] = "Sub Total";
                    aField6[tIndex] = vSubTotal.ToString();

                    aField_Billed[tIndex] = vSubTotal.ToString();

                    aField7[tIndex] = vUnPostBalance.ToString();
                    tIndex += 1;
                    aField1[tIndex] = "Unposted Transactions Total";
                    aField6[tIndex] = vTotal2.ToString();
                    aField7[tIndex] = vTotalUnPostBalance.ToString();
                }
                else
                {
                    //aField5[tIndex]="Total Unposted Balance";
                }

                #endregion

            }

            bool viewChild = performMAXRecords(tIndex, 2000);

            // DataTable

            #region // Parent table

            DataTable dt = new DataTable(ParentTable);
            DataRow dr;
            string strPost = "";

            dt.Columns.Add(new DataColumn("s", typeof(string)));
            dt.Columns.Add(new DataColumn("elt_account_number", typeof(string)));
            dt.Columns.Add(new DataColumn("Customer_Number", typeof(string)));
            dt.Columns.Add(new DataColumn(keyColName, typeof(string)));

            dt.Columns.Add(new DataColumn("Start", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("Paid", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("Billed", typeof(System.Decimal)));

            dt.Columns.Add(new DataColumn("Amount", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("Balance", typeof(System.Decimal)));
            bool dispOK = false;
            strPost = "Posted";
            for (int i = 0; i <= tIndex; i++)
            {
                if (aField0[i] != null)
                {
                    if (nBranch == "0")
                    {
                        CurrBranch = aField0[i];
                    }
                    else
                    {
                        CurrBranch = "";
                    }

                }
                if (aField5[i] != "Sub Total")
                {

                    if (aField1[i] != null)
                    {
                        cName = aField1[i];
                        cNumber = aFieldN[i];

                        if (aField1[i] == "Posted Transactions")
                        {
                            strPost = "Posted";
                            dr = dt.NewRow();
                            dr[0] = strPost;
                            //                            dr[1] = CurrBranch;
                            dr[2] = cNumber;
                            dr[3] = cName;
                            dt.Rows.Add(dr);
                            dispOK = false;
                            cName = "";
                            cNumber = "";
                        }

                        if (aField1[i] == "Posted Transactions Total")
                        {
                            strPost = "Posted";
                            dr = dt.NewRow();
                            dr[0] = strPost;
                            //                            dr[1] = CurrBranch;
                            dr[2] = cNumber;
                            dr[3] = cName;
                            dr[4] = 0;
                            dr[7] = double.Parse(vOpenAmount.ToString()) + double.Parse(vTotal1.ToString());
                            dt.Rows.Add(dr);
                            dispOK = false;
                            cName = "";
                            cNumber = "";

                        }

                        if (aField1[i] == "Unposted Transactions")
                        {
                            strPost = "Unposted";
                            dr = dt.NewRow();
                            dr[0] = strPost;
                            //                            dr[1] = CurrBranch;
                            dr[2] = cNumber;
                            dr[3] = cName;
                            dt.Rows.Add(dr);
                            dispOK = false;
                            cName = "";
                            cNumber = "";
                        }

                        if (aField1[i] == "Unposted Transactions Total")
                        {
                            strPost = "Unposted";
                            dr = dt.NewRow();
                            dr[0] = strPost;
                            //                            dr[1] = CurrBranch;
                            dr[2] = cNumber;
                            dr[3] = cName;
                            dr[4] = 0;
                            dr[7] = double.Parse(vTotal2.ToString());
                            dt.Rows.Add(dr);
                            dispOK = false;
                            cName = "";
                            cNumber = "";

                        }
                    }
                }

                if (cName != "" && (aField7[i] != null || aField6[i] != null))
                {
                    if (aField6[i] == null) aField6[i] = "0";
                    if (aField7[i] == null) aField7[i] = "0";

                    if ((aField5[i] == "Sub Total"))
                    {
                        dr = dt.NewRow();
                        dr[0] = strPost;
                        dr[1] = CurrBranch;
                        dr[2] = cNumber;
                        dr[3] = cName;
                        if (aField_Start[i] != null) dr[4] = double.Parse(aField_Start[i]);
                        if (aField_Paid[i] != null) dr[5] = double.Parse(aField_Paid[i]);
                        if (aField_Billed[i] != null) dr[6] = double.Parse(aField_Billed[i]);
                        if (aField6[i] != null) dr[7] = double.Parse(aField6[i]);
                        if (aField7[i] != null) dr[8] = double.Parse(aField7[i]);
                        dt.Rows.Add(dr);
                        cName = "";
                        cNumber = "";

                    }
                }
            }

            vTotal = vTotal1 + vTotal2;
            dr = dt.NewRow();
            dr[0] = "Grand";
            dr[1] = "";
            dr[3] = "Grand Total";
            dr[4] = 0;
            dr[6] = double.Parse(vOpenAmount.ToString()) + double.Parse(vTotal.ToString());
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr[0] = "Cumulative";
            dr[1] = "";
            dr[3] = "Cumulative Total";
            dr[4] = 0;
            dr[6] = double.Parse(vTotal.ToString());
            dt.Rows.Add(dr);

            ds.Tables.Add(dt);

            #endregion

            if (!viewChild) return;

            # region // Child table
            DataTable cdt = new DataTable(ChildTable);
            DataRow cdr;

            cdt.Columns.Add(new DataColumn("s", typeof(string)));
            cdt.Columns.Add(new DataColumn("elt_account_number", typeof(string)));
            cdt.Columns.Add(new DataColumn("Customer_Number", typeof(string)));
            cdt.Columns.Add(new DataColumn(keyColName, typeof(string)));
            cdt.Columns.Add(new DataColumn("Type", typeof(string)));
            cdt.Columns.Add(new DataColumn("Date", typeof(string)));
            cdt.Columns.Add(new DataColumn("Num", typeof(string)));
            cdt.Columns.Add(new DataColumn("Memo", typeof(string)));
            cdt.Columns.Add(new DataColumn("Account", typeof(string)));

            cdt.Columns.Add(new DataColumn("Start", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Paid", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Billed", typeof(System.Decimal)));

            cdt.Columns.Add(new DataColumn("Amount", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Balance", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Link", typeof(string)));
            strPost = "Posted";
            for (int i = 0; i <= tIndex; i++)
            {
                if (aField0[i] != null)
                {
                    if (nBranch == "0")
                    {
                        CurrBranch = aField0[i];
                    }
                    else
                    {
                        CurrBranch = "";
                    }

                }

                if (aField1[i] != null)
                {
                    cName = aField1[i];
                    cNumber = aFieldN[i];
                }

                if (cName == "Posted Transactions")
                {
                    strPost = "Posted";
                    continue;
                }

                if (cName == "Posted Transactions Total")
                {
                    strPost = "Posted";
                    continue;
                }

                if (cName == "Unposted Transactions")
                {
                    strPost = "Unposted";
                    continue;
                }

                if (cName == "Unposted Transactions Total")
                {
                    strPost = "Unposted";
                    continue;
                }

                if (cName.Length > 7)
                {
                    if (cName.Substring(0, 7) == "_Fiscal")
                    {
                        continue;
                    }
                }

                if (aField5[i] != "Sub Total" && cName != "" && (aField7[i] != null || aField6[i] != null))
                {

                    if (aField6[i] == null) aField6[i] = "0";
                    if (aField7[i] == null) aField7[i] = "0";

                    //if (double.Parse(aField7[i]) != 0 || double.Parse(aField6[i]) != 0)
                    //{
                    cdr = cdt.NewRow();
                    cdr[0] = strPost;
                    cdr[1] = CurrBranch;
                    cdr[2] = cNumber;
                    cdr[3] = cName;
                    cdr[4] = (aField2[i] == null ? "" : aField2[i]);
                    if (aField3[i] != null) cdr[5] = aField3[i];
                    cdr[6] = (aField4[i] == null ? "" : aField4[i]);
                    if (aField9[i] != null)
                    {
                        if (aField9[i] != "0" && aField9[i] != "")
                        {
                            cdr[6] = cdr[6] + " (" + aField9[i] + ")";
                        }
                    }
                    cdr[7] = (aField8[i] == null ? "" : aField8[i]);
                    cdr[8] = (aField5[i] == null ? "" : aField5[i]);

                    cdr[9] = (aField_Start[i] == null && aField_Start[i] != "0" ? double.Parse("0.00") : double.Parse(aField_Start[i]));

                    cdr[10] = (aField_Paid[i] == null ? double.Parse("0.00") : double.Parse(aField_Paid[i]));

                    cdr[11] = (aField_Billed[i] == null ? double.Parse("0.00") : double.Parse(aField_Billed[i]));

                    if (aField6[i] != null) cdr[12] = double.Parse(aField6[i]);
                    if (aField7[i] != null) cdr[13] = double.Parse(aField7[i]);
                    cdr[14] = (aLink[i] == null ? "" : aLink[i]);
                    cdt.Rows.Add(cdr);
                    //                    }
                }
            }

            ds.Tables.Add(cdt);

            #endregion

            add_total3();

            if (nBranch != "0")
            {
                DataColumn[] relComsP = new DataColumn[3];
                DataColumn[] relComsC = new DataColumn[3];
                relComsP[0] = ds.Tables[ParentTable].Columns["s"];
                relComsP[1] = ds.Tables[ParentTable].Columns[keyColName];
                relComsP[2] = ds.Tables[ParentTable].Columns["Customer_Number"];
                relComsC[0] = ds.Tables[ChildTable].Columns["s"];
                relComsC[1] = ds.Tables[ChildTable].Columns[keyColName];
                relComsC[2] = ds.Tables[ChildTable].Columns["Customer_Number"];

                if (ds.Relations.Count < 1) ds.Relations.Add(relComsP, relComsC);
            }
            else
            {
                DataColumn[] relComsP = new DataColumn[4];
                DataColumn[] relComsC = new DataColumn[4];
                relComsP[0] = ds.Tables[ParentTable].Columns["s"];
                relComsP[1] = ds.Tables[ParentTable].Columns["elt_account_number"];
                relComsP[2] = ds.Tables[ParentTable].Columns["Customer_Number"];
                relComsP[3] = ds.Tables[ParentTable].Columns[keyColName];

                relComsC[0] = ds.Tables[ChildTable].Columns["s"];
                relComsC[1] = ds.Tables[ChildTable].Columns["elt_account_number"];
                relComsC[2] = ds.Tables[ChildTable].Columns["Customer_Number"];
                relComsC[3] = ds.Tables[ChildTable].Columns[keyColName];

                if (ds.Relations.Count < 1) ds.Relations.Add(relComsP, relComsC);
            }

        }
        private bool performMAXRecords(int tIndex, int maxVal)
        {
            return true;
        }
        private void PerformGetDataARDetail(string strCommandText, string strCommandDetailText, string nBranch)
        {
            ConnectStr = GetConnectionString(AppConstants.DB_CONN_PROD);
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;

            Con.Open();

            Cmd.CommandTimeout = 300;
            Cmd.CommandText = strCommandDetailText;

            SqlDataReader reader = Cmd.ExecuteReader();

            //**********************************************// refer from old program logic        

            double
                    vTotal = 0,
                    vSubTotal = 0,
                    vSubBal = 0,
                    vTotalBalance = 0,
                    Debit = 0, Credit = 0,
                    DebitTotal = 0,
                    CreditTotal = 0, vStart = 0;

            string LastCustomer = "";

            int iCount = 0;
            while (reader.Read()) { iCount++; };
            reader.Close();

            iCount += 5000;

            string[] aField0 = new string[iCount];
            string[] aField1 = new string[iCount];
            string[] aField2 = new string[iCount];
            string[] aField3 = new string[iCount];
            string[] aField4 = new string[iCount];
            string[] aField5 = new string[iCount];
            string[] aField6 = new string[iCount];
            string[] aField7 = new string[iCount];
            string[] aFieldM = new string[iCount];
            string[] aFieldN = new string[iCount];
            string[] aFieldO = new string[iCount];
            string[] aFieldP = new string[iCount];

            string[] aField_Received = new string[iCount];
            string[] aField_Invoiced = new string[iCount];
            string[] aField_Start = new string[iCount];


            string[] aField8 = new string[iCount];
            string[] aLink = new string[iCount];

            int tIndex = 0;
            string CurrBranch = "";
            string LastBranch = "";
            string cNumber = "";
            string vTranType = "";
            string iType = "";
            string cName = "";
            string cEmail = "";
            string cStatus = "";
            string bID = "";

            reader = Cmd.ExecuteReader();

            /////////////////////////Read Detailed Information for the Child Table////////////////
            while (reader.Read())
            {
                CurrBranch = reader["elt_account_number"].ToString();//<-get current ELT account for each loop

                // 만일 모든 브랜치의 정보를 원하고 테이블이 처음 시작되는 것이면
                if (nBranch == "0" && tIndex == 0)
                {
                    aField0[tIndex] = CurrBranch;
                    tIndex += 1;
                    LastBranch = CurrBranch;
                }

                cName = reader["Customer_Name"].ToString().Trim();
                cNumber = reader["Customer_Number"].ToString();
                cEmail = reader["email"].ToString();
                cStatus = reader["status"].ToString();

                if (int.Parse(cNumber) > 300000) { cNumber = "0"; }

                //1)새로운 손님을 다루거나 혹은 2)모든 브랜치의 정보를 원하고 새브랜치를 다루면
                if ((LastCustomer != reader["Customer_Number"].ToString().Trim()) || (nBranch == "0" && CurrBranch != LastBranch))
                {
                    //1) 특정한 브랜치 만을 다루고, 첫번째 줄이 아니면 2) 모든 브랜치를 다루고 두번째 줄 이 아니면
                    // 특정한 브랜치일 때 첫번째 줄은? / 모든 브랜치를 다루고 두번째 줄은?               
                    if ((tIndex != 0 && nBranch != "0") || (tIndex != 1 && nBranch == "0"))
                    {
                        aField5[tIndex] = "Sub Total";
                        aField6[tIndex] = vSubTotal.ToString(); // 그 전 손님의 합계를 저장                        
                        aField7[tIndex] = aField7[tIndex - 1];

                        //
                        aField_Invoiced[tIndex] = DebitTotal.ToString();
                        aField_Received[tIndex] = CreditTotal.ToString();
                        aField_Start[tIndex] = vStart.ToString();
                        //
                        vTotalBalance = vTotalBalance + double.Parse(vSubBal.ToString());
                        tIndex = tIndex + 2;
                    }

                    if (nBranch == "0" && CurrBranch != LastBranch)
                    {
                        aField0[tIndex] = CurrBranch;
                        tIndex = tIndex + 1;
                        LastBranch = CurrBranch;
                    }


                    aField1[tIndex] = cName;
                    aFieldN[tIndex] = cNumber;
                    aFieldM[tIndex] = cEmail;
                    aFieldO[tIndex] = cStatus;
                    aFieldP[tIndex] = reader["file_no"].ToString();

                    LastCustomer = cNumber;

                    vSubTotal = DebitTotal = CreditTotal = vStart = 0;
                    if (reader["Type"].ToString() == "SSS")
                    {
                        vSubBal = 0;
                        vSubBal = Double.Parse(reader["balance"].ToString());
                        aField7[tIndex] = vSubBal.ToString();
                        aField_Start[tIndex] = vSubBal.ToString();
                        vStart = vSubBal;
                        if (aField7[tIndex] == "") { aField7[tIndex] = "0"; }
                        tIndex += 1;
                        continue;
                    }
                    else
                    {
                        vSubBal = 0;
                    }

                }
                else
                {
                    aFieldP[tIndex] = reader["file_no"].ToString();
                }


                vTranType = reader["Type"].ToString();
                iType = reader["Air_Ocean"].ToString();

                if (vTranType != "INIT")
                {
                    aField2[tIndex] = vTranType;
                    aField3[tIndex] = String.Format("{0:MM/dd/yyyy}", reader["Date"]);
                    aField4[tIndex] = reader["Num"].ToString();
                    Debit = double.Parse(reader["debit_amount"].ToString());
                    Credit = double.Parse(reader["credit_amount"].ToString());

                    aField_Received[tIndex] = Credit.ToString();
                    if (aField_Received[tIndex].ToString().Trim().Equals("")) aField_Received[tIndex] = "0";
                    aField_Invoiced[tIndex] = Debit.ToString();
                    if (aField_Invoiced[tIndex].ToString().Trim().Equals("")) aField_Invoiced[tIndex] = "0";


                    aField6[tIndex] = (Debit + Credit).ToString();

                    vSubTotal = vSubTotal + double.Parse(aField6[tIndex]);
                    DebitTotal = DebitTotal + double.Parse(aField_Invoiced[tIndex]);
                    CreditTotal = CreditTotal + double.Parse(aField_Received[tIndex]);

                    vSubBal = vSubBal + double.Parse(aField6[tIndex]);

                    aField7[tIndex] = vSubBal.ToString();
                    vTotal = vTotal + double.Parse(aField6[tIndex]);

                    aField8[tIndex] = reader["Memo"].ToString();

                    if (aField2[tIndex] == "PMT")
                    {
                        if (CurrBranch != elt_account_number)
                        {
                            aLink[tIndex] = "/ASP/acct_tasks/receiv_pay.asp?PaymentNo=" + aField4[tIndex] + "&Branch=" + CurrBranch + "&BCustomer=" + cName;
                        }
                        else
                        {
                            aLink[tIndex] = "/ASP/acct_tasks/receiv_pay.asp?PaymentNo=" + aField4[tIndex];
                        }
                    }
                    else if (aField2[tIndex] == "GJE")
                    {
                        aLink[tIndex] = "/ASP/acct_tasks/gj_entry.asp?View=yes&EntryNo=" + aField4[tIndex];
                    }
                    else if (aField2[tIndex] == "DEPOSIT")
                    {
                        aLink[tIndex] = "../../Accounting/BankDeposit.aspx?EntryNo=" + aField4[tIndex];
                    }
                    else if (aField2[tIndex] == "INV")
                    {
                        if (CurrBranch != elt_account_number)
                        {

                            aLink[tIndex] = "/ASP/acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" + aField4[tIndex] + "&Branch=" + CurrBranch;
                        }
                        else
                        {

                            aLink[tIndex] = "/ASP/acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" + aField4[tIndex];
                        }
                    }
                    else if (aField2[tIndex] == "ARN")
                    {
                        if (iType == "A")
                        {
                            aLink[tIndex] = "/ASP/air_import/arrival_notice.asp?iType=A&edit=yes&InvoiceNo=" + aField4[tIndex];
                        }
                        else
                        {
                            aLink[tIndex] = "/ASP/ocean_import/arrival_notice.asp?iType=O&edit=yes&InvoiceNo=" + aField4[tIndex];
                        }
                        if (CurrBranch != elt_account_number) { aLink[tIndex] += "&Branch=" + CurrBranch; }

                    }
                    tIndex += 1;
                }


            }//<----------------------end of while 

            reader.Close();
            Con.Close();

            aField5[tIndex] = "Sub Total";
            aField6[tIndex] = vSubTotal.ToString();
            aField_Invoiced[tIndex] = DebitTotal.ToString();
            aField_Received[tIndex] = CreditTotal.ToString();
            aField_Start[tIndex] = vStart.ToString();


            if (tIndex > 0)
            {
                aField7[tIndex] = aField7[tIndex - 1];
            }
            else
            {
                aField7[tIndex] = "0";
            }

            vTotalBalance = vTotalBalance + double.Parse(vSubBal.ToString());

            bool viewChild = performMAXRecords(tIndex, 2000);

            // DataTable

            #region // Parent table

            DataTable dt = new DataTable(ParentTable);

            DataRow dr;

            dt.Columns.Add(new DataColumn("elt_account_number", typeof(string)));
            dt.Columns.Add(new DataColumn(keyColName, typeof(string)));

            dt.Columns.Add(new DataColumn("Start", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("Invoiced", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("Received", typeof(System.Decimal)));

            dt.Columns.Add(new DataColumn("Amount", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("Balance", typeof(System.Decimal)));

            dt.Columns.Add(new DataColumn("To_do", typeof(string)));
            dt.Columns.Add(new DataColumn("Customer_Number", typeof(string)));

            bool dispOK = false;
            int itemIndex = 0;

            for (int i = 0; i <= tIndex; i++)
            {


                if (aField0[i] != null)
                {
                    if (nBranch == "0")
                    {
                        CurrBranch = aField0[i];
                    }
                    else
                    {
                        CurrBranch = "";
                    }

                }

                if (aField1[i] != null)
                {
                    cName = aField1[i];
                    cNumber = aFieldN[i];
                    cEmail = aFieldM[i];
                    cStatus = aFieldO[i];
                }

                if (cName != "" && (aField7[i] != null || aField6[i] != null))
                {
                    if (aField6[i] == null) aField6[i] = "0";
                    if (aField7[i] == null) aField7[i] = "0";

                    //  dispOK = true;

                    if (aField5[i] == "Sub Total")
                    {
                        dr = dt.NewRow();
                        dr[0] = CurrBranch;
                        dr[1] = cName;
                        dr[8] = cNumber;

                        if (aField_Start[i] != null) dr[2] = double.Parse(aField_Start[i]);
                        if (aField_Invoiced[i] != null) dr[3] = double.Parse(aField_Invoiced[i]);
                        if (aField_Received[i] != null) dr[4] = double.Parse(aField_Received[i]);

                        if (aField6[i] != null) dr[5] = double.Parse(aField6[i]);
                        if (aField7[i] != null) dr[6] = double.Parse(aField7[i]);

                        if (cNumber == "0" || (cName.Length > 6 && cName.Substring(0, 7) == "_Fiscal"))
                        {
                            dr[7] = "";
                        }
                        else
                        {
                            if (cEmail != null && cEmail.Trim() != "")
                            {
                                dr[7] = "";
                                // Email Function by Joon //////////////////////////////////////////////////
                                dr[7] = "<input type=\"checkbox\" style=\"height:14px; width:14px\" class=\"bodycopy\" name=\"sendItems\" value=\"" + cNumber + "\" />"
                                        + "<input type=\"text\" style=\"height:16px; width:0px; visibility:hidden\" class=\"bodycopy\" name=\"sendMessages\" />"

                                        + "&nbsp;&nbsp;<input type=\"image\" name=\"OneEMAIL\" style=\"height:12px; cursor:hand\" src=\"../../../Images/button_email_ig.gif\" border=\"0\" onclick=\"return SendOneEmail(" + itemIndex + ");\"/>"
                                        + "&nbsp;&nbsp;<input type=\"text\" style=\"height:16px; width:120px; border:none; background-color:transparent \" class=\"bodycopy\" name=\"sendStatus\" value=\"" + cStatus + "\" ReadOnly=\"ReadOnly\" />"
                                        + "<input type=\"hidden\" name=\"sendEmails\" value=\"" + cEmail + "\" />";

                                ////////////////////////////////////////////////////////////////////////////
                                itemIndex++;
                            }
                            else
                            {
                                dr[7] = "";
                            }
                        }
                        dt.Rows.Add(dr);
                        dispOK = false;
                    }
                }
            }

            ds.Tables.Add(dt);

            #endregion

            if (!viewChild) return;

            # region // Child table
            DataTable cdt = new DataTable(ChildTable);
            DataRow cdr;

            cdt.Columns.Add(new DataColumn("elt_account_number", typeof(string)));
            cdt.Columns.Add(new DataColumn(keyColName, typeof(string)));
            cdt.Columns.Add(new DataColumn("Type", typeof(string)));
            cdt.Columns.Add(new DataColumn("Date", typeof(string)));
            cdt.Columns.Add(new DataColumn("Num", typeof(string)));
            cdt.Columns.Add(new DataColumn("Memo", typeof(string)));
            cdt.Columns.Add(new DataColumn("Account", typeof(string)));

            cdt.Columns.Add(new DataColumn("Start", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Invoiced", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Received", typeof(System.Decimal)));

            cdt.Columns.Add(new DataColumn("Amount", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Balance", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Link", typeof(string)));
            cdt.Columns.Add(new DataColumn("Customer_number", typeof(string)));
            cdt.Columns.Add(new DataColumn("File No.", typeof(string)));

            for (int i = 0; i <= tIndex; i++)
            {
                if (aField0[i] != null)
                {
                    if (nBranch == "0")
                    {
                        CurrBranch = aField0[i];
                    }
                    else
                    {
                        CurrBranch = "";
                    }

                }

                if (aField1[i] != null)
                {
                    cName = aField1[i];
                    cNumber = aFieldN[i];
                }

                if (cName.Length > 7)
                {
                    if (cName.Substring(0, 7) == "_Fiscal")
                    {
                        continue;
                    }
                }
                if (aField5[i] != "Sub Total" && cName != "" && (aField7[i] != null || aField6[i] != null))
                {

                    if (aField6[i] == null) aField6[i] = "0";
                    if (aField7[i] == null) aField7[i] = "0";

                    cdr = cdt.NewRow();
                    cdr[0] = CurrBranch;
                    cdr[1] = cName;
                    cdr[2] = (aField2[i] == null ? "" : aField2[i]);
                    if (aField3[i] != null) cdr[3] = aField3[i];
                    cdr[4] = (aField4[i] == null ? "" : aField4[i]);
                    cdr[5] = (aField8[i] == null ? "" : aField8[i]);
                    cdr[6] = (aField5[i] == null ? "" : aField5[i]);

                    cdr[7] = (aField_Start[i] == null && aField_Start[i] != "0" ? double.Parse("0.00") : double.Parse(aField_Start[i]));

                    cdr[8] = (aField_Invoiced[i] == null ? double.Parse("0.00") : double.Parse(aField_Invoiced[i]));

                    cdr[9] = (aField_Received[i] == null ? double.Parse("0.00") : double.Parse(aField_Received[i]));


                    if (aField6[i] != null) cdr[10] = double.Parse(aField6[i]);
                    if (aField7[i] != null) cdr[11] = double.Parse(aField7[i]);
                    cdr[12] = (aLink[i] == null ? "" : aLink[i]);
                    cdr[13] = cNumber;
                    cdr[14] = aFieldP[i];
                    cdt.Rows.Add(cdr);
                }
            }

            ds.Tables.Add(cdt);
            #endregion


            add_total2();


            if (nBranch != "0")
            {
                DataColumn[] relComsP = new DataColumn[2];
                DataColumn[] relComsC = new DataColumn[2];

                relComsP[0] = ds.Tables[ParentTable].Columns["Customer_Number"];
                relComsP[1] = ds.Tables[ParentTable].Columns[keyColName];
                relComsC[0] = ds.Tables[ChildTable].Columns["Customer_Number"];
                relComsC[1] = ds.Tables[ChildTable].Columns[keyColName];

                if (ds.Relations.Count < 1) ds.Relations.Add(relComsP, relComsC);
            }
            else
            {
                DataColumn[] relComsP = new DataColumn[3];
                DataColumn[] relComsC = new DataColumn[3];

                relComsP[0] = ds.Tables[ParentTable].Columns["elt_account_number"];
                relComsP[1] = ds.Tables[ParentTable].Columns["Customer_Number"];
                relComsP[2] = ds.Tables[ParentTable].Columns[keyColName];
                relComsC[0] = ds.Tables[ChildTable].Columns["elt_account_number"];
                relComsC[1] = ds.Tables[ChildTable].Columns["Customer_Number"];
                relComsC[2] = ds.Tables[ChildTable].Columns[keyColName];

                if (ds.Relations.Count < 1) ds.Relations.Add(relComsP, relComsC);
            }


            
        }
        private void PerformGetDataARSumm(string strCommandText, string strCommandDetailText)
        {
            ConnectStr = GetConnectionString(AppConstants.DB_CONN_PROD);
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand cmdHeader = new SqlCommand();
            SqlCommand cmdDetail = new SqlCommand();

            cmdHeader.Connection = Con;
            cmdDetail.Connection = Con;

            SqlDataAdapter Adap = new SqlDataAdapter();
            Con.Open();

            if (strCommandText != "")
            {
                cmdHeader.CommandText = strCommandText;
                Adap.SelectCommand = cmdHeader;
                Adap.Fill(ds, ParentTable);
            }

            if (strCommandDetailText != "")
            {
                cmdDetail.CommandText = strCommandDetailText;
                Adap.SelectCommand = cmdDetail;
                Adap.Fill(ds, ChildTable);
            }

            Con.Close();

            add_total("Balance", ParentTable);

        }
        private void PerformGetDataAPSumm(string strCommandText, string strCommandDetailText)
        {
            ConnectStr = GetConnectionString(AppConstants.DB_CONN_PROD);
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand cmdHeader = new SqlCommand();
            SqlCommand cmdDetail = new SqlCommand();

            cmdHeader.Connection = Con;
            cmdDetail.Connection = Con;

            SqlDataAdapter Adap = new SqlDataAdapter();
            Con.Open();

            if (strCommandText != "")
            {
                cmdHeader.CommandText = strCommandText;
                Adap.SelectCommand = cmdHeader;
                Adap.Fill(ds, ParentTable);
            }

            if (strCommandDetailText != "")
            {
                cmdDetail.CommandText = strCommandDetailText;
                Adap.SelectCommand = cmdDetail;
                Adap.Fill(ds, ChildTable);
            }

            Con.Close();

        }
        private void PerformGetData(string strCommandText, string strCommandDetailText)
        {
            ConnectStr = GetConnectionString(AppConstants.DB_CONN_PROD);
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand cmdHeader = new SqlCommand(strCommandText, Con);
            SqlCommand cmdDetail = new SqlCommand(strCommandDetailText, Con);
            SqlDataAdapter Adap = new SqlDataAdapter();

            Con.Open();

            Adap.SelectCommand = cmdHeader;
            Adap.Fill(ds, ParentTable);

            Adap.SelectCommand = cmdDetail;
            Adap.Fill(ds, ChildTable);

            Con.Close();


        }
        private void add_total(string amount_field, string tableName)// adding a row to a parent table 
        {
            double cumulative_total = 0;
            double fiscal_total = 0;
            string tmpCus = "";

            foreach (DataRow eRow in ds.Tables[tableName].Rows)
            {


                tmpCus = eRow["Customer_Name"].ToString();
                try
                {
                    if (tmpCus.Length > 7 && tmpCus != null)
                    {
                        if (tmpCus.Substring(0, 7) == "_Fiscal")
                        {
                            cumulative_total = cumulative_total + double.Parse(eRow[amount_field].ToString());
                            continue;
                        }
                    }
                    fiscal_total = fiscal_total + double.Parse(eRow[amount_field].ToString());
                }
                catch (Exception ex)
                {
                  

                }
            }

            //DataRow aRow = ds.Tables[ParentTable].NewRow();
            //aRow["Customer_Name"] = " Total ";
            //aRow[amount_field] = fiscal_total;
            //ds.Tables[ParentTable].Rows.Add(aRow);// adding a row to a parent table 

            //aRow = ds.Tables[ParentTable].NewRow();
            //aRow["Customer_Name"] = " Cumulative Total ";
            //aRow[amount_field] = cumulative_total + fiscal_total;
            //ds.Tables[ParentTable].Rows.Add(aRow);
        }
        private void add_total2()// adding a row to a parent table 
        {
            string tableName = "HEADER";
            string tmpCus = "";

            double inv_total = 0;
            double rec_total = 0;
            double start_total = 0;

            double cum_inv = 0;
            double cum_rec = 0;

            double tmpValue0 = 0;
            double tmpValue1 = 0;
            double tmpValue2 = 0;

            foreach (DataRow eRow in ds.Tables[tableName].Rows)
            {
                tmpCus = eRow["Customer_Name"].ToString();

                tmpValue0 = double.Parse(eRow["Start"].ToString());
                tmpValue1 = double.Parse(eRow["Invoiced"].ToString());
                tmpValue2 = double.Parse(eRow["Received"].ToString());

                if (tmpCus.Length > 7 && tmpCus.Substring(0, 7) == "_Fiscal")
                {
                    cum_inv += tmpValue1;
                    cum_rec += tmpValue2;
                }
                else
                {
                    start_total += tmpValue0;
                    inv_total += tmpValue1;
                    rec_total += tmpValue2;
                }

            }

            DataRow aRow = ds.Tables[ParentTable].NewRow();
            aRow["Customer_Name"] = " Total ";
            aRow["Start"] = start_total;
            aRow["Invoiced"] = inv_total;
            aRow["Received"] = rec_total;
            aRow["Balance"] = start_total + inv_total + rec_total;
            ds.Tables[ParentTable].Rows.Add(aRow);
            aRow = ds.Tables[ParentTable].NewRow();
            aRow["Customer_Name"] = " Cumulative Total ";
            aRow["Invoiced"] = inv_total + cum_inv;
            aRow["Received"] = rec_total + cum_rec;
            aRow["Balance"] = inv_total + cum_inv + rec_total + cum_rec;
            ds.Tables[ParentTable].Rows.Add(aRow);
        }
        private void add_total3()
        {
            string tableName = "HEADER";
            string tmpCus = "";
            double tmpValue0 = 0;
            double tmpValue1 = 0;

            double paid_total = 0;
            double billed_total = 0;

            double grand_paid = 0;
            double grand_billed = 0;

            double cum_paid = 0;
            double cum_billed = 0;

            int rowCount = 0;
            double startBalance = 0;

            foreach (DataRow eRow in ds.Tables[tableName].Rows)
            {
                tmpCus = eRow["Customer_Name"].ToString();

                try
                {
                    tmpValue0 = double.Parse(eRow["Paid"].ToString());
                }
                catch
                {
                    tmpValue0 = 0;
                }
                try
                {

                    tmpValue1 = double.Parse(eRow["Billed"].ToString());
                }
                catch
                {
                    tmpValue1 = 0;
                }


                if (tmpCus.Length > 7 && tmpCus.Substring(0, 7) == "_Fiscal")
                {
                    cum_paid += tmpValue0;
                    cum_billed += tmpValue1;
                }
                else
                {
                    if (tmpCus != "Posted Transactions Total" && tmpCus != "Unposted Transactions Total" && tmpCus != "Grand Total" && tmpCus != "Cumulative Total")
                    {
                        paid_total += tmpValue0;
                        billed_total += tmpValue1;
                        grand_paid += tmpValue0;
                        grand_billed += tmpValue1;
                    }
                }


                if (tmpCus == "Posted Transactions Total" || tmpCus == "Unposted Transactions Total")
                {
                    ds.Tables["HEADER"].Rows[rowCount]["Paid"] = paid_total;
                    ds.Tables["HEADER"].Rows[rowCount]["Billed"] = billed_total;
                    startBalance = double.Parse(ds.Tables["HEADER"].Rows[rowCount]["Start"].ToString());
                    ds.Tables["HEADER"].Rows[rowCount]["Balance"] = startBalance + paid_total + billed_total;
                    paid_total = 0;
                    billed_total = 0;
                }
                else if (tmpCus == "Grand Total")
                {
                    ds.Tables["HEADER"].Rows[rowCount]["Paid"] = grand_paid;
                    ds.Tables["HEADER"].Rows[rowCount]["Billed"] = grand_billed;
                    startBalance = double.Parse(ds.Tables["HEADER"].Rows[rowCount]["Start"].ToString());
                    ds.Tables["HEADER"].Rows[rowCount]["Balance"] = startBalance + grand_paid + grand_billed;
                }
                else if (tmpCus == "Cumulative Total")
                {
                    ds.Tables["HEADER"].Rows[rowCount]["Paid"] = cum_paid + grand_paid;
                    ds.Tables["HEADER"].Rows[rowCount]["Billed"] = cum_billed + grand_billed;
                    startBalance = double.Parse(ds.Tables["HEADER"].Rows[rowCount]["Start"].ToString());
                    ds.Tables["HEADER"].Rows[rowCount]["Balance"] = startBalance + cum_paid + cum_billed + grand_paid + grand_billed;
                }

                rowCount++;
            }
        }
        private int performDetailDataRefine()
        {

            string tmpkey = "";
            double tmpBalance = 0;
            int iCnt = 0;
            if (strCode == "sales")
            {

                foreach (DataRow eRow in ds.Tables[ChildTable].Rows)
                {
                    iCnt++;
                    if (tmpkey != eRow["Customer_Name"].ToString().Trim())
                    {
                        tmpkey = eRow["Customer_Name"].ToString().Trim();
                        tmpBalance = 0;
                    }

                    tmpBalance = double.Parse(eRow["Amount"].ToString()) + tmpBalance;
                    eRow["Balance"] = tmpBalance;

                    if (eRow["Type"].ToString() == "CM")
                    {
                        eRow["Link"] = "/ASP/acct_tasks/receive_pay.asp?PaymentNo=" + eRow["Num"].ToString();
                    }
                    else
                    {
                        if (eRow["Type"].ToString() == "ARN")
                        {
                            string iType = eRow["air_ocean"].ToString();
                            if (iType == "") iType = "O";
                            if (iType == "A")
                            {
                                eRow["Link"] = "/ASP/air_import/arrival_notice.asp?iType=A&edit=yes&InvoiceNo=" + eRow["Num"].ToString();
                            }
                            else
                            {
                                eRow["Link"] = "/ASP/ocean_import/arrival_notice.asp?iType=O&edit=yes&InvoiceNo=" + eRow["Num"].ToString();
                            }
                        }
                        else
                        {
                            eRow["Link"] = "/ASP/acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" + eRow["Num"].ToString();
                        }
                        if (elt_account_number != eRow["elt_account_number"].ToString())
                        {
                            eRow["Link"] += "&Branch=" + eRow["elt_account_number"].ToString();
                        }
                    }
                }

                add_total("Amount", ParentTable);
            }
            else
            {
                foreach (DataRow eRow in ds.Tables[ChildTable].Rows)
                {
                    iCnt++;
                    if (tmpkey != eRow["Customer_Name"].ToString().Trim())
                    {
                        tmpkey = eRow["Customer_Name"].ToString().Trim();
                        tmpBalance = 0;
                    }

                    tmpBalance = double.Parse(eRow["Amount"].ToString()) + tmpBalance;
                    eRow["Balance"] = tmpBalance;

                    if (eRow["Type"].ToString() == "CM")
                    {
                        eRow["Link"] = "/ASP/acct_tasks/receive_pay.asp?PaymentNo=" + eRow["Num"].ToString();
                    }
                    else
                    {
                        eRow["Link"] = "/ASP/acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" + eRow["Num"].ToString();
                    }

                    if (elt_account_number != eRow["elt_account_number"].ToString())
                    {
                        eRow["Link"] += "&Branch=" + elt_account_number;
                    }
                }
            }

            return iCnt;
        }
        private void PerformARAgingRecords()
        {
            string[] str = new string[4];
            string strCommandText;
            string strlblBranch;
            strCommandText = HttpContext.Current.Session["strCommandText"].ToString();
            strlblBranch = HttpContext.Current.Session["strlblBranch"].ToString();
            string strBranch = HttpContext.Current.Session["strBranch"].ToString();  
            str[0] = HttpContext.Current.Session["Accounting_sPeriod"].ToString();
            str[1] = HttpContext.Current.Session["Accounting_sBranchName"].ToString();
            str[2] = HttpContext.Current.Session["Accounting_sBranch_elt_account_number"].ToString();
            str[3] = HttpContext.Current.Session["Accounting_sCompanName"].ToString();

            for (int i = 0; i < str.Length - 1; i++)
            {
                if (str[i + 1] != "") str[i] = str[i] + "/";
            }
            PerformGetARData(strCommandText, strBranch);
        }
        private void PerformGetARData(string strCommandText, string strBranch)
        {
            ConnectStr = GetConnectionString(AppConstants.DB_CONN_PROD);
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Con.Open();
            Cmd.CommandText = strCommandText;
            SqlDataReader reader = Cmd.ExecuteReader();
            double
                sTotalCurrent = 0,
                sTotal1_30 = 0,
                sTotal31_60 = 0,
                sTotal61_90 = 0,
                sTotal91 = 0,
                sTotal = 0,

                sCurrent = 0,
                s1_30 = 0,
                s31_60 = 0,
                s61_90 = 0,
                s91 = 0,
                sSubTotal = 0;

            string vLastName = "", cName = "", cPhone = "", cCredit = "", vLastCredit = "";
            string vLastCompanyName = "", cCompanyName = "", vLastPhone = "";
            int tIndex = 0;
            int bIndex = 0;

            int iCount = 0;
            while (reader.Read()) { iCount++; };
            reader.Close();

            string[,] aField = new string[10, iCount];
            string[,] bField = new string[19, iCount];

            reader = Cmd.ExecuteReader();

            while (reader.Read())
            {
                #region // Parent logic

                cName = reader["customer_no"].ToString().Trim();
                cCompanyName = reader["customer_dba_name"].ToString().Trim();
                cPhone = reader["business_phone"].ToString().Trim();
                cCredit = reader["customer_credit"].ToString().Trim();

                if (bIndex == 0)
                {
                    vLastName = cName;
                    vLastCompanyName = cCompanyName;
                    vLastPhone = cPhone;
                    vLastCredit = cCredit;
                }

                if (cName != vLastName)
                {
                    aField[0, tIndex] = vLastName;
                    aField[1, tIndex] = sTotalCurrent.ToString();
                    aField[2, tIndex] = sTotal1_30.ToString();
                    aField[3, tIndex] = sTotal31_60.ToString();
                    aField[4, tIndex] = sTotal61_90.ToString();
                    aField[5, tIndex] = sTotal91.ToString();
                    aField[6, tIndex] = sTotal.ToString();
                    aField[7, tIndex] = vLastCompanyName;
                    aField[8, tIndex] = vLastPhone;
                    aField[9, tIndex] = vLastCredit;

                    vLastName = cName;
                    vLastCompanyName = cCompanyName;
                    vLastPhone = cPhone;
                    vLastCredit = cCredit;

                    tIndex += 1;
                    sTotalCurrent = 0;
                    sTotal1_30 = 0;
                    sTotal31_60 = 0;
                    sTotal61_90 = 0;
                    sTotal91 = 0;
                    sTotal = 0;
                }

                string vInvoiceType = reader["invoice_type"].ToString();
                string vTerm = reader["term_curr"].ToString();
                if (vTerm == "")
                {
                    vTerm = "0";
                }

                DateTime vInvoiceDate;
                double vBalance;

                if (reader["invoice_no"].ToString() == string.Empty)
                {
                    vInvoiceDate = DateTime.Now;
                    vBalance = double.Parse(reader["customer_credit"].ToString());
                }
                else
                {
                    vInvoiceDate = DateTime.Parse(reader["invoice_date"].ToString());
                    vBalance = double.Parse(reader["balance"].ToString());
                }

                //DateTime d1 = DateTime.Now;
                DateTime d1 = DateTime.Parse(HttpContext.Current.Session["AsOf"].ToString());

                TimeSpan days = new TimeSpan(int.Parse(vTerm), 0, 0, 0, 0);
                TimeSpan vAging = d1 - (vInvoiceDate + days);

                if (vAging.Days <= 0)
                {
                    if (reader["invoice_no"].ToString() != string.Empty)
                    {
                        sTotalCurrent = sTotalCurrent + vBalance;
                    }
                    sTotal = sTotal + vBalance;
                    // vTotalCurrent=vTotalCurrent+vBalance;
                }
                else if (vAging.Days > 0 && vAging.Days < 31)
                {
                    sTotal1_30 = sTotal1_30 + vBalance;
                    sTotal = sTotal + vBalance;
                    // vTotal1_30=vTotal1_30+vBalance;
                }
                else if (vAging.Days > 30 && vAging.Days < 61)
                {
                    sTotal31_60 = sTotal31_60 + vBalance;
                    sTotal = sTotal + vBalance;
                    // vTotal31_60=vTotal31_60+vBalance;
                }
                else if (vAging.Days > 60 && vAging.Days < 91)
                {
                    sTotal61_90 = sTotal61_90 + vBalance;
                    sTotal = sTotal + vBalance;
                    // vTotal61_90=vTotal61_90+vBalance;
                }
                else if (vAging.Days > 90)
                {
                    sTotal91 = sTotal91 + vBalance;
                    sTotal = sTotal + vBalance;
                    // vTotal91=vTotal91+vBalance;
                }

                if ((bIndex + 1) == iCount)  // end of reader
                {
                    aField[0, tIndex] = cName;
                    aField[1, tIndex] = sTotalCurrent.ToString();
                    aField[2, tIndex] = sTotal1_30.ToString();
                    aField[3, tIndex] = sTotal31_60.ToString();
                    aField[4, tIndex] = sTotal61_90.ToString();
                    aField[5, tIndex] = sTotal91.ToString();
                    aField[6, tIndex] = sTotal.ToString();
                    aField[7, tIndex] = cCompanyName;
                    aField[8, tIndex] = cPhone;
                    aField[9, tIndex] = cCredit;

                    tIndex += 1;  // for using transfer to DataTable below
                }

                #endregion

                // Detail Info. : Refer from original program...I hate this kind of logic.... 
                // (by iMoon...)

                sCurrent = 0;
                s1_30 = 0;
                s31_60 = 0;
                s61_90 = 0;
                s91 = 0;
                sSubTotal = 0;

                bField[0, bIndex] = cName;
                bField[18, bIndex] = cCompanyName;
                bField[2, bIndex] = vInvoiceDate.ToShortDateString();
                bField[3, bIndex] = reader["invoice_no"].ToString();
                bField[4, bIndex] = reader["ref_no"].ToString();

                if (vInvoiceType != "P")
                {
                    bField[5, bIndex] = ((DateTime)(vInvoiceDate + days)).ToShortDateString();
                }

                if ((vAging.Days > 0) && (vInvoiceType != "P"))
                {
                    bField[6, bIndex] = vAging.Days.ToString();
                }

                bField[7, bIndex] = vBalance.ToString();

                if (vInvoiceType == "P")
                {
                    bField[7, bIndex] = (-1 * vBalance).ToString();
                }

                if (vAging.Days <= 0)
                {
                    sCurrent = vBalance;
                    sSubTotal = vBalance;
                }
                else if (vAging.Days > 0 && vAging.Days < 31)
                {
                    s1_30 = vBalance;
                    sSubTotal = vBalance;
                }
                else if (vAging.Days > 30 && vAging.Days < 61)
                {
                    s31_60 = vBalance;
                    sSubTotal = vBalance;
                }
                else if (vAging.Days > 60 && vAging.Days < 91)
                {
                    s61_90 = vBalance;
                    sSubTotal = vBalance;
                }
                else if (vAging.Days > 90)
                {
                    s91 = vBalance;
                    sSubTotal = vBalance;
                }

                bField[8, bIndex] = sCurrent.ToString();
                bField[9, bIndex] = s1_30.ToString();
                bField[10, bIndex] = s31_60.ToString();
                bField[11, bIndex] = s61_90.ToString();
                bField[12, bIndex] = s91.ToString();
                bField[13, bIndex] = sSubTotal.ToString();



                string vEI = reader["import_export"].ToString();
                string iType = reader["air_ocean"].ToString();

                string vAirOcean = reader["air_ocean"].ToString();
                string vImportExport = reader["import_export"].ToString();
                string vHouseNumber = reader["hawb_num"].ToString();
                string vMasterNumber = reader["mawb_num"].ToString();
                string vInvoiceNo = reader["invoice_no"].ToString();

                switch (vInvoiceType)
                {
                    case "P":
                        break;
                    case "I":
                        if (vAirOcean == "A" && vImportExport == "I")
                        {
                            bField[1, bIndex] = "ARN";
                        }
                        else if (vAirOcean == "O" && vImportExport == "I")
                        {
                            bField[1, bIndex] = "ARN";
                        }
                        else if (double.Parse(bField[13, bIndex]) < 0)
                        {
                            bField[1, bIndex] = "CRN";
                        }
                        else
                        {
                            bField[1, bIndex] = "INV";
                        }
                        break;
                    case "G":
                        bField[1, bIndex] = "GJE";
                        break;
                    default:
                        if (reader["customer_credit"].ToString() != string.Empty)
                        {
                            bField[1, bIndex] = "CRD";
                        }
                        else
                        {
                            bField[1, bIndex] = "PMT";
                        }
                        break;
                }

                bField[15, bIndex] = vTerm;
                bField[16, bIndex] = vHouseNumber;
                bField[17, bIndex] = vAirOcean + vImportExport;

                bIndex += 1;
            }

            reader.Close();

            Con.Close();

            // DataTable

            #region // Parent table

            DataTable dt = new DataTable(ParentTable);
            DataRow dr;

            dt.Columns.Add(new DataColumn(keyColName, typeof(string)));
            dt.Columns.Add(new DataColumn("Current", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("1~30", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("31~60", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("61~90", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("+90", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("Total", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("Company Name", typeof(string)));
            dt.Columns.Add(new DataColumn("Phone", typeof(string)));
            dt.Columns.Add(new DataColumn("Credit", typeof(System.Decimal)));

            for (int i = 0; i < tIndex; i++)
            {
                if (aField[0, i] == null) break;

                dr = dt.NewRow();
                dr[0] = aField[0, i];
                dr[1] = aField[1, i];
                dr[2] = aField[2, i];
                dr[3] = aField[3, i];
                dr[4] = aField[4, i];
                dr[5] = aField[5, i];
                dr[6] = aField[6, i];
                dr[7] = aField[7, i];
                dr[8] = aField[8, i];
                dr[9] = aField[9, i];

                if (dr[0].ToString() != string.Empty) dt.Rows.Add(dr);
            }


            ds.Tables.Add(dt);

            #endregion

            # region // Child table
            DataTable cdt = new DataTable(ChildTable);
            DataRow cdr;

            cdt.Columns.Add(new DataColumn(keyColName, typeof(string)));
            cdt.Columns.Add(new DataColumn("Type", typeof(string)));
            cdt.Columns.Add(new DataColumn("I/V Date", typeof(System.DateTime)));
            cdt.Columns.Add(new DataColumn("I/V No.", typeof(string)));
            cdt.Columns.Add(new DataColumn("House Type", typeof(string)));
            cdt.Columns.Add(new DataColumn("House No.", typeof(string)));
            cdt.Columns.Add(new DataColumn("Ref No.", typeof(string)));
            cdt.Columns.Add(new DataColumn("Due Date", typeof(System.DateTime)));
            cdt.Columns.Add(new DataColumn("Term", typeof(string)));
            cdt.Columns.Add(new DataColumn("Aging", typeof(string)));
            cdt.Columns.Add(new DataColumn("Open Balance", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Current", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("1~30", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("31~60", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("61~90", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("+90", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Total", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Company Name", typeof(string)));

            for (int i = 0; i < bIndex; i++)
            {
                if (bField[0, i] == null) break;

                cdr = cdt.NewRow();

                cdr[0] = bField[0, i];
                cdr[1] = bField[1, i];
                cdr[2] = bField[2, i];
                cdr[3] = bField[3, i];
                cdr[4] = bField[17, i];
                cdr[5] = bField[16, i];
                cdr[6] = bField[4, i];
                cdr[7] = bField[5, i];
                cdr[8] = bField[15, i];
                cdr[9] = bField[6, i];
                cdr[10] = bField[7, i];
                cdr[11] = bField[8, i];
                cdr[12] = bField[9, i];
                cdr[13] = bField[10, i];
                cdr[14] = bField[11, i];
                cdr[15] = bField[12, i];
                cdr[16] = bField[13, i];
                cdr[17] = bField[18, i];

                // Customer Credit
                if (bField[1, i] == "CRD")
                {
                    cdr[2] = DBNull.Value;
                    cdr[7] = DBNull.Value;
                    cdr[8] = DBNull.Value;
                    cdr[9] = DBNull.Value;
                    cdr[10] = DBNull.Value;
                    cdr[11] = DBNull.Value;
                }

                if (cdr[0].ToString() != string.Empty) cdt.Rows.Add(cdr);
            }

            ds.Tables.Add(cdt);


            #endregion


            if (ds.Relations.Count < 1)
                ds.Relations.Add(ds.Tables[ParentTable].Columns[keyColName], ds.Tables[ChildTable].Columns[keyColName]);
        }
        private void PerformAPAgingRecords()
        {
             
      
            string[] str = new string[7];
            string strCommandText, strCommandTextU;
            string strlblBranch;

            strCommandText = HttpContext.Current.Session["strCommandText"].ToString();
            strCommandTextU = HttpContext.Current.Session["strCommandTextU"].ToString();
            strlblBranch = HttpContext.Current.Session["strlblBranch"].ToString();
            string strBranch = HttpContext.Current.Session["strBranch"].ToString();

            str[0] = HttpContext.Current.Session["Accounting_sPeriod"].ToString();
            str[1] = HttpContext.Current.Session["Accounting_sBranchName"].ToString();
            str[2] = HttpContext.Current.Session["Accounting_sBranch_elt_account_number"].ToString();
            str[3] = HttpContext.Current.Session["Accounting_sCompanName"].ToString();

            for (int i = 0; i < str.Length - 1; i++)
            {
                if (str[i + 1] != "") str[i] = str[i] + "/";
            }

           
            dt.TableName = ParentTable;
            cdt.TableName = ChildTable;

            dt.Columns.Add(new DataColumn("vendor_name", typeof(string)));
            dt.Columns.Add(new DataColumn("Current", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("1~30", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("31~60", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("61~90", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("+90", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn("Total", typeof(System.Decimal)));
            dt.Columns.Add(new DataColumn(keyColName, typeof(string)));
            dt.Columns.Add(new DataColumn("telephone", typeof(string)));

            cdt.Columns.Add(new DataColumn("vendor_name", typeof(string)));
            cdt.Columns.Add(new DataColumn("Type", typeof(string)));
            cdt.Columns.Add(new DataColumn("Date", typeof(System.DateTime)));
            cdt.Columns.Add(new DataColumn("Doc.No.", typeof(string)));
            cdt.Columns.Add(new DataColumn("Ref No.", typeof(string)));
            cdt.Columns.Add(new DataColumn("Due Date", typeof(System.DateTime)));
            cdt.Columns.Add(new DataColumn("Aging", typeof(string)));
            cdt.Columns.Add(new DataColumn("Open Balance", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Current", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("1~30", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("31~60", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("61~90", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("+90", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Total", typeof(System.Decimal)));
            cdt.Columns.Add(new DataColumn("Link", typeof(string)));
            cdt.Columns.Add(new DataColumn(keyColName, typeof(string)));
            cdt.Columns.Add(new DataColumn("File No.", typeof(string)));

            PerformGetAPData(strCommandText, strBranch);
            if (strCommandTextU.Trim() != "")
            {
               
                PerformGetAPDataU(strCommandTextU, strBranch);
                DataTable tmpDt = new DataTable();
                DataRow tmpDr;
                tmpDt = dt.Clone();

                string uniqName = "", vendorNum = "";
                string expr = "";
                double Total_0, Total_1, Total_2, Total_3, Total_4, Total_5;

                foreach (DataRow eRow in dt.Select("", "vendor_name," + keyColName))
                {

                    if (vendorNum != eRow[keyColName].ToString())
                    {
                        uniqName = eRow["vendor_name"].ToString();
                        vendorNum = eRow[keyColName].ToString();

                        Total_0 = Total_1 = Total_2 = Total_3 = Total_4 = Total_5 = 0;
                        expr = keyColName + "=" + vendorNum;
                        try
                        {
                            foreach (DataRow eeRow in dt.Select(expr, "vendor_name," + keyColName))
                            {
                                Total_0 = Total_0 + double.Parse(eeRow[1].ToString());
                                Total_1 = Total_1 + double.Parse(eeRow[2].ToString());
                                Total_2 = Total_2 + double.Parse(eeRow[3].ToString());
                                Total_3 = Total_3 + double.Parse(eeRow[4].ToString());
                                Total_4 = Total_4 + double.Parse(eeRow[5].ToString());
                                Total_5 = Total_5 + double.Parse(eeRow[6].ToString());
                            }
                            tmpDr = tmpDt.NewRow();
                            tmpDr[0] = uniqName;
                            tmpDr[1] = Total_0;
                            tmpDr[2] = Total_1;
                            tmpDr[3] = Total_2;
                            tmpDr[4] = Total_3;
                            tmpDr[5] = Total_4;
                            tmpDr[6] = Total_5;
                            tmpDr[7] = vendorNum;
                            tmpDr[8] = eRow["telephone"].ToString();
                            tmpDt.Rows.Add(tmpDr);
                        }
                        catch(Exception ex)
                        {
                            throw ex;
                        }
                    }
                }
                tmpDt.TableName = ParentTable;
                ds.Tables.Add(tmpDt);
            }
            else
            {
                ds.Tables.Add(dt);
            }

            DataTable tmpcDt = new DataTable();
            DataRow tmpcDr;
            tmpcDt = cdt.Clone();

            foreach (DataRow eRow in cdt.Select("", keyColName + ",Date"))
            {
                tmpcDr = tmpcDt.NewRow();
                for (int i = 0; i < eRow.ItemArray.Length; i++)
                {
                    tmpcDr[i] = eRow[i];
                }
                tmpcDt.Rows.Add(tmpcDr);
            }

            tmpcDt.TableName = ChildTable;
            ds.Tables.Add(tmpcDt);

            DataColumn[] parentDataCols = new DataColumn[2];
            DataColumn[] childDataCols = new DataColumn[2];

            parentDataCols[0] = ds.Tables[ParentTable].Columns[keyColName];
            parentDataCols[1] = ds.Tables[ParentTable].Columns["vendor_name"];
            childDataCols[0] = ds.Tables[ChildTable].Columns[keyColName];
            childDataCols[1] = ds.Tables[ChildTable].Columns["vendor_name"];

            if (ds.Relations.Count < 1)
                ds.Relations.Add(parentDataCols, childDataCols);
        }
        private void PerformGetAPData(string strCommandText, string strBranch)
        {
            ConnectStr = GetConnectionString(AppConstants.DB_CONN_PROD);
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Con.Open();
            Cmd.CommandText = strCommandText;
            SqlDataReader reader = Cmd.ExecuteReader();

            //**********************************************// refer from old program logic

            double
                sTotalCurrent = 0,
                sTotal1_30 = 0,
                sTotal31_60 = 0,
                sTotal61_90 = 0,
                sTotal91 = 0,
                sTotal = 0,

                sCurrent = 0,
                s1_30 = 0,
                s31_60 = 0,
                s61_90 = 0,
                s91 = 0,
                sSubTotal = 0;

            string vLastVnum = "", vLastName = "", cName = "", cVnum = "";

            int tIndex = 0;
            int bIndex = 0;

            // DataTable schemaTable = reader.GetSchemaTable().Rows.Count;
            // int iCount = reader.GetSchemaTable().Rows.Count;

            int iCount = 0;
            while (reader.Read()) { iCount++; };
            reader.Close();

            string[,] aField = new string[9, iCount];
            string[,] bField = new string[17, iCount];

            reader = Cmd.ExecuteReader();

            while (reader.Read())
            {
                #region // Parent logic

                if (cName == null)
                {
                    cName = "";
                }

                cName = reader["vendor_name"].ToString().Trim().Replace("'", "`");
                cVnum = reader["vendor_number"].ToString();

                if (bIndex == 0)
                {
                    vLastName = cName;
                    vLastVnum = cVnum;
                }

                if (vLastVnum != cVnum)
                {
                    aField[0, tIndex] = vLastName;
                    aField[1, tIndex] = sTotalCurrent.ToString();
                    aField[2, tIndex] = sTotal1_30.ToString();
                    aField[3, tIndex] = sTotal31_60.ToString();
                    aField[4, tIndex] = sTotal61_90.ToString();
                    aField[5, tIndex] = sTotal91.ToString();
                    aField[6, tIndex] = sTotal.ToString();
                    aField[7, tIndex] = vLastVnum;
                    aField[8, tIndex] = reader["business_phone"].ToString();

                    vLastName = cName;
                    vLastVnum = cVnum;
                    tIndex += 1;
                    sTotalCurrent = 0;
                    sTotal1_30 = 0;
                    sTotal31_60 = 0;
                    sTotal61_90 = 0;
                    sTotal91 = 0;
                    sTotal = 0;
                }

                string vBillType = reader["bill_type"].ToString();

                DateTime vBillDate = DateTime.Parse(reader["bill_due_date"].ToString());
                double vBalance = double.Parse(reader["bill_amt_due"].ToString());

                // DateTime d1 = DateTime.Now;
                DateTime d1 = DateTime.Parse(HttpContext.Current.Session["AsOf"].ToString());

                TimeSpan vAging = d1 - vBillDate;

                if (vAging.Days <= 0)
                {
                    sTotalCurrent = sTotalCurrent + vBalance;
                    sTotal = sTotal + vBalance;
                }
                else if (vAging.Days > 0 && vAging.Days < 31)
                {
                    sTotal1_30 = sTotal1_30 + vBalance;
                    sTotal = sTotal + vBalance;
                }
                else if (vAging.Days > 30 && vAging.Days < 61)
                {
                    sTotal31_60 = sTotal31_60 + vBalance;
                    sTotal = sTotal + vBalance;
                }
                else if (vAging.Days > 60 && vAging.Days < 91)
                {
                    sTotal61_90 = sTotal61_90 + vBalance;
                    sTotal = sTotal + vBalance;
                }
                else if (vAging.Days > 90)
                {
                    sTotal91 = sTotal91 + vBalance;
                    sTotal = sTotal + vBalance;
                }

                if ((bIndex + 1) == iCount)  // end of reader
                {
                    aField[0, tIndex] = cName;
                    aField[1, tIndex] = sTotalCurrent.ToString();
                    aField[2, tIndex] = sTotal1_30.ToString();
                    aField[3, tIndex] = sTotal31_60.ToString();
                    aField[4, tIndex] = sTotal61_90.ToString();
                    aField[5, tIndex] = sTotal91.ToString();
                    aField[6, tIndex] = sTotal.ToString();
                    aField[7, tIndex] = cVnum;
                    aField[8, tIndex] = reader["business_phone"].ToString();

                    tIndex += 1;  // for using transfer to DataTable below
                }

                #endregion

                // Detail Info. : Refer from original program...I hate this kind of logic.... 
                // (by iMoon...)

                sCurrent = 0;
                s1_30 = 0;
                s31_60 = 0;
                s61_90 = 0;
                s91 = 0;
                sSubTotal = 0;

                bField[0, bIndex] = cName;
                bField[2, bIndex] = vBillDate.ToShortDateString();
                bField[3, bIndex] = reader["bill_number"].ToString();
                bField[4, bIndex] = reader["ref_no"].ToString();
                bField[5, bIndex] = ((DateTime)(vBillDate)).ToShortDateString();
                if (vAging.Days > 0)
                {
                    bField[6, bIndex] = vAging.Days.ToString();
                }

                bField[7, bIndex] = vBalance.ToString();

                if (vAging.Days <= 0)
                {
                    sCurrent = vBalance;
                    sSubTotal = vBalance;
                }
                else if (vAging.Days > 0 && vAging.Days < 31)
                {
                    s1_30 = vBalance;
                    sSubTotal = vBalance;
                }
                else if (vAging.Days > 30 && vAging.Days < 61)
                {
                    s31_60 = vBalance;
                    sSubTotal = vBalance;
                }
                else if (vAging.Days > 60 && vAging.Days < 91)
                {
                    s61_90 = vBalance;
                    sSubTotal = vBalance;
                }
                else if (vAging.Days > 90)
                {
                    s91 = vBalance;
                    sSubTotal = vBalance;
                }

                bField[8, bIndex] = sCurrent.ToString();
                bField[9, bIndex] = s1_30.ToString();
                bField[10, bIndex] = s31_60.ToString();
                bField[11, bIndex] = s61_90.ToString();
                bField[12, bIndex] = s91.ToString();
                bField[13, bIndex] = sSubTotal.ToString();
                bField[15, bIndex] = cVnum;
                bField[16, bIndex] = reader["ref_no_Our"].ToString();

                switch (vBillType)
                {
                    case "G":
                        bField[1, bIndex] = "GJE";
                        break;
                    default:
                        bField[1, bIndex] = "BILL";
                        break;
                }
                if (elt_account_number == reader["elt_account_number"].ToString())
                {
                    bField[14, bIndex] = "javascript:goFindURL('"
                        + bField[1, bIndex] + "','" + bField[3, bIndex]
                        + "','" + bField[4, bIndex] + "','" + vType + "','"
                        + xType + "','" + IDNum + "','" + cVnum
                        + "','" + md + "')";

                    vNum = "";
                    cVnum = "";
                    vType = "";
                    xType = "";
                    md = "";
                    IDNum = "";
                }

                bIndex += 1;
            }

            reader.Close();

            Con.Close();

            // DataTable

            #region // Parent table

            DataRow dr;

            for (int i = 0; i < tIndex; i++)
            {
                if (aField[0, i] == null) break;

                dr = dt.NewRow();
                dr[0] = aField[0, i];
                dr[1] = aField[1, i];
                dr[2] = aField[2, i];
                dr[3] = aField[3, i];
                dr[4] = aField[4, i];
                dr[5] = aField[5, i];
                dr[6] = aField[6, i];
                dr[7] = aField[7, i];
                dr[8] = aField[8, i];
                if (dr[0].ToString() != string.Empty) dt.Rows.Add(dr);
            }

            #endregion

            # region // Child table

            DataRow cdr;

            for (int i = 0; i < bIndex; i++)
            {
                if (bField[0, i] == null) break;

                cdr = cdt.NewRow();

                cdr[0] = bField[0, i];
                cdr[1] = bField[1, i];
                cdr[2] = DateTime.Parse(bField[2, i]);
                cdr[3] = bField[3, i];
                cdr[4] = bField[4, i];
                cdr[5] = DateTime.Parse(bField[5, i]);
                cdr[6] = bField[6, i];
                cdr[7] = bField[7, i];
                cdr[8] = bField[8, i];
                cdr[9] = bField[9, i];
                cdr[10] = bField[10, i];
                cdr[11] = bField[11, i];
                cdr[12] = bField[12, i];
                cdr[13] = bField[13, i];
                cdr[14] = bField[14, i];
                cdr[15] = bField[15, i];
                cdr[16] = bField[16, i];
                if (cdr[0].ToString() != string.Empty) cdt.Rows.Add(cdr);
            }

            #endregion

            
        }
        private void PerformGetAPDataU(string strCommandText, string strBranch)
        {
            ConnectStr = GetConnectionString(AppConstants.DB_CONN_PROD);
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Con.Open();
            Cmd.CommandText = strCommandText;
            SqlDataReader reader = Cmd.ExecuteReader();
            double
                sTotalCurrent = 0,
                sTotal1_30 = 0,
                sTotal31_60 = 0,
                sTotal61_90 = 0,
                sTotal91 = 0,
                sTotal = 0,

                sCurrent = 0,
                s1_30 = 0,
                s31_60 = 0,
                s61_90 = 0,
                s91 = 0,
                sSubTotal = 0;

            string vLastVnum = "", vLastName = "", cName = "", cVnum = "";
            int tIndex = 0;
            int bIndex = 0;
            int bIndexAdjuster = 0;
            int iCount = 0;
            while (reader.Read()) { iCount++; };
            reader.Close();

            string[,] aField = new string[9, iCount];
            string[,] bField = new string[17, iCount];

            reader = Cmd.ExecuteReader();

            while (reader.Read())
            {
                #region // Parent logic
                cName = reader["vendor_name"].ToString().Trim().Replace("'", "`");
                cVnum = reader["vendor_number"].ToString();

                if (cName == "")
                {
                    bIndexAdjuster += 1;
                    continue;
                }

                if (bIndex == 0)
                {
                    vLastName = cName;
                    vLastVnum = cVnum;
                }

                if (cVnum != vLastVnum)
                {
                    aField[0, tIndex] = vLastName;
                    aField[1, tIndex] = sTotalCurrent.ToString();
                    aField[2, tIndex] = sTotal1_30.ToString();
                    aField[3, tIndex] = sTotal31_60.ToString();
                    aField[4, tIndex] = sTotal61_90.ToString();
                    aField[5, tIndex] = sTotal91.ToString();
                    aField[6, tIndex] = sTotal.ToString();
                    aField[7, tIndex] = vLastVnum;
                    aField[8, tIndex] = reader["business_phone"].ToString();

                    vLastName = cName;
                    vLastVnum = cVnum;
                    tIndex += 1;
                    sTotalCurrent = 0;
                    sTotal1_30 = 0;
                    sTotal31_60 = 0;
                    sTotal61_90 = 0;
                    sTotal91 = 0;
                    sTotal = 0;
                }

                DateTime vBillDate = DateTime.Parse(reader["tran_date"].ToString());
                double vBalance = double.Parse(reader["item_amt"].ToString());

                DateTime d1 = DateTime.Now;
                TimeSpan vAging = d1 - vBillDate;

                if (vAging.Days <= 0)
                {
                    sTotalCurrent = sTotalCurrent + vBalance;
                    sTotal = sTotal + vBalance;
                }
                else if (vAging.Days > 0 && vAging.Days < 31)
                {
                    sTotal1_30 = sTotal1_30 + vBalance;
                    sTotal = sTotal + vBalance;
                }
                else if (vAging.Days > 30 && vAging.Days < 61)
                {
                    sTotal31_60 = sTotal31_60 + vBalance;
                    sTotal = sTotal + vBalance;
                }
                else if (vAging.Days > 60 && vAging.Days < 91)
                {
                    sTotal61_90 = sTotal61_90 + vBalance;
                    sTotal = sTotal + vBalance;
                }
                else if (vAging.Days > 90)
                {
                    sTotal91 = sTotal91 + vBalance;
                    sTotal = sTotal + vBalance;
                }

                if ((bIndex + bIndexAdjuster + 1) >= iCount)  // end of reader
                {
                    aField[0, tIndex] = cName;
                    aField[1, tIndex] = sTotalCurrent.ToString();
                    aField[2, tIndex] = sTotal1_30.ToString();
                    aField[3, tIndex] = sTotal31_60.ToString();
                    aField[4, tIndex] = sTotal61_90.ToString();
                    aField[5, tIndex] = sTotal91.ToString();
                    aField[6, tIndex] = sTotal.ToString();
                    aField[7, tIndex] = cVnum;
                    aField[8, tIndex] = reader["business_phone"].ToString();
                    tIndex += 1;  // for using transfer to DataTable below
                }

                #endregion

             
                sCurrent = 0;
                s1_30 = 0;
                s31_60 = 0;
                s61_90 = 0;
                s91 = 0;
                sSubTotal = 0;

                bField[0, bIndex] = cName;
                bField[14, bIndex] = cVnum;
                bField[2, bIndex] = vBillDate.ToShortDateString();
                bField[3, bIndex] = reader["invoice_no"].ToString();

                if (reader["invoice_no"].ToString() == "0")
                {
                }

                bField[5, bIndex] = ((DateTime)(vBillDate)).ToShortDateString();

                if (vAging.Days > 0)
                {
                    bField[5, bIndex] = vAging.Days.ToString();
                }

                bField[6, bIndex] = vBalance.ToString();

                if (vAging.Days <= 0)
                {
                    sCurrent = vBalance;
                    sSubTotal = vBalance;
                }
                else if (vAging.Days > 0 && vAging.Days < 31)
                {
                    s1_30 = vBalance;
                    sSubTotal = vBalance;
                }
                else if (vAging.Days > 30 && vAging.Days < 61)
                {
                    s31_60 = vBalance;
                    sSubTotal = vBalance;
                }
                else if (vAging.Days > 60 && vAging.Days < 91)
                {
                    s61_90 = vBalance;
                    sSubTotal = vBalance;
                }
                else if (vAging.Days > 90)
                {
                    s91 = vBalance;
                    sSubTotal = vBalance;
                }

                bField[7, bIndex] = sCurrent.ToString();
                bField[8, bIndex] = s1_30.ToString();
                bField[9, bIndex] = s31_60.ToString();
                bField[10, bIndex] = s61_90.ToString();
                bField[11, bIndex] = s91.ToString();
                bField[12, bIndex] = sSubTotal.ToString();

                bField[1, bIndex] = "INV";
                string import_export = reader["import_export"].ToString();
                string air_ocean = reader["itype"].ToString();

                if (air_ocean == "A" && import_export == "I")
                {
                    vType = "AI";
                    bField[1, bIndex] = "ARN";
                }
                if (air_ocean == "O" && import_export == "I")
                {
                    vType = "OI";
                    bField[1, bIndex] = "ARN";
                }

                if (reader["invoice_no"].ToString() == "0")
                {

                    bField[3, bIndex] = reader["agent_debit_no"].ToString();
                    md = reader["mb_no"].ToString();
                    if (reader["itype"].ToString() == "A" && reader["agent_debit_no"].ToString() != "")
                    {
                        xType = "A";

                        bField[1, bIndex] = "ADN";
                        bField[4, bIndex] = reader["ref_no"].ToString();
                    }
                    else if (reader["itype"].ToString() == "O" && reader["agent_debit_no"].ToString() != "")
                    {
                        xType = "O";
                        bField[1, bIndex] = "ADN";
                        bField[4, bIndex] = reader["ref_no"].ToString();
                    }
                    else
                    {
                        bField[3, bIndex] = "Direct Entry";
                        vNum = reader["vendor_number"].ToString();
                        IDNum = reader["item_id"].ToString();
                    }
                }
                else
                {
                    bField[16, bIndex] = reader["ref_no_Our"].ToString();
                }

                if (elt_account_number == reader["elt_account_number"].ToString())
                {
                    bField[15, bIndex] = "javascript:goFindURL('"
                        + bField[1, bIndex] + "','" + bField[3, bIndex]
                        + "','" + bField[4, bIndex] + "','" + vType + "','"
                        + xType + "','" + IDNum + "','" + vNum + "','" + md + "')";

                    vNum = "";
                    cVnum = "";
                    vType = "";
                    xType = "";
                    md = "";
                    IDNum = "";
                }

                bIndex += 1;
            }

            reader.Close();

            Con.Close();


            #region // Parent table
            DataRow dr;

            for (int i = 0; i < tIndex; i++)
            {
                if (aField[0, i] == null) break;

                dr = dt.NewRow();
                dr[0] = aField[0, i];
                dr[1] = aField[1, i];
                dr[2] = aField[2, i];
                dr[3] = aField[3, i];
                dr[4] = aField[4, i];
                dr[5] = aField[5, i];
                dr[6] = aField[6, i];
                dr[7] = aField[7, i];
                dr[8] = aField[8, i];

                if (dr[0].ToString() != string.Empty) dt.Rows.Add(dr);
            }

            #endregion

            # region // Child table
            DataRow cdr;

            for (int i = 0; i < bIndex; i++)
            {
                if (bField[0, i] == null) break;

                cdr = cdt.NewRow();

                cdr[0] = bField[0, i];
                cdr[1] = bField[1, i];
                cdr[2] = bField[2, i];
                cdr[3] = bField[3, i];
                cdr[4] = bField[4, i];
                cdr[5] = System.DBNull.Value;
                cdr[6] = bField[5, i];
                cdr[7] = bField[6, i];
                cdr[8] = bField[7, i];
                cdr[9] = bField[8, i];
                cdr[10] = bField[9, i];
                cdr[11] = bField[10, i];
                cdr[12] = bField[11, i];
                cdr[13] = bField[12, i];
                cdr[14] = bField[15, i];
                cdr[15] = bField[14, i];
                cdr[16] = bField[16, i];

                if (cdr[0].ToString() != string.Empty) cdt.Rows.Add(cdr);
            }

            #endregion

        }

    }
}
