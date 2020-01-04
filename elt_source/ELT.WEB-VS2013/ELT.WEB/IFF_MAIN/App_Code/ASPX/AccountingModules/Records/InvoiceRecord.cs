using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections;



/// <summary>
/// Summary description for InvoiceRecord
/// </summary>
public class InvoiceRecord
{
    private ArrayList chargeItemList;

    public ArrayList ChargeItemList
    {
        
        get { return chargeItemList; }
    }
    public void setChargeItemListWithChargeItemArrayList(ArrayList chlist)
    {
        ArrayList newList = new ArrayList();
        for (int i = 0; i < chlist.Count; i++)
        {
            ChargeItemRecord cR = (ChargeItemRecord)chlist[i];
            IVChargeItemRecord IVcR = new IVChargeItemRecord();
            IVcR.Invoice_no = this.invoice_no;
            IVcR.Charge_amount = cR.Amount;
            IVcR.Item_desc = cR.Description;
            IVcR.Item_id = cR.ItemId;
            IVcR.Item_no = cR.ItemNo;
           
            string iType = "";
            if (cR.Waybill_type == "HAWB" || cR.Waybill_type == "MAWB")
            {
                iType = "A";
               
                 
            }
            else if (cR.Waybill_type == "HBOL" || cR.Waybill_type == "MBOL")
            {
                iType = "O";
               
            }

            IVcR.IType = iType;
            IVcR.Hb_no = cR.Hb;
            IVcR.Mb_no = cR.Mb;

            IVcR.Import_export = cR.Import_export;
            newList.Add(IVcR);
        }
        chargeItemList = newList;
    }

    public void setChargeItemListWithDataTable(DataTable dt)
    {          
            ArrayList newList = new ArrayList();
            for (int i = 0; i < dt.Rows.Count; i++)
            {              
                IVChargeItemRecord IVcR = new IVChargeItemRecord();
                IVcR.Invoice_no = this.invoice_no;
                IVcR.Charge_amount = Decimal.Parse(dt.Rows[i]["charge_amount"].ToString());
                IVcR.Item_desc = dt.Rows[i]["item_desc"].ToString();
                IVcR.Item_id = Int32.Parse(dt.Rows[i]["item_id"].ToString());
                IVcR.Item_no = Int32.Parse(dt.Rows[i]["item_no"].ToString());
                IVcR.IType = dt.Rows[i]["iType"].ToString();
                IVcR.Hb_no = dt.Rows[i]["hb_no"].ToString();
                IVcR.Mb_no = dt.Rows[i]["mb_no"].ToString();
                IVcR.Import_export = dt.Rows[i]["import_export"].ToString();
                newList.Add(IVcR);
            }
            chargeItemList = newList;       
    }


    public void setCostItemListWithDataTable(DataTable dt)
    {
        ArrayList newList = new ArrayList();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            IVCostItemRecord IVcR = new IVCostItemRecord();
            IVcR.Invoice_no = this.invoice_no;
            IVcR.Cost_amount = Decimal.Parse(dt.Rows[i]["cost_amount"].ToString());
            IVcR.Item_desc = dt.Rows[i]["item_desc"].ToString();
            IVcR.Item_id = Int32.Parse(dt.Rows[i]["item_id"].ToString());
            IVcR.Item_no = Int32.Parse(dt.Rows[i]["item_no"].ToString());


            IVcR.IType = dt.Rows[i]["iType"].ToString();
            IVcR.Hb_no = dt.Rows[i]["hb_no"].ToString();
            IVcR.Mb_no = dt.Rows[i]["mb_no"].ToString();
            
            IVcR.Ref_no = dt.Rows[i]["ref_no"].ToString();
            IVcR.Vendor_no = Int32.Parse(dt.Rows[i]["vendor_no"].ToString());
            IVcR.Import_export = dt.Rows[i]["import_export"].ToString();
            newList.Add(IVcR);
        }
        costItemList = newList;
    }
    public void setCostItemListWithCostItemArrayList(ArrayList costlist)
    {
        ArrayList newList = new ArrayList();
        for (int i = 0; i < costlist.Count; i++)
        {
            CostItemRecord cR = (CostItemRecord)costlist[i];
            IVCostItemRecord IVcR = new IVCostItemRecord();
            IVcR.Invoice_no = this.invoice_no;
            IVcR.Cost_amount = cR.Amount;
            IVcR.Item_desc = cR.Description;
            IVcR.Item_id = cR.ItemId;
            IVcR.Item_no = cR.ItemNo;

            string iType = "";
            if (cR.Waybill_type == "HAWB" || cR.Waybill_type == "MAWB")
            {
                iType = "A";
            }
            else if(cR.Waybill_type == "HBOL" || cR.Waybill_type == "MBOL")
            {
                iType = "O";
            }

            IVcR.IType = iType;
            IVcR.Hb_no = cR.Hb;
            IVcR.Mb_no = cR.Mb;

            IVcR.Vendor_no = cR.Vendor_no;
            IVcR.Ref_no = cR.Ref_no;
            IVcR.Import_export = cR.Import_export;
            newList.Add(IVcR);
        }
        costItemList = newList;
    }
    private ArrayList billDetailList;

    public ArrayList BillDetailList
    {
        get { return billDetailList; }
        set
        {
            value = BillDetailList;
        }
    }

    public void setBillDetailWithCostItemArrayList(ArrayList costlist)
    {
        ArrayList newList = new ArrayList();
        for (int i = 0; i < costlist.Count; i++)
        {
            try
            {
                CostItemRecord cR = (CostItemRecord)costlist[i];
                if (!cR.ap_lock)
                {
                    BillDetailRecord BDRec = new BillDetailRecord();
                    BDRec.invoice_no = this.invoice_no;
                    BDRec.item_amt = cR.Amount;
                    BDRec.item_id = cR.ItemId;
                    BDRec.item_no = cR.ItemNo;

                    string iType = "";
                    if (cR.Waybill_type == "HAWB" || cR.Waybill_type == "MAWB")
                    {
                        iType = "A";
                    }
                    else if (cR.Waybill_type == "HBOL" || cR.Waybill_type == "MBOL")
                    {
                        iType = "O";
                    }
                    else
                    {


                    }
                    BDRec.import_export = cR.Import_export;
                    BDRec.iType = iType;
                    BDRec.mb_no = cR.Mb;
                    BDRec.hb_no = cR.Hb;
                    BDRec.ref_no = cR.Ref_no;
                    BDRec.tran_date = this.invoice_date;
                    BDRec.vendor_name = cR.Vendor_name;
                    BDRec.vendor_number = cR.Vendor_no;
                    newList.Add(BDRec);
                }
            }
            catch (Exception ex)
            {
                
                throw ex;
            }
        }
        billDetailList = newList;
    }

    private ArrayList costItemList;

    public ArrayList CostItemList
    {     
        get { return costItemList; }
    }


    private ArrayList aajList;

    public ArrayList AllAccountsJournalList
    {
        get { return aajList; }
        set { aajList = value; }
    }

    

    private ArrayList invoiceHeaders;
    public ArrayList InvoiceHeaders
    {
        get { return invoiceHeaders; }
        set { invoiceHeaders = value; }
    }

	public InvoiceRecord()
	{
        chargeItemList = new ArrayList();
        costItemList = new ArrayList();
    }

    public int getCostItemCount(){
        return costItemList.Count;
    }

    public int getchargeItemCount()
    {
        return chargeItemList.Count;
    }

    private int invoice_no;
    public int Invoice_no
    {
        get { return invoice_no; }
        set
        {
            invoice_no = value;
            for (int i = 0; i < chargeItemList.Count; i++)
            {
               ((IVChargeItemRecord)chargeItemList[i]).Invoice_no= invoice_no;
              
            }
            for (int i = 0; i < costItemList.Count; i++)
            {               
                ((IVCostItemRecord)costItemList[i]).Invoice_no = invoice_no;
            }
        }
    }

    public string invoice_type;
    public string import_export;
    public string air_ocean;
    public string inland_type; //added by stanley on 12/14
    public string invoice_date;

    public string ref_no;
    public string ref_no_Our;
    public string AMS_No;
    public string Customer_info;
    public string Description;
    public string Customer_Name;
    public string shipper;
    public string consignee;
    public string in_memo;
    public string Carrier;


    public string Total_Gross_Weight;
    public string Total_Charge_Weight;
    public string Total_Pieces;
    public string Origin_Dest;
    public string origin;
    public string dest;
    public int Customer_Number;
    
   
    public string entry_no;
    public string entry_date;
   
    public string Arrival_Dept;
    public string mawb_num;
    public string hawb_num;
    public Decimal subtotal;
    public Decimal sale_tax;
    public Decimal agent_profit;
    public int accounts_receivable;
    public Decimal amount_charged;
    public Decimal amount_paid;
    public Decimal balance;
    public Decimal total_cost;
    public string remarks;
    public string pay_status;
    public string term30;
    public string term60;
    public int term_curr;
    public string term90;
    public Decimal received_amt;
  
    public string pmt_method;
    public Decimal existing_credits;
    public int deposit_to;
    public string lock_ar;
    public string lock_ap;
    
    public string is_org_merged;
    public bool is_deleted;

    public void replaceQuote()
    {
        GeneralUtility gUtil = new GeneralUtility();
        ref_no  =  gUtil.replaceQuote( ref_no );   
        ref_no_Our  =  gUtil.replaceQuote( ref_no_Our );
        AMS_No = gUtil.replaceQuote(AMS_No);
        Customer_info  =  gUtil.replaceQuote( Customer_info );  
        Description  =  gUtil.replaceQuote( Description );  
        Customer_Name  =  gUtil.replaceQuote( Customer_Name );  
        shipper  =  gUtil.replaceQuote( shipper );
        consignee  =  gUtil.replaceQuote( consignee );
        in_memo  =  gUtil.replaceQuote( in_memo );
        Carrier  =  gUtil.replaceQuote( Carrier );
        origin = gUtil.replaceQuote(origin);
        dest = gUtil.replaceQuote(dest);
    } 
  
}
