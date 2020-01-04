using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class ASPX_AccountingTasks_Controls_BillListControl:System.Web.UI.UserControl
{
    private string elt_account_number;
    private string user_id, login_name, user_right;
    private string ConnectStr; 
    private DataTable dtBillList;    
    private Decimal total_amount;
    private Hashtable parentObject;
  
    private ArrayList billList;

    public ArrayList BillList
    {
        get
        {
            getValuesFromGrid();
            return billList;
        }
    }

    private ArrayList checkDetailList;

    public ArrayList CheckDetailList
    {
        get
        {
            getValuesFromGrid();
            return checkDetailList;
        }
    }


   // private TextBox balance;

    public Decimal Total_Amount
    {
        get {             
            return total_amount;        
        }
    }
    public void Clear()
    {
        dtBillList = (DataTable)Session["dtBillList"];
        if (dtBillList != null)
        {
            dtBillList.Clear();
            this.reBind_BillChangesToGrid(dtBillList,false);
            Session["dtBillList"] = null;
        }
    }

    public void setParentControl(Object control){
        if (parentObject==null)
        {
             parentObject = new Hashtable();
        }
        parentObject.Add(((WebControl)control).ID, control);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (parentObject == null)
        {
            parentObject = new Hashtable();
        }
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        ConnectStr = (new igFunctions.DB().getConStr());
    }     

    public void reBind_BillChangesToGrid(DataTable dt,bool fromCheckTable)
    {
        this.GridViewBillItem.Enabled = true;
        try
        {
            total_amount = 0;
            Decimal due_money = 0;
            this.GridViewBillItem.DataSource = dt.DefaultView;
            this.GridViewBillItem.DataBind();
            this.hClearIDs.Value = "";
            this.hDueIDs.Value = "";
            Decimal dueTotalClearAmt = 0;
            Decimal dueTotalDueAmt = 0;
            for (int i = 0; i < this.GridViewBillItem.Rows.Count; i++)
            {
                ((TextBox)this.GridViewBillItem.Rows[i].FindControl("txtBillAmount")).Text = Decimal.Parse(dt.Rows[i]["bill_amt"].ToString()).ToString("N2");
                ((TextBox)this.GridViewBillItem.Rows[i].FindControl("txtAmountDue")).Text = Decimal.Parse(dt.Rows[i]["bill_amt_due"].ToString()).ToString("N2");

                if (fromCheckTable)
                {
                    ((TextBox)this.GridViewBillItem.Rows[i].FindControl("txtAmountClear")).Text = Decimal.Parse(dt.Rows[i]["bill_amt_paid"].ToString()).ToString("N2");
                    ((Image)this.GridViewBillItem.Rows[i].FindControl("btnCheck")).ImageUrl = "~/ASPX/AccountingTasks/images/mark_x.gif";
                }
                dueTotalClearAmt += Decimal.Parse(dt.Rows[i]["bill_amt_paid"].ToString());
                dueTotalDueAmt += Decimal.Parse(dt.Rows[i]["bill_amt_due"].ToString());
                ((TextBox)this.GridViewBillItem.Rows[i].FindControl("txtMemo")).Text = dt.Rows[i]["memo"].ToString();
                ((TextBox)this.GridViewBillItem.Rows[i].FindControl("txtDueDate")).Text = DateTime.Parse(dt.Rows[i]["bill_due_date"].ToString()).ToShortDateString();
                string clear_hidden = ((HiddenField)this.GridViewBillItem.Rows[i].FindControl("hPrevious")).ClientID;

                string checkbox = ((Image)this.GridViewBillItem.Rows[i].FindControl("btnCheck")).ClientID;
                string clearTotal = ((TextBox)this.GridViewBillItem.FooterRow.FindControl("txtAmtClearTotal")).ClientID;

                string clear = ((TextBox)this.GridViewBillItem.Rows[i].FindControl("txtAmountClear")).ClientID;
                string due = ((TextBox)this.GridViewBillItem.Rows[i].FindControl("txtAmountDue")).ClientID;
                string IsChecked = ((HiddenField)this.GridViewBillItem.Rows[i].FindControl("hIsChecked")).ClientID;
                due_money += Decimal.Parse(((TextBox)this.GridViewBillItem.Rows[i].FindControl("txtAmountDue")).Text);
                this.hClearIDs.Value += clear + "^^";
                this.hDueIDs.Value += due + "^^";
                ((Image)this.GridViewBillItem.Rows[i].FindControl("btnCheck")).Attributes.Add("onclick", "check_clicked(" + checkbox + "," + due + "," + clear + "," + IsChecked + ")");               
                ((TextBox)this.GridViewBillItem.Rows[i].FindControl("txtAmountClear")).Attributes.Add("onblur", "clear_changed(" + checkbox + "," + due + "," + clear + "," + IsChecked + ")");      
                ((TextBox)this.GridViewBillItem.Rows[i].FindControl("txtAmountClear")).Attributes.Add("onfocus", "save_prev(" + clear + ")");

            }
            if (this.GridViewBillItem.Rows.Count > 0)
            {
                ((TextBox)this.GridViewBillItem.FooterRow.FindControl("txtAmtDueTotal")).Text = due_money.ToString("N2");
                this.hTotalDue.Value = ((TextBox)this.GridViewBillItem.FooterRow.FindControl("txtAmtDueTotal")).ClientID;
                this.hTotalClear.Value = ((TextBox)this.GridViewBillItem.FooterRow.FindControl("txtAmtClearTotal")).ClientID;
                ((TextBox)this.GridViewBillItem.FooterRow.FindControl("txtAmtDueTotal")).Text = dueTotalDueAmt.ToString("N2");
                ((TextBox)this.GridViewBillItem.FooterRow.FindControl("txtAmtClearTotal")).Text = dueTotalClearAmt.ToString("N2");
            }

            this.hClearIDs.Value.Trim();
            this.hDueIDs.Value.Trim();
        }
        catch (Exception ex)
        {
            throw ex;
        }
      
        Session["dtBillList"] = dt;
    }


    protected void initaializeGridViewBillItem()
    {
        for (int i = 0; i < this.GridViewBillItem.Rows.Count; i++)
        {
          ((TextBox)this.GridViewBillItem.Rows[i].FindControl("txtDate")).Text=DateTime.Today.ToShortDateString();
        }
    }
   


    private void getValuesFromGrid()
    {
        dtBillList = (DataTable)Session["dtBillList"];
        bool is_checked = false;
        for (int i = 0; i < this.GridViewBillItem.Rows.Count; i++)
        {
            if (Decimal.Parse(((TextBox)this.GridViewBillItem.Rows[i].FindControl("txtAmountClear")).Text) != 0)
            {
                string Checked = ((HiddenField)this.GridViewBillItem.Rows[i].FindControl("hIsChecked")).Value;

                if (Checked == "images/mark_x.gif")
                {
                    is_checked = true;
                }
                else
                {
                    is_checked = false;
                }
                try
                {
                    if (is_checked){ 

                        dtBillList.Rows[i]["is_checked"] = "true";
                        dtBillList.Rows[i]["bill_amt"] = Decimal.Parse(((TextBox)this.GridViewBillItem.Rows[i].FindControl("txtBillAmount")).Text);
                        dtBillList.Rows[i]["bill_amt_clear"] = Decimal.Parse(((TextBox)this.GridViewBillItem.Rows[i].FindControl("txtAmountClear")).Text);
                        dtBillList.Rows[i]["bill_amt_due"] = ((TextBox)this.GridViewBillItem.Rows[i].FindControl("txtAmountDue")).Text;
                        dtBillList.Rows[i]["bill_due_date"] = DateTime.Parse(((TextBox)this.GridViewBillItem.Rows[i].FindControl("txtDueDate")).Text).ToShortDateString();
                        dtBillList.Rows[i]["memo"] = ((TextBox)this.GridViewBillItem.Rows[i].FindControl("txtMemo")).Text;                     
                    
                    } 
                    else 
                    { 
                        dtBillList.Rows[i]["is_checked"] = "false";
                        
                    }                   
                }
                catch (Exception ex)
                {
                    string msg = ex.Message;
                    throw ex;
                }
            }
        }
        try
        {
            billList = new ArrayList();
            DropDownList ddlAPAcct = (DropDownList)parentObject["ddlAPAcct"];
            int apAcct = Int32.Parse(ddlAPAcct.SelectedValue.ToString());
            for (int k = 0; k < dtBillList.Rows.Count; k++)
            {
               if (dtBillList.Rows[k]["is_checked"].ToString() == "true")
               {                   
                    BillRecord bItm = new BillRecord();
                    bItm.Bill_type = "D";
                    //SAVES FINAL STATE OF THE BILL DETAIL, AND IT KEEPS THE PREVIOUS STATE BY ADDING IT TO PAID AMOUNT
                    bItm.Bill_amt_due = Decimal.Parse(dtBillList.Rows[k]["bill_amt_due"].ToString()) - Decimal.Parse(dtBillList.Rows[k]["bill_amt_clear"].ToString());
                    bItm.Bill_amt_paid = Decimal.Parse(dtBillList.Rows[k]["bill_amt_paid"].ToString()) + Decimal.Parse(dtBillList.Rows[k]["bill_amt_clear"].ToString());                    
                    bItm.Bill_ap = apAcct;
                    bItm.Bill_number = Int32.Parse(dtBillList.Rows[k]["bill_number"].ToString());
                    bItm.Bill_status = "A";
                    bItm.Lock = "Y";
                    bItm.Bill_date = dtBillList.Rows[k]["bill_date"].ToString();
                    bItm.Bill_expense_acct = Int32.Parse(dtBillList.Rows[k]["bill_expense_acct"].ToString());
                    bItm.Bill_amt = Decimal.Parse(dtBillList.Rows[k]["bill_amt"].ToString());
                    bItm.Ref_no = dtBillList.Rows[k]["ref_no"].ToString();
                    bItm.Bill_due_date = dtBillList.Rows[k]["bill_due_date"].ToString();                    
                  // bItm.Print_id = printID;//PRINT ID IS GIVEN WHEN IT IS PRINTED
                    billList.Add(bItm);
               }
            }
            checkDetailList = new ArrayList();
            for (int k = 0; k < dtBillList.Rows.Count; k++)
            {
                if (dtBillList.Rows[k]["is_checked"].ToString() == "true")
                {
                    CheckDetailRecord cdItem = new CheckDetailRecord();
                    //JUST FOR THIS TRANSACTION
                    cdItem.amt_due = Decimal.Parse(dtBillList.Rows[k]["bill_amt_due"].ToString()) ;
                    cdItem.amt_paid = Decimal.Parse(dtBillList.Rows[k]["bill_amt_clear"].ToString());
                    //
                    try
                    {
                        cdItem.invoice_no = Int32.Parse(dtBillList.Rows[k]["ref_no"].ToString());
                    }
                    catch(Exception ex)
                    {
                        cdItem.invoice_no = 0;
                    }
                    cdItem.due_date = dtBillList.Rows[k]["bill_due_date"].ToString();
                    cdItem.tran_id=k;
                    cdItem.memo = dtBillList.Rows[k]["memo"].ToString();
                    cdItem.bill_number = Int32.Parse(dtBillList.Rows[k]["bill_number"].ToString());
                    checkDetailList.Add(cdItem);
                }
            }
        }
        catch (Exception ex)
        {
            string msg = ex.Message;
            throw ex;
        }
        Session["dtBillList"] =dtBillList;
    }

    public DataTable createBillTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add(new DataColumn("tran_id", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("print_id", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("bill_number", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("vendor_number", System.Type.GetType("System.String")));

        dt.Columns.Add(new DataColumn("url", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("memo", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("pmt_method", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("bill_due_date", System.Type.GetType("System.String")));

        dt.Columns.Add(new DataColumn("bill_amt", System.Type.GetType("System.Decimal")));
        dt.Columns.Add(new DataColumn("bill_amt_paid", System.Type.GetType("System.Decimal")));
        dt.Columns.Add(new DataColumn("bill_amt_due", System.Type.GetType("System.Decimal")));
       
        return dt;
    }


    public bool bindFromCheckDetailTable(DataTable dt)
    {
        int Cnt = dt.Rows.Count;
        GeneralUtility gUtil = new GeneralUtility();
        gUtil.removeNull(ref dt);
        dtBillList = createBillTable();     
      
        try
        {            
            for (int i = 0; i < Cnt; i++)
            {
                DataRow dr = dtBillList.NewRow();
                dr["tran_id"] = Int32.Parse(dt.Rows[i]["tran_id"].ToString());
                dr["print_id"] = Int32.Parse(dt.Rows[i]["print_id"].ToString());
                dr["url"] = dt.Rows[i]["url"].ToString();
                dr["bill_number"] = Int32.Parse(dt.Rows[i]["bill_number"].ToString());               
                dr["bill_amt"] = Decimal.Parse(dt.Rows[i]["bill_amt"].ToString());
                dr["bill_amt_paid"] = Decimal.Parse(dt.Rows[i]["amt_paid"].ToString());
                dr["bill_amt_due"] = Decimal.Parse(dt.Rows[i]["amt_due"].ToString());
                dr["bill_due_date"] = dt.Rows[i]["due_date"].ToString();               
                dr["memo"] = dt.Rows[i]["memo"].ToString();
                dr["pmt_method"] = dt.Rows[i]["pmt_method"].ToString();
                dtBillList.Rows.Add(dr);
            }
           
            reBind_BillChangesToGrid(dtBillList,true);
            this.GridViewBillItem.Enabled = false;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return true;
    }
    

  


    //    BillListControl1.setParentControl(this.txt_print_check_as);
    //    BillListControl1.setParentControl(this.txtAddress);
    //    BillListControl1.setParentControl(this.txtChekNo);
    //    BillListControl1.setParentControl(this.txtDate);
    //    BillListControl1.setParentControl(this.ddlAPAcct);
    //    BillListControl1.setParentControl(this.ddlBankAcct);
    //    BillListControl1.setParentControl(this.ddlPaymethod);
}
