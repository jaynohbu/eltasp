using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web;
using System.Web.Mobile;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.MobileControls;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

public partial class ASPX_Domestic_driver_hawb_detail : System.Web.UI.MobileControls.MobilePage
{
    protected string elt_account_number, driver_acct, hawb_val;

    protected void Page_Load(object sender, EventArgs e)
    {
        elt_account_number = Request.Params["ELT"].ToString();
        driver_acct = Request.Params["ORG"].ToString();
        hawb_val = Request.Params["HAWB"].ToString();

        if (!IsPostBack)
        {
            bindHAWBInfo();
            bindMilestones();
        }
    }

    protected void bindHAWBInfo()
    {
        string sqlText = "SELECT a.hawb_num,a.piece,a.weight,b.item_desc,a.driver_paid,a.remark"
            + " FROM hawb_master_drivers a JOIN item_cost b ON (a.elt_account_number=b.elt_account_number AND a.cost_item_no=b.item_no)"
            + " Where a.elt_account_number=" + elt_account_number + " AND a.driver_acct=" + driver_acct + " AND a.hawb_num='" + hawb_val + "'";

        SqlConnection Con = null;
        try
        {
            string ConnectStr = (new igFunctions.DB().getConStr());
            Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand(sqlText, Con);
            Con.Open();
            SqlDataReader reader = Cmd.ExecuteReader();

            if (reader.Read())
            {
                labelHAWB.Text = reader["hawb_num"].ToString();
                TextBoxWeight.Text = reader["weight"].ToString();
                TextBoxPiece.Text = reader["piece"].ToString();
                TextBoxCostDesc.Text = reader["item_desc"].ToString();
                TextBoxCostAmt.Text = reader["driver_paid"].ToString();
                TextBoxRemark.Text = reader["remark"].ToString();
            }
            reader.Close();
        }
        catch
        {
        }
        finally
        {
            if (Con != null)
            {
                Con.Close();
            }
        }
    }

    protected void bindMilestones()
    {
        string sqlText = "SELECT * FROM hawb_milestones WHERE elt_account_number=" + elt_account_number 
            + " AND hawb_num='" + hawb_val + "' ORDER BY seq_id";

        SqlConnection Con = null;
        try
        {
            string ConnectStr = (new igFunctions.DB().getConStr());
            Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand(sqlText, Con);
            Con.Open();
            SqlDataReader reader = Cmd.ExecuteReader();

            ListMilestones.Items.Clear();
            ListMilestones.Items.Add(new MobileListItem("",""));
            while (reader.Read())
            {
                ListMilestones.Items.Add(new MobileListItem(reader["location_id"].ToString(), reader["seq_id"].ToString()));
            }
            ListMilestones.SelectedIndex = 0;
            reader.Close();
        }
        catch
        {
        }
        finally
        {
            if (Con != null)
            {
                Con.Close();
            }
        }
    }

    protected void updateDriverHAWB()
    {
        SqlConnection Con = null;
        SqlCommand Cmd = null;
        SqlTransaction trans = null;
        try
        {
            string ConnectStr = (new igFunctions.DB().getConStr());
            Con = new SqlConnection(ConnectStr);
            Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Con.Open();
            trans = Con.BeginTransaction();
            Cmd.Transaction = trans;

            string sqlText = @"
                    update hawb_master_drivers SET
                        piece = @piece,
                        weight = @weight,
                        driver_paid = @driver_paid,
                        remark = @remark
                    WHERE elt_account_number=@elt_account_number 
                    AND hawb_num=@hawb_num AND driver_acct=@driver_acct";

            Cmd.CommandText = sqlText;

            Cmd.Parameters.AddWithValue("@elt_account_number", elt_account_number);
            Cmd.Parameters.AddWithValue("@hawb_num", hawb_val);
            Cmd.Parameters.AddWithValue("@driver_acct", driver_acct);
            Cmd.Parameters.AddWithValue("@piece", TextBoxPiece.Text);
            Cmd.Parameters.AddWithValue("@weight", TextBoxWeight.Text);
            Cmd.Parameters.AddWithValue("@driver_paid", TextBoxCostAmt.Text);
            Cmd.Parameters.AddWithValue("@remark", TextBoxRemark.Text);
            Cmd.ExecuteNonQuery();
            trans.Commit();
        }
        catch (Exception e)
        {
            trans.Rollback();
            TextBoxRemark.Text = "error";
        }

        finally
        {
            Con.Close();
            Cmd.Dispose();
            trans.Dispose();
        }
    }

    protected void Command1_Click(object sender, EventArgs e)
    {
        Response.Redirect("driver_hawb_list.aspx?ELT=" + elt_account_number + "&ORG=" + driver_acct);
    }

    protected void Command2_Click(object sender, EventArgs e)
    {
        Response.Redirect("driver_hawb_milestones.aspx?ELT=" + elt_account_number + "&ORG=" + driver_acct + "&HAWB=" + hawb_val);
    }

    protected void Command3_Click(object sender, EventArgs e)
    {
        updateDriverHAWB();
    }
}
