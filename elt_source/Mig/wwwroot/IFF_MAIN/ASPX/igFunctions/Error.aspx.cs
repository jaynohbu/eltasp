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

namespace igFunctions
{
	/// <summary>
	/// Error�� ���� ��� �����Դϴ�.
	/// </summary>
	/// 
	

	public partial class Error : System.Web.UI.Page
	{
		

		protected void Page_Load(object sender, System.EventArgs e)
		{
			lblError.Text = Request.Params["ErrorMsg"];
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: �� ȣ���� ASP.NET Web Form �����̳ʿ� �ʿ��մϴ�.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// �����̳� ������ �ʿ��� �޼����Դϴ�.
		/// �� �޼����� ������ �ڵ� ������� �������� ���ʽÿ�.
		/// </summary>
		private void InitializeComponent()
		{    

		}
		#endregion
	}
}
