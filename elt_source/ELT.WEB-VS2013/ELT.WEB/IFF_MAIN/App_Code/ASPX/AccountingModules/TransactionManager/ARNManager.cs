using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Collections;
using System.Text;


/// <summary>
/// Summary description for glManager
/// </summary>
public class ARNManager:Manager
{   
    private IVChargeItemsManager IVChManager;
    private IVCostItemsManager IVCostManager;
    private BillDetailManager bdMgr;
    private AllAccountsJournalManager aajMgr;

    public ARNManager(string elt_acct)
        : base(elt_acct)
    {
         IVChManager = new IVChargeItemsManager(elt_account_number);
        IVCostManager = new IVCostItemsManager(elt_account_number);
        bdMgr = new BillDetailManager(elt_account_number);
        aajMgr = new AllAccountsJournalManager(elt_account_number);
       
    }      

    public int getARN_NO(int invoice_no)
    {
        int return_val = 0;

        SQL = " select isnull(arn_no,0) as arn_no from import_hawb where elt_account_number = "
            + elt_account_number + " and invoice_no=" + invoice_no;

        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        customerCreditRecord cCRec = new customerCreditRecord();
        GeneralUtility gUtil = new GeneralUtility();

        try
        {
            ad.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                return_val = Int32.Parse(dt.Rows[0]["arn_no"].ToString());
            }
           
        }
        catch (Exception ex)
        {           
            throw ex;
        }
        finally
        {
           
        }
        return return_val;
    }

    public void deleteARNRecord(int invoice_no)
    {
        this.aajMgr.delete_Entries(invoice_no, "ARN");
        this.IVChManager.deleteIVChargeItems(invoice_no);
        this.IVCostManager.deleteIVCostItems(invoice_no);
        this.bdMgr.deleteBillDetailListForInvoice(invoice_no);      

        SQL = "delete from  import_hawb where elt_account_number = "+elt_account_number+" and invoice_no = " + invoice_no;
        Cmd = new SqlCommand(SQL, Con);

        try
        {               
            Con.Open();
            Cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            Con.Close();
        }

        SQL = "delete from  invoice where elt_account_number = " + elt_account_number + " and invoice_no = " + invoice_no;
        Cmd = new SqlCommand(SQL, Con);

        try
        {
            Con.Open();
            Cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            Con.Close();
        }

    }


    public ARNRecord getARNRecord(int invoice_no, string iType)
    {
        SQL = " select * from import_hawb where elt_account_number = "
            + elt_account_number + " and invoice_no=" + invoice_no+" and iType='"+iType+"'";
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        customerCreditRecord cCRec = new customerCreditRecord();
        GeneralUtility gUtil = new GeneralUtility();
        ARNRecord ARNRec = new ARNRecord();
        
        try
        {
            ad.Fill(dt);
            gUtil.removeNull(ref dt);

            if (dt.Rows.Count > 0)
            {
                ARNRec.arr_code = dt.Rows[0]["arr_code"].ToString();
                ARNRec.arr_port = dt.Rows[0]["arr_port"].ToString();             
                ARNRec.broker_info = dt.Rows[0]["broker_info"].ToString();
                ARNRec.broker_name = dt.Rows[0]["broker_name"].ToString();
                ARNRec.cargo_location = dt.Rows[0]["cargo_location"].ToString();
                ARNRec.consignee_info = dt.Rows[0]["consignee_info"].ToString();
                ARNRec.consignee_name = dt.Rows[0]["consignee_name"].ToString();
                ARNRec.container_location = dt.Rows[0]["container_location"].ToString();
                ARNRec.CreatedBy = dt.Rows[0]["CreatedBy"].ToString();
                ARNRec.CreatedDate = dt.Rows[0]["CreatedDate"].ToString();
                ARNRec.customer_ref = dt.Rows[0]["customer_ref"].ToString();
                ARNRec.delivery_place = dt.Rows[0]["delivery_place"].ToString();
                ARNRec.dep_code = dt.Rows[0]["dep_code"].ToString();
                ARNRec.dep_port = dt.Rows[0]["dep_port"].ToString();
                ARNRec.desc1 = dt.Rows[0]["desc1"].ToString();
                ARNRec.desc2 = dt.Rows[0]["desc2"].ToString();
                ARNRec.desc3 = dt.Rows[0]["desc3"].ToString();
                ARNRec.desc4 = dt.Rows[0]["desc4"].ToString();
                ARNRec.desc5 = dt.Rows[0]["desc5"].ToString();
                ARNRec.destination = dt.Rows[0]["destination"].ToString();
                ARNRec.eta = dt.Rows[0]["eta"].ToString();
                ARNRec.eta2 = dt.Rows[0]["eta2"].ToString();
                ARNRec.etd = dt.Rows[0]["etd"].ToString();
                ARNRec.etd2 = dt.Rows[0]["etd2"].ToString();
                ARNRec.flt_no = dt.Rows[0]["flt_no"].ToString();
                ARNRec.free_date = dt.Rows[0]["free_date"].ToString();
                ARNRec.go_date = dt.Rows[0]["go_date"].ToString();
                ARNRec.hawb_num = dt.Rows[0]["hawb_num"].ToString();
                ARNRec.igSub_HAWB = dt.Rows[0]["igSub_HAWB"].ToString();              
                ARNRec.is_default_rate = dt.Rows[0]["is_default_rate"].ToString();
                ARNRec.is_org_merged = dt.Rows[0]["is_org_merged"].ToString();
                ARNRec.it_date = dt.Rows[0]["it_date"].ToString();
                ARNRec.it_entry_port = dt.Rows[0]["it_entry_port"].ToString();
                ARNRec.it_number = dt.Rows[0]["it_number"].ToString();
                ARNRec.iType = dt.Rows[0]["iType"].ToString();
                ARNRec.mawb_num = dt.Rows[0]["mawb_num"].ToString();
                ARNRec.ModifiedBy = dt.Rows[0]["ModifiedBy"].ToString();
                ARNRec.ModifiedDate = dt.Rows[0]["ModifiedDate"].ToString();               
                ARNRec.notify_info = dt.Rows[0]["notify_info"].ToString();
                ARNRec.notify_name = dt.Rows[0]["notify_name"].ToString();            
                ARNRec.prepaid_collect = dt.Rows[0]["prepaid_collect"].ToString();
                ARNRec.prepared_by = dt.Rows[0]["prepared_by"].ToString();
                ARNRec.process_dt = dt.Rows[0]["process_dt"].ToString();
                ARNRec.processed = dt.Rows[0]["processed"].ToString();
                
                ARNRec.remarks = dt.Rows[0]["remarks"].ToString();
                ARNRec.SalesPerson = dt.Rows[0]["SalesPerson"].ToString();
                ARNRec.scale1 = dt.Rows[0]["scale1"].ToString();
                ARNRec.shipper_info = dt.Rows[0]["shipper_info"].ToString();
                ARNRec.shipper_name = dt.Rows[0]["shipper_name"].ToString();
                ARNRec.sub_mawb1 = dt.Rows[0]["sub_mawb1"].ToString();
                ARNRec.sub_mawb2 = dt.Rows[0]["sub_mawb2"].ToString();
                ARNRec.tran_dt = dt.Rows[0]["tran_dt"].ToString();
                ARNRec.uom = dt.Rows[0]["uom"].ToString();
                ARNRec.scale2 = dt.Rows[0]["scale2"].ToString();
                
                ARNRec.pickup_date = dt.Rows[0]["pickup_date"].ToString();

                ARNRec.term = Int32.Parse(dt.Rows[0]["term"].ToString());
                ARNRec.agent_elt_acct = Int32.Parse(dt.Rows[0]["agent_elt_acct"].ToString());
                ARNRec.agent_org_acct = Int32.Parse(dt.Rows[0]["agent_org_acct"].ToString());
                //ARNRec.arn_no = Int32.Parse(dt.Rows[0]["arn_no"].ToString());
                ARNRec.broker_acct = Int32.Parse(dt.Rows[0]["broker_acct"].ToString());
                ARNRec.consignee_acct = Int32.Parse(dt.Rows[0]["consignee_acct"].ToString());
                ARNRec.invoice_no = Int32.Parse(dt.Rows[0]["invoice_no"].ToString());
                ARNRec.shipper_acct = Int32.Parse(dt.Rows[0]["shipper_acct"].ToString());
                ARNRec.sec = Int32.Parse(dt.Rows[0]["sec"].ToString());
                ARNRec.notify_acct = Int32.Parse(dt.Rows[0]["notify_acct"].ToString());

                ARNRec.chg_wt = Decimal.Parse(dt.Rows[0]["chg_wt"].ToString());
                ARNRec.fc_charge = Decimal.Parse(dt.Rows[0]["fc_charge"].ToString());
                ARNRec.fc_rate = Decimal.Parse(dt.Rows[0]["fc_rate"].ToString());
                ARNRec.freight_collect = Decimal.Parse(dt.Rows[0]["freight_collect"].ToString());
                ARNRec.gross_wt = Decimal.Parse(dt.Rows[0]["gross_wt"].ToString());
                ARNRec.oc_collect = Decimal.Parse(dt.Rows[0]["oc_collect"].ToString());
                ARNRec.pieces = Decimal.Parse(dt.Rows[0]["pieces"].ToString());               
                ARNRec.total_other_charge = Decimal.Parse(dt.Rows[0]["total_other_charge"].ToString());
               
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
           
        }
        return ARNRec;
    }
    public bool insertARNRecord(ARNRecord arnRec)
    {
        arnRec.replaceQuote();       
        //INSERT IV CHARGE ITEMS 
        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;
        bool return_val = false;
        try
        {           
            //INSERT INVOICE RECORD 
            SQL = "INSERT INTO [import_hawb] ";
            SQL += "( elt_account_number, ";
            SQL += "agent_elt_acct,";
            SQL += " agent_org_acct ,";
           // SQL += "  arn_no  ,";
            SQL += " arr_code   ,";
            SQL += " arr_port ,";
            SQL += " broker_acct   ,";
            SQL += "  broker_info  ,";
            SQL += "  broker_name  ,";
            SQL += " cargo_location   ,";
            SQL += " chg_wt   ,";
            SQL += " consignee_acct   ,";
            SQL += "  consignee_info  ,";
            SQL += " consignee_name   ,";
            SQL += " container_location   ,";
            SQL += " CreatedBy   ,";
            SQL += " CreatedDate   ,";
            SQL += " customer_ref   ,";
            SQL += "  delivery_place  ,";
            SQL += " dep_code   ,";
            SQL += "  dep_port  ,";
            SQL += " desc1   ,";
            SQL += " desc2   ,";
            SQL += " desc3 ,";
            SQL += " desc4   ,";
            SQL += " desc5   ,";
            SQL += " destination   ,";
            SQL += " eta   ,";
            SQL += " eta2 ,";
            SQL += " etd   ,";
            SQL += "  etd2  ,";
            SQL += " fc_charge   ,";
            SQL += "fc_rate  ,";
            SQL += " flt_no   ,";
            SQL += " free_date   ,";
            SQL += " freight_collect   ,";
            SQL += " go_date   ,";
            SQL += " gross_wt   ,";
            SQL += " hawb_num   ,";
            SQL += " igSub_HAWB   ,";
            SQL += " invoice_no   ,";
            SQL += "  is_default_rate  ,";
            SQL += " is_org_merged ,";
            SQL += " it_date   ,";
            SQL += "  it_entry_port  ,";
            SQL += " it_number ,";
            SQL += " iType ,";
            SQL += " mawb_num   ,";
            SQL += "  ModifiedBy ,";
            SQL += " ModifiedDate   ,";
            SQL += " notify_acct   ,";
            SQL += " notify_info   ,";
            SQL += "  notify_name  ,";
            SQL += "oc_collect    ,";
            SQL += " pickup_date   ,";
            SQL += "pieces    ,";
            SQL += " prepaid_collect   ,";
            SQL += "prepared_by    ,";
            SQL += "process_dt    ,";
            SQL += " processed   ,";          
            SQL += " remarks ,";
            SQL += " SalesPerson   ,";
            SQL += "scale1   ,";
            SQL += " scale2   ,";
            SQL += " sec   ,";
            SQL += " shipper_acct   ,";
            SQL += " shipper_info ,";
            SQL += " shipper_name   ,";
            SQL += " sub_mawb1   ,";
            SQL += "sub_mawb2   ,";
            SQL += " term   ,";
            SQL += "total_other_charge  ,";
            SQL += "tran_dt    ,";
            SQL += "uom ) ";
            SQL += "VALUES";
            SQL += "('" + base.elt_account_number;
            SQL += "','" + arnRec.agent_elt_acct;
            SQL += "','" + arnRec.agent_org_acct;  
            //SQL += "','" + arnRec.arn_no;  
            SQL += "','" + arnRec.arr_code;  
            SQL += "','" + arnRec.arr_port;
            SQL += "','" + arnRec.broker_acct;  
            SQL += "','" + arnRec.broker_info;  
            SQL += "','" + arnRec.broker_name;  
            SQL += "','" + arnRec.cargo_location;  
            SQL += "','" + arnRec.chg_wt;  
            SQL += "','" + arnRec.consignee_acct;  
            SQL += "','" + arnRec.consignee_info;  
            SQL += "','" + arnRec.consignee_name;  
            SQL += "','" + arnRec.container_location;  
            SQL += "','" + arnRec.CreatedBy;  
            SQL += "','" + arnRec.CreatedDate; // 
            SQL += "','" + arnRec.customer_ref;  
            SQL += "','" + arnRec.delivery_place;  
            SQL += "','" + arnRec.dep_code;  
            SQL += "','" + arnRec.dep_port;  
            SQL += "','" + arnRec.desc1;  
            SQL += "','" + arnRec.desc2;  
            SQL += "','" + arnRec.desc3;
            SQL += "','" + arnRec.desc4;  
            SQL += "','" + arnRec.desc5;  
            SQL += "','" + arnRec.destination;  
            SQL += "','" + arnRec.eta;  
            SQL += "','" + arnRec.eta2;
            SQL += "','" + arnRec.etd;  
            SQL += "','" + arnRec.etd2;  
            SQL += "','" + arnRec.fc_charge;  
            SQL += "','" + arnRec.fc_rate;
            SQL += "','" + arnRec.flt_no;
            SQL += "','" + arnRec.free_date;//   
            SQL += "','" + arnRec.freight_collect;
            SQL += "','" + arnRec.go_date;// 
            SQL += "','" + arnRec.gross_wt;  
            SQL += "','" + arnRec.hawb_num;  
            SQL += "','" + arnRec.igSub_HAWB;  
            SQL += "','" + arnRec.invoice_no;  
            SQL += "','" + arnRec.is_default_rate;  
            SQL += "','" + arnRec.is_org_merged;
            SQL += "','" + arnRec.it_date; //  
            SQL += "','" + arnRec.it_entry_port;  
            SQL += "','" + arnRec.it_number;
            SQL += "','" + arnRec.iType;
            SQL += "','" + arnRec.mawb_num;  
            SQL += "','" + arnRec.ModifiedBy; 
            SQL += "','" + arnRec.ModifiedDate;  
            SQL += "','" + arnRec.notify_acct;  
            SQL += "','" + arnRec.notify_info;  
            SQL += "','" + arnRec.notify_name;  
            SQL += "','" + arnRec.oc_collect;  
            SQL += "','" + arnRec.pickup_date;//  
            SQL += "','" + arnRec.pieces;  
            SQL += "','" + arnRec.prepaid_collect;  
            SQL += "','" + arnRec.prepared_by;  
            SQL += "','" + arnRec.process_dt;  
            SQL += "','" + arnRec.processed;          
            SQL += "','" + arnRec.remarks;
            SQL += "','" + arnRec.SalesPerson;  
            SQL += "','" + arnRec.scale1; 
            SQL += "','" + arnRec.scale2;  
            SQL += "','" + arnRec.sec;  
            SQL += "','" + arnRec.shipper_acct;  
            SQL += "','" + arnRec.shipper_info;
            SQL += "','" + arnRec.shipper_name;  
            SQL += "','" + arnRec.sub_mawb1;  
            SQL += "','" + arnRec.sub_mawb2; 
            SQL += "','" + arnRec.term;  
            SQL += "','" + arnRec.total_other_charge;
            SQL += "','" + arnRec.tran_dt;  
            SQL += "','" + arnRec.uom; 
            SQL += "')";

            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();
            trans.Commit();            
            return_val = true;
        }
        catch (Exception ex)
        {
            trans.Rollback();
            throw ex;
        }
        finally
        {
            Con.Close();
        }
        return return_val;
    }

    public bool updateARNRecord(ref ARNRecord arnRec)
    {
        arnRec.replaceQuote();
        //INSERT IV CHARGE ITEMS 
        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;
        bool return_val = false;
        try
        {
            SQL = "UPDATE import_hawb ";
            SQL += "set elt_account_number='" +elt_account_number + "'";
            SQL += ",agent_elt_acct='" + arnRec.agent_elt_acct + "'";
            SQL += ",agent_org_acct ='" + arnRec.agent_org_acct + "'";
           // SQL += ",arn_no  ='" + arnRec.arn_no + "'";
            SQL += ",arr_code   ='" + arnRec.arr_code + "'";
            SQL += ",arr_port ='" + arnRec.arr_port + "'";
            SQL += ",broker_acct   ='" + arnRec.broker_acct + "'";
            SQL += " ,broker_info  ='" + arnRec.broker_info + "'";
            SQL += " , broker_name  ='" + arnRec.broker_name + "'";
            SQL += " ,cargo_location   ='" + arnRec.cargo_location + "'";
            SQL += " ,chg_wt   ='" + arnRec.chg_wt + "'";
            SQL += ", consignee_acct   ='" + arnRec.consignee_acct + "'";
            SQL += " , consignee_info  ='" + arnRec.consignee_info + "'";
            SQL += " ,consignee_name   ='" + arnRec.consignee_name + "'";
            SQL += " ,container_location   ='" + arnRec.container_location + "'";
            SQL += " ,CreatedBy   ='" + arnRec.CreatedBy + "'";
            SQL += " ,CreatedDate   ='" + arnRec.CreatedDate + "'";
            SQL += " ,customer_ref   ='" + arnRec.customer_ref + "'";
            SQL += " , delivery_place  ='" + arnRec.delivery_place + "'";
            SQL += " ,dep_code   ='" + arnRec.dep_code + "'";
            SQL += " , dep_port  ='" + arnRec.dep_port + "'";
            SQL += " ,desc1   ='" + arnRec.desc1 + "'";
            SQL += " ,desc2   ='" + arnRec.desc2 + "'";
            SQL += " ,desc3 ='" + arnRec.desc3 + "'";
            SQL += " ,desc4   ='" + arnRec.desc4 + "'";
            SQL += " ,desc5   ='" + arnRec.desc5 + "'";
            SQL += " ,destination   ='" + arnRec.destination + "'";
            SQL += " ,eta   ='" + arnRec.eta + "'";
            SQL += " ,eta2 ='" + arnRec.eta2 + "'";
            SQL += " ,etd   ='" + arnRec.etd + "'";
            SQL += "  ,etd2  ='" + arnRec.etd2 + "'";
            SQL += ", fc_charge   ='" + arnRec.fc_charge + "'";
            SQL += ",fc_rate  ='" + arnRec.fc_rate + "'";
            SQL += " ,flt_no   ='" + arnRec.flt_no + "'";
            SQL += " ,free_date   ='" + arnRec.free_date + "'";
            SQL += " ,freight_collect   ='" + arnRec.freight_collect + "'";
            SQL += " ,go_date   ='" + arnRec.go_date + "'";
            SQL += " ,gross_wt   ='" + arnRec.gross_wt + "'";
            SQL += " ,hawb_num   ='" + arnRec.hawb_num + "'";
            SQL += " ,igSub_HAWB   ='" + arnRec.igSub_HAWB + "'";
            SQL += " ,invoice_no   ='" + arnRec.invoice_no + "'";
            SQL += " , is_default_rate  ='" + arnRec.is_default_rate + "'";
            SQL += " ,is_org_merged ='" + arnRec.is_org_merged + "'";
            SQL += " ,it_date   ='" + arnRec.it_date + "'";
            SQL += " , it_entry_port  ='" + arnRec.it_entry_port + "'";
            SQL += " ,it_number ='" + arnRec.it_number + "'";
            SQL += " ,iType ='" + arnRec.iType + "'";
            SQL += " ,mawb_num   ='" + arnRec.mawb_num + "'";
            SQL += " , ModifiedBy ='" + arnRec.ModifiedBy + "'";
            SQL += " ,ModifiedDate   ='" + arnRec.ModifiedDate + "'";
            SQL += " ,notify_acct   ='" + arnRec.notify_acct + "'";
            SQL += " ,notify_info   ='" + arnRec.notify_info + "'";
            SQL += " , notify_name  ='" + arnRec.notify_name + "'";
            SQL += ",oc_collect    ='" + arnRec.oc_collect + "'";
            SQL += ", pickup_date   ='" + arnRec.pickup_date + "'";
            SQL += ",pieces    ='" + arnRec.pieces + "'";
            SQL += " ,prepaid_collect   ='" + arnRec.prepaid_collect + "'";
            SQL += ",prepared_by    ='" + arnRec.prepared_by + "'";
            SQL += ",process_dt    ='" + arnRec.process_dt + "'";
            SQL += " ,processed   ='" + arnRec.processed + "'";
        
            SQL += " ,remarks ='" + arnRec.remarks + "'";
            SQL += " ,SalesPerson   ='" + arnRec.SalesPerson + "'";
            SQL += ",scale1   ='" + arnRec.scale1 + "'";
            SQL += " ,scale2   ='" + arnRec.scale2 + "'";
            SQL += " ,sec   ='" + arnRec.sec + "'";
            SQL += " ,shipper_acct   ='" + arnRec.shipper_acct + "'";
            SQL += " ,shipper_info ='" + arnRec.shipper_info + "'";
            SQL += " ,shipper_name   ='" + arnRec.shipper_name + "'";
            SQL += " ,sub_mawb1   ='" + arnRec.sub_mawb1 + "'";
            SQL += ",sub_mawb2   ='" + arnRec.sub_mawb2 + "'";
            SQL += " ,term   ='" + arnRec.term + "'";
            SQL += ",total_other_charge  ='" + arnRec.total_other_charge + "'";
            SQL += ",tran_dt    ='" + arnRec.tran_dt + "'";
            SQL += ",uom = '" + arnRec.uom + "'";
            SQL += " WHERE elt_account_number =" + elt_account_number;
            SQL += " and invoice_no =" + arnRec.invoice_no;
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();
            trans.Commit();
            return_val = true;
        }
        catch (Exception ex)
        {
            trans.Rollback();
            throw ex;
        }
        finally
        {
            Con.Close();
        }
        return return_val;
            
    }

  
}
