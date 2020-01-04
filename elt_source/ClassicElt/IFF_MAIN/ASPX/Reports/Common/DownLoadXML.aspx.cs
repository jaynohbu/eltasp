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
	/// DownLoadXML�� ���� ��� �����Դϴ�.
	/// </summary>
	public partial class DownLoadXML : System.Web.UI.Page
	{
		protected void Page_Load(object sender, System.EventArgs e)
		{
			string c_strFilePathXML = Request.QueryString["FilePath"];
			string c_strFileNameXML = System.IO.Path.GetFileName(c_strFilePathXML);

			Response.Clear();
			Response.ContentType = "Application/XML";
			Response.AddHeader("Content-Disposition", "attachment;filename=" + c_strFileNameXML);
			Response.WriteFile(c_strFilePathXML);
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
