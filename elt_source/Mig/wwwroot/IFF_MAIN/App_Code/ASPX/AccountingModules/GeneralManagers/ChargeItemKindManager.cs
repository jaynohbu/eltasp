using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Collections;


/// <summary>
/// Summary description for ChargeItemKindManager
/// </summary>
public class ChargeItemKindManager:Manager
{
   
    private ArrayList chargeItemKindsList; 

    public ArrayList getChargeItemKindList(){
        return chargeItemKindsList;
    }
    public int getChargeItemRevenueAcct(int item_no)
    {
        int account=-1;
        try
        {
            for (int i = 0; i < chargeItemKindsList.Count; i++)
            {
                if (((ChargeItemKindRecord)chargeItemKindsList[i]).Item_no == item_no)
                {

                    account = ((ChargeItemKindRecord)chargeItemKindsList[i]).Account_revenue;
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return account;
    }


    public ChargeItemKindManager(string elt_acct)
        : base(elt_acct)
	{
		
        getChargeItemKinds();
	}

    private void getChargeItemKinds(){
        SQL = "select item_no,item_name,item_type,item_desc,account_revenue,Unit_Price from item_charge where elt_account_number = " + elt_account_number + " order by item_name";
        DataTable dt = new DataTable();
        SqlDataAdapter adt = new SqlDataAdapter(SQL, Con);
        adt.Fill(dt);
        GeneralUtility util = new GeneralUtility();
        util.removeNull(ref dt);
        chargeItemKindsList = new ArrayList();

        ChargeItemKindRecord ikr1 = new ChargeItemKindRecord();
        ikr1.Account_revenue = -1;
        ikr1.Item_desc = "";
        ikr1.Item_name = "Select";
        ikr1.Item_no = -1;
        ikr1.Item_type = "";
        ikr1.Unit_price = 0;
        ikr1.Delim = "";
        this.chargeItemKindsList.Add(ikr1);

        ChargeItemKindRecord ikr2 = new ChargeItemKindRecord();
        ikr2.Account_revenue = -1;
        ikr2.Item_desc = "";
        ikr2.Item_name = "Add New";
        ikr2.Item_no = -2;
        ikr2.Item_type = "";
        ikr2.Unit_price = 0;
        ikr2.Delim = "";
        this.chargeItemKindsList.Add(ikr2);        

        for(int i=0;i<dt.Rows.Count;i++){
            ChargeItemKindRecord ikr = new ChargeItemKindRecord();
            ikr.Account_revenue = Int32.Parse(dt.Rows[i]["account_revenue"].ToString());
            ikr.Item_desc = dt.Rows[i]["item_desc"].ToString();
            ikr.Item_name = dt.Rows[i]["item_name"].ToString();
            ikr.Item_no = Int32.Parse(dt.Rows[i]["item_no"].ToString());
            ikr.Item_type = dt.Rows[i]["item_type"].ToString();
            ikr.Unit_price = Decimal.Parse(dt.Rows[i]["unit_price"].ToString());
            this.chargeItemKindsList.Add(ikr);           
        }

    }
}
