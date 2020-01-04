using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace FreightEasy.Rates
{
    /// <summary>
    /// Summary description for RateEntity
    /// </summary>
    public class RateEntity
    {
        protected string _origin_port = null;
        protected string _dest_port = null;
        protected string _kg_lb = null;
        protected string _airline = null;
        protected string _dba_name = null;
        protected string _weight_break = null;
        protected decimal _rate = 0;
        protected decimal _share = 0;
        protected decimal _item_no = -1;
        protected decimal _elt_account_number = -1;
        protected int _rate_type = -1;
        protected int _agent_no = -1;
        protected int _customer_no = -1;
        protected decimal _fl_rate = -1;
        protected decimal _sec_rate = -1;
        protected string _include_fl_rate = null;
        protected string _include_sec_rate = null;

        public string origin_port
        {
            get { return _origin_port; }
            set { _origin_port = value; }
        }

        public string dest_port
        {
            get { return _dest_port; }
            set { _dest_port = value; }
        }

        public string kg_lb
        {
            get { return _kg_lb; }
            set { _kg_lb = value; }
        }

        public string airline
        {
            get { return _airline; }
            set { _airline = value; }
        }

        public string dba_name
        {
            get { return _dba_name; }
            set { _dba_name = value; }
        }

        public string weight_break
        {
            get { return _weight_break; }
            set { _weight_break = value; }
        }

        public decimal rate
        {
            get { return _rate; }
            set { _rate = value; }
        }

        public decimal share
        {
            get { return _share; }
            set { _share = value; }
        }

        public decimal item_no
        {
            get { return _item_no; }
            set { _item_no = value; }
        }

        public decimal elt_account_number
        {
            get { return _elt_account_number; }
            set { _elt_account_number = value; }
        }

        public int rate_type
        {
            get { return _rate_type; }
            set { _rate_type = value; }
        }

        public int customer_no
        {
            get { return _customer_no; }
            set { _customer_no = value; }
        }

        public int agent_no
        {
            get { return _agent_no; }
            set { _agent_no = value; }
        }

        public decimal fl_rate
        {
            get { return _fl_rate; }
            set { _fl_rate = value; }
        }

        public decimal sec_rate
        {
            get { return _sec_rate; }
            set { _sec_rate = value; }
        }

        public string include_fl_rate
        {
            get { return _include_fl_rate; }
            set { _include_fl_rate = value; }
        }

        public string include_sec_rate
        {
            get { return _include_sec_rate; }
            set { _include_sec_rate = value; }
        }
    }
}