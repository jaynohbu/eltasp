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
using System.Text;

using System.Data.SqlClient;
using System.Configuration;

namespace IFF_MAIN.ASPX.OnLines.CompanyConfig.Schedule
{
	/// <summary>
	/// Summary description for CustomDays.
	/// </summary>
	public class CalinderComment : System.Web.UI.Page
	{
		protected Infragistics.WebUI.WebSchedule.WebCalendar Calendar2;
		protected System.Web.UI.WebControls.Label Label3;
		protected System.Web.UI.WebControls.Label Label2;
		protected System.Web.UI.WebControls.Button AddDay;
		protected System.Web.UI.WebControls.DropDownList YearField;
		protected System.Web.UI.WebControls.DropDownList MonthField;
		protected System.Web.UI.WebControls.DropDownList DayField;
		protected System.Web.UI.WebControls.DropDownList ColorField;
		protected System.Web.UI.WebControls.DropDownList ImageField;
		protected System.Web.UI.WebControls.Label Label1;
		protected System.Web.UI.WebControls.CheckBox NoBell;
		protected System.Web.UI.WebControls.Label Label4;
		protected System.Web.UI.WebControls.Label ShowSelected;

        protected string ConnectStr;

		
		private static string strAccount;
		private static int iPickedAccountNumber;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			ConnectStr = (new igFunctions.DB().getConStr());
			if(!IsPostBack)
			{
				strAccount = Request.QueryString["elt_account_number"];
				if(strAccount == null ) 
				{
//					Response.Write("<script language= 'javascript'> alert('Please use this page through Company configuration.'); </script>");
					Response.Redirect("../CompanyConfig.aspx");
				}

				iPickedAccountNumber = int.Parse(Request.QueryString["iPickedAccountNumber"]);
			}

		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
			this.YearField.SelectedIndex = DateTime.Now.Year - 2000;
			this.MonthField.SelectedIndex = DateTime.Now.Month - 1;
			this.ImageField.SelectedIndex = 3;
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.Calendar2.ValueChanged += new Infragistics.WebUI.WebSchedule.ValueChangedHandler(this.Calendar2_ValueChanged);
			this.AddDay.Click += new System.EventHandler(this.AddDay_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion
		protected override void OnPreRender(EventArgs e)
		{
			base.OnPreRender(e);
			if(this.Page != null)
			{
				CustomDays days = this.GetCustomDays();
				if(days.Count > 0)
					this.Page.RegisterClientScriptBlock("MyDaysData", days.ToString());
				this.Page.RegisterClientScriptBlock("MyDaysFile", "\n\r<script language=\"javascript\" src=\"customDays.js\"></script>\n\r");
			}
		}
		private CustomDays GetCustomDays()
		{
			CustomDays days = Session["customDays"] as CustomDays;
			if(days == null)
				days = this.CreateCustomDays();
			return days;
		}
		private CustomDays CreateCustomDays()
		{
			CustomDays days = new CustomDays();

			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand Cmd = new SqlCommand();
			Cmd.Connection = Con;

			Con.Open();
			Cmd.CommandText="select * from ig_org_comments where elt_account_number = " + strAccount + " and org_account_number = " + iPickedAccountNumber.ToString();
			SqlDataReader reader = Cmd.ExecuteReader();

			if(reader.Read())
			{
					
			}
			else
			{
					
			}

			reader.Close();
			Con.Close();

//			days.AddDay(DateTime.Now, null, "./images/dollarsign.gif");
//			days.AddDay(DateTime.Now.AddDays(2), "#F0C000", "./images/bell.gif");
//			days.AddDay(DateTime.Now.AddDays(8), null, "./images/bell.gif");
//			days.AddDay(DateTime.Now.AddDays(3), "Pink", null);
//			days.AddDay(DateTime.Now.AddDays(5), "#C0D0C0", null);
//			days.AddDay(DateTime.Now.AddDays(-2), null, "./images/folderopen.gif");
//			days.AddDay(DateTime.Now.AddDays(-3), null, "./images/telephone.gif");
//			days.AddDay(DateTime.Now.AddDays(-9), "yellow", "./images/telephone.gif");
//			days.AddDay(DateTime.Now.AddDays(10), null, "./images/cal.gif");
//			days.AddDay(DateTime.Now.AddDays(20), null, "./images/img1.gif");
//			days.AddDay(DateTime.Now.AddDays(30), "#C0C0A0", "./images/img2.gif");
//			days.AddDay(DateTime.Now.AddDays(7), "#F0A0D0", "./images/basketball.gif");
//			days.AddDay(-1, -1, 1, null, "./images/reoccur.gif");
//			days.AddDay(DateTime.Now.AddDays(15), null, "./images/chevy.gif");
//			days.AddDay(-1, 7, 4, "#A0A0FF", "./images/flag.gif");
			
			
			
			Session["customDays"] = days;
			return days;
		}

		private void AddDay_Click(object sender, System.EventArgs e)
		{
			string back = null, url = null;
			if(this.ImageField.SelectedIndex > 0)
				url = "./images/" + this.ImageField.SelectedItem.Value ;
			if(this.ColorField.SelectedIndex > 0)
				back = this.ColorField.SelectedItem.Value;
			this.GetCustomDays().AddDay(new DateTime(2000 + this.YearField.SelectedIndex, this.MonthField.SelectedIndex + 1, this.DayField.SelectedIndex + 1), back, url);
		}

		private void Calendar2_ValueChanged(object sender, Infragistics.WebUI.WebSchedule.ValueChangedEventArgs e)
		{
//			int i=0;
		}
	}
	public class CustomDay
	{
		public int year = 0;
		public int month = 0;
		public int day = 0;
		public string url = "";
		public string back = "";
		//
		public CustomDay(int year, int month, int day, string back, string url)
		{
			this.year = year;
			this.month = month;
			this.day = day;
			this.url = (url == null) ? string.Empty : url;
			this.back = (back == null) ? string.Empty : back;
		}
	}
	public class CustomDays : ArrayList
	{
		public void AddDay(DateTime date, string back, string url)
		{
			this.AddDay(date.Year, date.Month, date.Day, back, url);
		}
		public void AddDay(int year, int month, int day, string back, string url)
		{
			int days = this.Count;
			CustomDay d = null;
			while(days-- > 0)
			{
				d = this[days] as CustomDay;
				if(year == d.year && month == d.month && day == d.day)
					break;
			}
			if(days >= 0)
			{
				if((back == null || back.Length == 0) && (url == null || url.Length == 0))
					this.Remove(d);
				else
				{
					d.back = (back == null) ? string.Empty : back;
					d.url = (url == null) ? string.Empty : url;
				}
			}
			else if((back != null && back.Length > 0) || (url != null && url.Length > 0))
				this.Add(new CustomDay(year, month, day, back, url));
		}
		public override string ToString()
		{
			StringBuilder str = new StringBuilder("<script language=\"javascript\">\n");
			str.Append("var customDays = [");
			bool first = true;
			foreach(CustomDay day in this)
			{
				if(first) first = false;
				else str.Append(",\n");
				str.Append("[").Append(day.year).Append(",").Append(day.month).Append(",").Append(day.day).Append(",\"");
				str.Append(day.back).Append("\",\"").Append(day.url).Append("\"]");
			}
			str.Append("];\n");
			str.Append("</script>");
			return str.ToString();
		}
	}
}
