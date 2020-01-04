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



namespace IFF_MAIN.ASPX.Reports.Operation
{
	/// <summary>
	/// AirExportOperationSelection에 대한 요약 설명입니다.
	/// </summary>
	public partial class AirImportOperationSelection : System.Web.UI.Page
	{

		public string elt_account_number;
		public string user_id,login_name,user_right;
		
        protected string ConnectStr;
        public string windowName;
        public bool bReadOnly = false;
        protected string Qry = "";
        protected string vGrp ="";
        protected string vAnl = "";
        protected DataSet ds;
        protected DataTable dt;
       

		protected void Page_Load(object sender, System.EventArgs e)
		{
			Session.LCID = 1033;
            windowName = Request.QueryString["WindowName"];
            elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
			
            user_id  = Request.Cookies["CurrentUserInfo"]["user_id"];
			user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
			
            login_name  = Request.Cookies["CurrentUserInfo"]["login_name"];
			
            ConnectStr = (new igFunctions.DB().getConStr());

            vGrp = Request["GRP"];
           
            vAnl = Request["ANL"];
			
			if(!IsPostBack)
			{
                iBtnGo.Attributes.Add("onclick", "Javascript:return validateDate_Cat();");
				
			}
		}


        protected void iBtnGo_Click(object sender, ImageClickEventArgs e)
        {
           // if (!PerformDateCheck()) return;
           // if (!PerformGroupCheck()) return;
            if(!performSearch())return;
            Session["DSet"] = ds;
         
           // Response.Write(Qry);

            Response.Redirect("OperationResult.aspx?Part=Air-Import&" + "WindowName=" + windowName);

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
					
			daysToAdd = System.DateTime.DaysInMonth(int.Parse(sd.Year.ToString()),int.Parse(sd.Month.ToString())) - int.Parse(sd.Day.ToString());
			firstDate = sd.AddDays(daysToAdd);
			return firstDate.AddDays(1);

		}
		# endregion

		private bool performSearch()
		{
            string QryGrossWeight = "";
            string QryChargeableWeight = "";

            //<>'KG' includes null, air's  scale is normally LB
            if (Request["sltWtScale"] == "KG")
            {
                //Response.Write(Request["sltWtScale"]);
               // Response.End();
                //Response.Write(Request["sltWtScale"]); Response.End();
                QryGrossWeight =" case when (isnull(a.scale1,'LB')<>'KG') then (isnull(a.gross_wt,0)*0.45359237) Else isnull(a.gross_wt,0) End as [Gross Wt.],";
            }
           else 
            {
               // Response.Write(Request["sltWtScale"]);
               // Response.End();

                QryGrossWeight = " case when (isnull(a.scale1,'LB')='KG') then (isnull(a.gross_wt,0)*2.20462262) Else isnull(a.gross_wt,0) End as [Gross Wt.],";
            }

            if (Request["sltWtScale"] == "KG")
            {
                QryChargeableWeight = " case when(isnull(a.scale2,'LB')<>'KG') then (isnull(a.chg_wt,0)*0.45359237) Else isnull(a.chg_wt,0) End as [Chargeable Wt.],";
            }

            else 
            {
                QryChargeableWeight = " case when(isnull(a.scale1,'LB')='KG') then (isnull(a.chg_wt,0)*2.20462262) Else isnull(a.chg_wt,0) End as [Chargeable Wt.],";
            }
           
            //Response.Write(Webdatetimeedit1.Date.ToShortDateString()+" ---   ");
            string timeStart = Webdatetimeedit1.Date.ToShortDateString();
            string timeEnd = Webdatetimeedit2.Date.ToShortDateString();
			
			ConnectStr = (new igFunctions.DB().getConStr());

			SqlConnection Con = new SqlConnection(ConnectStr);


            Qry = @"SELECT 
                isnull(b.File_No,'') as [File#],

                a.MAWB_NUM as [Master], 
                isnull(a.HAWB_NUM,'') as [House], 
                 
                Upper(isnull(a.Shipper_name,'')) as [Shipper], 
                Upper(isnull(a.consignee_name,'')) as [Consignee], 
                Upper(isnull( b.export_agent_name,'') )as[Agent],
                Upper(isnull( b.carrier,'') )as [Carrier],


                Upper(isnull( a.dep_port,'')) as [Origin], 
                Upper(isnull(a.arr_port,'')) as [Destination],

                convert(varchar(10), a.eta , 101) as[Date], 


                Upper(isnull( a.SalesPerson,'')) as [Sales Rep.],
                Upper(isnull(a.CreatedBy,'')) as [Processed By],
                isnull(a.pieces,0) as [Quantity],"
                +QryGrossWeight
                +QryChargeableWeight
                +

                @"isnull(a.freight_collect,0) as [Freight Charge],
                isnull(a.oc_collect,0) as[Other Charge],
                isnull(a.sec,1) as[sec]
                
                from import_hawb a 

                left outer join import_mawb b
                on a.mawb_num=b.mawb_num
                where a.itype='A'and a.elt_account_number = " + elt_account_number +
                " and a.elt_account_number = b.elt_account_number " +
                " AND (CAST(CASE WHEN ISDATE(a.eta)=1 THEN a.eta END AS DATETIME)>=CONVERT(DATETIME,'"
                + timeStart +
                "')AND CAST(CASE WHEN ISDATE(a.eta)=1 THEN a.eta END AS DATETIME)<CONVERT(DATETIME,'"
                + timeEnd + "'))";
               
            
            Session["timeStart"] = timeStart;
            Session["timeEnd"] = timeEnd;

            setQRY_GroupBy();

            SqlCommand cmd = new SqlCommand(Qry);
            cmd.Connection = Con;
			
			SqlDataAdapter Adap = new SqlDataAdapter();
	        ds = new DataSet();

         
           Con.Open();
           Adap.SelectCommand = cmd;

           //Response.Output.Write("------------------" + Qry + "<br>");
           //Response.End();

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
            //Response.Write("----" + Qry);
           // Response.End();
           
        }


        protected void groupBy(string grp, string anl)
        {
           
           
            string[] Group=new string[ds.Tables["Child"].Rows.Count];

            int[] Quantity=new int[ds.Tables["Child"].Rows.Count];
            float[] Gross_Weight=new float[ds.Tables["Child"].Rows.Count];
            float[] Chargeable_Weight=new float[ds.Tables["Child"].Rows.Count];
            float[] Air_Freight_Charge=new float[ds.Tables["Child"].Rows.Count];
            float[] Total_Other_Charge=new float[ds.Tables["Child"].Rows.Count];
            float[] target = new float[ds.Tables["Child"].Rows.Count];
            float[] proportion = new float[ds.Tables["Child"].Rows.Count];
            int[] frequency=new int[ds.Tables["Child"].Rows.Count];
           
            float targetGrandTotal = 0;
            int k = 0;
            string ans="";// temporal 
            string current = "";
            string previous = "";
            
            previous = ds.Tables["Child"].Rows[0][grp].ToString();//<---differ by method           


            //<------------------------------------------Scanning 

            for(int i =0; i<ds.Tables["Child"].Rows.Count;i++){

                current= ds.Tables["Child"].Rows[i][grp].ToString().Trim();        // differ by method        
             
                if (previous != current)
                {
                   // ans += "-----"+ds.Tables["Child"].Rows[i][grp].ToString()+"<br>";// to delete
                   k++;
                   previous=current;
                }

                Group[k]=ds.Tables["Child"].Rows[i][grp].ToString().Trim();
                Quantity[k]+=int.Parse(ds.Tables["Child"].Rows[i]["Quantity"].ToString());
                Gross_Weight[k] += float.Parse(ds.Tables["Child"].Rows[i]["Gross Wt."].ToString()); ;
                Chargeable_Weight[k] += float.Parse(ds.Tables["Child"].Rows[i]["Chargeable Wt."].ToString()); ;
                Air_Freight_Charge[k] += float.Parse(ds.Tables["Child"].Rows[i]["Freight Charge"].ToString());
                Total_Other_Charge[k] += float.Parse(ds.Tables["Child"].Rows[i]["Other Charge"].ToString());
                
                frequency[k]+= 1;
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
            //Response.Output.Write(ans);
            //Response.End();
            string temp = "";

            //<------------------------------------------target calculation 
            for (int j = 0; j <= k; j++)
            {
                proportion[j] = target[j] / targetGrandTotal * 100;
               
            }


            // Creating DataTable and inserting DataRows to the DataTable

            dt = new DataTable();
            dt.TableName = "parent";

            dt.Columns.Add(new DataColumn(grp));
            dt.Columns.Add(new DataColumn("Gross Wt.",Type.GetType("System.Double")));
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

            for (int j = 0; j <=k; j++)
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
            ds.Relations.Add( ds.Tables["parent"].Columns[grp],ds.Tables["child"].Columns[grp]);
           
           
        }



        //
    }
}
