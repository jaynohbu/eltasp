using System;
using System.Data;
using System.Text;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
/*****************************************************************************
* 
* 
* ****************************************************************************/
public partial class ASPX_modalAddClient : System.Web.UI.Page
{
    private string elt_account_number;
    private string ConnectStr;
    private string addText="";
    private string addValue="";
    private string errMessage = "";

    private string[] states = {"AK", "AL", "AR" , "AZ", "CA" , "CO", "CT", "DC", "DE", "FL", "GA", "HI", "IA"
 , "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE", "NH",
        "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VT", "WA", "WI", "WV", "WY"};
   

    /*************************************************************************
     * 
     * 
     * ***********************************************************************/
    protected void Page_Load(object sender, EventArgs e)
    {
       
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];

        ConnectStr = (new igFunctions.DB().getConStr());

        if (!IsPostBack)
        {
            this.txtDbaName.Focus();        
            
        }
        this.txtDbaName.Focus();
    }

    /*************************************************************************
     * 
     * 
     * ***********************************************************************/
    
    protected void btnFullInfo_Click(object sender, EventArgs e)
    {

        if (Request.QueryString["type"] == "agent")
        {
            string script = "<script language='javascript'>";
            script += " fbtnFullInfo('" + this.txtDbaName.Text + "');";
            script += "</script>";
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script);
        }
    }
   
    /*************************************************************************
     * 
     * 
     * ***********************************************************************/

    protected void btnCancel_Click(object sender, EventArgs e)
    {       
        Response.Write("<script language='javascript'> parent.fShowModal.hReturnValue.value = 'cancel';window.top.close(); </script>");    
    }
    
    /*************************************************************************
     * 
     * 
     * ***********************************************************************/

    protected void btnQuickAdd_Click(object sender, EventArgs e)
    {      

        if (Request.QueryString["type"]=="agent")
        {
          
                if (!this.addAgent())
                {
                    this.pnlInit.Visible = false;
                    this.lblError.Text = errMessage;
                    this.pnlNext.Visible = true;
                }
                else
                {
                    Response.Write("<script language='javascript'> parent.fShowModal.hReturnValue.value = '" + this.addText + "^" + this.addValue + "';window.top.close(); </script>");
                }
                if (Request.QueryString["src"] == "hawb")
                {
                    this.btnFullInfo_Click(sender, e);

                }
          
            
        }
        
    }

    /*************************************************************************
     * 
     * 
     * ***********************************************************************/

    private  bool addAgent()
    {
        Client client = new Client();
        string already = "";  
       
        if (!this.txtDbaName.Text.Equals(""))
        {           
            already = client.checkExisitingClients(elt_account_number, this.txtDbaName.Text);            
           

            if (already!="")//update existing client to be an agent
            {
                string id  = client.updateJobType(elt_account_number, already, "is_agent");
              
                this.addValue = id + "-" + this.txtDbaName.Text;
                this.addText = this.txtDbaName.Text;
                return true;          
            }
            else// insert a client and update to be agent 
            {     
               /* if(Request.QueryString["src"]=="hawb"){
                    

                    string cAcct , cName ,cAddress ,cCity , cState , cZip , cCountry, cCountry_Code , cPhone;
                    
                    cName=this.txtDbaName.Text;
                    cAddress=this.txtAddress.Text;
                    cCity=this.txtCity.Text;
                    cState=this.ddlState.SelectedItem.Value.ToString();
                    cZip=this.txtZip.Text;

                    cCountry=this.ddlCountry.SelectedItem.Text;
                    cCountry_Code = this.ddlCountry.SelectedItem.Value.ToString();
                    cPhone=this.txtPhoneNumber.Text;
                   
                    cAcct=client.insertClient(elt_account_number , cName ,cAddress ,cCity , cState , cZip , cCountry ,cCountry_Code, cPhone);
                    
                    Response.Write(cAcct);
                    Response.End();

                    this.addValue=cAcct+"-"+cName+"          "+ cAddress+"          "+ cCity +"          "+ ","+ cState+ " " + cZip +","+ cCountry +"          "+ cPhone;
                    this.addText=this.txtDbaName.Text;


                }else{*/
                  
                   string id= client.insertClient(elt_account_number, this.txtDbaName.Text);

                  client.updateJobType(elt_account_number, id, "is_agent");
                 
                  this.addValue = id+"-"+this.txtDbaName.Text;
                  this.addText = this.txtDbaName.Text;
                //}
                  return true;
            }
        }
        else
        {            
          this.errMessage= "Please enter a DBA name!";                  
        }
        return false;       
    }

    protected void btnResume_Click(object sender, EventArgs e)
    {
        this.pnlInit.Visible = true;
        this.lblError.Text = "";
        this.pnlNext.Visible = false;
    }  

   
}
