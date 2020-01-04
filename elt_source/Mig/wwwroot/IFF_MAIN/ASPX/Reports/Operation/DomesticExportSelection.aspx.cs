using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Data.SqlClient;
using System.Configuration;


public partial class ASPX_Reports_Operation_DomesticExportSelection : System.Web.UI.Page
{
        public string elt_account_number;
        public string user_id, login_name, user_right;

        protected string ConnectStr;
        public string windowName;
        public bool bReadOnly = false;
        protected string Qry = "";
        protected string vGrp = "";
        protected string vAnl = "";
        protected DataSet ds;
        protected DataTable dt;


        protected void Page_Load(object sender, System.EventArgs e)
        {
            Session.LCID = 1033;
            windowName = Request.QueryString["WindowName"];
            elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];

            user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
            user_right = Request.Cookies["CurrentUserInfo"]["user_right"];

            login_name = Request.Cookies["CurrentUserInfo"]["login_name"];

            ConnectStr = (new igFunctions.DB().getConStr());

            vGrp = Request["GRP"];

            vAnl = Request["ANL"];

            if (!IsPostBack)
            {
                iBtnGo.Attributes.Add("onclick", "Javascript:return validateDate_Cat();");

            }
        }


        protected void iBtnGo_Click(object sender, ImageClickEventArgs e)
        {
            // if (!PerformDateCheck()) return;
            // if (!PerformGroupCheck()) return;
            if (!performSearch()) return;
            Session["DSet"] = ds;

            // Response.Write(Qry);

            Response.Redirect("OperationResult.aspx?Part=Domestic-Export&" + "WindowName=" + windowName);

        }

        # region /// DateDefault
        private void performDateDefault()
        {

            //			this.Button1.Attributes.Add("onMouseDown", "Javascript:checkDate();");

            //			Webdatetimeedit1.Date = getFirstDate();
            //			Webdatetimeedit2.Date = DateTime.Now;
        }

        private DateTime getFirstDate()
        {
            int daysToAdd;
            DateTime sd = DateTime.Now.AddMonths(-1);
            DateTime firstDate;

            daysToAdd = System.DateTime.DaysInMonth(int.Parse(sd.Year.ToString()), int.Parse(sd.Month.ToString())) - int.Parse(sd.Day.ToString());
            firstDate = sd.AddDays(daysToAdd);
            return firstDate.AddDays(1);

        }
        # endregion

        private bool performSearch()
        {
            string QryGrossWeight = "";
            string QryChargeableWeight = "";

            string QryGrossWeight2 = "";
            string QryChargeableWeight2 = "";
            //<>'K' includes null, air's  scale is normally LB
            if (Request["sltWtScale"] == "KG")
            {

                // Transfer all LG TO KG leave KG's as it is 
                QryGrossWeight = "CASE WHEN ( isnull(f.kg_lb,'L') <> 'K' ) then ( isnull(c.Total_Gross_Weight,0) * 0.45359237 )  ELSE  isnull(c.Total_Gross_Weight,0) END AS [Gross Wt.],";

                QryGrossWeight2 = "CASE WHEN ( isnull(g.kg_lb,'L') <>'K' ) then ( isnull(a.Total_Gross_Weight,0) * 0.45359237 )  ELSE  isnull(a.Total_Gross_Weight,0) END AS [Gross Wt.],";
            }

            else
            {

                QryGrossWeight = "CASE WHEN ( isnull(f.kg_lb,'L') = 'K' ) then ( isnull(c.Total_Gross_Weight,0) * 2.20462262 )  ELSE  isnull(c.Total_Gross_Weight,0) END AS [Gross Wt.],";
                QryGrossWeight2 = "CASE WHEN ( isnull(g.kg_lb,'L') = 'K' ) then ( isnull(a.Total_Gross_Weight,0) * 2.20462262 )  ELSE  isnull(a.Total_Gross_Weight,0) END AS [Gross Wt.],";

            }

            if (Request["sltWtScale"] == "KG")
            {
                QryChargeableWeight = "CASE WHEN ( isnull(f.kg_lb,'L') <>'K' ) then ( isnull(c.Total_Chargeable_Weight,0) * 0.45359237 )  ELSE  isnull(c.Total_Chargeable_Weight,0)END AS [Chargeable Wt.],";
                QryChargeableWeight2 = "CASE WHEN (isnull(g.kg_lb,'L')<> 'K' ) then ( isnull(a.Total_Chargeable_Weight,0) * 0.45359237 )  ELSE  isnull(a.Total_Chargeable_Weight,0)END AS [Chargeable Wt.],";

            }
            else
            {
                QryChargeableWeight = "CASE WHEN ( isnull(f.kg_lb,'L') = 'K' ) then ( isnull(c.Total_Chargeable_Weight,0) * 2.20462262 )  ELSE  isnull(c.Total_Chargeable_Weight,0)END AS [Chargeable Wt.],";
                QryChargeableWeight2 = "CASE WHEN ( isnull(g.kg_lb,'L') = 'K' ) then ( isnull(a.Total_Chargeable_Weight,0) * 2.20462262 )  ELSE  isnull(a.Total_Chargeable_Weight,0)END AS [Chargeable Wt.],";

            }


            //Response.Write(Webdatetimeedit1.Date.ToShortDateString()+" ---   ");
            string timeStart = Webdatetimeedit1.Date.ToShortDateString();
            string timeEnd = Webdatetimeedit2.Date.ToShortDateString();

            ConnectStr = (new igFunctions.DB().getConStr());

            SqlConnection Con = new SqlConnection(ConnectStr);


            Qry =

           @"SELECT 
            isnull(b.file#,'') as [File#], 
            a.MAWB_NUM AS [Master], 
            a.HAWB_NUM AS [House], 
            Upper(isnull(a.Shipper_Name,''))  AS [Shipper],
            Upper(isnull(a.Consignee_Name,''))  AS [Consignee],
            Upper(isnull(a.Agent_Name,''))  AS [Agent],
            Upper(isnull(a.by_1,'') ) AS [Carrier],
            Upper(isnull(a.Departure_Airport,''))  AS [Origin],
            Upper(isnull(a.Dest_Airport,''))  AS [Destination],
            convert(varchar(10), a.export_date, 101) AS [Date],
            Upper(isnull(a.SalesPerson,'')) As [Sales Rep.],
            Upper(isnull(a.CreatedBy,'')) As [Processed By],
            isnull(a.Total_Pieces,0) AS [Quantity],"

             + QryGrossWeight2
             + QryChargeableWeight2
             +



            @"isnull(a.Total_Weight_Charge_HAWB,0) AS [Freight Charge], 
            isnull(a.Total_Other_Charges,0) AS [Other Charge] 
            FROM HAWB_master a left outer join mawb_number b 
            on a.elt_account_number = b.elt_account_number and a.mawb_num = b.mawb_no 
           
            INNER JOIN hawb_weight_charge g
            On a.elt_account_number=g.elt_account_number and a.HAWB_NUM =g.HAWB_NUM " +

            "where a.elt_account_number =" + elt_account_number +     //       
            "AND (a.export_date >= '" + timeStart +//
            "' AND a.export_date < DATEADD(day, 1,'" + timeEnd +//

            "')) and a.is_dome='Y'" +

            "UNION " +

            @"SELECT
            isnull(d.file#,'') as [File#],
            c.MAWB_NUM AS [Master],
            '' AS [House],
            Upper(isnull(c.Shipper_Name,''))  AS [Shipper],
            Upper(isnull(c.Consignee_Name,''))  AS [Consignee], 
            Upper(isnull(e.dba_name,''))  AS [Agent],
            Upper(isnull(c.by_1,''))  AS [Carrier],
            Upper(isnull(c.Departure_Airport,''))  AS [Origin], 
            Upper(isnull(c.Dest_Airport,''))  AS [Destination], 
            convert(varchar(10), d.ETD_DATE1, 101) AS [Date],
            Upper(isnull(c.SalesPerson,'')) As [Sales Rep.],
            Upper(isnull(c.CreatedBy,'')) As [Processed By],
            isnull(c.Total_Pieces,0) AS [Quantity], "
            + QryGrossWeight
            + QryChargeableWeight
            +

            @"isnull(c.Total_Weight_Charge_HAWB,0) AS [Freight Charge],
            isnull(c.Total_Other_Charges,0) AS [Other Charge]
            FROM MAWB_master c left outer JOIN MAWB_NUMBER d 
            ON c.elt_account_number=d.elt_account_number and c.MAWB_NUM = d.MAWB_NO 
           
            INNER JOIN organization e 
            ON e.elt_account_number=d.elt_account_number and e.org_account_number=c.master_agent 
          
            INNER JOIN mawb_weight_charge f
            On e.elt_account_number=f.elt_account_number and c.MAWB_NUM =f.MAWB_NUM " +

            "WHERE d.elt_account_number =" + elt_account_number +//
             "AND ( d.ETD_DATE1 >= '" + timeStart +//
            "' AND  d.ETD_DATE1 < DATEADD(day, 1,'" + timeEnd +
             "')) " +

            " and c.mawb_num not in ( select mawb_num from hawb_master ) and c.is_dome='Y'";





            Session["timeStart"] = timeStart;
            Session["timeEnd"] = timeEnd;

            setQRY_GroupBy();

            SqlCommand cmd = new SqlCommand(Qry);
            cmd.Connection = Con;

            SqlDataAdapter Adap = new SqlDataAdapter();
            ds = new DataSet();

            //Response.Write(cmd.CommandText);
            //Response.End();

            Con.Open();
            Adap.SelectCommand = cmd;
            Adap.Fill(ds, "Child");

            Con.Close();
            if (ds.Tables["Child"].Rows.Count == 0)
            {

                Response.Write("<script language= 'javascript'> alert(' No data was found during the period!')</script>");
                return false;
            }

            groupBy(vGrp, vAnl);

            Session["anal"] = vAnl;

            return true;

        }


        #region Web Form 디자이너에서 생성한 코드
        override protected void OnInit(EventArgs e)
        {
            //
            // CODEGEN: 이 호출은 ASP.NET Web Form 디자이너에 필요합니다.
            //
            InitializeComponent();
            base.OnInit(e);
        }

        /// <summary>
        /// 디자이너 지원에 필요한 메서드입니다.
        /// 이 메서드의 내용을 코드 편집기로 수정하지 마십시오.
        /// </summary>
        private void InitializeComponent()
        {
            //this.iBtnGo.Click += new System.Web.UI.ImageClickEventHandler(this.iBtnGo_Click);

        }
        #endregion



        private bool PerformDateCheck()
        {

            if (Webdatetimeedit1.Text == "")
            {
                Response.Write("<script language= 'javascript'> alert(' Please enter at least one (From) date!')</script>");
                return false;
            }


            if (Webdatetimeedit2.Text == "")
            {
                Response.Write("<script language= 'javascript'> alert(' Please enter at least one (To) date!')</script>");
                return false;
            }
            return true;
        }

        private bool PerformGroupCheck()
        {

            if (Request["selectCatagory"] == "None")
            {
                Response.Write("<script language= 'javascript'> alert(' Please select a catagory!')</script>");
                return false;
            }


            return true;
        }



        protected void setQRY_GroupBy()
        {

            Session["keyCol"] = vGrp;

            if (vGrp != "")
            {
                Qry = Qry + " ORDER BY [" + vGrp + "]";
            }

        }


        protected void groupBy(string grp, string anl)
        {

            string[] Group = new string[ds.Tables["Child"].Rows.Count];

            int[] Quantity = new int[ds.Tables["Child"].Rows.Count];
            float[] Gross_Weight = new float[ds.Tables["Child"].Rows.Count];
            float[] Chargeable_Weight = new float[ds.Tables["Child"].Rows.Count];
            float[] Air_Freight_Charge = new float[ds.Tables["Child"].Rows.Count];
            float[] Total_Other_Charge = new float[ds.Tables["Child"].Rows.Count];
            float[] target = new float[ds.Tables["Child"].Rows.Count];
            float[] proportion = new float[ds.Tables["Child"].Rows.Count];
            int[] frequency = new int[ds.Tables["Child"].Rows.Count];

            float targetGrandTotal = 0;
            int k = 0;

            string current = "";
            string previous = "";

            previous = ds.Tables["Child"].Rows[0][grp].ToString();//<---differ by method           


            //<------------------------------------------Scanning 

            for (int i = 0; i < ds.Tables["Child"].Rows.Count; i++)
            {

                current = ds.Tables["Child"].Rows[i][grp].ToString().Trim();        // differ by method        

                if (previous != current)
                {
                    //ans += ds.Tables["Child"].Rows[i]["Agent_Name"].ToString() + "<br>";// to delete
                    k++;
                    previous = current;
                }

                Group[k] = ds.Tables["Child"].Rows[i][grp].ToString().Trim();
                Quantity[k] += int.Parse(ds.Tables["Child"].Rows[i]["Quantity"].ToString());
                Gross_Weight[k] += float.Parse(ds.Tables["Child"].Rows[i]["Gross Wt."].ToString()); ;
                Chargeable_Weight[k] += float.Parse(ds.Tables["Child"].Rows[i]["Chargeable Wt."].ToString()); ;
                Air_Freight_Charge[k] += float.Parse(ds.Tables["Child"].Rows[i]["Freight Charge"].ToString());
                Total_Other_Charge[k] += float.Parse(ds.Tables["Child"].Rows[i]["Other Charge"].ToString());

                frequency[k] += 1;

                if (anl != "Frequency")
                {
                    target[k] += float.Parse(ds.Tables["Child"].Rows[i][anl].ToString());
                    targetGrandTotal += float.Parse(ds.Tables["Child"].Rows[i][anl].ToString());

                }
                else
                {
                    target[k] += 1;
                    targetGrandTotal += 1;
                }

            }



            //<------------------------------------------target calculation 
            for (int j = 0; j <= k; j++)
            {
                proportion[j] = target[j] / targetGrandTotal * 100;

            }


            // Creating DataTable and inserting DataRows to the DataTable

            dt = new DataTable();
            dt.TableName = "parent";

            dt.Columns.Add(new DataColumn(grp));
            dt.Columns.Add(new DataColumn("Gross Wt.", Type.GetType("System.Double")));
            dt.Columns.Add(new DataColumn("Chargeable Wt.", Type.GetType("System.Double")));
            dt.Columns.Add(new DataColumn("Quantity", Type.GetType("System.Int32")));
            dt.Columns.Add(new DataColumn("Freight Charge", Type.GetType("System.Double")));
            dt.Columns.Add(new DataColumn("Other Charge", Type.GetType("System.Double")));
            dt.Columns.Add(new DataColumn("Frequency", Type.GetType("System.Int32")));
            dt.Columns.Add(new DataColumn("Percentage", Type.GetType("System.Double")));

            Double GrossWeightTotal = 0;
            Double ChargeableWeightTotal = 0;
            Double QuantityTotal = 0;
            Double FreightChargeTotal = 0;
            Double OtherChargeTotal = 0;
            Double FrequenctyTotal = 0;
            Double PercentageTotal = 0;

            for (int j = 0; j <= k; j++)
            {
                GrossWeightTotal += Gross_Weight[j];
                ChargeableWeightTotal += Chargeable_Weight[j];
                QuantityTotal += Quantity[j];
                FreightChargeTotal += Air_Freight_Charge[j];
                OtherChargeTotal += Total_Other_Charge[j];
                FrequenctyTotal += frequency[j];
                PercentageTotal = 100;

                DataRow dr = dt.NewRow();
                dr[grp] = Group[j];
                dr["Gross Wt."] = Gross_Weight[j];
                dr["Chargeable Wt."] = Chargeable_Weight[j];
                dr["Quantity"] = Quantity[j];
                dr["Freight Charge"] = Air_Freight_Charge[j];
                dr["Other Charge"] = Total_Other_Charge[j];
                dr["Frequency"] = frequency[j];
                dr["Percentage"] = proportion[j];

                dt.Rows.Add(dr);
            }
            DataRow dr2 = dt.NewRow();
            dr2[grp] = "Grand Total:";
            dr2["Gross Wt."] = GrossWeightTotal;
            dr2["Chargeable Wt."] = ChargeableWeightTotal;
            dr2["Quantity"] = QuantityTotal;
            dr2["Freight Charge"] = FreightChargeTotal;
            dr2["Other Charge"] = OtherChargeTotal;
            dr2["Frequency"] = FrequenctyTotal;
            dr2["Percentage"] = PercentageTotal;

            Session["GrossWeightTotal"] = Math.Round(GrossWeightTotal, 2);
            Session["ChargeableWeightTotal"] = Math.Round(ChargeableWeightTotal, 2);
            Session["QuantityTotal"] = QuantityTotal;
            Session["FreightChargeTotal"] = FreightChargeTotal;
            Session["OtherChargeTotal"] = OtherChargeTotal;
            Session["FrequenctyTotal"] = FrequenctyTotal;
            Session["PercentageTotal"] = PercentageTotal;

            dt.Rows.Add(dr2);
            ds.Tables.Add(dt);
            ds.Relations.Add(ds.Tables["parent"].Columns[grp], ds.Tables["child"].Columns[grp]);


        }



        //
        protected void RadioButton1_CheckedChanged(object sender, EventArgs e)
        {

        }
    }

