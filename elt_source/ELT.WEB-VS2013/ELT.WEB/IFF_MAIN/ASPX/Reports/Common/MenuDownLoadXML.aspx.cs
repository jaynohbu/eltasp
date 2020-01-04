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
	/// BookingReportXML Ŭ������ ���� ��༳��
	/// </summary>
	public partial class MenuDownLoadXML : System.Web.UI.Page
	{

		private static string c_strFilePathXSD;
		private static string c_strFilePathXML;
		private static string c_strFilePathXSDXML;

		private static string c_strFileNameXSD;
		private static string c_strFileNameXML;
		private static string c_strFileNameXSDXML;


		protected void Page_Load(object sender, System.EventArgs e)
		{

			if(!this.IsPostBack)
			{		
				TableRow tr;
				TableCell td;
				System.Web.UI.WebControls.Image img;
				System.Web.UI.WebControls.Label txt;

				HyperLink link;

				c_strFilePathXSD = Request.QueryString["c_strFilePathXSD"];
				c_strFilePathXML = Request.QueryString["c_strFilePathXML"];
				c_strFilePathXSDXML = Request.QueryString["c_strFilePathXSDXML"];

//				c_strFileNameXSD = System.IO.Path.GetFileName(c_strFilePathXSD);
//				c_strFileNameXML = System.IO.Path.GetFileName(c_strFilePathXML);
//				c_strFileNameXSDXML = System.IO.Path.GetFileName(c_strFilePathXSDXML);
	
				c_strFileNameXSD = "Data Schema file Only. <- click";
				c_strFileNameXML = "XML Data Only. <- click";
				c_strFileNameXSDXML = "All in One file. <- click";

				tr= new TableRow();
				tr.BackColor = Color.Yellow;

				td= new TableCell();
				td.Text = "XML File Name & Data Schema";
				td.HorizontalAlign = HorizontalAlign.Center;
				td.Width = Unit.Pixel(300);
				tr.Cells.Add(td);
				Table1.Rows.Add(tr);

/// All in one		
				tr= new TableRow();
				tr.BackColor = Color.White;

				td= new TableCell();

				txt = new System.Web.UI.WebControls.Label();
				txt.Text = "* ";

				link = new HyperLink();
				link.NavigateUrl = "DownLoadXML.aspx?FilePath=" + c_strFilePathXSDXML;
				link.Text = c_strFileNameXSDXML;

				td.Controls.Add(txt);
				td.Controls.Add(link);
				tr.Cells.Add(td);
				Table1.Rows.Add(tr);

/// XML		
				tr= new TableRow();
				tr.BackColor = Color.White;

				td= new TableCell();

				img = new System.Web.UI.WebControls.Image();
				img.ImageUrl = "../../../images/xml.gif";
				img.ImageAlign = ImageAlign.AbsMiddle;

				link = new HyperLink();
				link.NavigateUrl = "DownLoadXML.aspx?FilePath=" + c_strFilePathXML;
				link.Text = c_strFileNameXML;

				td.Controls.Add(img);
				td.Controls.Add(link);
				tr.Cells.Add(td);
				Table1.Rows.Add(tr);

/// XSD
				tr= new TableRow();
				tr.BackColor = Color.White;

				td= new TableCell();

				img = new System.Web.UI.WebControls.Image();
				img.ImageUrl = "../../../images/xsd.gif";
				img.ImageAlign = ImageAlign.AbsMiddle;

				link = new HyperLink();
				link.NavigateUrl = "DownLoadXSD.aspx?FilePath=" + c_strFilePathXSD;
				link.Text = c_strFileNameXSD;

				td.Controls.Add(img);
				td.Controls.Add(link);
				tr.Cells.Add(td);
				Table1.Rows.Add(tr);
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

		protected void Button1_Click(object sender, System.EventArgs e)
		{
			OnClose();
		}
		private void OnClose()
		{
			System.Text.StringBuilder sb = new System.Text.StringBuilder();		
			sb.Append("<script language='javascript'>"
				+ "window.close();"
				+ "</script>");
			this.ClientScript.RegisterStartupScript(this.GetType(), "Close", sb.ToString());
		}

	}
}
