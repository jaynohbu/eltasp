using System;
using System.Web;
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
using System.Globalization;
namespace ELT.DA
{ 
    public class ReportingDA:DABase
    {
        private const string STR_Constant = "#.##";
        public List<AirTransactionItem> GetAirExportTransItems(string ELT_account_number, ReportSearchItem search_items)
        {         
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[Reporting].[AEOperationReport]" };
            List<AirTransactionItem> list = new List<AirTransactionItem>();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@Unit", search_items.WeightScale));
                cmd.Parameters.Add(new SqlParameter("@StartDate", search_items.PeriodBegin));
                cmd.Parameters.Add(new SqlParameter("@EndDate", search_items.PeriodEnd));
                cmd.Parameters.Add(new SqlParameter("@EltAccountNumber", ELT_account_number));
                conn.Open();
              
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        AirTransactionItem item = new AirTransactionItem();
                        item.Agent = Convert.ToString(reader["Agent"]);
                        item.Master = Convert.ToString(reader["Master"]);
                        item.House = Convert.ToString(reader["House"]);
                        item.Shipper = Convert.ToString(reader["Shipper"]);
                        item.Shipper = Convert.ToString(reader["Carrier"]);
                        item.Origin = Convert.ToString(reader["Origin"]);
                        item.Destination = Convert.ToString(reader["Destination"]);
                        item.Date = Convert.ToString(reader["Date"]);
                        item.Sale_Rep = Convert.ToString(reader["Sales Rep."]);
                        item.Processed_By = Convert.ToString(reader["Processed By"]);
                        item.Quantity = Convert.ToString(reader["Quantity"]);
                        item.Gros_Wt = Math.Round(Convert.ToDecimal(reader["Gross Wt."]), 2).ToString();                       
                        item.ChargeableWeight = Math.Round(Convert.ToDecimal(reader["Chargeable Wt."]),2).ToString();
                     
                        item.Freight_Charge = Convert.ToString(reader["Freight Charge"]);
                        item.Other_Charge = Convert.ToString(reader["Other Charge"]);
                        //File#	Master	House	Shipper	Consignee	Agent	Carrier	Origin	Destination	Date	
                        //Sales Rep.	Processed By	Quantity	Gross Wt.	Chargeable Wt.	Freight Charge	Other Charge

                        list.Add(item);
                    }
                }               
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }

            return list;
        }
        public List<AirTransactionItem> GetAirImportTransItems(string ELT_account_number, ReportSearchItem search_items)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[Reporting].[AIOperationReport]" };
            List<AirTransactionItem> list = new List<AirTransactionItem>();

            try
            {
                //string Scale = selection.WeightScale;
                //DateTime start = selection.PeriodBegin;
                //DateTime end = selection.PeriodEnd;

                cmd.Parameters.Add(new SqlParameter("@Unit", search_items.WeightScale));
                cmd.Parameters.Add(new SqlParameter("@StartDate", search_items.PeriodBegin));
                cmd.Parameters.Add(new SqlParameter("@EndDate", search_items.PeriodEnd));
                cmd.Parameters.Add(new SqlParameter("@EltAccountNumber", ELT_account_number));
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        AirTransactionItem item = new AirTransactionItem();
                        item.Agent = Convert.ToString(reader["Agent"]);
                        item.Master = Convert.ToString(reader["Master"]);
                        item.House = Convert.ToString(reader["House"]);
                        item.Shipper = Convert.ToString(reader["Shipper"]);
                        item.Shipper = Convert.ToString(reader["Carrier"]);
                        item.Origin = Convert.ToString(reader["Origin"]);
                        item.Destination = Convert.ToString(reader["Destination"]);
                        item.Date = Convert.ToString(reader["Date"]);
                        item.Sale_Rep = Convert.ToString(reader["Sales Rep."]);
                        item.Processed_By = Convert.ToString(reader["Processed By"]);
                        item.Quantity = Convert.ToString(reader["Quantity"]);
                        item.Gros_Wt = Math.Round(Convert.ToDecimal(reader["Gross Wt."]), 2).ToString();
                        item.ChargeableWeight = Math.Round(Convert.ToDecimal(reader["Chargeable Wt."]), 2).ToString();

                        item.Freight_Charge = Convert.ToString(reader["Freight Charge"]);
                        item.Other_Charge = Convert.ToString(reader["Other Charge"]);
                        //File#	Master	House	Shipper	Consignee	Agent	Carrier	Origin	Destination	Date	
                        //Sales Rep.	Processed By	Quantity	Gross Wt.	Chargeable Wt.	Freight Charge	Other Charge

                        list.Add(item);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }

            return list;
        }
        public List<OceanTransactionItem> GetOceanExportTransItems(string ELT_account_number, ReportSearchItem search_items)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[Reporting].[OEOperationReport]" };
            List<OceanTransactionItem> list = new List<OceanTransactionItem>();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@Unit", search_items.WeightScale));
                cmd.Parameters.Add(new SqlParameter("@StartDate", search_items.PeriodBegin));
                cmd.Parameters.Add(new SqlParameter("@EndDate", search_items.PeriodEnd));
                cmd.Parameters.Add(new SqlParameter("@EltAccountNumber", ELT_account_number));
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        OceanTransactionItem item = new OceanTransactionItem();
                        item.Agent = Convert.ToString(reader["Agent"]);
                        item.Master = Convert.ToString(reader["Master"]);
                        item.House = Convert.ToString(reader["House"]);
                        item.Shipper = Convert.ToString(reader["Shipper"]);
                        item.Shipper = Convert.ToString(reader["Carrier"]);
                        item.Origin = Convert.ToString(reader["Origin"]);
                        item.Destination = Convert.ToString(reader["Destination"]);
                        item.Date = Convert.ToString(reader["Date"]);
                        item.Sale_Rep = Convert.ToString(reader["Sales Rep."]);
                        item.Processed_By = Convert.ToString(reader["Processed By"]);
                        item.Quantity = Convert.ToString(reader["Quantity"]);
                        item.Gros_Wt = Math.Round(Convert.ToDecimal(reader["Gross Wt."]), 2).ToString();
                        item.Measurement = Math.Round(Convert.ToDecimal(reader["Chargeable Wt."]), 2).ToString();

                        item.Freight_Charge = Convert.ToString(reader["Freight Charge"]);
                        item.Other_Charge = Convert.ToString(reader["Other Charge"]);
                        

                        list.Add(item);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }

            return list;
        }
        public List<OceanTransactionItem> GetOceanImportTransItems(string ELT_account_number, ReportSearchItem search_items)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[Reporting].[OIOperationReport]" };
            List<OceanTransactionItem> list = new List<OceanTransactionItem>();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@Unit", search_items.WeightScale));
                cmd.Parameters.Add(new SqlParameter("@StartDate", search_items.PeriodBegin));
                cmd.Parameters.Add(new SqlParameter("@EndDate", search_items.PeriodEnd));
                cmd.Parameters.Add(new SqlParameter("@EltAccountNumber", ELT_account_number));
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        OceanTransactionItem item = new OceanTransactionItem();
                        item.Agent = Convert.ToString(reader["Agent"]);
                        item.Master = Convert.ToString(reader["Master"]);
                        item.House = Convert.ToString(reader["House"]);
                        item.Shipper = Convert.ToString(reader["Shipper"]);
                        item.Shipper = Convert.ToString(reader["Carrier"]);
                        item.Origin = Convert.ToString(reader["Origin"]);
                        item.Destination = Convert.ToString(reader["Destination"]);
                        item.Date = Convert.ToString(reader["Date"]);
                        item.Sale_Rep = Convert.ToString(reader["Sales Rep."]);
                        item.Processed_By = Convert.ToString(reader["Processed By"]);
                        item.Quantity = Convert.ToString(reader["Quantity"]);
                        item.Gros_Wt = Math.Round(Convert.ToDecimal(reader["Gross Wt."]), 2).ToString();
                        item.Measurement = Math.Round(Convert.ToDecimal(reader["Chargeable Wt."]), 2).ToString();

                        item.Freight_Charge = Convert.ToString(reader["Freight Charge"]);
                        item.Other_Charge = Convert.ToString(reader["Other Charge"]);


                        list.Add(item);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }

            return list;
        }
        //public List<ARDetailItem> GetARDetailItems(string ELT_account_number, AccountingSearchItem search_items  )
        //{
        //    SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
        //    SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[Reporting].[ARDetail]" };
        //    List<ARDetailItem> list = new List<ARDetailItem>();
        //    var selectedBranch = search_items.Branch.Split(',').First();
        //    if (selectedBranch == "")
        //        selectedBranch = ELT_account_number.Substring(0, 5);
        //    try
        //    {
        //        cmd.Parameters.Add(new SqlParameter("@GLAccountType", search_items.GLAccountType));
        //        cmd.Parameters.Add(new SqlParameter("@StartDate", search_items.PeriodBegin));
        //        cmd.Parameters.Add(new SqlParameter("@EndDate", search_items.PeriodEnd));
        //        cmd.Parameters.Add(new SqlParameter("@EltAccountNumber",selectedBranch));
        //        conn.Open();

        //        using (SqlDataReader reader = cmd.ExecuteReader())
        //        {
        //            while (reader.Read())
        //            {
        //                ARDetailItem item = new ARDetailItem();
        //                item.CustomerName = Convert.ToString(reader["customer_name"]);
        //                item.ELTAccountNumber = Convert.ToString(reader["EmailItemID"]);
        //                item.CustomerNo = Convert.ToString(reader["customer_number"]);
        //                string str_date = Convert.ToString(reader["date"]);
        //                item.Date = str_date;
        //                if (str_date != "")
        //                {
        //                    DateTime date = Convert.ToDateTime(str_date);
        //                    item.Date = date.ToString("MM/dd/yyyy");
        //                }
                       
                        
        //                item.Type = Convert.ToString(reader["type"]);
        //                item.AirOcean = Convert.ToString(reader["air_ocean"]);
        //                item.Num = Convert.ToString(reader["num"]);
        //                item.Memo = Convert.ToString(reader["memo"]);
        //                item.FileNo = Convert.ToString(reader["file_no"]);
        //                item.DebitAmt = Convert.ToString(reader["debit_amount"]);
        //                item.CreditAmt = Convert.ToString(reader["credit_amount"]);
        //                item.Balance = Convert.ToString(reader["balance"]);
        //                item.Email = Convert.ToString(reader["email"]);
        //                item.Status = Convert.ToString(reader["status"]);
        //                item.AutoUID = Convert.ToString(reader["auto_uid"]);
        //                //item.Status = Math.Round(Convert.ToDecimal(reader["Gross Wt."]), 2).ToString();
        //                //item.AutoUID = Math.Round(Convert.ToDecimal(reader["Chargeable Wt."]), 2).ToString();

        //                list.Add(item);
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    finally
        //    {
        //        conn.Close();
        //        conn.Dispose();
        //    }
        //    return list;
        //}
        //public List<APDetailItem> GetAPDetailItems(string ELT_account_number, AccountingSearchItem search_items)
        //{
        //    SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
        //    SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[Reporting].[APDetail]" };
        //    List<APDetailItem> list = new List<APDetailItem>();

        //    var selectedBranch = search_items.Branch.Split(',').First();
        //    if (selectedBranch == "")
        //        selectedBranch = ELT_account_number.Substring(0, 5);
        //    try
        //    {
        //        cmd.Parameters.Add(new SqlParameter("@GLAccountType", search_items.GLAccountType));
        //        cmd.Parameters.Add(new SqlParameter("@StartDate", search_items.PeriodBegin));
        //        cmd.Parameters.Add(new SqlParameter("@EndDate", search_items.PeriodEnd));
        //        cmd.Parameters.Add(new SqlParameter("@EltAccountNumber", selectedBranch));
        //        conn.Open();

        //        using (SqlDataReader reader = cmd.ExecuteReader())
        //        {
        //            while (reader.Read())
        //            {
        //                APDetailItem item = new APDetailItem();
        //                item.CustomerName = Convert.ToString(reader["customer_name"]);
        //                item.ELTAccountNumber = Convert.ToString(reader["EmailItemID"]);
        //                item.CustomerNo = Convert.ToString(reader["customer_number"]);
        //                string str_date = Convert.ToString(reader["date"]);
        //                item.Date = str_date;
        //                if (str_date != "")
        //                {
        //                    DateTime date = Convert.ToDateTime(str_date);
        //                    item.Date = date.ToString("MM/dd/yyyy");
        //                }


        //                item.Type = Convert.ToString(reader["type"]);
        //                item.AirOcean = Convert.ToString(reader["air_ocean"]);
        //                item.Num = Convert.ToString(reader["num"]);
        //                item.Memo = Convert.ToString(reader["memo"]);
        //                item.CheckNo = Convert.ToString(reader["check_no"]);
        //                item.DebitAmt = Convert.ToString(reader["debit_amount"]);
        //                item.CreditAmt = Convert.ToString(reader["credit_amount"]);
        //                item.Balance = Convert.ToString(reader["balance"]);
                      
        //                //item.Status = Math.Round(Convert.ToDecimal(reader["Gross Wt."]), 2).ToString();
        //                //item.AutoUID = Math.Round(Convert.ToDecimal(reader["Chargeable Wt."]), 2).ToString();

        //                list.Add(item);
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    finally
        //    {
        //        conn.Close();
        //        conn.Dispose();
        //    }
        //    return list;
        //}
      
        
        public List<BrachAccount> GetBranches(string elt_account_number)
        {
            string SQL = "select elt_account_number,dba_name from agent where left(elt_account_number,5) = " + elt_account_number.Substring(0, 5);
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.Text, CommandText = SQL };
            List<BrachAccount> list = new List<BrachAccount>();
            try
            {
                cmd.Parameters.Add(new SqlParameter("@elt_account_number", elt_account_number));              
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        //

                        BrachAccount item = new BrachAccount()
                        {
                            dba_name = Convert.ToString(reader["dba_name"]),
                            elt_account_number = Convert.ToInt32(reader["elt_account_number"])
                            


                        };
                        list.Add( item);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return list;
        }    
        public List<BankRegisterItem> GetBankRegisterItem(string ELT_account_number, AccountingSearchItem search_items)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[Reporting].[BankRegisterReport]" };
            List<BankRegisterItem> list = new List<BankRegisterItem>();

            //var selectedBranch = search_items.Branch.Split(',').First();
            //if (selectedBranch == "")
            //    selectedBranch = ELT_account_number.Substring(0, 5);

            // for temporary, seachable in current branch
            var selectedBranch = ELT_account_number;
            try
            {
                cmd.Parameters.Add(new SqlParameter("@GLAccountType", search_items.GLAccountType));
                cmd.Parameters.Add(new SqlParameter("@StartDate", search_items.PeriodBegin));
                cmd.Parameters.Add(new SqlParameter("@EndDate", search_items.PeriodEnd));
                cmd.Parameters.Add(new SqlParameter("@EltAccountNumber", selectedBranch));
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        BankRegisterItem item = new BankRegisterItem();
                        item.elt_account_number = Convert.ToString(reader["elt_account_number"]);
                        item.Type = Convert.ToString(reader["type"]);
                       
                        string str_date = Convert.ToString(reader["date"]);
                        item.Date = str_date;
                        if (str_date != "")
                        {
                            DateTime date = Convert.ToDateTime(str_date);
                            item.Date = date.ToString("MM/dd/yyyy");
                        }

                        item.CheckNo = Convert.ToString(reader["Check_No"]);
                        item.Memo = Convert.ToString(reader["memo"]);

                        item.Description = Convert.ToString(reader["Description"]);
                        item.PrintCheckAs = Convert.ToString(reader["PrintCheckAs"]);
                        item.Clear = Convert.ToString(reader["Clear"]);
                        item.Void = Convert.ToString(reader["Void"]);
                        //item.Amount = Convert.ToString(reader["Amount"]);

                        //item.AirOcean = Convert.ToString(reader["air_ocean"]);
                        //item.TransNo = Convert.ToString(reader["tran_num"]);

                        //item.GlAccountName = Convert.ToString(reader["gl_account_name"]);
                       
                        list.Add(item);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return list;
        }
        //public List<SalesItem> GetSalesMasterItem(string ELT_account_number, AccountingSearchItem search_items)
        //{
        //    SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
        //    SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[Reporting].[SalesReportMaster]" };
        //    List<SalesItem> list = new List<SalesItem>();

        //    //var selectedBranch = search_items.Branch.Split(',').First();
        //    //if (selectedBranch == "")
        //    //    selectedBranch = ELT_account_number.Substring(0, 5);

        //    // for temporary, seachable in current branch
        //    var selectedBranch = ELT_account_number;
        //    try
        //    {
        //        cmd.Parameters.Add(new SqlParameter("@GLAccountType", search_items.GLAccountType));
        //        cmd.Parameters.Add(new SqlParameter("@StartDate", search_items.PeriodBegin));
        //        cmd.Parameters.Add(new SqlParameter("@EndDate", search_items.PeriodEnd));
        //        cmd.Parameters.Add(new SqlParameter("@EltAccountNumber", selectedBranch));
        //        conn.Open();

        //        using (SqlDataReader reader = cmd.ExecuteReader())
        //        {

        //            while (reader.Read())
        //            {
        //                SalesItem item = new SalesItem();
        //                item.CustomerName = Convert.ToString(reader["customer_name"]);
        //                item.CustomerNumber = Convert.ToString(reader["customer_number"]);

        //                item.Amount = Convert.ToString(reader["Amount"]);
        //                item.Balance = Convert.ToString(reader["Balance"]);
        //                list.Add(item);
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    finally
        //    {
        //        conn.Close();
        //        conn.Dispose();
        //    }
        //    return list;
        //}
        //public List<SalesTransactionalItem> GetSalesDetailItem(string ELT_account_number, AccountingSearchItem search_items)
        //{
        //    SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
        //    SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[Reporting].[SalesReportDetail]" };
        //    List<SalesTransactionalItem> list = new List<SalesTransactionalItem>();

        //    //var selectedBranch = search_items.Branch.Split(',').First();
        //    //if (selectedBranch == "")
        //    //    selectedBranch = ELT_account_number.Substring(0, 5);

        //    // for temporary, seachable in current branch
        //    var selectedBranch = ELT_account_number;
        //    try
        //    {
        //        cmd.Parameters.Add(new SqlParameter("@GLAccountType", search_items.GLAccountType));
        //        cmd.Parameters.Add(new SqlParameter("@StartDate", search_items.PeriodBegin));
        //        cmd.Parameters.Add(new SqlParameter("@EndDate", search_items.PeriodEnd));
        //        cmd.Parameters.Add(new SqlParameter("@EltAccountNumber", selectedBranch));
        //        conn.Open();

        //        using (SqlDataReader reader = cmd.ExecuteReader())
        //        {

        //            while (reader.Read())
        //            {
        //                SalesTransactionalItem item = new SalesTransactionalItem();
        //                item.ELTAccountNumber = Convert.ToString(reader["EmailItemID"]);
        //                item.CustomerName = Convert.ToString(reader["customer_name"]);
        //                item.CustomerNumber = Convert.ToString(reader["customer_number"]);
        //                item.AirOcean = Convert.ToString(reader["air_ocean"]);
        //                item.Type = Convert.ToString(reader["type"]);

        //                item.Num = Convert.ToString(reader["Num"]);

        //                string str_date = Convert.ToString(reader["Date"]);
        //                item.Date = str_date;
        //                if (str_date != "")
        //                {
        //                    DateTime date = Convert.ToDateTime(str_date);
        //                    item.Date = date.ToString("MM/dd/yyyy");
        //                }

        //                item.Amount = Convert.ToString(reader["Amount"]);
        //                item.Balance = Convert.ToString(reader["Balance"]);
        //                item.Link = Convert.ToString(reader["Link"]);

        //                list.Add(item);
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    finally
        //    {
        //        conn.Close();
        //        conn.Dispose();
        //    }
        //    return list;
        //}
      
        
        //public List<ExpenseItem> GetExpensesMasterItem(string ELT_account_number, AccountingSearchItem search_items)
        //{
        //    SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
        //    SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[Reporting].[ExpenseReportMaster]" };
        //    List<ExpenseItem> list = new List<ExpenseItem>();

        //    //var selectedBranch = search_items.Branch.Split(',').First();
        //    //if (selectedBranch == "")
        //    //    selectedBranch = ELT_account_number.Substring(0, 5);

        //    // for temporary, seachable in current branch
        //    var selectedBranch = ELT_account_number;
        //    try
        //    {
        //        cmd.Parameters.Add(new SqlParameter("@GLAccountType", search_items.GLAccountType));
        //        cmd.Parameters.Add(new SqlParameter("@StartDate", search_items.PeriodBegin));
        //        cmd.Parameters.Add(new SqlParameter("@EndDate", search_items.PeriodEnd));
        //        cmd.Parameters.Add(new SqlParameter("@EltAccountNumber", selectedBranch));
        //        conn.Open();

        //        using (SqlDataReader reader = cmd.ExecuteReader())
        //        {

        //            while (reader.Read())
        //            {
        //                ExpenseItem item = new ExpenseItem();
        //                item.CustomerName = Convert.ToString(reader["customer_name"]);
                 
        //                item.Amount = Convert.ToString(reader["Amount"]);
        //                item.Balance = Convert.ToString(reader["Balance"]);
        //                list.Add(item);
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    finally
        //    {
        //        conn.Close();
        //        conn.Dispose();
        //    }
        //    return list;
        //}
        //public List<ExpenseTransactionalItem> GetExpensesDetailItem(string ELT_account_number, AccountingSearchItem search_items)
        //{
        //    SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
        //    SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[Reporting].[ExpenseReportDetail]" };
        //    List<ExpenseTransactionalItem> list = new List<ExpenseTransactionalItem>();

        //    //var selectedBranch = search_items.Branch.Split(',').First();
        //    //if (selectedBranch == "")
        //    //    selectedBranch = ELT_account_number.Substring(0, 5);

        //    // for temporary, seachable in current branch
        //    var selectedBranch = ELT_account_number;
        //    try
        //    {
        //        cmd.Parameters.Add(new SqlParameter("@GLAccountType", search_items.GLAccountType));
        //        cmd.Parameters.Add(new SqlParameter("@StartDate", search_items.PeriodBegin));
        //        cmd.Parameters.Add(new SqlParameter("@EndDate", search_items.PeriodEnd));
        //        cmd.Parameters.Add(new SqlParameter("@EltAccountNumber", selectedBranch));
        //        conn.Open();

        //        using (SqlDataReader reader = cmd.ExecuteReader())
        //        {

        //            while (reader.Read())
        //            {
        //                ExpenseTransactionalItem item = new ExpenseTransactionalItem();
        //                item.ELTAccountNumber = Convert.ToString(reader["EmailItemID"]);
        //                item.CustomerName = Convert.ToString(reader["customer_name"]);
        //                item.Type = Convert.ToString(reader["type"]);
        //                string str_date = Convert.ToString(reader["Date"]);
        //                item.Date = str_date;
        //                if (str_date != "")
        //                {
        //                    DateTime date = Convert.ToDateTime(str_date);
        //                    item.Date = date.ToString("MM/dd/yyyy");
        //                }
        //                item.Num = Convert.ToString(reader["Num"]);

        //                item.Memo = Convert.ToString(reader["Memo"]);
        //                item.Account = Convert.ToString(reader["Account"]);
        //                item.Split = Convert.ToString(reader["Split"]);

        //                item.Amount = Convert.ToString(reader["Amount"]);
        //                item.Balance = Convert.ToString(reader["Balance"]);
        //                item.Link = Convert.ToString(reader["Link"]);

        //                list.Add(item);
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    finally
        //    {
        //        conn.Close();
        //        conn.Dispose();
        //    }
        //    return list;
        //}
      
        
        //public List<GeneralLedgerReportItem> GetGeneralLedgerMasterItem(string ELT_account_number, AccountingSearchItem search_items)
        //{
        //    SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
        //    SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[Reporting].[GeneralLedgerMasterReport]" };
        //    List<GeneralLedgerReportItem> list = new List<GeneralLedgerReportItem>();

        //    var selectedBranch = search_items.Branch;
        //    if (selectedBranch == "")
        //    {
        //        selectedBranch = ELT_account_number;
        //    }

        //    try
        //    {
        //        cmd.Parameters.Add(new SqlParameter("@StartDate", search_items.PeriodBegin));
        //        cmd.Parameters.Add(new SqlParameter("@EndDate", search_items.PeriodEnd));
        //        cmd.Parameters.Add(new SqlParameter("@EltAccountNumber", selectedBranch));
        //        conn.Open();

        //        using (SqlDataReader reader = cmd.ExecuteReader())
        //        {
        //            while (reader.Read())
        //            {
        //                GeneralLedgerReportItem item = new GeneralLedgerReportItem();
        //                item.ELTAccountNumber = Convert.ToString(reader["EmailItemID"]);
        //                item.GLNumber = Convert.ToString(reader["gl_number"]);
        //                item.Title = Convert.ToString(reader["gl_name"]);
        //                item.CustomerName = Convert.ToString(reader["customer_name"]);
        //                item.Balance = Convert.ToString(reader["Balance"]);
        //                list.Add(item);
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    finally
        //    {
        //        conn.Close();
        //        conn.Dispose();
        //    }
        //    return list;
        //}
        //public List<GeneralLedgerTransactionalItem> GetGeneralLedgerDetailItems(string ELT_account_number, AccountingSearchItem search_items)
        //{
        //    SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
        //    SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[Reporting].[GeneralLedgerDetailReport]" };
        //    List<GeneralLedgerTransactionalItem> list = new List<GeneralLedgerTransactionalItem>();

        //    //var selectedBranch = search_items.Branch.Split(',').First();
        //    //if (selectedBranch == "")
        //    //    selectedBranch = ELT_account_number.Substring(0, 5);

        //    // for temporary, seachable in current branch
        //    var selectedBranch = ELT_account_number;
        //    try
        //    {
        //        cmd.Parameters.Add(new SqlParameter("@StartDate", search_items.PeriodBegin));
        //        cmd.Parameters.Add(new SqlParameter("@EndDate", search_items.PeriodEnd));
        //        cmd.Parameters.Add(new SqlParameter("@EltAccountNumber", selectedBranch));
        //        conn.Open();

        //        using (SqlDataReader reader = cmd.ExecuteReader())
        //        {
        //            while (reader.Read())
        //            {
        //                GeneralLedgerTransactionalItem item = new GeneralLedgerTransactionalItem();
        //                item.ELTAccountNumber = Convert.ToString(reader["EmailItemID"]);
        //                item.GLNumber = Convert.ToString(reader["GL_Number"]);
        //                item.GLName = Convert.ToString(reader["GL_Name"]);
        //                string str_date = Convert.ToString(reader["Date"]);
        //                item.Date = str_date;
        //                if (str_date != "")
        //                {
        //                    DateTime date = Convert.ToDateTime(str_date);
        //                    item.Date = date.ToString("MM/dd/yyyy");
        //                }
        //                item.Type = Convert.ToString(reader["type"]);

        //                item.AirOcean = Convert.ToString(reader["air_ocean"]);
        //                item.Num = Convert.ToString(reader["Num"]);
        //                item.CheckNo = Convert.ToString(reader["check_no"]);
        //                item.CompanyName = Convert.ToString(reader["Company_Name"]);
        //                item.Memo = Convert.ToString(reader["Memo"]);

        //                item.Split = Convert.ToString(reader["Split"]);
        //                item.DebitAmt = Convert.ToString(reader["debit_amount"]);
        //                item.CreditAmt = Convert.ToString(reader["credit_amount"]);

        //                list.Add(item);
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    finally
        //    {
        //        conn.Close();
        //        conn.Dispose();
        //    }
        //    return list;
        //}
        
        
        public List<TrialBalanceItem> GetTrialBalanceItem(string ELT_account_number, AccountingSearchItem search_items)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[Reporting].[TrialBalanceReport]" };
            List<TrialBalanceItem> list = new List<TrialBalanceItem>();

            //var selectedBranch = search_items.Branch.Split(',').First();
            //if (selectedBranch == "")
            //    selectedBranch = ELT_account_number.Substring(0, 5);

            // for temporary, seachable in current branch
            var selectedBranch = ELT_account_number;
            try
            {

                cmd.Parameters.Add(new SqlParameter("@EndDate", search_items.PeriodEnd));
                cmd.Parameters.Add(new SqlParameter("@EltAccountNumber", selectedBranch));
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        TrialBalanceItem item = new TrialBalanceItem();
                        item.GlAccountNumber = Convert.ToString(reader["gl_account_number"]);
                        item.GLAccountName = Convert.ToString(reader["gl_account_name"]);
                        item.DebitAmt = Convert.ToString(reader["Debit"]);
                        item.CreditAmt = Convert.ToString(reader["Credit"]);
                        item.Balance = Convert.ToString(reader["Balance"]);
                        list.Add(item);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return list;
        }
        public List<APDisputeTransactionItem> GetAPDisputeTransactionItem()
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.Text, CommandText = HttpContext.Current.Session["PNLINDEX"].ToString() };
            List<APDisputeTransactionItem> list = new List<APDisputeTransactionItem>();

            try
            {
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        APDisputeTransactionItem item = new APDisputeTransactionItem();
                        //item.Cost = Convert.ToString(reader["Cost"]);
                        //item.Date = Convert.ToString(reader["Date"]);
                        //item.sort_key = Convert.ToString(reader["sort_key"]);
                        //item.Profit = Convert.ToString(reader["Profit"]);
                        //item.Amount = Convert.ToString(reader["Amount"]);

                        list.Add(item);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return list;
        }

        public void RefreshPNL(int elt_account_number)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "Reporting.RefreshPNL" };
      
            try
            {
            
                cmd.Parameters.Add(new SqlParameter("@elt_account_number", elt_account_number));              
                conn.Open();
                cmd.ExecuteNonQuery();               
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }       
        }
        public List<PNLTransactionItem> GetPNLTransactionItem(int elt_account_number, ReportSearchItem search_items)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "Reporting.GetPNL" };
            List<PNLTransactionItem> list = new List<PNLTransactionItem>();
            //
            try
            {
              
                cmd.Parameters.Add(new SqlParameter("@Begin", search_items.PeriodBegin));
                cmd.Parameters.Add(new SqlParameter("@End", search_items.PeriodEnd));
                cmd.Parameters.Add(new SqlParameter("@elt_account_number", elt_account_number));
                cmd.Parameters.Add(new SqlParameter("@MBL_NUM", search_items.MAWB));
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        PNLTransactionItem item = new PNLTransactionItem();
                        item.Type = Convert.ToString(reader["Type"]);
                        item.ImportExport = Convert.ToString(reader["ImportExport"]);
                        item.AirOcean = Convert.ToString(reader["AirOcean"]);
                        item.Master_House = Convert.ToString(reader["Master_House"]);
                        item.elt_account_number = Convert.ToString(reader["elt_account_number"]);
                        item.MBL_NUM = Convert.ToString(reader["MBL_NUM"]);
                        item.HBL_NUM = Convert.ToString(reader["HBL_NUM"]);
                        item.Item_Code = Convert.ToString(reader["Item_Code"]);
                        item.Description = Convert.ToString(reader["Description"]);
                        item.Customer_ID = Convert.ToInt32(reader["Customer_ID"]);
                      
                        if (item.Type == "Revenue")
                        {
                            item.Revenue = reader["Amount"].GetType()==Type.GetType("System.DBNull")?0:Convert.ToDecimal(reader["Amount"]);
                            item.Expense = 0;
                        }
                        else
                        {
                            item.Revenue = 0;
                            item.Expense = reader["Amount"].GetType() == Type.GetType("System.DBNull") ? 0 : Convert.ToDecimal(reader["Amount"]);
                        }
                        item.ORIGIN = Convert.ToString(reader["ORIGIN"]);
                        item.DEST = Convert.ToString(reader["DEST"]);
                        item.Customer_Name = Convert.ToString(reader["Customer_Name"]);                       
                        item.Date = Convert.ToDateTime(reader["Date"]).ToShortDateString();
                        list.Add(item);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return list;
        }
       
        public List<IncomeStatementItem> GetIncomeStatementItem(string ELT_account_number, AccountingSearchItem search_items)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[Reporting].[IncomeStatementReport]" };
            List<IncomeStatementItem> list = new List<IncomeStatementItem>();

            //var selectedBranch = search_items.Branch.Split(',').First();
            //if (selectedBranch == "")
            //    selectedBranch = ELT_account_number.Substring(0, 5);

            // for temporary, seachable in current branch
            var selectedBranch = ELT_account_number;
            try
            {
                cmd.Parameters.Add(new SqlParameter("@StartDate", search_items.PeriodBegin));
                cmd.Parameters.Add(new SqlParameter("@EndDate", search_items.PeriodEnd));
                cmd.Parameters.Add(new SqlParameter("@EltAccountNumber", selectedBranch));
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        IncomeStatementItem item = new IncomeStatementItem();
                        item.Area = Convert.ToString(reader["Area"]);
                        item.Category = Convert.ToString(reader["Category"]);
                        item.SubCategory = Convert.ToString(reader["SubCategory"]);
                        item.Type = Convert.ToString(reader["Type"]);
                        item.GlAccountNumber = Convert.ToString(reader["GL_Number"]);
                        item.GLAccountName = Convert.ToString(reader["GL_Name"]);
                        item.Amount = Convert.ToString(reader["Amount"]);
                      
                        list.Add(item);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return list;
        }
        public List<BalanceSheetItem> GetBalanceSheetItem(string ELT_account_number, AccountingSearchItem search_items)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[Reporting].[BalanceSheetReport]" };
            List<BalanceSheetItem> list = new List<BalanceSheetItem>();
            var selectedBranch = ELT_account_number;
            try
            {

                cmd.Parameters.Add(new SqlParameter("@EndDate", search_items.PeriodEnd));
                cmd.Parameters.Add(new SqlParameter("@EltAccountNumber", selectedBranch));
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        BalanceSheetItem item = new BalanceSheetItem();
                        //item.Header = Convert.ToString(reader["Header"]);
                        item.Type = Convert.ToString(reader["Type"]);
                       // item.GLAccountType = Convert.ToString(reader["gl_account_type"]);
                       // item.GLAccountType2 = Convert.ToString(reader["gl_account_type2"]);
                        item.GlAccountNumber = Convert.ToString(reader["GL_Number"]);
                        item.GLAccountName = Convert.ToString(reader["GL_Name"]);
                        item.Amount = Convert.ToString(reader["Amount"]);
                        item.BeginBalance = Convert.ToString(reader["Begin_Balance"]);
                        list.Add(item);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return list;
        }    
        public List<GLTransactionType> GetAllGLTranType(string elt_account_number)
        {
            string SQL = string.Empty;
            if (elt_account_number.Substring(6, 2) == "00")
            {
                SQL = @" select distinct tran_type from all_accounts_journal where left(elt_account_number,5) = " +
                    elt_account_number.Substring(0, 5) + " and isnull(tran_type,'1') <> '1'";
            }
            else
            {
                SQL = @" select distinct tran_type from all_accounts_journal where elt_account_number = " +
                    elt_account_number + " and isnull(tran_type,'1') <> '1'";
            }
            List<GLTransactionType> items = new List<GLTransactionType>();
            SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Cmd.CommandText = SQL;
            try
            {
                Con.Open();

                using (SqlDataReader reader = Cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        items.Add(new GLTransactionType { tran_type = Convert.ToString(reader["tran_type"]) });
                    }
                }

            }
            catch (Exception ex)
            {

            }
            finally
            {
                Con.Close();
                Con.Dispose();
            }              
            return items;
        }
        public List<GLAccount> GetAllGLAccount(string elt_account_number)
        {
            string SQL = string.Empty;
            if (elt_account_number.Substring(6, 2) == "00")
            {
                SQL = @" select distinct gl_account_number,(rtrim(str(gl_account_number)) + ' : ' + gl_account_name) as gl_text   from all_accounts_journal where left(elt_account_number,5) = " +
                    elt_account_number.Substring(0, 5) + " and isnull(gl_account_number,'1') <> '1' and isnull(gl_account_name,'1') <> '1' order by gl_account_number";
            }
            else
            {
                SQL = @" select distinct gl_account_number,(rtrim(str(gl_account_number)) + ' : ' + gl_account_name) as gl_text   from all_accounts_journal where elt_account_number = " +
                    elt_account_number + " and isnull(gl_account_number,'1') <> '1' and isnull(gl_account_name,'1') <> '1' order by gl_account_number";
            }

            List<GLAccount> items = new List<GLAccount>();
            SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Cmd.CommandText = SQL;
            try
            {
                Con.Open();

                using (SqlDataReader reader = Cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        items.Add(new GLAccount { gl_account_number = Convert.ToInt32(reader["gl_account_number"]), gl_text = Convert.ToString(reader["gl_text"]) });
                    }
                }

            }
            catch (Exception ex)
            {

            }
            finally
            {
                Con.Close();
                Con.Dispose();
            }
            return items;
        }    
    }   
}
