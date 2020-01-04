using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;

namespace igFunctions
{
	/// <summary>
	/// DB에 대한 요약 설명입니다.
	/// </summary>
	public class DB
	{
		private int mCount = 0;
		private SqlConnection mDbConn = null;
		private SqlCommand	  mCmd = null;
		private SqlDataReader mReader = null;
		StringBuilder sb = new StringBuilder();

		/* DataBase Connection Open */
		public void DbConn()
		{
           
			try
			{
				mDbConn = new SqlConnection(GetDSN);
				mDbConn.Open();
			}
			catch (Exception e)
			{
				DbErrorMsg(e.Source, e.Message, e.StackTrace, "DataBase Open fail");
			}
		}

        public void DbConnELT(string strServer, string strPort)
		{
			try
			{
                mDbConn = new SqlConnection(getLocalCon(strServer, strPort));
				mDbConn.Open();
			}
			catch (Exception e)
			{
				DbErrorMsg(e.Source, e.Message, e.StackTrace, "DataBase Open fail");
			}
		}

        public string getConStr()
        {
            string strServer = System.Web.HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToLower();
            string strPort = System.Web.HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToLower();
            string conStr = getLocalCon(strServer, strPort);
            return conStr;
        }

        public bool AUTH_CHECK(string strEltAcct,string strUserId, string strConn, string strURL, string strQuery)
        {
            bool rValue = false;

            string user_right = System.Web.HttpContext.Current.Request.Cookies["CurrentUserInfo"]["user_right"];
			string login_name  = System.Web.HttpContext.Current.Request.Cookies["CurrentUserInfo"]["login_name"];
            string strcurPageName = PerformGetWorkName(strURL);
            if (strQuery != "")
            {
                strcurPageName += "?parm=" + strQuery;
            }

            if (login_name != "admin" && user_right != "9")
            {
				string redPage = System.Web.HttpContext.Current.Request.Cookies["CurrentUserInfo"]["ORIGINPAGE"];
                # region
                if (strEltAcct == null)
                {
                    string script = "<script language='javascript'>";
                    script += "alert(Authorization Failed');";
                    script += "self.close();";
					if (redPage.Trim()!="")
					{
                    script += "top.location.replace('"+ redPage +"');";
					}
					else
					{
                        script += "top.location.replace('/EXP_MAIN/Default.aspx');";
					}
                    script += "</script>";
                    System.Web.HttpContext.Current.Response.Write(script);
                    System.Web.HttpContext.Current.Response.End();
                }


                string Query = "SELECT a.Authority_Id,b.Name, b.PhysicalPage FROM SE_User_Authority a, SE_Pages b WHERE a.Page_Id=b.Page_Id AND a.elt_account_number=" +
                                strEltAcct + " AND UserID=" + strUserId + " AND b.PhysicalPage like '%" + strcurPageName + "'";

                mDbConn = new SqlConnection(strConn);
                mDbConn.Open();
                mCmd = new SqlCommand(Query, mDbConn);
                mReader = mCmd.ExecuteReader();
                if (mReader.Read())
                {
                    string aType = mReader["Authority_Id"].ToString();
                    if (aType == "1")
                    {
                        rValue = true;
                    }
                }
                else
                {
                    mReader.Close();
                    mCmd.CommandText = "SELECT PhysicalPage FROM SE_Pages WHERE PhysicalPage like '%" + strcurPageName + "'";
                    mReader = mCmd.ExecuteReader();
                    
                    if (!mReader.Read())
                    {
                        rValue = false;
                    }
                    else
                    {
                        /*
                        string script = "<script language='javascript'>";
                        script += "alert('" + "You don`t have the privilege to access this page!" + "');";
                        script += "</script>";
                        System.Web.HttpContext.Current.Response.Write(script);
                        */
                    }
                }

                mReader.Close();
#endregion
            }
            else
            {
                rValue = true;
                mDbConn = new SqlConnection(strConn);
                mDbConn.Open();
                mCmd = new SqlCommand("", mDbConn);
            }

//////////////////////////////////////////////// view_login check

            string elt_user_id = strEltAcct + System.Web.HttpContext.Current.Request.Cookies["CurrentUserInfo"]["user_id"];
            string Query_login = "SELECT * FROM view_login where elt_account_number=" + strEltAcct + " AND ip='" + System.Web.HttpContext.Current.Request.Cookies["CurrentUserInfo"]["IP"].ToString() + "'" + " AND server_name='" + System.Web.HttpContext.Current.Request.Cookies["CurrentUserInfo"]["Server_Name"].ToString() + "'";
            mCmd.CommandText = Query_login;
            mReader = mCmd.ExecuteReader();
            if (mReader.Read())
            {
                mReader.Close();
                Query_login = "SELECT * FROM view_login where elt_account_number=" + strEltAcct + " AND user_id='" + elt_user_id + "'";
                mCmd.CommandText = Query_login;
                mReader = mCmd.ExecuteReader();
                if (!mReader.Read())
                {
                    mReader.Close();
                    string script = "<script language='javascript'>";
                    script += "alert('You can`t use different user ID in one Session.');";
                    script += "self.close();";
                    script += "top.location.replace('/EXP_MAIN/Default.aspx');";
                    script += "</script>";
                    System.Web.HttpContext.Current.Response.Write(script);
                    System.Web.HttpContext.Current.Response.End();
                }
                else
                {
                    mReader.Close();
                    Query_login = "Update view_login Set alive = 1, u_time='" + System.DateTime.Now.ToString() + "',requested_page='"+strcurPageName+"' where elt_account_number=" + strEltAcct  + " AND ip='" + System.Web.HttpContext.Current.Request.Cookies["CurrentUserInfo"]["IP"].ToString()  + "'";
                    mCmd.CommandText = Query_login;
                    mCmd.ExecuteNonQuery();
                }

            }
            else
            {
                mReader.Close();
                Query_login = "SELECT * FROM view_login where elt_account_number=" + strEltAcct + " AND user_id='" + elt_user_id + "'";
                mCmd.CommandText = Query_login;
                mReader = mCmd.ExecuteReader();
				string redPage = System.Web.HttpContext.Current.Request.Cookies["CurrentUserInfo"]["ORIGINPAGE"];
                if (!mReader.Read())
                {

                    string script = "<script language='javascript'>";
                    script += "alert('Your session was expired or disconnected! Error Code - 0004');";
                    script += "self.close();";
                    if (redPage.Trim() != "")
					{
                    script += "top.location.replace('"+ redPage +"');";
					}
					else
					{
                        script += "top.location.replace('/EXP_MAIN/Default.aspx');";
					}
                    script += "</script>";
                    System.Web.HttpContext.Current.Response.Write(script);
                }
                else
                {
                    string another_user = "";
                    string another_ip = "";
                    another_user = mReader["server_name"].ToString();
                    another_ip = mReader["intIP"].ToString();
                    string script = "<script language='javascript'>";
                    script += "alert('Your session was disconnected by another computer! Error Code - 0005\\n ('+'" + another_user + ":" + another_ip + "' +')' );";
                    script += "self.close();";
                    if (redPage.Trim() != "")
					{
                    script += "top.location.replace('"+ redPage +"');";
					}
					else
					{
                        script += "top.location.replace('/EXP_MAIN/Default.aspx');";
					}
                    script += "</script>";
                    System.Web.HttpContext.Current.Response.Write(script);
                }
                System.Web.HttpContext.Current.Response.End();
            }
////////////////////////////////////////////////

            mReader.Close();
            mDbConn.Close();

            return rValue;
        }

        private string PerformGetWorkName(string Url)
        {
            if (Url == null) return Url;

            int lastSlashIndex = Url.LastIndexOf("/");

            if (lastSlashIndex <= 0) return Url;

            string parentVirPath = Url.Substring(0, lastSlashIndex);

            string strUrl1 = PerformValidName(Url);
            string strUrl2 = PerformValidName(parentVirPath);
            string tmpStr = strUrl2 + "/" + strUrl1;
            return tmpStr;

        }


        private string PerformValidName(string Url)
        {
            int lastSlashIndex = Url.LastIndexOf("/");
            if (lastSlashIndex < 0) return Url;

            string parentVirPath = Url.Substring(0, lastSlashIndex);
            string strUrl = Url.Substring(lastSlashIndex + 1);

            return strUrl;
        }

        protected string getLocalCon(string cServerName, string cServerPort)
        { 
        return "server=.;database=DEVDB;user id=sa; password=njy*8824";

            switch (cServerName)
            {
                case "elt":
                    if (cServerPort == "80")
                    {
                        return "server=.;database=CORNERSTONE;user id=sa; password=";
                    }
                    else
                    {
                        return "server=.;database=DEVDB;user id=sa; password=";
                    }

                case "www.freighteasy.net":
                    if (cServerPort == "80")
                    {
                        return "server=.;database=PRDDB;user id=sa; password=dpV8XXVK";
                    }
                    else
                    {
                        return "server=.;database=TSTDB;user id=sa; password=dpV8XXVK";
                    }
                case "freighteasy.net":
                    if (cServerPort == "80")
                    {
                        return "server=.;database=PRDDB;user id=sa; password=dpV8XXVK";
                    }
                    else
                    {
                        return "server=.;database=TSTDB;user id=sa; password=dpV8XXVK";
                    }

                case "www.e-logitech.net":
                    if (cServerPort == "80")
                    {
                        return "server=.;database=PRDDB;user id=sa; password=dpV8XXVK";
                    }
                    else
                    {
                        return "server=.;database=TSTDB;user id=sa; password=dpV8XXVK";
                    }

                case "e-logitech.net":
                    if (cServerPort == "80")
                    {
                        return "server=.;database=PRDDB;user id=sa; password=dpV8XXVK";
                    }
                    else
                    {
                        return "server=.;database=TSTDB;user id=sa; password=dpV8XXVK";
                    }
                // KAS AMERICA
                case "210.245.110.69":
                    return "server=NN1994;database=PRDDB;user id=sa; password=dpV8XXVK";
                case "192.168.0.100":
                    return "server=NN1994;database=PRDDB;user id=sa; password=dpV8XXVK";
                case "192.168.1.114":
                    return "server=NN1994;database=PRDDB;user id=sa; password=dpV8XXVK";
                case "s-app01":
                    return "server=NN1994;database=PRDDB;user id=sa; password=dpV8XXVK";
                case "www.kasamerica.vn":
                    return "server=NN1994;database=PRDDB;user id=sa; password=dpV8XXVK";
                case "kasamerica.vn":
                    return "server=NN1994;database=PRDDB;user id=sa; password=dpV8XXVK";
                case "www.elogisticstechnology.com":
                    if (cServerPort == "80")
                    {
                        return "server=.;database=PRDDB;user id=sa; password=dpV8XXVK";
                    }
                    else
                    {
                        return "server=.;database=TSTDB;user id=sa; password=dpV8XXVK";
                    }

                case "elogisticstechnology.com":
                    if (cServerPort == "80")
                    {
                        return "server=.;database=PRDDB;user id=sa; password=dpV8XXVK";
                    }
                    else
                    {
                        return "server=.;database=TSTDB;user id=sa; password=dpV8XXVK";
                    }

                case "w-dev-jp01":
                    if (cServerPort == "8070" || cServerPort == "8080")
                    {
                        return "server=NN1994;database=TSTDB;user id=sa; password=dpV8XXVK";
                    }
                    else
                    {
                        return "server=.;database=DevDb;user id=sa; password=";
                    }

                default:
                    return "server=.;database=DEVDB; user id=sa; password=";
            }
        }

		protected string strELTConn
		{
			get
			{
                return "server=.;database=DEVDB;user id=sa; password=";
			}
		}

		protected string GetDSN
		{
			get
			{
				return System.Configuration.ConfigurationManager.AppSettings["BoardDSN"];
			}
		}


		/* DataBase Connection Close */
		public void DbClose()
		{	
			if (mDbConn == null) 
			{
				return;
			}

			try 
			{
				if (mDbConn.State.ToString() == "Open") 
				{
					mDbConn.Close();
				}
			}
			catch (Exception e)
			{
				DbErrorMsg(e.Source, e.Message, e.StackTrace, "DataBase Close 실패");
			}
		}

		/* DataBase Transaction Init */
		public void InitTransaction( string TransName )
		{
			try 
			{
				mCmd = new SqlCommand();
				mCmd.Connection = mDbConn;
				mCmd.Transaction = mDbConn.BeginTransaction(IsolationLevel.ReadCommitted, TransName);
			} 
			catch (Exception e) 
			{
				DbErrorMsg(e.Source, e.Message, e.StackTrace, "Trancsaction Open Error");
			}
		}

		/* Transaction Execute Query */
		public void ExecuteTransaction(string[] QueryArr) 
		{
			try
			{
				foreach (string Query in QueryArr) 
				{
					mCmd.CommandText = Query;
					mCmd.ExecuteNonQuery();
				}
				mCmd.Transaction.Commit();

			}
			catch (Exception e)
			{
				mCmd.Transaction.Rollback();
				DbErrorMsg(e.Source, e.Message, e.StackTrace, "Trancsaction Commit 실패");
			}
		}


		/* Query Execute */
		public void ExecuteQuery(string Query) 
		{
			try
			{
				mCmd = new SqlCommand (Query, mDbConn);
				mCmd.ExecuteNonQuery();
			}
			catch (Exception e)
			{
				DbErrorMsg(e.Source,e.Message,e.StackTrace, Query);
			}
		}

		/* SQL DataReader Fatech Query */
		public SqlDataReader FatechQuery(string Query)
		{	
			try
			{
				mCmd = new SqlCommand (Query, mDbConn);
				mReader = mCmd.ExecuteReader();
			}
			catch (Exception e)
			{
				DbErrorMsg(e.Source,e.Message,e.StackTrace, Query);
			}
			return mReader;
		}

		/* SQL DataReader Close */
		public void ReaderClose()
		{
			try 
			{
				if (!mReader.IsClosed) 
				{
					mReader.Close();
				}
			}
			catch (Exception e)
			{
				DbErrorMsg(e.Source, e.Message, e.StackTrace, "SQLReader Close 실패");
			}
		}

		/* Procedure Execute */
		public int ExecuteProc(string ProcName, IDataParameter[] parameters)
		{
			int Result = 0;
			try 
			{
				SqlCommand Cmd = BuildIntCommand( ProcName, parameters );
				Cmd.ExecuteNonQuery();
				Result = (int)Cmd.Parameters["ReturnValue"].Value;
			} 
			catch (Exception e) 
			{
				DbErrorMsg(e.Source, e.Message, e.StackTrace, "Procedure ExecuteProc Error");	
			}
			return Result;
		}
		
		/* SQL DataReader Fatech Procedure */
		public SqlDataReader FatechProc(string ProcName, IDataParameter[] parameters )
		{
			SqlCommand Cmd = BuildProcCommand( ProcName, parameters );
			try 
			{
				Cmd.CommandType = CommandType.StoredProcedure;
				mReader = Cmd.ExecuteReader();
			} 
			catch (Exception e) 
			{
				DbErrorMsg(e.Source, e.Message, e.StackTrace, "Procedure FatechProc Error");
			}
			return mReader;
		}

		/* Execute Query DateSet */
		public DataSet ExecuteDataSet(string Query, string TableName, int StartRecord, int PageSize) 
		{
			DataSet mDataSet = new DataSet();
			try 
			{
				SqlDataAdapter mDataAdapter = new SqlDataAdapter(Query,  mDbConn);
				mDataAdapter.Fill(mDataSet, StartRecord, PageSize, TableName);
			} 
			catch (Exception e) 
			{
				DbErrorMsg(e.Source, e.Message, e.StackTrace, Query);
			}
			
			return mDataSet;
		}

        public DataSet igExecuteDataSet(string Query, string TableName, DataSet mDataSet)
        {
            try
            {
                SqlDataAdapter mDataAdapter = new SqlDataAdapter(Query, mDbConn);
                mDataAdapter.Fill(mDataSet,TableName);
            }
            catch (Exception e)
            {
                DbErrorMsg(e.Source, e.Message, e.StackTrace, Query);
            }

            return mDataSet;
        }
		
		/* Execute Procedure DateSet */
		public DataSet ExecuteProcDataSet(string ProcName, IDataParameter[] parameters, string TableName, int StartRecord, int PageSize)
		{
			DataSet mDataSet = new DataSet();
			SqlDataAdapter mDataAdapter = new SqlDataAdapter();

			mDataAdapter.SelectCommand = BuildProcCommand( ProcName, parameters );
			try 
			{
				mDataAdapter.Fill(mDataSet, StartRecord, PageSize, TableName);
			} 
			catch (Exception e) 
			{
				DbErrorMsg(e.Source, e.Message, e.StackTrace, "Procedure ExecuteProcDataSet Error");
			}

			return mDataSet;
		}

		/* Total Count Function */
		public int TotalQuery(string Query) 
		{
			try
			{
				mCmd = new SqlCommand (Query, mDbConn);
				mCount = (int)mCmd.ExecuteScalar();
			}
			catch (Exception e)
			{
				DbErrorMsg(e.Source, e.Message, e.StackTrace, Query);
			}
			return mCount;	
		}

		/* Procedure BuildIntCommand */
		protected SqlCommand BuildIntCommand(string ProcName, IDataParameter[] parameters)
		{
			SqlCommand Cmd = BuildProcCommand( ProcName, parameters );			
	
			try 
			{
				Cmd.Parameters.Add( new SqlParameter ( "ReturnValue",
					SqlDbType.Int,
					4, /* Size */
					ParameterDirection.ReturnValue,
					false, /* is nullable */
					0, /* byte precision */
					0, /* byte scale */
					string.Empty,
					DataRowVersion.Default,
					null ));
			} 
			catch (Exception e) 
			{
				DbErrorMsg(e.Source, e.Message, e.StackTrace, "Procedure BuildIntCommand Error");
			}

			return Cmd;
		}

		/* Procedure Parameter Build */
		protected SqlCommand BuildProcCommand(string ProcName, IDataParameter[] parameters)
		{
			try 
			{
				mCmd = new SqlCommand (ProcName, mDbConn);
				mCmd.CommandType = CommandType.StoredProcedure;

				foreach (SqlParameter parameter in parameters)
				{
					mCmd.Parameters.Add( parameter );
				}
			}
			catch (Exception e)
			{
				DbErrorMsg(e.Source, e.Message, e.StackTrace, "Procedure BuildProcCommand Error");
			}

			return mCmd;
		}

		/* Error Message Print */
		public void DbErrorMsg(string ErrSource, string ErrMsg, string stack, string Query)
		{ 
			DbClose();
			string ErrorMsg = "Error Souce =" + ErrSource + "<br>"
				+ "Error Message = <font color='red'><b>" +  ErrMsg + "</b></font><br>"
				+ "Stack = " + stack + "<br><br>"
				+ "Query = <font color='blue'><b>" + Query + "</b></font>";
			System.Web.HttpContext.Current.Response.Write(ErrorMsg);
			System.Web.HttpContext.Current.Response.End();
		}

	}
}
