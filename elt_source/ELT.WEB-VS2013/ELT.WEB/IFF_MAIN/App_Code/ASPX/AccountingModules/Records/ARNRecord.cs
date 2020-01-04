using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

/// <summary>
/// Summary description for ARNRecord
/// </summary>
public class ARNRecord
{

    public int agent_org_acct;
    public int agent_elt_acct;
   
    public int term;
   // public int arn_no;
    public int sec;
    public int invoice_no;
    public int shipper_acct;
    public int notify_acct;
    public int broker_acct;
    public Decimal pieces;
    public int consignee_acct;
    public string dep_code;
    public string arr_code;
    public string tran_dt;
    public string iType;
    public string mawb_num;
    public string hawb_num;
    public string process_dt;
    public string processed;
    public string shipper_name;
    public string shipper_info;
    public string consignee_name;
    public string consignee_info;
    public string notify_name;
    public string notify_info;
    public string broker_info;
    public string uom;
    public string prepaid_collect;
    public string scale1;
    public string prepared_by;
    public string sub_mawb1;
    public string sub_mawb2;
    public string customer_ref;
    public string delivery_place;
    public string etd2;
    public string eta2;
    public string container_location;
    public string destination;
    public string free_date;
    public string go_date;
    public string it_number;
    public string it_date;
    public string it_entry_port;
    public string cargo_location;
    public string desc1;
    public string desc2;
    public string desc3;
    public string desc4;
    public string desc5;
    public string remarks;
    public string pickup_date;
    public string igSub_HAWB;
    public string SalesPerson;
    public string CreatedBy;
    public string CreatedDate;
    public string ModifiedBy;
    public string ModifiedDate;
    public string is_default_rate;
    public string eta;
    public string etd;
    public string flt_no;
    public string broker_name;
    public string is_org_merged;
    public string dep_port;
    public string arr_port;
    public string ref_no_our;
    public string AMS_No; //added by stanley on 12/13
    public string inland_type; //added by stanley on 12/14
    public string scale2;
    public string carrier_code;
    public Decimal gross_wt;
    public Decimal chg_wt;   
    public Decimal freight_collect;
    public Decimal oc_collect;
    public Decimal fc_rate;
    public Decimal fc_charge;
    public Decimal total_other_charge;

    public void replaceQuote()
    {
        GeneralUtility gUtil = new GeneralUtility();      
        shipper_name = gUtil.replaceQuote(shipper_name);        
        shipper_info = gUtil.replaceQuote(shipper_info);       
        consignee_name = gUtil.replaceQuote(consignee_name);       
        consignee_info = gUtil.replaceQuote(consignee_info);        
        notify_name = gUtil.replaceQuote(notify_name);        
        notify_info = gUtil.replaceQuote(notify_info);       
        broker_info = gUtil.replaceQuote(broker_info);        
        customer_ref = gUtil.replaceQuote(customer_ref);      
        delivery_place = gUtil.replaceQuote(delivery_place);      
        container_location = gUtil.replaceQuote(container_location);       
        destination = gUtil.replaceQuote(destination);       
        it_entry_port = gUtil.replaceQuote(it_entry_port);
        cargo_location = gUtil.replaceQuote(cargo_location);   
        desc1 = gUtil.replaceQuote(desc1);
        desc2 = gUtil.replaceQuote(desc2);    
        desc3 = gUtil.replaceQuote(desc3);    
        desc4 = gUtil.replaceQuote(desc4);      
        desc5 = gUtil.replaceQuote(desc5);      
        remarks = gUtil.replaceQuote(remarks);      
        pickup_date = gUtil.replaceQuote(pickup_date);      
        igSub_HAWB = gUtil.replaceQuote(igSub_HAWB);   
        SalesPerson = gUtil.replaceQuote(SalesPerson);      
        CreatedBy = gUtil.replaceQuote(CreatedBy);        
        ModifiedBy = gUtil.replaceQuote(ModifiedBy);       
        flt_no = gUtil.replaceQuote(flt_no);       
        broker_name = gUtil.replaceQuote(broker_name);
        arr_port = gUtil.replaceQuote(arr_port);
        dep_port = gUtil.replaceQuote(dep_port); 
        
    }
   

	public ARNRecord()
	{
		
	}



}
