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

    /*************************************************************************
     * 
     * 
     * ***********************************************************************/
    protected void Page_Load(object sender, EventArgs e)
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];    
        ConnectStr = (new igFunctions.DB().getConStr());
        this.txtDbaName.Focus();        
    }
    /*************************************************************************
     * 
     * 
     * ***********************************************************************/
    protected void btnFullInfo_Click(object sender, EventArgs e)
    {
        Response.Write("<script language='javascript'> parent.fShowModal.hReturnValue.value = 'companyconfigcreate.aspx?newDBA= " + this.txtDbaName.Text+ "';window.top.close(); </script>");   
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
        bool already = false;
        ArrayList kindsOfjobs = new ArrayList();

        if (!this.txtDbaName.Text.Equals(""))
        {
            already = checkExisitingClients(elt_account_number, this.txtDbaName.Text);

            if (already)
            {
                this.pnlInit.Visible = false;
                this.lblError.Text = "The DBA, already exist in the database !";
                this.pnlNext.Visible = true;
            }
            else
            {            
                if (insertClient(elt_account_number, this.txtDbaName.Text))
                {
                  Response.Write("<script language='javascript'> parent.fShowModal.hReturnValue.value = 'insertion successful';window.top.close(); </script>");
                }
            }
        }
        else
        {
            this.pnlInit.Visible = false;
            this.lblError.Text = "Please enter a DBA name!";
            this.pnlNext.Visible = true;
        }
    }
    /*************************************************************************
     * 
     * 
     * ***********************************************************************/
    private bool checkExisitingClients(string acct, string dba)    {
       
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        ArrayList alist = new ArrayList();        
        string a = "";        
        
        try
        {          
            Con.Open();
            Cmd.CommandText = "select *  from organization where elt_account_number ='" + acct + "' AND dba_name like '"+ dba +"' ";            
            SqlDataReader reader = Cmd.ExecuteReader();         
            
            if (reader.HasRows)
            {
                reader.Read();
                a = reader["dba_name"].ToString();  
                if(a.Equals(dba))                          
                return true;               
            }
            else
            {
                return false;
            }
            
        }catch (Exception ex)
        {
            Response.Write("<script language='javascript'> alert('"+ex.Message+"') </script>");
        }
        Con.Close();
        return false;
    }
    /*************************************************************************
     * 
     * 
     * ***********************************************************************/

    private bool insertClient(string acct, string dba)
    {           
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;      

        try
        {
            Con.Open();
            Cmd.CommandText = "insert into organization ( elt_account_number, dba_name, org_account_number ) VALUES ( " + acct + ", '" + dba + "', " + getNextClientID()+ ")";

            if (Cmd.ExecuteNonQuery() == 0)
            {
                Response.Write("<script language='javascript'> alert('" + "Error was occured - ( Account Number Creation Error )" + "') </script>");                
            }
            else return true;
        }
        catch (Exception ex)
        {           
            Response.Write("<script language='javascript'> alert('" +ex.ToString()+ "') </script>");
        }
        finally
        {
            Con.Close();            
        }       
        return false;
    }

    private string getNextClientID()
    {
        int i = 0;

        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;

        string err = "";
        try
        {
            Con.Open();
            Cmd.CommandText = "select max(org_account_number) as org_account_number from organization where elt_account_number = " + elt_account_number;
            SqlDataReader reader = Cmd.ExecuteReader();
           
            if (reader.Read())
            {
                string strI = reader["org_account_number"].ToString();
                if (strI != "")
                {                 
                    i = int.Parse(strI);
                }
            }
            else
            {
                err = "Error was occured - ( Account Number Creation Error )";
            }

            reader.Close();
        }
        catch (Exception ex)
        {
            Response.Write("<script language='javascript'> alert('" + ex.Message + "') </script>");              
        }
        finally
        {
            Con.Close();
            i++;
        }
        return i.ToString();
    }

    protected void btnResume_Click(object sender, EventArgs e)
    {
        this.pnlInit.Visible = true;
        this.lblError.Text = "";
        this.pnlNext.Visible = false;
    }
    
}
