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

namespace IFF_MAIN.ASPX.Reports.Common
{
	/// <summary>
	/// DownLoadXSD�� ���� ��� �����Դϴ�.
	/// </summary>
	public partial class DownLoadXSD : System.Web.UI.Page
	{
		protected void Page_Load(object sender, System.EventArgs e)
		{
			string c_strFilePathXSD = Request.QueryString["FilePath"];
			string c_strFileNameXSD = System.IO.Path.GetFileName(c_strFilePathXSD);

			Response.Clear();
			Response.ContentType = "Application/XSD";
			Response.AddHeader("Content-Disposition", "attachment;filename=" + c_strFileNameXSD);
			Response.WriteFile(c_strFilePathXSD);
			Response.End();				
		}

		#region Web Form �����̳ʿ��� ������ �ڵ�
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
