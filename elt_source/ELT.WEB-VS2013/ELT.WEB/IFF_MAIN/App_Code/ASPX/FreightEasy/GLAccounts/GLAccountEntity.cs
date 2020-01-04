using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace FreightEasy.GLAccounts
{

    public class GLAccountEntity
    {
        protected decimal _gl_account_number = 0;
        protected string _gl_account_desc = null;
        protected string _gl_master_type = null;
        protected string _gl_account_type = null;
        protected decimal _gl_account_balance = 0;
        protected string _gl_account_status = null;
        protected DateTime _gl_account_cdate = DateTime.Now;
        protected DateTime _gl_last_modified = DateTime.Now;
        protected decimal _control_no = 0;
        protected string _gl_default = null;


        public decimal gl_account_number
        {
            get { return _gl_account_number; }
            set { _gl_account_number = value; }
        }

        public string gl_account_desc
        {
            get { return _gl_account_desc; }
            set { _gl_account_desc = value; }
        }

        public string gl_master_type
        {
            get { return _gl_master_type; }
            set { _gl_master_type = value; }
        }

        public decimal gl_account_balance
        {
            get { return _gl_account_balance; }
            set { _gl_account_balance = value; }
        }

        public string gl_account_status
        {
            get { return _gl_account_status; }
            set { _gl_account_status = value; }
        }

        public DateTime gl_account_cdate
        {
            get { return _gl_account_cdate; }
            set { _gl_account_cdate = value; }
        }

        public DateTime gl_last_modified
        {
            get { return _gl_last_modified; }
            set { _gl_last_modified = value; }
        }

        public decimal control_no
        {
            get { return _control_no; }
            set { _control_no = value; }
        }

        public string gl_default
        {
            get { return _gl_default; }
            set { _gl_default = value; }
        }

        
    }
}