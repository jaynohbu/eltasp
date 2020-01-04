using System;
using System.IO;
using System.Data;
using System.Drawing;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Net.Mail;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CrystalDecisions.Shared;

public partial class ASPX_Domestic_Domestic_Email : System.Web.UI.Page
{
    //protected SmtpClient client = null;
    protected MailMessage mail;
    protected DataSet ds = null;
    protected DataSet dn = null;
    protected DataSet dm = null;
    protected string ConnectStr = null;
    private string elt_account_number = null;
    private int lastuid = 0;
    private string user_id, login_name, user_right;
    protected ReportSourceManager rsm = null;
    private int maxRows = 20;
    protected string search_no, search_type;
    protected string OrgNox="";
    protected string DateS = null;
    protected string DateE = null;
    protected string Typex = null;
    protected string SQL = null;
    protected void Page_Load(object sender, EventArgs e)
    {
        object PreNo = Request.Params.Get("searchNo");
        /*  try
           {*/
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        ConnectStr = (new igFunctions.DB().getConStr());
        
        if (!IsPostBack)
        {
            LoadParameters();
            userinfo();
        }
        //LoadParameters();
        //userinfo();
        if (OrgNox != "")
        {
            hORGNO.Value = OrgNox;
            CustomerInfo(OrgNox);
        }



        /* }
           catch
           {
              Response.Write("<script>alert('Session Expired. Try logining in again'); self.close();</script>");
              Response.End();
           }*/
    }

    protected void LoadParameters()
    {
        //hORGNO.Visible = false;
        
        try
        {
            OrgNox = Request.Params["Org_num"].ToString();
            Typex = Request.Params["type"].ToString();
            SQL = Request.Params["SQL"].ToString();
            DateS = Request.Params["DateS"].ToString();
            DateE = Request.Params["DateE"].ToString();
            

        }
        catch { }
        if (DateE == null)
        {
            DateE = System.DateTime.Today.ToString("yyyy-MM-dd");

        }
        if (DateS == null)
        {
            DateS = System.DateTime.Today.ToString("yyyy-MM-dd");
        }

    }



    protected void FormatDataSet(string tableName)
    {
        try
        {
            DataColumn newColumn = new DataColumn("row_index", typeof(int));
            ds.Tables[tableName].Columns.Add(newColumn);
            for (int i = 0; i < ds.Tables[tableName].Rows.Count; i++)
            {
                ds.Tables[tableName].Rows[i][newColumn] = i;
            }
        }
        catch { }
    }


    protected void SendMail(object sender, EventArgs e)
    {
       //
        string from = txtEmail.Text.ToString();
        string to = TxtTO.Text.ToString();
        string subject = TxtSubject.Text.ToString();
        string body = txtBody.Text.ToString();
       if(TxtTO.Text.Trim() == "")
        {
            Response.Write("<script>alert('Please enter recipient email addresas'); </script>");
        Response.Write("<script>window.history.back(); </script>");
            
        }
        if (from == null || from =="")
        {
            Response.Write("<script>alert('Please enter your email addresas. ');window.history.back(); </script>");
        }
        else
        {
            MailSend(from, to,subject, body);
        }
        }



    protected void MailSend(string from, string to, string subject, string body)
    {
        //Test Email Data
        string strdir = "D:\\TEMP\\";
        string AttFileName = Label2.Text.ToString();
        string filelocation = strdir + AttFileName;
        //client = new SmtpClient();
        //client.Host = "localhost";
        //client.Port = 25;
        try
        {
            bool T1;
            GoofyMailSender mail = new GoofyMailSender("localhost");
            T1=mail.SendMailWithAttachment(to, from, subject, body, "");
            if (T1 == false)
            {
                Response.Write("<script>alert('Email address Error, Your Mail do not send,Please check recipient mail '); </script>");
            }
            else
            {
                if (PDFCheckBox.Checked == true)
                {
                    mail.AttachFile(filelocation);
                }
                mail.MailSend();
                updateEmailhistory(to, subject, body, from);
                //File.Delete(filelocation);
            }
        }
        catch
        {
            //File.Delete(filelocation);
            Response.Write("<script>alert('Email address Error, Your Mail do not send '); indow.close();</script>");
            
        }
         finally
        {
                Response.Write("Your E-mail has been sent sucessfully");
                Response.Write("<script>window.close();</script>");
        } 
   
    }
    protected void MailClose(object sender, EventArgs e)
    {
        string strdir = "D:\\TEMP\\";
        string AttFileName = Label2.Text.ToString();
        File.Delete(strdir + AttFileName);
        Response.Write("<script>window.close();</script>");
    }

    protected void userinfo()
    {
        string sqlText = "select * from users where elt_account_number=" + elt_account_number;
        if (user_id != "0000")
        {
            sqlText = sqlText + "and userid=" + user_id;
        }
        DataTable dt = new DataTable("user_title");
        SqlDataAdapter Adap = null;
        SqlConnection Con = null;
        if (sqlText != null && sqlText.Trim() != "")
        {
            try
            {
                ConnectStr = (new igFunctions.DB().getConStr());
                Con = new SqlConnection(ConnectStr);
                Adap = new SqlDataAdapter();
                ds = new DataSet();

                Con.Open();
                SqlCommand cmd = new SqlCommand(sqlText.ToString(), Con);
                Adap.SelectCommand = cmd;
                Adap.Fill(dt);
            }
            catch
            {
            }
            finally
            {
                if (Adap != null)
                {
                    Adap.Dispose();
                }
                if (Con != null)
                {
                    Con.Close();
                }
            }
        }
        txtname.Text = dt.Rows[0]["user_fname"].ToString() + " " + dt.Rows[0]["user_lname"].ToString();
        txtEmail.Text = dt.Rows[0]["user_email"].ToString();
    }


    protected void CustomerInfo(string OrgNo)
    {
        string sqlText = "select * from organization where elt_account_number=" + elt_account_number + " and org_account_number=" +OrgNox ;

        DataTable dt = new DataTable("send_title");
        SqlDataAdapter Adap = null;
        SqlConnection Con = null;
        if (sqlText != null && sqlText.Trim() != "")
        {
            try
            {
                ConnectStr = (new igFunctions.DB().getConStr());
                Con = new SqlConnection(ConnectStr);
                Adap = new SqlDataAdapter();
                ds = new DataSet();

                Con.Open();
                SqlCommand cmd = new SqlCommand(sqlText.ToString(), Con);
                Adap.SelectCommand = cmd;
                Adap.Fill(dt);
            }
            catch
            {
            }
            finally
            {
                if (Adap != null)
                {
                    Adap.Dispose();
                }
                if (Con != null)
                {
                    Con.Close();
                }
            }
        }
        TxtCustomerName.Text = dt.Rows[0]["dba_name"].ToString(); 
        //Label1.Text = dt.Rows[0]["dba_name"].ToString() + ".pdf";
        TxtTO.Text = dt.Rows[0]["owner_email"].ToString();
        if (Typex == "CD")
        {
            TxtSubject.Text = " Customer Daily Recap Report";
            Label2.Text="Customer_Daily_Recap_" + DateS+".pdf";
        }
        else if (Typex == "AS")
        {
            TxtSubject.Text = " Active Shippment Report["+ DateS+"]";;
            Label2.Text = "active_shipment_" + DateS + ".pdf";
        }
    }

    protected void MakeDataSet(string tableName, string sqlText)
    {
        SqlDataAdapter Adap = null;
        SqlConnection Con = null;

        if (sqlText != null && sqlText.Trim() != "")
        {
            try
            {
                DataTable tempTable = new DataTable(tableName);

                ConnectStr = (new igFunctions.DB().getConStr());
                Con = new SqlConnection(ConnectStr);
                Adap = new SqlDataAdapter();

                Con.Open();
                SqlCommand cmd = new SqlCommand(sqlText.ToString(), Con);
                Adap.SelectCommand = cmd;
                Adap.Fill(tempTable);
                dm.Tables.Add(tempTable);
            }
            catch (Exception Error)
            {

            }
            finally
            {
                if (Adap != null)
                {
                    Adap.Dispose();
                }
                if (Con != null)
                {
                    Con.Close();
                }
            }
        }
    }
    protected void GetUid()
    {
        string sqlText = "select auto_uid from email_history order by auto_uid desc";
        DataTable dt = new DataTable("email_title");
        SqlDataAdapter Adap = null;
        SqlConnection Con = null;
        if (sqlText != null && sqlText.Trim() != "")
        {
            try
            {
                ConnectStr = (new igFunctions.DB().getConStr());
                Con = new SqlConnection(ConnectStr);
                Adap = new SqlDataAdapter();
                ds = new DataSet();

                Con.Open();
                SqlCommand cmd = new SqlCommand(sqlText.ToString(), Con);
                Adap.SelectCommand = cmd;
                Adap.Fill(dt);
            }
            catch
            {
            }
            finally
            {
                if (Adap != null)
                {
                    Adap.Dispose();
                }
                if (Con != null)
                {
                    Con.Close();
                }
            }
        }
        lastuid = Convert.ToInt32(dt.Rows[0]["auto_uid"].ToString()) + 1;

    }


    protected void updateEmailhistory( string ToEmail,  string subject, string body, string from)
    {
        GetUid();
        SqlConnection Con = null;
        SqlCommand Cmd = null;
        SqlTransaction trans = null;
        string orgName = TxtCustomerName.Text.ToString();
        string sender = txtname.Text.ToString();
        string pdfName = Label2.Text.ToString();
       try
        {
            
            //SET IDENTITY_INSERT = OFF;
            Con = new SqlConnection(ConnectStr);
            Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Con.Open();
            trans = Con.BeginTransaction();
            Cmd.Transaction = trans;

            string insertText = @"
                    insert into email_history (
                        elt_account_number,
                        auto_uid,
                        email_id,
                        user_id,
                        to_org_id,
                        to_org_name,
                        email_sender,
                        email_from,
                        email_to,
                        email_cc,
                        email_subject,
                        email_content,
                        sent_date,    
                        sent_status,
                        air_ocean,
                        im_export,
                        screen_name,
                        master_num,
                        house_num,
                        attached_pdf
                    )
                    values
                    (
                        @elt_account_number,
                        @auto_uid,
                        @email_id,
                        @user_id,
                        @to_org_id,
                        @to_org_name,
                        @email_sender,
                        @email_from,
                        @email_to,
                        @email_cc,
                        @email_subject,
                        @email_content,
                        @sent_date,    
                        @sent_status,
                        @air_ocean,
                        @im_export,
                        @screen_name,
                        @master_num,
                        @house_num,
                        @attached_pdf
                    )";

            Cmd.CommandText = insertText;
            Cmd.Parameters.AddWithValue("@elt_account_number", elt_account_number);
            Cmd.Parameters.AddWithValue("@auto_uid", lastuid);
            Cmd.Parameters.AddWithValue("@email_id", Session.SessionID.ToString() + "-" + elt_account_number + "-" + OrgNox);
            Cmd.Parameters.AddWithValue("@user_id", user_id);
            Cmd.Parameters.AddWithValue("@to_org_id", OrgNox);
            Cmd.Parameters.AddWithValue("@to_org_name", orgName);
            Cmd.Parameters.AddWithValue("@email_sender", sender);
            Cmd.Parameters.AddWithValue("@email_from", from);
            Cmd.Parameters.AddWithValue("@email_to", ToEmail);
            Cmd.Parameters.AddWithValue("@email_cc", "");
            Cmd.Parameters.AddWithValue("@email_subject", subject);
            Cmd.Parameters.AddWithValue("@email_content", body);
            Cmd.Parameters.AddWithValue("@sent_date", System.DateTime.Today.ToString());
            Cmd.Parameters.AddWithValue("@sent_status", "Send Test");
            Cmd.Parameters.AddWithValue("@air_ocean", "A");
            Cmd.Parameters.AddWithValue("@im_export", "E");
            Cmd.Parameters.AddWithValue("@screen_name", "Domestic Email");
            Cmd.Parameters.AddWithValue("@master_num", "");
            Cmd.Parameters.AddWithValue("@house_num", "");
            Cmd.Parameters.AddWithValue("@attached_pdf", pdfName);
            
            Cmd.ExecuteNonQuery();
            
            trans.Commit();
      }
        catch
        {
            
            trans.Rollback();
        }

        finally
        {
            Con.Close();
            Cmd.Dispose();
            trans.Dispose();
        }
    }



    protected void doUploadFile(string shipper_acct, string faile_name, byte[] file_bytes)
    {
        
        SqlConnection Con = null;
        SqlCommand Cmd = null;
        SqlTransaction trans = null;

        try
        {
            Con = new SqlConnection(ConnectStr);
            Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Con.Open();
            trans = Con.BeginTransaction();
            Cmd.Transaction = trans;

            string insertText = @"
                    insert into user_files (
                        elt_account_number,
                        org_no,
                        file_name,
                        file_size,
                        file_type,
                        file_content,
                        file_checked,
                        in_dt
                    )
                    values
                    (
                        @elt_account_number,
                        @org_no,
                        @file_name,
                        @file_size,
                        @file_type,
                        @file_content,
                        @file_checked,
                        @in_dt
                    )";

            Cmd.CommandText = insertText;

            Cmd.Parameters.AddWithValue("@elt_account_number", elt_account_number);
            Cmd.Parameters.AddWithValue("@org_no", shipper_acct);
            Cmd.Parameters.AddWithValue("@file_name", faile_name);
            Cmd.Parameters.AddWithValue("@file_size", file_bytes.Length);
            Cmd.Parameters.AddWithValue("@file_type", "");
            Cmd.Parameters.AddWithValue("@file_content", file_bytes);
            Cmd.Parameters.AddWithValue("@file_checked", "Y");
            Cmd.Parameters.AddWithValue("@in_dt", System.DateTime.Now);

            Cmd.ExecuteNonQuery();
            trans.Commit();
        }
        catch
        {
            trans.Rollback();
        }

        finally
        {
            Con.Close();
            Cmd.Dispose();
            trans.Dispose();
        }
    }
}