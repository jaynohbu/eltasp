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
	/// DownLoadXSD에 대한 요약 설명입니다.
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
		}
		#endregion
	}
}
