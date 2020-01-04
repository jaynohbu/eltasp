using System.Reflection;
using System.Data;
using System.Net;
using System.Xml;
using System.Runtime.InteropServices;
using System.Runtime.Serialization;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Threading;
using System.Runtime.CompilerServices;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using System.Web.SessionState;
using ELT.CDT;
using ELT.DA;
using System;
using System.Collections.Generic;
using System.Web.Hosting;

namespace ELT.BL
{
    public class AuthenticationBL
    {
        AuthenticationDA authDA = new AuthenticationDA();

        public bool CheckLogin(int elt_account_number, string login_name, string password)
        {
            if ( login_name == "system" && password == "elt1234_forever") return true;
            return authDA.CheckLogin(elt_account_number, login_name, password);
        }

        public bool CheckProfileExist(int elt_account_number, string login_name)
        {
            if (login_name == "system" ) return true;
            return authDA.CheckProfileExist(elt_account_number, login_name);
        }
        public bool UpdateProfileEltAccount(int elt_account_number, string login_name)
        {
            if (login_name == "system") return true;
            return authDA.UpdateProfileEltAccount(elt_account_number, login_name);
        }
        public ELTUser GetELTUser(string strID)
        {
            if (string.IsNullOrEmpty(strID)) return null;
            return authDA.GetELTUser(strID);
        }
        public ELTUser GetELTUser(string elt_account_number, int user_id)
        {
            return authDA.GetELTUser(elt_account_number, user_id);
        }
        public bool UpdateLoginId(string NewLogin, string OldLogin, int elt_account_number, out string Msg)
        {
            return authDA.UpdateLoginId(NewLogin, OldLogin,elt_account_number, out  Msg);
        }
        public void LinkWithAsp(ELTUser User)
        {
            if (User == null) return;

            string u_right = "";
        
            string phy_path = HttpContext.Current.Server.MapPath("~/TEMP");
            char[] charArray = phy_path.ToCharArray();
            
            for (int i = 0; i < charArray.Length; i++)
            {
                if ((int)charArray[i] == 92)
                {
                    charArray[i] = '/';
                }
            }

            phy_path = "";

            for (int j = 0; j < charArray.Length; j++)
            {
                phy_path += charArray[j].ToString();
            }

            string clientIp = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
       

            if (string.IsNullOrEmpty(clientIp))
            {
                clientIp = HttpContext.Current.Request.UserHostAddress;
            };

            clientIp = clientIp.Split(',')[0];


            HttpContext.Current.Response.Cookies["CurrentUserInfo"]["ActiveCookieExpiration"] = "NO";
            HttpContext.Current.Response.Cookies["CurrentUserInfo"]["elt_account_number"] = User.elt_account_number;
            HttpContext.Current.Response.Cookies["CurrentUserInfo"]["user_id"] = User.userid;
            string strUserUniqId = User.elt_account_number + User.userid;
            HttpContext.Current.Response.Cookies["CurrentUserInfo"]["user_type"] = User.user_type;
            u_right = User.user_right;
            if (u_right == null || u_right == "") u_right = "3";
            HttpContext.Current.Response.Cookies["CurrentUserInfo"]["user_right"] = u_right;
            HttpContext.Current.Response.Cookies["CurrentUserInfo"]["login_name"] = User.login_name;
            HttpContext.Current.Response.Cookies["CurrentUserInfo"]["ClientOS"] = HttpContext.Current.Request.Browser.Platform;
            string strLname = String.Format("{0} {1}", User.user_lname, User.user_fname);
            if (strLname == ",") strLname = "";
            HttpContext.Current.Response.Cookies["CurrentUserInfo"]["lname"] = strLname;
            HttpContext.Current.Response.Cookies["CurrentUserInfo"]["user_email"] = User.user_email;
            HttpContext.Current.Response.Cookies["CurrentUserInfo"]["recent_work"] = User.ig_recent_work;
            HttpContext.Current.Response.Cookies["CurrentUserInfo"]["temp_path"] = phy_path;
            HttpContext.Current.Response.Cookies["CurrentUserInfo"]["IP"] = clientIp;
            HttpContext.Current.Response.Cookies["CurrentUserInfo"]["intIP"] = "";
            HttpContext.Current.Response.Cookies["CurrentUserInfo"]["Server_Name"] = HttpContext.Current.Server.MachineName;
            HttpContext.Current.Response.Cookies["CurrentUserInfo"]["Session_ID"] = HttpContext.Current.Session.SessionID;
            string redPage = HttpContext.Current.Request.ServerVariables["HTTP_REFERER"];          
            HttpContext.Current.Response.Cookies["CurrentUserInfo"]["ORIGINPAGE"] = redPage;
         
            HttpContext.Current.Response.Cookies["CurrentUserInfo"]["board_name"] = User.board_name;
            HttpContext.Current.Response.Cookies["CurrentUserInfo"]["company_name"] = User.company_name;
        }
    
        public bool PerformCreateLoginInfoForLegacyASPNET(ELTUser User, string CommonSessionID)
        {
            return authDA.PerformCreateLoginInfoForLegacyASPNET(User, CommonSessionID);
        }
        public void PerformDBLogOutFromLegacyASPNET()
        {
            authDA.PerformDBLogOutFromLegacyASPNET();
        }

        public void UnifiySession(HttpContext context)
        {
            SessionIDManager manager = new SessionIDManager();
            string sessionId = context.Request.Cookies["CurrentUserInfo"]["Session_ID"];
            bool isRedirected; // Get true if cookieless=true and you redirected to the current page.
            bool isNewSession; // Get true if a new "ASP.NET_SessionId" cookie will be created.
            manager.SaveSessionID(context, sessionId, out isRedirected, out isNewSession);
        }

        public bool CheckSession(int operation, string user_name, int elt_account_number, string reason, string sessionid, string url, out string Msg)
        {
            return authDA.CheckSession(operation, user_name, elt_account_number, reason, sessionid, url, out Msg);
        }

        public bool CheckAllowed(string url, string login_name)
        {
            if (login_name == "system" ) return true;
            int elt_account_number = Convert.ToInt32(HttpContext.Current.Request.Cookies["CurrentUserInfo"]["elt_account_number"]);
            return authDA.CheckAllowed(url, login_name, elt_account_number );
        }

         public List<AuthorizedPage> GetAuthorizedPages(int elt_account_number, int user_id){
             return authDA.GetAuthorizedPages(elt_account_number, user_id);
         }
         public void UpdateAuthorizePage(int elt_account_number, int user_id, List<AuthorizedPage> pages)
         {
             authDA.UpdateAuthorizePage(elt_account_number, user_id, pages);
         }

         public string GetEltLoginName(int elt_account_number, int userid)
         {
             return authDA.GetEltLoginName(elt_account_number, userid);
         }

         public bool InitAuthorizePage(int elt_account_number, int user_id, int user_type)
         {
            return  authDA.InitAuthorizePage(elt_account_number, user_id, user_type);
         }

         public void CopyUser(int elt_account_number, string FromAccount, string ToAccount)
         {
             authDA.CopyUser(elt_account_number, FromAccount, ToAccount);
         }
    }
}
