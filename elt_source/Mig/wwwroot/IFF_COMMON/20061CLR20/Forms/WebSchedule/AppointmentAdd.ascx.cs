namespace Forms
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;

	/// <summary>
	///		Summary description for Appointment1.
	/// </summary>
	public partial class AppointmentAddUC : System.Web.UI.UserControl
	{

//		protected System.Web.UI.WebControls.DropDownList ddReminder;
		protected System.Web.UI.WebControls.Label labelEndTime;
		protected Forms.ComboBox combobox1;
		protected Forms.ComboBox Combobox2;

		protected void Page_Load(object sender, System.EventArgs e)
		{
			this.wdcStartTime.Attributes.CssStyle["height"]=" ";
			this.wdcStartTime.EditStyle.CustomRules="height:;";
			this.wdcEndTime.Attributes.CssStyle["height"]=" ";
			this.wdcEndTime.EditStyle.CustomRules="height:;";
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{

		}
		#endregion
	}
}
