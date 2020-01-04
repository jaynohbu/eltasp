using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public class IVQRecord
{
    private int queue_id;

    public int Queue_id
    {
        get { return queue_id; }
        set { queue_id = value; }
    }
    private string inqueue_date;

    public string Inqueue_date
    {
        get { return inqueue_date; }
        set { inqueue_date = value; }
    }
    
    private string hawb_num;

    public string Hawb_num
    {
        get { return hawb_num; }
        set { hawb_num = value; }
    }
    private string mawb_num;

    public string Mawb_num
    {
        get { return mawb_num; }
        set { mawb_num = value; }
    }
    private string bill_to;

    public string Bill_to
    {
        get { return bill_to; }
        set { bill_to = value; }
    }
    private int bill_to_org_acct;

    public int Bill_to_org_acct
    {
        get { return bill_to_org_acct; }
        set { bill_to_org_acct = value; }
    }
    private int agent_org_acct;

    public int Agent_org_acct
    {
        get { return agent_org_acct; }
        set { agent_org_acct = value; }
    }
    private string master_agent;

    public string Master_agent
    {
        get { return master_agent; }
        set { master_agent = value; }
    }
    private string air_ocean;

    public string Air_ocean
    {
        get { return air_ocean; }
        set { air_ocean = value; }
    }
    private string master_only;

    public string Master_only
    {
        get { return master_only; }
        set { master_only = value; }
    }
    private string invoiced;

    public string Invoiced
    {
        get { return invoiced; }
        set { invoiced = value; }
    }
    private int pieces;
    public int Pieces
    {
        get { return pieces; }
        set { pieces = value; }
    }
    private Decimal chargeable_weight;
    public Decimal Chargeable_weight
    {
        get { return chargeable_weight; }
        set { chargeable_weight = value; }
    }

    private Decimal gross_weight;

    public Decimal Gross_weight
    {
        get { return gross_weight; }
        set { gross_weight = value; }
    }
  

    private string etd;
    public string ETD
    {
        get { return etd; }
        set { etd = value; }
    }
    private string eta;
    public string ETA
    {
        get { return eta; }
        set { eta = value; }
    }
   
       
    public IVQRecord()
    {

    }

    private string agent_shipper;
    public string Agent_shipper
    {
        get { return agent_shipper; }
        set { agent_shipper = value; }
    }
    private string agent_name;
    public string Agent_name
    {
        get { return agent_name; }
        set { agent_name = value; }
    }
    private string consignee;
    public string Consignee
    {
        get { return consignee; }
        set { consignee = value; }
    }
    private string shipper;
    public string Shipper
    {
        get { return shipper; }
        set { shipper = value; }
    }

    private string file_no;
    public string FileNo
    {
        get { return file_no; }
        set { file_no = value; }
    }


    public void replaceQuote()
    {
        GeneralUtility gUtil = new GeneralUtility();
        agent_shipper = gUtil.replaceQuote(agent_shipper);
        agent_name = gUtil.replaceQuote(agent_name);
        consignee = gUtil.replaceQuote(consignee);
        shipper = gUtil.replaceQuote(shipper);
        file_no = gUtil.replaceQuote(file_no);
    }

    public string origin;
    public string destination;
    public string carrier;

}
