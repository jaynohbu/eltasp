namespace IFF_MAIN.ASPX.Reports.SelectionControls
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;

	/// <summary>
	///		rdSelectDateControl3�� ���� ��� �����Դϴ�.
	/// </summary>
	public partial class rdSelectDateControl3 : System.Web.UI.UserControl
	{

		protected void Page_Load(object sender, System.EventArgs e)
		{
			// ���⿡ ����� �ڵ带 ��ġ�Ͽ� �������� �ʱ�ȭ�մϴ�.
			if(!IsPostBack)
			{
				this.rdDateSet3.Attributes.Add("onchange","Javascript:myRadioButtonforDateSet3CheckDate(this);");
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
		///		�����̳� ������ �ʿ��� �޼����Դϴ�. �� �޼����� ������
		///		�ڵ� ������� �������� ���ʽÿ�.
		/// </summary>
		private void InitializeComponent()
		{

		}
		#endregion
	}
}
