namespace IFF_MAIN.ASPX.Reports.SelectionControls
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;

	/// <summary>
	///		rdSelectDateControl1�� ���� ��� �����Դϴ�.
	/// </summary>
    public partial class rdSelectDateControl0 : System.Web.UI.UserControl
    {

        protected void Page_Load(object sender, System.EventArgs e)
        {
            // ���⿡ ����� �ڵ带 ��ġ�Ͽ� �������� �ʱ�ȭ�մϴ�.
            if (!IsPostBack)
            {
                this.rdDateSet1.Attributes.Add("onchange", "Javascript:myRadioButtonforDateSet1CheckDate(this);");
            }
        }



        protected void period_change_back(object sender, EventArgs e)
        {
            rdDateSet1.SelectedIndex = 0;
        
        }

    }
}
