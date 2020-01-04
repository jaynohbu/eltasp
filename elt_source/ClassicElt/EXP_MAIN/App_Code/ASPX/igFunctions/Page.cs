using System;

namespace igFunctions
{
	/// <summary>
	/// Page Class 에 대한 요약 설명입니다.
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

			// 링크 문자열
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

			// 이전 10개 표시
			if ((int)((CurPage - 1) / 10) > 0) 
			{
				Prev = "<a href='"+Path + (FromPage-1).ToString()+"&"+ Parametter + "'>" 
					+ "<img src='Images/list_prev.gif' border='0' align='absmiddle'></a>";
				
			}
			else 
			{
				Prev = "<img src='Images/list_prev.gif' border='0' align='absmiddle'>";
			}

			// 페이지 네비게이션 표시
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

			// 다음 10개 표시
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
