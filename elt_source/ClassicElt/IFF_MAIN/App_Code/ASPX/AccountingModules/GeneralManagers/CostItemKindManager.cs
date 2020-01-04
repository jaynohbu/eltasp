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
/// Summary description for CostItemKindManager
/// </summary>
public class CostItemKindManager:Manager
{
   
    private ArrayList CostItemKindsList;

    public ArrayList getCostItemKindList()
    {
        return CostItemKindsList;
    }
    public int getCostItemExpenseAcct(int item_no)
    {
        int account = -1;
        for (int i = 0; i < CostItemKindsList.Count; i++)
        {
            if (((CostItemKindRecord)CostItemKindsList[i]).Item_no == item_no)
            {
                account = ((CostItemKindRecord)CostItemKindsList[i]).Account_expense;
            }
        }
        return account;
    }


    public CostItemKindManager(string elt_acct): base(elt_acct){       
        getCostItemKinds();
    }

    private void getCostItemKinds()
    {
        SQL = "select item_no,item_name,item_type,item_desc,account_expense,Unit_Price from item_cost where elt_account_number = " + elt_account_number + " order by item_name";
        DataTable dt = new DataTable();
        SqlDataAdapter adt = new SqlDataAdapter(SQL, Con);
        adt.Fill(dt);
        GeneralUtility util = new GeneralUtility();
        util.removeNull(ref dt);

        CostItemKindsList = new ArrayList();

        CostItemKindRecord ikr1 = new CostItemKindRecord();
        ikr1.Account_expense = -1;
        ikr1.Item_desc = "";
        ikr1.Item_name = "Select";
        ikr1.Item_no = -1;
        ikr1.Item_type = "";
        ikr1.Unit_price = 0;
        ikr1.Delim = "";
        this.CostItemKindsList.Add(ikr1);

        CostItemKindRecord ikr2 = new CostItemKindRecord();
        ikr2.Account_expense = -1;
        ikr2.Item_desc = "";
        ikr2.Item_name = "Add New";
        ikr2.Item_no = -2;
        ikr2.Item_type = "";
        ikr2.Unit_price = 0;
        ikr2.Delim = "";
        this.CostItemKindsList.Add(ikr2);



        for (int i = 0; i < dt.Rows.Count; i++)
        {
            CostItemKindRecord ikr = new CostItemKindRecord();
            ikr.Account_expense = Int32.Parse(dt.Rows[i]["account_expense"].ToString());
            ikr.Item_desc = dt.Rows[i]["item_desc"].ToString();
            ikr.Item_name = dt.Rows[i]["item_name"].ToString();
            ikr.Item_no = Int32.Parse(dt.Rows[i]["item_no"].ToString());
            ikr.Item_type = dt.Rows[i]["item_type"].ToString();
            ikr.Unit_price = Decimal.Parse(dt.Rows[i]["unit_price"].ToString());
            this.CostItemKindsList.Add(ikr);
        }

    }


    
}
