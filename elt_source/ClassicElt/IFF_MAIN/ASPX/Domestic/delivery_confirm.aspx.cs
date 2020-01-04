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

public partial class ASPX_Domestic_delivery_confirm : System.Web.UI.Page
{
    protected DataSet ds = null;
    protected DataSet dt = null;
    protected MailMessage message;
    protected GoofyMailSender msg = new GoofyMailSender("localhost");
    //protected SmtpClient client = null;
    protected string ConnectStr = null;
    protected string ConnectStr2 = null;
    protected int lastuid = 0;
    private string elt_account_number = null;
    private string user_id, login_name, user_right;
    private int maxRows = 20;
    private int Findex = 0;
    private string Refpage = "N";
    private string emailError = "N";
    protected string search_no, search_type, back;
    protected string File_Name, shipperNo;
    protected string strdir = "D:\\TEMP\\";
    
    protected void Page_Load(object sender, EventArgs e)
    {
        object PreNo = Request.Params.Get("searchNo");

            Session.LCID = 1033;
            elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
            user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
            login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
            ConnectStr = (new igFunctions.DB().getConStr());

            LoadParameters();


            if (!IsPostBack)
            {
                //BindGridView();
                userinfo();
            }
             
            //LoadParameters();
            //BindGridView();
            //userinfo();
            if (PreNo != null && PreNo.ToString().Trim() != "")
            {
                if (HSend.Value != "Y")
                {
                    BindGridView();
                    HSend.Value = "Y";
                }
        }
    
    }

    protected void LoadParameters()
    {
        try
        {
            search_no = Request.Params["searchNo"].ToString();
            search_type = Request.Params["searchType"].ToString();
            lstSearchType.SelectedValue = search_type;
            shipperNo = Request.Params["orgNum"].ToString();
            File_Name = Request.Params["FileName"].ToString();
            if (File_Name != "")
            {
                DeleteFile(File_Name.ToString(), shipperNo.ToString());
            }
        }
        catch { 
        }
    }

    protected void BindGridView()
    {
        string sqlText = "select a.shipper_name,a.shipper_account_number as shipper_account_number,c.owner_email as shipper_email,a.consignee_name,ISNULL(a.Consignee_acct_num,'0') as Consignee_num,e.owner_email as consignee_email,a.MAWB_num as mawbNum,a.HAWB_num as HAWB_num,d.dba_name as AgentName, a.ci as Nsubject,b.File# as FileNo from HAWB_Master a left join organization c on (a.elt_account_number=c.elt_account_number and a.shipper_account_number = c.org_account_number) left join organization e on (a.elt_account_number=e.elt_account_number and Consignee_name = e.dba_name) left join agent d on (a.elt_account_number=d.elt_account_number) left join MAWB_number b on (a.elt_account_number=b.elt_account_number and a.MAWB_num = b.MAWB_no and b.is_dome ='Y') where a.elt_account_number=" + elt_account_number + " AND a.is_dome = 'Y' and a.shipper_account_number <> ''";
        if (search_type == "HAWB")
        {
            sqlText = sqlText + " and a.hawb_num='" + search_no + "'";
        }
        else if (search_type == "MAWB")
        {
            sqlText = sqlText + " and a.mawb_num='" + search_no + "'";
        }
        else
        {
            sqlText = sqlText + " and b.file#='" + search_no + "'";
        }
        string FileSQL = "select elt_account_number,cast(org_no as nvarchar(16)) as org_no,file_name,file_size,file_type,file_checked,in_dt from user_files where elt_account_number=" + elt_account_number;
        MakeDataSet("HAWBList", sqlText);
        MakeDataSet("FileList", FileSQL);
        FormatDataSet("HAWBList");
        FormatDataSet("FileList");

        // SQL TEST
        ////////////////////////////////////////

        if (ds.Tables[0].Rows.Count == 0)
        {
            MakeEmptyGridView();
        }
        else
        {
            HEmpty.Value = "N";
            if (ds.Tables["HAWBList"].Rows.Count == 0)
            {
                MakeEmptyGridView();
            }
            else
            {
                GridViewHAWB.PageSize = maxRows;
                GridViewHAWB.DataSource = ds.Tables["HAWBList"].DefaultView;
                GridViewHAWB.DataBind();
                //import email ID 
                for (int i = 0; i < GridViewHAWB.Rows.Count; i++)
                {
                    Repeater FileRepeater = (Repeater)GridViewHAWB.Rows[i].FindControl("repeaterUploadFile");
                    string CBID ="";
                    string MID = ((CheckBox)GridViewHAWB.Rows[i].FindControl("MainCheckBox")).ClientID;
                    string ID=((HiddenField)GridViewHAWB.Rows[i].FindControl("hOrgNo")).ClientID;
                    string ShipperEmail = ((TextBox)GridViewHAWB.Rows[i].FindControl("Txtshipper_email")).ClientID;
                    string ID2 = ((HiddenField)GridViewHAWB.Rows[i].FindControl("hConsigneeID")).ClientID;
                    string ConsigneeEmail = ((TextBox)GridViewHAWB.Rows[i].FindControl("Txtconsignee_email")).ClientID;
                    string ShipperName = ((TextBox)GridViewHAWB.Rows[i].FindControl("txtShipper_Name")).ClientID;
                    string ConsigneeName = ((TextBox)GridViewHAWB.Rows[i].FindControl("txtConsignee_name")).ClientID;
                    string CCEmail = ((TextBox)GridViewHAWB.Rows[i].FindControl("TxtCC")).ClientID;
                    string EmailSubject = ((TextBox)GridViewHAWB.Rows[i].FindControl("TxtSubject")).ClientID;
                    string EmailBody = ((TextBox)GridViewHAWB.Rows[i].FindControl("txtBody")).ClientID;
                    string CheckHAWB = ((CheckBox)GridViewHAWB.Rows[i].FindControl("HAWBCheckBox")).ClientID;
                    string FileID = ((Repeater)GridViewHAWB.Rows[i].FindControl("repeaterUploadFile")).ClientID;
                    string Uimage = ((ImageButton)GridViewHAWB.Rows[i].FindControl("ImagU")).ClientID;
                    string ATTFILE = ((FileUpload)GridViewHAWB.Rows[i].FindControl("fileShipperAttachment")).ClientID;
                    string Repnid = FileRepeater.ClientID;
                    //((TextBox)GridViewHAWB.Rows[i].FindControl("Txtshipper_email")).Attributes.Add("onblur", "changeShipperEmail(" + ((TextBox)GridViewHAWB.Rows[i].FindControl("Txtshipper_email")).ClientID + "," + ID + ")");
                    //((TextBox)GridViewHAWB.Rows[i].FindControl("Txtconsignee_email")).Attributes.Add("onblur", "changeConsigneeEmail(" + ((TextBox)GridViewHAWB.Rows[i].FindControl("Txtconsignee_email")).ClientID + "," + ID2 + ")");
                    ((ImageButton)GridViewHAWB.Rows[i].FindControl("Image1")).Attributes.Add("onClick", "changeShipperEmail(" + ShipperEmail + "," + ID + ")");
                    ((ImageButton)GridViewHAWB.Rows[i].FindControl("Image2")).Attributes.Add("onClick", "changeConsigneeEmail(" + ConsigneeEmail + "," + ID2 + ")");
                    for (int Rep_index = 0; Rep_index < FileRepeater.Items.Count; Rep_index++)
                    {
                        CBID = ((CheckBox)FileRepeater.Items[0].FindControl("checkItem")).ClientID;
                    }

                    ((CheckBox)GridViewHAWB.Rows[i].FindControl("MainCheckBox")).Attributes.Add("onClick", "BlockEmailRow(" + ((CheckBox)GridViewHAWB.Rows[i].FindControl("MainCheckBox")).ClientID + "," + ShipperEmail + "," + ConsigneeEmail + "," + ConsigneeName + "," + ShipperName + "," + CCEmail + "," + EmailSubject + "," + EmailBody + "," + CheckHAWB + "," + ATTFILE + "," + ATTFILE  + ")");

                     CheckBox MainCheck=(CheckBox)GridViewHAWB.Rows[i].FindControl("MainCheckBox");

                 /*  for (int Rep_index = 0; Rep_index < FileRepeater.Items.Count; Rep_index++)
                     {
                         string CBID = ((CheckBox)FileRepeater.Items[1].FindControl("checkItem")).ClientID;
                         //Response.Write("<script>alert('"+ CBID +"');</script>");
                       //((CheckBox)GridViewHAWB.Rows[i].FindControl("MainCheckBox")).Attributes.Add("onClick", "BlockEmailRow(" + ((CheckBox)GridViewHAWB.Rows[i].FindControl("MainCheckBox")).ClientID + "," + ShipperEmail + "," + ConsigneeEmail + "," + ConsigneeName + "," + ShipperName + "," + CCEmail + "," + EmailSubject + "," + EmailBody + "," + CheckHAWB + "," + CheckHAWB + "," + CBID + ")");
                       //((CheckBox)GridViewHAWB.Rows[i].FindControl("MainCheckBox")).Attributes.Add("onClick", "checkSelection(" + MID + "," + CBID + ")");  
                     }*/

                ds.Relations.Clear();
                BindRepeater();
            }
        }
        //ds.Dispose();
        /* if (back == "Y")
         {
             Response.Write("<script>window.history.back();</script>");
         }*/
        }
    }

    protected void BindRepeater()
    {
        try
        {
            ds.Relations.Add(ds.Tables["HAWBList"].Columns["shipper_account_number"], ds.Tables["FileList"].Columns["org_no"]);
        }
        catch { }
        if (GridViewHAWB.Rows.Count != 0)
        {
            for (int rowIndex = 0; rowIndex < GridViewHAWB.Rows.Count; rowIndex++)
            {
                Repeater FileRepeater = (Repeater)GridViewHAWB.Rows[rowIndex].FindControl("repeaterUploadFile");
                if (FileRepeater != null)
                {
                    DataRow[] reportSet = ds.Tables["HAWBList"].Rows[rowIndex].GetChildRows(ds.Relations[0]);
                    DataTable dm = new DataTable();

                    dm = ds.Tables["FileList"].Clone();

                    if (reportSet.Length > 0)
                    {
                        for (int i = 0; i < reportSet.Length; i++)
                        {
                            dm.Rows.Add(reportSet[i].ItemArray);
                        }
                        FileRepeater.DataSource = dm;
                        FileRepeater.DataBind();
                    }
                }
            }
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
                ds.Tables.Add(tempTable);
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

    protected void MakeEmptyGridView()
    {
        ds.Tables[0].Rows.Add(ds.Tables[0].NewRow());
        GridViewHAWB.DataSource = ds.Tables[0].DefaultView;
        GridViewHAWB.DataBind();
        int columnCount = GridViewHAWB.Rows[0].Cells.Count;
        GridViewHAWB.Rows[0].Cells.Clear();
        GridViewHAWB.Rows[0].Cells.Add(new TableCell());
        GridViewHAWB.Rows[0].Cells[0].ColumnSpan = columnCount;
        GridViewHAWB.Rows[0].Cells[0].Text = "No HAWB Records Found.";
        GridViewHAWB.Rows[0].Cells[0].HorizontalAlign = HorizontalAlign.Center;
        HEmpty.Value = "Y";
    }

    protected void GridViewHAWB_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridViewHAWB.PageIndex = e.NewPageIndex;
        BindGridView();
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


    protected void btnFileUpload_Command(object sender, CommandEventArgs e)
    {
        string[] commandArgs = e.CommandArgument.ToString().Split(new char[] { '-' });

        GridViewRow gvRow = GridViewHAWB.Rows[Int32.Parse(commandArgs[0].ToString())];
        FileUpload fileUploadObj = (FileUpload)gvRow.FindControl("fileShipperAttachment");


        if (fileUploadObj.HasFile)
        {
            byte[] fileBytes = fileUploadObj.FileBytes;
            string fileName = fileUploadObj.FileName;
            // Need file size check logic
            doUploadFile(commandArgs[1].ToString(), fileName, fileBytes);
        }
        else
        {
            Response.Write("<script>alert('Please Browse Attach File');</script>");
            Response.Write("<script>window.history.back();</script>");
            
        }
    }
    // attachment file counter///////////////////////
    public string GetNo2()
    {
        Findex = Findex + 1;
        return Findex.ToString();
    }
    // reset counter////////////////////////////////
    public string GetNoV()
    {
        Findex = 0;
        return "";
    }
    //check event

 
    private void Update_Click(object sender, System.EventArgs e)
    {
        CheckBox c = (CheckBox)sender;
        string wineID = ((Control)c).ID;
        SqlConnection conn = new SqlConnection(ConnectStr);
        SqlCommand comm = new SqlCommand();
        string sql;
        
        sql = "Update user_files Set file_checked = ";
       if (c.Checked)
       {
            sql = sql + "'Y'";
           
       }
       else
       {
           sql = sql + "'N'";
       }
       sql = sql + ", in_dt = '" + System.DateTime.Now.ToString() + "' Where elt_account_number = '" + elt_account_number ;
        //+ "' and file_name = '" + FileName + "' and org_no =" + org_No  
        comm.Connection = conn;
        comm.CommandType = CommandType.Text;
        comm.CommandText = sql;
        conn.Open();
        comm.ExecuteNonQuery();
        conn.Close();
    }


    // Send Mail Check
    protected void btnEmail_Check(object sender, EventArgs e)
    {
        //check empty Mail
        string emtpyemail = "N";
        int Y = 0;
        if (search_no != null)
        {
            if (HEmpty.Value.ToString() == "N")
            {
                // Check Empty Shipper Mail address
                for (int rowIndex = 0; rowIndex < GridViewHAWB.Rows.Count; rowIndex++)
                {
                    TextBox txtTo = (TextBox)GridViewHAWB.Rows[rowIndex].FindControl("Txtshipper_email");
                    CheckBox CHK = (CheckBox)GridViewHAWB.Rows[rowIndex].FindControl("MainCheckBox");
                    if (CHK.Checked == true)
                    {
                        if (txtTo.Text.ToString() == "")
                        {
                            emtpyemail = "Y";
                        }
                    }
                    else
                    {
                        Y = Y + 1;
                    }
                }
                if (Y == GridViewHAWB.Rows.Count)
                {
                    Response.Write("<script>alert('Please select one or more mail');</script>");
                }
                //check Sender Name  
                if (txtname.Text.Trim() == "")
                {
                    Response.Write("<script>alert('Please enter your name');</script>");
                }
                //check Sender Address 
                else if (txtEmail.Text.Trim() == "")
                {
                    Response.Write("<script>alert('Please enter your Email');</script>");
                }
                else if (emtpyemail == "Y")
                {
                    //if empty shipper Emaill then return error massage
                    Response.Write("<script>alert('Please enter All Shipper Email Address'); </script>");
  
                }
                else if (GridViewHAWB.Rows.Count == 0)
                {
                    Response.Write("<script>alert('Please select one or more mail'); window.history.back();</script>");
                    
                }
                else
                {
                    //mail send
                    HSend.Value = "Y";
                    //HSend.Value = "Y";
                    btnEmail_Click();
                }
            }
            else
            {
                Response.Write("<script>alert('No Email Recond Found');</script>");
                Response.Write("<script>window.history.back();</script>");
            }
        }
        else
        {
            //if no Recound Found then Return Error
            Response.Write("<script>alert('Please select AirBill or File No!');</script>");
            Response.Write("<script>window.history.back();</script>");
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

    //MAIL SEND 
    protected void btnEmail_Click()
    {
        //FILE Location

        string strFileName;
        string PdfFile;

        int X = 0;

        //Mail Info
        for (int rowIndex = 0; rowIndex < GridViewHAWB.Rows.Count; rowIndex++)
        {

            try
            {
                // Mail Check box
                CheckBox MainBox = (CheckBox)GridViewHAWB.Rows[rowIndex].FindControl("MainCheckBox");
                // Get HAWB Checkbox
                CheckBox HAWBox = (CheckBox)GridViewHAWB.Rows[rowIndex].FindControl("HAWBCheckBox");
                if (MainBox.Checked == true)
                {
                    // Mail shipper mail to 
                    TextBox txtTo = (TextBox)GridViewHAWB.Rows[rowIndex].FindControl("Txtshipper_email");
                    // Mail subject 
                    TextBox txtSubject = (TextBox)GridViewHAWB.Rows[rowIndex].FindControl("TxtSubject");
                    // Mail Body 
                    TextBox txtBody = (TextBox)GridViewHAWB.Rows[rowIndex].FindControl("txtBody");
                    // Consignee Name 
                    TextBox txtConsigneeName = (TextBox)GridViewHAWB.Rows[rowIndex].FindControl("txtConsignee_name");
                    // Mail Consignee mail TO 
                    TextBox txtConsigneeEmail = (TextBox)GridViewHAWB.Rows[rowIndex].FindControl("Txtconsignee_email");
                    TextBox txtShipperName = (TextBox)GridViewHAWB.Rows[rowIndex].FindControl("txtShipper_Name");
                    // Mail CC
                    TextBox txtCC = (TextBox)GridViewHAWB.Rows[rowIndex].FindControl("txtCC");
                    // GET Shipper ID 
                    HiddenField orgNo = (HiddenField)GridViewHAWB.Rows[rowIndex].FindControl("hOrgNo");
                    // Get HAWB No
                    HiddenField HAWBNO = (HiddenField)GridViewHAWB.Rows[rowIndex].FindControl("hHAWBNo");
                    // create new Client
                    //client = new SmtpClient();
                    // set Host and Port
                    //client.Host = "localhost";
                    //client.Port = 25;
                    // get from , Shipper to, Consignee To, subject, Body To String Form
                    string ShipperName = txtShipperName.Text.ToString();
                    string ConsigneeName = txtConsigneeName.Text.ToString();
                    string From = txtEmail.Text.ToString();
                    string Subject = txtSubject.Text.ToString();
                    string Body = txtBody.Text.ToString();
                    string ToShipper = txtTo.Text.ToString();
                    string ToConsignee = txtConsigneeEmail.Text.ToString();
                    string HAWB_num = HAWBNO.Value.ToString();
                    string CC_email = txtCC.Text.ToString();
                    string org_acct = orgNo.Value.ToString();
                    bool T1 = true;
                    bool T2 = true;
                    // Sned Mail To shipper and Consignee
                    
                    try
                    {

                        T1 = msg.SendMailWithCC(ToShipper, From, Subject, Body, CC_email, "");
                        if (T1 == false)
                        {
                            Response.Write("<script>alert('Check address! Shipper or CC address Error'); </script>");
                        }
                        else
                        {
                            PDFAttchFile(rowIndex, HAWB_num);
                            ALLAttchFile(rowIndex, org_acct);
                            msg.MailSend();
                            if (T1 == false && emailError != "N")
                            {
                                Response.Write("<script>alert('Email Send Error'); </script>");
                            }
                            else
                            {
                                updateEmailhistory(org_acct, ShipperName, ToShipper, CC_email, Subject, Body, HAWB_num, "S");
                                emailError = "N";
                            }
                        }
                        if (T1 != false && emailError == "N")
                        {

                            if (txtConsigneeName.Text.ToString() != "" && txtConsigneeEmail.Text.ToString() != "")
                            {

                                // mail to Consignee

                                T2 = msg.SendMailWithAttachment(ToConsignee, From, Subject, Body, "");

                                if (T2 == false)
                                {
                                    Response.Write("<script>alert('Check address! Consignee Emai address Error'); </script>");
                                }
                                else
                                {

                                    PDFAttchFile(rowIndex, HAWB_num);
                                    ALLAttchFile(rowIndex, org_acct);
                                    msg.MailSend();
                                    if (T2 == false && emailError != "N")
                                    {
                                        Response.Write("<script>alert('Email Send Error'); </script>");
                                    }
                                    else
                                    {
                                        updateEmailhistory(org_acct, ConsigneeName, ToConsignee, CC_email, Subject, Body, HAWB_num, "C");
                                        Response.Write("<script>alert('Shipper and Consignee Email Send'); </script>");

                                    }

                                }
                            }
                            else
                            {
                                Response.Write("<script>alert('Shipper Email Send'); </script>");
                            }
                        }
                    }
                    catch
                    {
                        //if shipper email Error
                        Response.Write("<script>alert(' Email address Error'); self.close();</script>");
                    }

                }
                else
                {
                    MainBox.Checked = true;
                    HAWBox.Checked = true;

                }
            }
            catch
            {
            }

            //Response.Write("<script>window.history.back();</script>");

        }
    }

    //File Attact to MAil
    protected void ALLAttchFile(int RowIndex, string orgid)
    {
        Repeater Rep = (Repeater)GridViewHAWB.Rows[RowIndex].FindControl("repeaterUploadFile");
        for (int RepIndex = 0; RepIndex < Rep.Items.Count; RepIndex++)
        {
            CheckBox CB = (CheckBox)Rep.Items[RepIndex].FindControl("checkItem");
            HiddenField HFileName =(HiddenField)Rep.Items[RepIndex].FindControl("hFileName");
            string FileName = HFileName.Value.ToString();
            if (CB.Checked == true)
            {
                AddTOMail(FileName, orgid);
            }
            
        }
    }

    protected void PDFAttchFile(int rowIndex, string HAWB)
    {
        string strdir = "D:\\TEMP\\";
        // Get HAWB Checkbox
        CheckBox HAWBox = (CheckBox)GridViewHAWB.Rows[rowIndex].FindControl("HAWBCheckBox");
        if (HAWBox.Checked == true)
        {
            //PDFFILE Location
            string PdfFile = strdir + elt_account_number + "shippermail" + HAWB + ".pdf";
            try
            {
                //PDF file attach////////////////////////////////////////////////////
                //Response.Write("<script> window.open('/IFF_MAIN/ASP/ajaxFunctions/ajax_EMAIL_Fileattchment.asp?mode=send&HAWB=" + HAWBNO.Value.ToString() + "');</script>");
                msg.AttachFile(PdfFile);
                // attacment file////////////////////////////////////////////////


            }
            catch
            {
                emailError = "Y";
            }

        }

    }

    //GET ROW NO
    public string GetNo()
    {
        int index = 0;
        index = GridViewHAWB.Rows.Count;
        return index.ToString();
    }
    public bool CCBox(string check)
    {
        if (check == "Y")
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    // get Title to Emai Subject 
    public string GetSubject(string Company, string HAWBNO)
    {
        string subject;

        subject = "Notice: " + Company +" ("+ search_type.ToString()+": "+ search_no.ToString();
        if (search_type.ToString() != "HAWB")
        {
            subject = subject + " HAWB: " + HAWBNO ;
        }
        subject = subject + ")";
        return subject;
    }

    
    //attach binary file to memory file and attach to mail
    private void BinaryFileAttachment(byte[] Filebyte, string FileName, string type, int length, MailMessage mag)
    {
     try
        {

            MemoryStream ms = new MemoryStream(Filebyte);
            ms.Write(Filebyte, 0, length);
            Attachment data = new Attachment(ms, FileName, type);
            mag.Attachments.Add(data);
            ms.Close();
       }
        catch { 
        }
    }



    //file restore 
    protected void AddTOMail(string FileName, string org_No)
    {

        string sqlText = "select * from user_files where elt_account_number=" + elt_account_number + "and file_name = '" + FileName + "' and org_no =" + org_No;
        //sqlOutput.Text = sqlText.ToString();
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

        for (int i = 0; i < dt.Rows.Count; i++)
        {
            try
            {
                string filelocation= strdir + elt_account_number + org_No + FileName;
                byte[] filebyte = (byte[])dt.Rows[i]["file_content"];
                string type = dt.Rows[i]["file_type"].ToString();
                string lenght = dt.Rows[i]["file_size"].ToString();
                int xlenght =Int32.Parse(lenght);
                msg.AttachBinary(filebyte, FileName, type);
                //msg.AttachDateFile(filebyte, FileName, filelocation, xlenght);
                
           }
            catch
            {
                emailError = "Y";
                Response.Write("<script>alert('Attactment File error! try attach file again');</script>");
            }
        }
    }

    //delete Attach File///////////////////////////////////////
    protected void DeleteFile(string FileName, string orgNo)
    {
        SqlConnection con = new SqlConnection(ConnectStr);
        string deleteString = "DELETE user_files " +
          "WHERE file_name=@FileName and elt_account_number=@elt_account_number and org_no=@org_no";
        SqlCommand cmd = new SqlCommand(deleteString, con);
        cmd.Parameters.AddWithValue("@FileName", FileName);
        cmd.Parameters.AddWithValue("@elt_account_number", elt_account_number);
        cmd.Parameters.AddWithValue("@org_no", orgNo);
        con.Open();
        cmd.ExecuteNonQuery();
        con.Close();
    }


    protected void updateEmailhistory(string orgno, string orgName, string ToEmail, string CC, string subject, string body, string hawbno,string person)
    {
        string mawbno = "";
        string status = "";
         if (person == "S")
        {
            status="Shipper Delivery Confirmation";
        }
        else
        {
            status="Consignee Delivery Confirmation";
        }
        GetUid();
        Response.Write("<script>alert('" + lastuid + orgno + orgName + ToEmail + CC + subject + body + hawbno + status +"');</script>");
        if (search_type == "MAWB")
        {
            mawbno = search_no.ToString();
        }

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

            Cmd.CommandText = insertText;
            Cmd.Parameters.AddWithValue("@elt_account_number", elt_account_number);
            Cmd.Parameters.AddWithValue("@auto_uid", lastuid);
            Cmd.Parameters.AddWithValue("@email_id", Session.SessionID.ToString() + "-" + elt_account_number + "-" + orgno);
            Cmd.Parameters.AddWithValue("@user_id", user_id);
            Cmd.Parameters.AddWithValue("@to_org_id", orgno);
            Cmd.Parameters.AddWithValue("@to_org_name", orgName);
            Cmd.Parameters.AddWithValue("@email_sender", txtname.Text.ToString());
            Cmd.Parameters.AddWithValue("@email_from", txtEmail.Text.ToString());
            Cmd.Parameters.AddWithValue("@email_to", ToEmail);
            Cmd.Parameters.AddWithValue("@email_cc", CC);
            Cmd.Parameters.AddWithValue("@email_subject", subject);
            Cmd.Parameters.AddWithValue("@email_content", body);
            Cmd.Parameters.AddWithValue("@sent_date", System.DateTime.Today.ToString());
            Cmd.Parameters.AddWithValue("@sent_status", status);
            Cmd.Parameters.AddWithValue("@air_ocean", "A");
            Cmd.Parameters.AddWithValue("@im_export", "E");
            Cmd.Parameters.AddWithValue("@screen_name", "Delivery Confirmation");
            Cmd.Parameters.AddWithValue("@master_num", mawbno);
            Cmd.Parameters.AddWithValue("@house_num", hawbno);
            Cmd.Parameters.AddWithValue("@attached_pdf", "shippermail" + orgno + ".pdf");
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

    ///file display////////////////////////
    protected void DisplayFile(string FileName, string orgNo)
    {
        
        string SQLtext = "select * from user_files where elt_account_number=" + elt_account_number + "and org_num =" + orgNo + "and file_name ='" + FileName +"'" ;
        using (SqlConnection conn = new SqlConnection(SQLtext))
        {
            using (SqlCommand cmd = conn.CreateCommand())
            {
                cmd.CommandText = "LoadFromRepository";
                cmd.CommandType = CommandType.StoredProcedure;
                //cmd.Parameters.AddWithValue("@ID", fileID);
                conn.Open();

                using (SqlDataReader rdr =
                           cmd.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    byte[] filebyte = (byte[])rdr["file_content"];
                    Response.ContentType = rdr["file_type"].ToString();
                    Response.BinaryWrite(filebyte);
                }
                conn.Close();
            }
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
        reload.Value = "Y";
    }
}
