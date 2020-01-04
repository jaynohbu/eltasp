using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

/// <summary>
/// Summary description for ImportMAWBRecord
/// </summary>
public class ImportMAWBRecord
    {
    public string process_dt;			    
    public string file_no;
    public string dep_port;
    public string arr_port;
    public string dep_code;
    public string arr_code;
    public string carrier_code ;    			 
    public string  flt_no ;			
    public string etd;
    public string eta;			   
    public string cargo_location;
    public string  it_number;
    public string it_date;
    public string  it_entry_port;
    public string place_of_delivery;
    public string  last_free_date;
    public string sub_mawb;

	public ImportMAWBRecord()
	{
		
	}
}
