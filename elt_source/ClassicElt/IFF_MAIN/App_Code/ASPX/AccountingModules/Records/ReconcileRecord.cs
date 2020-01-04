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
/// Summary description for ReconcileRecord
/// </summary>
public class ReconcileRecord
{
    public  DataTable dtReceivement;
    public  DataTable dtPayment;

    public ArrayList receivementDetailList;
    public ArrayList paymentDetailList;

    public int recon_id;
    public string elt_account_number;    
    public string modified_date;
    public string recon_state;//I,C
    public string created_date;
    public string statement_ending_date;

    public string Statement_ending_date
    {
        get { return statement_ending_date; }
        set
        {
            statement_ending_date = value;
        }
    }
    public string reconcile_date;


    public string service_charge_date;
    public string interested_earned_date;

    public int bank_account_number;
    public int gj_entry_no;
    public Decimal system_balance_asof_recon_date;
    public Decimal opening_balance;
    public Decimal total_cleared;
    public Decimal statement_ending_balance;
    public Decimal total_uncleared;
    public Decimal system_balance_asof_statement;    
    public Decimal total_unclear_after_statement;
    public Decimal service_charge;
    public Decimal interest_earned;
    public string recon_beginning_date;


    public ArrayList AAJEntryList;

	public ReconcileRecord()
	{
		//
		// TODO: Add constructor logic here
		//
	}
}
