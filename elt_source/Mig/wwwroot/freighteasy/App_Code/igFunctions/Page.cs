using System;

namespace igFunctions
{
	/// <summary>
	/// Page Class �� ���� ��� �����Դϴ�.
	/// </summary>
	public class Pager
	{
		protected System.Web.UI.Page mPage;
		protected System.Web.UI.WebControls.Label mlblPage;

		public Pager(System.Web.UI.Page Page, ref System.Web.UI.WebControls.Label lblPage)
		{
			mPage = Page;
			mlblPage = lblPage;
		}

		public void PageNavigationParametter(int CurPage, int PageCount, string Parametter)
		{
			string Path, Prev = "", Next = "", PageStr = "";
			int FromPage, ToPage, i;

			// ��ũ ���ڿ�
			Path = mPage.Request.ServerVariables["PATH_INFO"].ToString() + "?Page=";

			FromPage = (int)((CurPage - 1) / 10) * 10 + 1;

			if (PageCount > FromPage + 9) 
			{
				ToPage = FromPage + 9;
			}
			else 
			{
				ToPage = PageCount;
			}

			// ���� 10�� ǥ��
			if ((int)((CurPage - 1) / 10) > 0) 
			{
				Prev = "<a href='"+Path + (FromPage-1).ToString()+"&"+ Parametter + "'>" 
					+ "<img src='Images/list_prev.gif' border='0' align='absmiddle'></a>";
				
			}
			else 
			{
				Prev = "<img src='Images/list_prev.gif' border='0' align='absmiddle'>";
			}

			// ������ �׺���̼� ǥ��
			for (i = FromPage; i<=ToPage; i++)
			{
				if (i == CurPage) 
				{
					PageStr += "[<b>" + i.ToString() + "</b>]";
				}
				else 
				{
					PageStr += " <a href='" + Path + i.ToString() + "&"+ Parametter +"'>" +"["+ i.ToString() + "]</a>";
				}
			}

			// ���� 10�� ǥ��
			if (ToPage < PageCount) 
			{
				Next = "<a href='"+Path + (ToPage + 1).ToString()+"&"+ Parametter + "'>" 
					+ "<img src='Images/list_next.gif' border='0' align='absmiddle'></a>";
			}
			else 
			{
				Next = "<img src='Images/list_next.gif' border='0' align='absmiddle'>";
			}
			mlblPage.Text = Prev +" "+ PageStr +" "+ Next;
		}
	}
}
