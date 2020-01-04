using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Reflection;
using ELT.COMMON;
using ELT.CDT;

namespace ELT.DA
{
    public class TabsDA:DABase
    {
        public List<TabItem> GetAllFavoriteTabItem(string elt_account_number, string userid)
        {
          
            SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Cmd.CommandText = "select page_label, page_url, top_module, sub_module  from tab_master where page_status='A' and page_label<>'Default Page' and page_label<>'Default Module Page' and  page_id in (select page_id from tab_user where is_faved='Y' and elt_account_number=" + elt_account_number + " and user_id=" +
                userid+")  order by top_seq_id,sub_seq_id,page_seq_id";
            List<TabItem> Tabs = new List<TabItem>();
            if (userid == "") return Tabs;
            try
            {
                Con.Open();
                SqlDataReader reader = Cmd.ExecuteReader();
                while (reader.Read())
                {
                    TabItem Menu = new TabItem();
                    Menu.page_label = Convert.ToString(reader["page_label"]);
                    Menu.page_url = Convert.ToString(reader["page_url"]);
                    Menu.top_module = Convert.ToString(reader["top_module"]);
                    Menu.sub_module = Convert.ToString(reader["sub_module"]);
                    Tabs.Add(Menu);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Tabs;
        }
    }
}
