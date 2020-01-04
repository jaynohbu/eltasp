using System;
using System.Collections;
using System.ComponentModel;
using System.Web;
using System.Web.SessionState;
using System.Configuration;
using System.IO;
using CounterLib;

using System.Data.SqlClient;

namespace IFF_V1 
{
	/// <summary>
	/// Global�� ���� ��� �����Դϴ�.
	/// </summary>
	public class Global : System.Web.HttpApplication
	{
		/// <summary>
		/// �ʼ� �����̳� �����Դϴ�.
		/// </summary>
		private System.ComponentModel.IContainer components = null;
		string countFilePath = @"C:\temp\count.txt";

		public Global()
		{
			InitializeComponent();
		}	
		
		protected void Application_Start(Object sender, EventArgs e)
		{
			Counter c = new Counter(countFilePath);
			if(!c.Exists)
				Application["Count"] = 0;
			else
				Application["Count"] = c.ReadCount();

			Application["CurrentCount"] = 0;
		}

		protected void Application_End(Object sender, EventArgs e)
		{
			Counter c = new Counter(countFilePath);
			c.WriteCount(Application["Count"].ToString());
		}

 
		protected void Session_Start(Object sender, EventArgs e)
		{

			Application["Count"] = (int)Application["Count"] + 1;

			if( (int)Application["Count"] % 10 == 0)
			{
				Counter c = new Counter(countFilePath);
				c.WriteCount(Application["Count"].ToString());
			}

			Application["CurrentCount"] = (int)Application["CurrentCount"] + 1;
		}

		protected void Application_BeginRequest(Object sender, EventArgs e)
		{

		}

		protected void Application_EndRequest(Object sender, EventArgs e)
		{

		}

		protected void Application_AuthenticateRequest(Object sender, EventArgs e)
		{

		}

		protected void Application_Error(Object sender, EventArgs e)
		{

		}

		protected void Session_End(Object sender, EventArgs e)
		{

// delete tmp files			
			string tmpLogDir = Request.Cookies["CurrentUserInfo"]["temp_path"];
			string strSessionID = Session.SessionID.ToString();

			DirectoryInfo dir = new DirectoryInfo(tmpLogDir);
			if(dir.Exists)
			{
				int lastIndex;
				foreach(FileInfo file in dir.GetFiles())
				{
					lastIndex = file.ToString().LastIndexOf(strSessionID);
					if (lastIndex ==0) file.Delete();
				}
			}


//// delete que
            string ConnectStr = (new igFunctions.DB().getConStr());
			SqlConnection Con = new SqlConnection(ConnectStr);
			SqlCommand Cmd = new SqlCommand();
			Cmd.Connection = Con;
			
			Con.Open();
			
//			Cmd.CommandText="delete from ig_org_que where sessionid = '" + strSessionID + "'";
//			Cmd.ExecuteNonQuery();

//			Cmd.CommandText="delete from ig_ocean_ams_que where sessionid = '" + strSessionID + "'";
//			Cmd.ExecuteNonQuery();


            Cmd.CommandText = "Delete view_login where session_id='" + Request.Cookies["CurrentUserInfo"]["Session_ID"].ToString() + "'";
			Cmd.ExecuteNonQuery();

			Con.Close();

            // Cookie delete
            if (Request.Cookies["CurrentUserInfo"] != null)
            {
                Request.Cookies["CurrentUserInfo"].Value = "";
                Request.Cookies["CurrentUserInfo"].Expires = DateTime.Now;
            }


		}

			
		#region Web Form �����̳ʿ��� ������ �ڵ�
		/// <summary>
		/// �����̳� ������ �ʿ��� �޼����Դϴ�.
		/// �� �޼����� ������ �ڵ� ������� �������� ���ʽÿ�.
		/// </summary>
		private void InitializeComponent()
		{    
			this.components = new System.ComponentModel.Container();
		}
		#endregion
	}
}

