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

public partial class ASPX_AccountingTasks_Controls_ARControl:System.Web.UI.UserControl
{
    private string elt_account_number;
    private string user_id, login_name, user_right;
    private string ConnectStr; 
    private DataTable dtPaymentDetailList;    
    private Decimal total_amount;
    private InvoiceManager ivMgr;

    private Hashtable parentObject;

    public void setParentControl(Object control)
    {
        if (parentObject == null)
        {
            parentObject = new Hashtable();
        }
        parentObject.Add(((WebControl)control).ID, control);
    }  
    private ArrayList paymentDetailList;

    public ArrayList PaymentDetailList
    {
        get
        {           
            return paymentDetailList;
        }
        set
        {
            paymentDetailList = value;
        }
    }

    private ArrayList invoiceList;

    public ArrayList InvoiceList
    {
        get
        {            
            return invoiceList;
        }
        set
        {
            invoiceList = value;
        }
    }

    public Decimal Total_Amount
    {
        get 
        {             
            return total_amount;
        }
        set
        {
            total_amount = value;
        }
    }

    public void Clear()
    {
        dtPaymentDetailList = (DataTable)Session["dtPaymentDetailList"];
        if (dtPaymentDetailList != null)
        {
            dtPaymentDetailList.Clear();
            this.reBind_BillChangesToGrid(dtPaymentDetailList);
            
        }
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
    

    public void reBind_BillChangesToGrid(DataTable dt)
    {
        total_amount = 0;
        Decimal due_money = 0;
        Decimal payment_money = 0;
        this.GridViewARItem.DataSource = dt.DefaultView;
        this.GridViewARItem.DataBind();
        hAmountDueIDs.Value = "";       
        hAmountPaymentIDs.Value = "";
        hCheckBoxIDs.Value = "";

        for (int i = 0; i < this.GridViewARItem.Rows.Count; i++)
        {
            ((TextBox)this.GridViewARItem.Rows[i].FindControl("txtOrigAmt")).Text = dt.Rows[i]["amount_charged"].ToString();
            ((TextBox)this.GridViewARItem.Rows[i].FindControl("txtAmtDue")).Text = dt.Rows[i]["balance"].ToString();
            ((TextBox)this.GridViewARItem.Rows[i].FindControl("txtDueDate")).Text = DateTime.Parse(dt.Rows[i]["invoice_date"].ToString()).ToShortDateString();
            ((TextBox)this.GridViewARItem.Rows[i].FindControl("txtPayment")).Text = dt.Rows[i]["amt_clear"].ToString();
            ((TextBox)this.GridViewARItem.Rows[i].FindControl("txtOrigAmt")).Attributes.Add("onblur", "validateNumber(this)");
            ((TextBox)this.GridViewARItem.Rows[i].FindControl("txtAmtDue")).Attributes.Add("onblur", "validateNumber(this)");           
            ((TextBox)this.GridViewARItem.Rows[i].FindControl("txtPayment")).Attributes.Add("onblur", "validateNumber(this)");
           
            payment_money +=Decimal.Parse(dt.Rows[i]["amt_clear"].ToString());
            string checkbox = ((Image)this.GridViewARItem.Rows[i].FindControl("btnCheck")).ClientID;
            if (dt.Rows[i]["is_checked"].ToString() == "true")
            {
                ((Image)this.GridViewARItem.Rows[i].FindControl("btnCheck")).ImageUrl = "~/ASPX/AccountingTasks/images/mark_x.gif";
            }
            else
            {
                ((Image)this.GridViewARItem.Rows[i].FindControl("btnCheck")).ImageUrl = "~/ASPX/AccountingTasks/images/mark_o.gif";
            }
            string paymentTotal = ((TextBox)this.GridViewARItem.FooterRow.FindControl("txtPaymentTotal")).ClientID;
            string payment = ((TextBox)this.GridViewARItem.Rows[i].FindControl("txtPayment")).ClientID;
            string due = ((TextBox)this.GridViewARItem.Rows[i].FindControl("txtAmtDue")).ClientID;
           
           
            hAmountDueIDs.Value += due + "^^";
            hAmountPaymentIDs.Value+= payment + "^^";
            hCheckBoxIDs.Value+=checkbox+"^^";

            string dueTotal = ((TextBox)this.GridViewARItem.FooterRow.FindControl("txtAmtDueTotal")).ClientID;
            due_money += Decimal.Parse(((TextBox)this.GridViewARItem.Rows[i].FindControl("txtAmtDue")).Text);
            ((Image)this.GridViewARItem.Rows[i].FindControl("btnCheck")).Attributes.Add("onclick", "check_clicked(this)");           
        }
        
        
        if (this.GridViewARItem.Rows.Count > 0)
        {
            this.hDTnPT.Value = ((TextBox)this.GridViewARItem.FooterRow.FindControl("txtAmtDueTotal")).ClientID + "^^" + ((TextBox)this.GridViewARItem.FooterRow.FindControl("txtPaymentTotal")).ClientID;
            ((TextBox)this.GridViewARItem.FooterRow.FindControl("txtAmtDueTotal")).Text = due_money.ToString("N2");
            ((TextBox)this.GridViewARItem.FooterRow.FindControl("txtPaymentTotal")).Text = payment_money.ToString("N2");
        }      
        Session["dtPaymentDetailList"] = dt;
    }

    protected void initaializeGridViewBillItem()
    {
        for (int i = 0; i < this.GridViewARItem.Rows.Count; i++)
        {
          ((TextBox)this.GridViewARItem.Rows[i].FindControl("txtDate")).Text=DateTime.Today.ToShortDateString();
        }
    }

    public void getValuesFromGrid()
    {
        try
        {
            dtPaymentDetailList = (DataTable)Session["dtPaymentDetailList"];
            
            for (int i = 0; i < this.GridViewARItem.Rows.Count; i++)
            {
                Decimal pay = Decimal.Parse(Request[((TextBox)this.GridViewARItem.Rows[i].FindControl("txtPayment")).UniqueID]);
                if (pay != 0)
                {
                    dtPaymentDetailList.Rows[i]["is_checked"] = "true";
                    string amt_clear = pay.ToString();
                    dtPaymentDetailList.Rows[i]["amt_clear"] = amt_clear;
                }
                else
                {
                    dtPaymentDetailList.Rows[i]["is_checked"] = "false";
                }

            }
            paymentDetailList = new ArrayList();
            DropDownList ddlBankAcct = (DropDownList)parentObject["ddlBankAcct"];
            int bkAcct = Int32.Parse(ddlBankAcct.SelectedValue.ToString());

            for (int k = 0; k < dtPaymentDetailList.Rows.Count; k++)
            {
                if (dtPaymentDetailList.Rows[k]["is_checked"].ToString() == "true")
                {
                    PaymentDetailRecord pItm = new PaymentDetailRecord();
                    pItm.item_id = k;
                    pItm.amt_due = Decimal.Parse(dtPaymentDetailList.Rows[k]["balance"].ToString()) - Decimal.Parse(dtPaymentDetailList.Rows[k]["amt_clear"].ToString());
                    pItm.payment = Decimal.Parse(dtPaymentDetailList.Rows[k]["amt_clear"].ToString());
                    pItm.invoice_no = Int32.Parse(dtPaymentDetailList.Rows[k]["invoice_no"].ToString());
                    pItm.invoice_date = dtPaymentDetailList.Rows[k]["invoice_date"].ToString();
                    pItm.orig_amt = Decimal.Parse(dtPaymentDetailList.Rows[k]["amount_charged"].ToString());
                    // here is to fix later 
                    pItm.type = "INVOICE";
                    paymentDetailList.Add(pItm);
                }
            }

            invoiceList = new ArrayList();
            elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            ivMgr = new InvoiceManager(elt_account_number);
            for (int k = 0; k < dtPaymentDetailList.Rows.Count; k++)
            {
                if (dtPaymentDetailList.Rows[k]["is_checked"].ToString() == "true")
                {
                    int invoice_no = Int32.Parse(dtPaymentDetailList.Rows[k]["invoice_no"].ToString());
                    if (invoice_no != 0)
                    {
                        InvoiceRecord iItm = ivMgr.getInvoiceRecord(invoice_no);
                        iItm.balance = Decimal.Parse(dtPaymentDetailList.Rows[k]["balance"].ToString()) - Decimal.Parse(dtPaymentDetailList.Rows[k]["amt_clear"].ToString());
                        iItm.amount_paid = Decimal.Parse(dtPaymentDetailList.Rows[k]["amt_paid"].ToString()) + Decimal.Parse(dtPaymentDetailList.Rows[k]["amt_clear"].ToString());
                        invoiceList.Add(iItm);
                    }
                }
            }       
       }
       catch (Exception ex)
       {          
           throw ex;
       }
        Session["dtPaymentDetailList"] =dtPaymentDetailList;
    }

  

    public bool bindFromPaymentDetailTable(DataTable dt)
    {
        bool return_val = false;
        if (dt.Rows.Count > 0)
        {
            int Cnt = dt.Rows.Count;
            ArrayList invoiceNos = new ArrayList();
            elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            ivMgr = new InvoiceManager(elt_account_number);
            try
            {
                for (int i = 0; i < Cnt; i++)
                {
                    invoiceNos.Add(Int32.Parse(dt.Rows[i]["invoice_no"].ToString()));
                }
                dtPaymentDetailList = ivMgr.getInvoiceListWithInvoiceNumbersForReceivePayment(invoiceNos);
                reBind_BillChangesToGrid(dtPaymentDetailList);
                return_val = true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        return return_val;
    }
}
