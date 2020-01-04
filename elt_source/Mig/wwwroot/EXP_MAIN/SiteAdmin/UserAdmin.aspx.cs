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

public partial class SiteAdmin_UserAdmin : System.Web.UI.Page
{
    protected string ConnectStr, user_id, login_name, user_right, elt_account_number;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Session.LCID = 1033;
            ConnectStr = (new igFunctions.DB().getConStr());

            if (!IsPostBack)
            {
                LoadAllData(user_id);
            }
        }
        catch
        {
        }
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];

        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("loginUsers", "SELECT LOWER(login_name) as login_name,userid FROM users WHERE elt_account_number=" + elt_account_number);
        feData.AddToDataSet("organizations", "SELECT TOP 0 * FROM organization WHERE elt_account_number=" + elt_account_number);

        DataTable tblLoginUsers = feData.Tables["loginUsers"];
        DataTable tblOrganizaions = feData.Tables["organizations"];

        lstLoginID.DataSource = tblLoginUsers;
        lstLoginID.DataTextField = "login_name";
        lstLoginID.DataValueField = "userid";
        lstLoginID.DataBind();
        lstLoginID.Items.Insert(0,new ListItem("New User","0"));

        lstOrganization.DataSource = tblOrganizaions;
        lstOrganization.DataTextField = "dba_name";
        lstOrganization.DataValueField = "org_account_number";
        lstOrganization.DataBind();
        lstOrganization.Items.Insert(0, new ListItem("", "0"));
        
    }

    protected void LoadAllData(string UserID)
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("UserInfo", "SELECT * FROM users WHERE elt_account_number=" + elt_account_number + "  AND userid=" + UserID);

        if (feData.Tables["UserInfo"].Rows.Count > 0)
        {
            DataRow drUser = feData.Tables["UserInfo"].Rows[0];

            lstLoginID.SelectedValue = drUser["userid"].ToString();
            lstUserType.SelectedValue = drUser["user_type"].ToString();
            lstOrganization.SelectedValue = drUser["org_acct"].ToString();
            txtFirstName.Text = drUser["user_fname"].ToString();
            txtLastName.Text = drUser["user_lname"].ToString();
            txtTitle.Text = drUser["user_title"].ToString();
            txtLoginID.Text = drUser["login_name"].ToString();
            txtPassword.Text = drUser["password"].ToString();
            txtRepeatPassword.Text = drUser["password"].ToString();
            txtSSN.Text = drUser["ig_user_ssn"].ToString();
            txtBirth.Text = drUser["ig_user_dob"].ToString();
            txtAddress.Text = drUser["user_address"].ToString();
            txtCity.Text = drUser["user_city"].ToString();
            lstState.SelectedValue = drUser["user_state"].ToString();
            txtZip.Text = drUser["user_zip"].ToString();
            txtCountry.Text = drUser["user_country"].ToString();
            txtPhoneNo.Text = drUser["user_phone"].ToString();
            txtCellNo.Text = drUser["ig_user_cell"].ToString();
            txtEmail.Text = drUser["user_email"].ToString();

            btnAddUser.Visible = false;
            btnUpdateUser.Visible = true;
            //(user_id == "1000" && login_name == "admin") || (user_id == "0000" && login_name == "System")
            if (int.Parse(user_right) == 9)
            {
                if (UserID != "1000")
                {
                    btnDeleteUser.Visible = true;
                }
                else
                {
                    btnDeleteUser.Visible = false;
                }
                lstLoginID.Enabled = true;
            }
            else
            {
                lstLoginID.Enabled = false;
                btnDeleteUser.Visible = false;
            }
        }
        else
        {
            lstLoginID.SelectedIndex = 0;
            lstUserType.SelectedIndex = 0;
            lstOrganization.SelectedIndex = 0;
            txtFirstName.Text = "";
            txtLastName.Text = "";
            txtTitle.Text = "";
            txtLoginID.Text = "";
            txtPassword.Text = "";
            txtRepeatPassword.Text = "";
            txtSSN.Text = "";
            txtBirth.Text = "";
            txtAddress.Text = "";
            txtCity.Text = "";
            lstState.SelectedIndex = 0;
            txtZip.Text = "";
            txtPhoneNo.Text = "";
            txtCellNo.Text = "";
            txtEmail.Text = "";
            btnUpdateUser.Visible = false;
            btnDeleteUser.Visible = false;
            txtCountry.Text = "US";
            //(user_id == "1000" && login_name == "admin") || (user_id == "0000" && login_name == "System")
            if (int.Parse(user_right) == 9)
            {
                btnAddUser.Visible = true;
            }
        }
    }
    
    protected void lstUserType_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadAllData(lstLoginID.SelectedValue);
    }

    protected void DeleteUser(string UserID)
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string[] tranStr = new string[2];
        tranStr[0] = "DELETE FROM users WHERE elt_account_number=" + elt_account_number + " AND userid=" + UserID;
        tranStr[1] = "DELETE FROM view_login WHERE elt_account_number=" + elt_account_number + " AND user_id=" + elt_account_number + UserID;

        if (!feData.DataTransactions(tranStr))
        {
            Response.Write(feData.GetLastTransactionError());
        }
        else
        {
            Response.Redirect("UserAdmin.aspx");
        }
    }

    protected void AddNewUser()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string[] tranStr = new string[1];
        tranStr[0] = "DECLARE @new_user_id DECIMAL\n";
        tranStr[0] += "SET @new_user_id=(SELECT ISNULL(MAX(userid),1000)+1 FROM users WHERE elt_account_number=" + elt_account_number + ")\n";
        tranStr[0] += "INSERT INTO users(elt_account_number,userid,user_type,user_right,login_name,password,org_acct,user_lname,user_fname,user_title,user_address,user_city,user_state,user_zip,user_country,user_phone,user_email,create_date,last_modified,ig_user_ssn,ig_user_dob,ig_user_cell)\n";
        tranStr[0] += "VALUES(" + elt_account_number + ",@new_user_id," + lstUserType.SelectedValue + "," + lstUserType.SelectedValue + ",'" + txtLoginID.Text.ToLower() + "','" + txtPassword.Text + "'," + lstOrganization.SelectedValue + ",N'" + txtLastName.Text + "',N'" + txtFirstName.Text + "',N'" + txtTitle.Text
            + "',N'" + txtAddress.Text + "',N'" + txtCity.Text + "',N'" + lstState.SelectedValue + "',N'" + txtZip.Text + "',N'" + txtCountry.Text + "',N'" + txtPhoneNo.Text + "',N'" + txtEmail.Text + "',GETDATE(),GETDATE(),N'" + txtSSN.Text + "',N'" + txtBirth.Text + "',N'" + txtCellNo.Text + "')";

        if (!feData.DataTransactions(tranStr))
        {
            Response.Write(feData.GetLastTransactionError());
        }
        else
        {
            Response.Redirect("UserAdmin.aspx");
        }
    }

    protected void UpdateUser(string UserID)
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string[] tranStr = new string[1];
        tranStr[0] = "UPDATE users SET user_type=" + lstUserType.SelectedValue
            + ",user_right=" + lstUserType.SelectedValue
            + ",login_name=N'" + txtLoginID.Text
            + "',password='" + txtPassword.Text
            + "',org_acct=" + lstOrganization.SelectedValue
            + ",user_lname=N'" + txtLastName.Text
            + "',user_fname=N'" + txtFirstName.Text
            + "',user_title=N'" + txtTitle.Text
            + "',user_address=N'" + txtAddress.Text
            + "',user_city=N'" + txtCity.Text
            + "',user_state=N'" + lstState.SelectedValue
            + "',user_zip=N'" + txtZip.Text
            + "',user_country=N'" + txtCountry.Text
            + "',user_phone=N'" + txtPhoneNo.Text
            + "',user_email=N'" + txtEmail.Text
            + "',last_modified=GETDATE()"
            + ",ig_user_ssn=N'" + txtSSN.Text
            + "',ig_user_dob=N'" + txtBirth.Text
            + "',ig_user_cell=N'" + txtCellNo.Text + "' WHERE "
            + "elt_account_number=" + elt_account_number + " AND userid=" + UserID;

        if (!feData.DataTransactions(tranStr))
        {
            Response.Write(feData.GetLastTransactionError());
        }
        else
        {
            Response.Redirect("UserAdmin.aspx");
        }
    }

    protected void btnAddUser_Click(object sender, ImageClickEventArgs e)
    {
        if(txtPassword.Text != txtRepeatPassword.Text)
        {
            Response.Write("<script>alert('Passwords did not match.');</script>");
        }
        else if (lstLoginID.Items.FindByText(txtLoginID.Text) != null)
        {
            Response.Write("<script>alert('The same login ID exists already. ');</script>");
        }
        else
        {
            AddNewUser();
        }
    }

    protected void btnDeleteUser_Click(object sender, ImageClickEventArgs e)
    {
        if(lstLoginID.SelectedIndex > 0)
        {
            DeleteUser(lstLoginID.SelectedValue);
        }
    }

    protected void btnUpdateUser_Click(object sender, ImageClickEventArgs e)
    {
        if (lstLoginID.SelectedIndex > 0)
        {
            UpdateUser(lstLoginID.SelectedValue);
        }
    }
}
