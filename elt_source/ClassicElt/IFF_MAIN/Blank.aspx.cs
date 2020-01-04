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
using System.Web.Security;

namespace IFF_MAIN
{
	/// <summary>
	/// Blank�� ���� ��� �����Դϴ�.
	/// </summary>
	public partial class Blank : System.Web.UI.Page
	{
		protected void Page_Load(object sender, System.EventArgs e)
		{
			if(!User.Identity.IsAuthenticated) 
			{
				if( Request.Cookies["CurrentUserInfo"] != null )
				{
					Request.Cookies["CurrentUserInfo"].Value ="";
					Request.Cookies["CurrentUserInfo"].Expires  =DateTime.Now;
				}									
				Response.Redirect("Main.aspx");
			}
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
