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
using System.Text;


/// <summary>
/// Summary description for glManager
/// </summary>
public class GLManager:Manager
{ 
    private Hashtable glDescriiption;
    public GLManager(string elt_acct) : base(elt_acct)
    {
        glDescriiption = new Hashtable();
        setGlDescription();
    }

    private void setGlDescription(){
        SQL="select gl_account_number,gl_account_desc from gl where elt_account_number=" + elt_account_number;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);      
        GeneralUtility gUtil=new GeneralUtility();        
        try
        {
            ad.Fill(dt);
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                glDescriiption.Add(Int32.Parse(dt.Rows[i]["gl_account_number"].ToString()),
                dt.Rows[i]["gl_account_desc"].ToString());
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }


    public GLRecord getGLAcct(int gl_account_number)
    {
        SQL = "select isnull(control_no,0) as control_no ,gl_account_balance,gl_account_cdate,gl_account_desc,gl_account_number,gl_account_status,gl_account_type,gl_begin_balance,gl_default,gl_last_modified,gl_master_type  from gl where elt_account_number = " + elt_account_number + " and gl_account_number=" + gl_account_number;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        GeneralUtility gUtil = new GeneralUtility();
        GLRecord gRec = new GLRecord();
        ad.Fill(dt);     
        try
        {          
            gUtil.removeNull(ref dt);
            gRec.Control_no=dt.Rows[0]["control_no"].ToString();
            gRec.Gl_account_balance=Decimal.Parse(dt.Rows[0]["gl_account_balance"].ToString());
            gRec.Gl_account_cdate = dt.Rows[0]["gl_account_cdate"].ToString();
            gRec.Gl_account_desc = dt.Rows[0]["gl_account_desc"].ToString();
            gRec.Gl_account_number = Int32.Parse((dt.Rows[0]["gl_account_number"].ToString()));
            gRec.Gl_account_status = dt.Rows[0]["gl_account_status"].ToString();
            gRec.Gl_account_type = dt.Rows[0]["gl_account_type"].ToString();
            gRec.Gl_begin_balance = Decimal.Parse(dt.Rows[0]["gl_begin_balance"].ToString());
            gRec.Gl_default = dt.Rows[0]["gl_default"].ToString();
            gRec.Gl_last_modified = dt.Rows[0]["gl_last_modified"].ToString();
            gRec.Gl_master_type = dt.Rows[0]["gl_master_type"].ToString();
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return gRec;
    }
    
    public GLRecord getDefaultARAccount()
    {
        SQL = "select  top 1 * from  gl  where elt_account_number = " + elt_account_number + "  and gl_account_type= '" + Account.ACCOUNT_RECEIVABLE + "'";
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        GeneralUtility gUtil = new GeneralUtility();
        GLRecord gRec = new GLRecord();
        ad.Fill(dt);
        try
        {
            gUtil.removeNull(ref dt);
            gRec.Control_no = dt.Rows[0]["control_no"].ToString();
            gRec.Gl_account_balance = Decimal.Parse(dt.Rows[0]["gl_account_balance"].ToString());
            gRec.Gl_account_cdate = dt.Rows[0]["gl_account_cdate"].ToString();
            gRec.Gl_account_desc = dt.Rows[0]["gl_account_desc"].ToString();
            gRec.Gl_account_number = Int32.Parse((dt.Rows[0]["gl_account_number"].ToString()));
            gRec.Gl_account_status = dt.Rows[0]["gl_account_status"].ToString();
            gRec.Gl_account_type = dt.Rows[0]["gl_account_type"].ToString();
            gRec.Gl_begin_balance = Decimal.Parse(dt.Rows[0]["gl_begin_balance"].ToString());
            gRec.Gl_default = dt.Rows[0]["gl_default"].ToString();
            gRec.Gl_last_modified = dt.Rows[0]["gl_last_modified"].ToString();
            gRec.Gl_master_type = dt.Rows[0]["gl_master_type"].ToString();
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return gRec;
    }

    public GLRecord getDefaultCustomerCreditAcct()
    {
        SQL = "select  top 1 * from  gl  where elt_account_number = " + elt_account_number + "  and gl_account_type= '" + Account.CUSTOMER_CREDIT + "'";
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        GeneralUtility gUtil = new GeneralUtility();
        GLRecord gRec = new GLRecord();
        ad.Fill(dt);

        if(dt.Rows.Count>0)
        {
            try
            {
                gUtil.removeNull(ref dt);
                gRec.Control_no = dt.Rows[0]["control_no"].ToString();
                gRec.Gl_account_balance = Decimal.Parse(dt.Rows[0]["gl_account_balance"].ToString());
                gRec.Gl_account_cdate = dt.Rows[0]["gl_account_cdate"].ToString();
                gRec.Gl_account_desc = dt.Rows[0]["gl_account_desc"].ToString();
                gRec.Gl_account_number = Int32.Parse((dt.Rows[0]["gl_account_number"].ToString()));
                gRec.Gl_account_status = dt.Rows[0]["gl_account_status"].ToString();
                gRec.Gl_account_type = dt.Rows[0]["gl_account_type"].ToString();
                gRec.Gl_begin_balance = Decimal.Parse(dt.Rows[0]["gl_begin_balance"].ToString());
                gRec.Gl_default = dt.Rows[0]["gl_default"].ToString();
                gRec.Gl_last_modified = dt.Rows[0]["gl_last_modified"].ToString();
                gRec.Gl_master_type = dt.Rows[0]["gl_master_type"].ToString();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        else
        {
            int gl_acct = 0;
            gl_acct = getNewGLAccount("LIABILITY");

            gRec = createGLAccount(gl_acct, "Customer Credit", "LIABILITY", Account.CUSTOMER_CREDIT);
        }       
        return gRec;
    }

    public GLRecord getDefaultInterestIncomeAcct()
    {
        SQL = "select  top 1 * from  gl  where elt_account_number = " + elt_account_number + "  and gl_account_type= '" + Account.OTHER_REVENUE + "' AND gl_account_desc='INTEREST INCOME'";
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        GeneralUtility gUtil = new GeneralUtility();
        GLRecord gRec = new GLRecord();
        ad.Fill(dt);

        if (dt.Rows.Count > 0)
        {
            try
            {
                gUtil.removeNull(ref dt);
                gRec.Control_no = dt.Rows[0]["control_no"].ToString();
                gRec.Gl_account_balance = Decimal.Parse(dt.Rows[0]["gl_account_balance"].ToString());
                gRec.Gl_account_cdate = dt.Rows[0]["gl_account_cdate"].ToString();
                gRec.Gl_account_desc = dt.Rows[0]["gl_account_desc"].ToString();
                gRec.Gl_account_number = Int32.Parse((dt.Rows[0]["gl_account_number"].ToString()));
                gRec.Gl_account_status = dt.Rows[0]["gl_account_status"].ToString();
                gRec.Gl_account_type = dt.Rows[0]["gl_account_type"].ToString();
                gRec.Gl_begin_balance = Decimal.Parse(dt.Rows[0]["gl_begin_balance"].ToString());
                gRec.Gl_default = dt.Rows[0]["gl_default"].ToString();
                gRec.Gl_last_modified = dt.Rows[0]["gl_last_modified"].ToString();
                gRec.Gl_master_type = dt.Rows[0]["gl_master_type"].ToString();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        else
        {
            int gl_acct = 0;
            gl_acct = getNewGLAccount("REVENUE");
            gRec = createGLAccount(gl_acct, "INTEREST INCOME", "REVENUE", Account.OTHER_REVENUE);
        }
        return gRec;
    }



    public GLRecord getDefaultBankServiceChargeAcct()
    {
        SQL = "select  top 1 * from  gl  where elt_account_number = " + elt_account_number + "  and gl_account_type= '" + Account.OTHER_EXPENSE + "' AND gl_account_desc='BANK SERVICE'";
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        GeneralUtility gUtil = new GeneralUtility();
        GLRecord gRec = new GLRecord();
        ad.Fill(dt);

        if (dt.Rows.Count > 0)
        {
            try
            {
                gUtil.removeNull(ref dt);
                gRec.Control_no = dt.Rows[0]["control_no"].ToString();
                gRec.Gl_account_balance = Decimal.Parse(dt.Rows[0]["gl_account_balance"].ToString());
                gRec.Gl_account_cdate = dt.Rows[0]["gl_account_cdate"].ToString();
                gRec.Gl_account_desc = dt.Rows[0]["gl_account_desc"].ToString();
                gRec.Gl_account_number = Int32.Parse((dt.Rows[0]["gl_account_number"].ToString()));
                gRec.Gl_account_status = dt.Rows[0]["gl_account_status"].ToString();
                gRec.Gl_account_type = dt.Rows[0]["gl_account_type"].ToString();
                gRec.Gl_begin_balance = Decimal.Parse(dt.Rows[0]["gl_begin_balance"].ToString());
                gRec.Gl_default = dt.Rows[0]["gl_default"].ToString();
                gRec.Gl_last_modified = dt.Rows[0]["gl_last_modified"].ToString();
                gRec.Gl_master_type = dt.Rows[0]["gl_master_type"].ToString();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        else
        {
            int gl_acct = 0;
            gl_acct = getNewGLAccount("EXPENSE");
            gRec = createGLAccount(gl_acct, "BANK SERVICE", "EXPENSE", Account.OTHER_EXPENSE);
        }
        return gRec;
    }





    public GLRecord getDefaultRetainedEarningAcct()
    {
        SQL = "select  top 1 * from  gl  where elt_account_number = " + elt_account_number 
            + "  and gl_account_type= '" + Account.EQUITY_RETAINED_EARNINGS + "'";
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        GeneralUtility gUtil = new GeneralUtility();
        GLRecord gRec = new GLRecord();
        ad.Fill(dt);

        if (dt.Rows.Count > 0)
        {
            try
            {
                gUtil.removeNull(ref dt);
                gRec.Control_no = dt.Rows[0]["control_no"].ToString();
                gRec.Gl_account_balance = Decimal.Parse(dt.Rows[0]["gl_account_balance"].ToString());
                gRec.Gl_account_cdate = dt.Rows[0]["gl_account_cdate"].ToString();
                gRec.Gl_account_desc = dt.Rows[0]["gl_account_desc"].ToString();
                gRec.Gl_account_number = Int32.Parse((dt.Rows[0]["gl_account_number"].ToString()));
                gRec.Gl_account_status = dt.Rows[0]["gl_account_status"].ToString();
                gRec.Gl_account_type = dt.Rows[0]["gl_account_type"].ToString();
                gRec.Gl_begin_balance = Decimal.Parse(dt.Rows[0]["gl_begin_balance"].ToString());
                gRec.Gl_default = dt.Rows[0]["gl_default"].ToString();
                gRec.Gl_last_modified = dt.Rows[0]["gl_last_modified"].ToString();
                gRec.Gl_master_type = dt.Rows[0]["gl_master_type"].ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        else
        {
            int gl_acct = 0;
            gl_acct = getNewGLAccount("EQUITY");
            gRec = createGLAccount(gl_acct, "Retained Earnings", "EQUITY", Account.EQUITY_RETAINED_EARNINGS);
        }
        return gRec;
    }


    public string setDefaultDFChargeAcct()
    {
        string return_val = "false";

        //---------
        SQL = "select  isnull(max(item_no),0) as item_no  from  item_charge  where elt_account_number = "
            + elt_account_number;

        DataTable dt = new DataTable();
        SqlDataAdapter ad2 = new SqlDataAdapter(SQL, Con);
        ad2.Fill(dt);

        int next_no = Int32.Parse(dt.Rows[0]["item_no"].ToString());
        next_no += 1;
        dt.Clear();

       
        //-----------------

        SQL = "select  top 1 * from  gl  where elt_account_number = " + elt_account_number
            + "  and gl_account_type= '" + Account.REVENUE
            + "' and gl_master_type='REVENUE' and gl_account_desc='Default Domestic Freight Charge'";

        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        GeneralUtility gUtil = new GeneralUtility();
        GLRecord gRec = new GLRecord();
        ad.Fill(dt);

        int gl_acct = 0;
        if (dt.Rows.Count == 0)
        {
            
            gl_acct = getNewGLAccount("REVENUE");
            gRec = createGLAccount(gl_acct, "Default Domestic Freight Charge", "REVENUE", Account.REVENUE);
        }else
        {
            gl_acct=Int32.Parse(dt.Rows[0]["gl_account_number"].ToString());
        }

        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;


        try
        {
            SQL = "INSERT INTO [item_charge] ";
            SQL += "( elt_account_number, ";
            SQL += "item_no,";
            SQL += "item_name,";
            SQL += "item_type,";
            SQL += "item_desc,";
            SQL += "unit_price,";
            SQL += "account_revenue) ";
            SQL += "VALUES";
            SQL += "('" + elt_account_number;
            SQL += "','" + next_no;
            SQL += "','" + "DF";
            SQL += "','" + "Domestic Freight";
            SQL += "','" + "DOMESTIC FREIGHT";
            SQL += "','" + "0";
            SQL += "','" + gl_acct;
            SQL += "')";

            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();


            SQL = "UPDATE [user_profile] ";
            SQL += "set default_domestic_charge_item= '" + next_no + "'";
            SQL += "where elt_account_number = " + elt_account_number;

            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();
            trans.Commit();
            return_val = "true";
        }
        catch (Exception ex)
        {
            trans.Rollback();
            throw ex;
        }
        finally
        {
            Con.Close();
        }
    
    return return_val;
    }





    public string setDefaultAFChargeAcct()
    {
        string return_val = "false";

        //---------
        SQL = "select  isnull(max(item_no),0) as item_no from  item_charge  where elt_account_number = "
            + elt_account_number;

        DataTable dt = new DataTable();
        SqlDataAdapter ad2 = new SqlDataAdapter(SQL, Con);
        ad2.Fill(dt);

        int next_no = Int32.Parse(dt.Rows[0]["item_no"].ToString());
        next_no += 1;

        dt.Clear();
      

        //-----------------

        SQL = "select  top 1 * from  gl  where elt_account_number = " + elt_account_number
            + "  and gl_account_type= '" + Account.REVENUE
            + "' and gl_master_type='REVENUE' and gl_account_desc='Default Air Freight Charge'";

        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        GeneralUtility gUtil = new GeneralUtility();
        GLRecord gRec = new GLRecord();
        ad.Fill(dt);
        int gl_acct = 0;
        if (dt.Rows.Count == 0)
        {
            
            gl_acct = getNewGLAccount("REVENUE");
            gRec = createGLAccount(gl_acct, "Default Air Freight Charge", "REVENUE", Account.REVENUE);
        }
        else
        {
            gl_acct = Int32.Parse(dt.Rows[0]["gl_account_number"].ToString());
        }
        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;


        try
        {
            SQL = "INSERT INTO [item_charge] ";
            SQL += "( elt_account_number, ";
            SQL += "item_no,";
            SQL += "item_name,";
            SQL += "item_type,";
            SQL += "item_desc,";
            SQL += "unit_price,";
            SQL += "account_revenue) ";
            SQL += "VALUES";
            SQL += "('" + elt_account_number;
            SQL += "','" + next_no;
            SQL += "','" + "AF";
            SQL += "','" + "Air Freight";
            SQL += "','" + "AIR FREIGHT";
            SQL += "','" + "0";
            SQL += "','" + gl_acct;
            SQL += "')";

            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();


            SQL = "UPDATE [user_profile] ";
            SQL += "set default_air_charge_item= '" + next_no + "'";
            SQL += "where elt_account_number = " + elt_account_number;

            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();
            trans.Commit();
            return_val = "true";
        }
        catch (Exception ex)
        {
            trans.Rollback();
            throw ex;
        }
        finally
        {
            Con.Close();
        }
      
        return return_val;
    }


    public string setDefaultOFChargeAcct()
    {
        string return_val = "false";

        //---------
        SQL = "select  isnull(max(item_no),0) as item_no from  item_charge  where elt_account_number = "
            + elt_account_number;

        DataTable dt = new DataTable();
        SqlDataAdapter ad2 = new SqlDataAdapter(SQL, Con);
        ad2.Fill(dt);

        int next_no = Int32.Parse(dt.Rows[0]["item_no"].ToString());
        next_no += 1;
        dt.Clear();

        //-----------------



        SQL = "select  top 1 * from  gl  where elt_account_number = " + elt_account_number
            + "  and gl_account_type= '" + Account.REVENUE
            + "' and gl_master_type='REVENUE' and gl_account_desc='Default Ocean Freight'";


        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        GeneralUtility gUtil = new GeneralUtility();
        GLRecord gRec = new GLRecord();
        ad.Fill(dt);
        int gl_acct = 0;

        if (dt.Rows.Count == 0)
        {
            
            gl_acct = getNewGLAccount("REVENUE");
            gRec = createGLAccount(gl_acct, "Default Ocean Freight Charge", "REVENUE", Account.REVENUE);
        }
        else
        {
            gl_acct = Int32.Parse(dt.Rows[0]["gl_account_number"].ToString());
        }
        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;

        try
        {
            SQL = "INSERT INTO [item_charge] ";
            SQL += "( elt_account_number, ";
            SQL += "item_no,";
            SQL += "item_name,";
            SQL += "item_type,";
            SQL += "item_desc,";
            SQL += "unit_price,";
            SQL += "account_revenue) ";
            SQL += "VALUES";
            SQL += "('" + elt_account_number;
            SQL += "','" + next_no;
            SQL += "','" + "OF";
            SQL += "','" + "Ocean Freight";
            SQL += "','" + "OCEAN FREIGHT";
            SQL += "','" + "0";
            SQL += "','" + gl_acct;
            SQL += "')";

            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();


            SQL = "UPDATE [user_profile] ";
            SQL += "set default_ocean_charge_item= '" + next_no + "'";
            SQL += "where elt_account_number = " + elt_account_number;

            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();
            trans.Commit();
            return_val = "true";
        }
        catch (Exception ex)
        {
            trans.Rollback();
            throw ex;
        }
        finally
        {
            Con.Close();
        }

        return return_val;
    }

    public string setDefaultAFCostAcct()
    {
        string return_val = "false";

        //---------
        SQL = "select  isnull(max(item_no),0) as item_no  from  item_cost  where elt_account_number = "
            + elt_account_number;

        DataTable dt = new DataTable();
        SqlDataAdapter ad2 = new SqlDataAdapter(SQL, Con);
        ad2.Fill(dt);

        int next_no = Int32.Parse(dt.Rows[0]["item_no"].ToString());
        next_no += 1;
        dt.Clear();

        SQL = "select  top 1 * from  gl  where elt_account_number = "
            + elt_account_number + "  and gl_account_type= '" + Account.COST_OF_SALES
            + "' and gl_master_type='EXPENSE' and gl_account_desc='Default Air Freight Cost'";

        //-----------------

        
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        GeneralUtility gUtil = new GeneralUtility();
        GLRecord gRec = new GLRecord();
        ad.Fill(dt);
        int gl_acct = 0;
        if (dt.Rows.Count == 0)
        {
           
            gl_acct = getNewGLAccount("EXPENSE");
            gRec = createGLAccount(gl_acct, "Default Air Freight Cost", "EXPENSE", Account.COST_OF_SALES);
        }
        else
        {
            gl_acct = Int32.Parse(dt.Rows[0]["gl_account_number"].ToString());
        }
        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;

        try
        {
            SQL = "INSERT INTO [item_cost] ";
            SQL += "( elt_account_number, ";
            SQL += "item_no,";
            SQL += "item_name,";
            SQL += "item_type,";
            SQL += "item_desc,";
            SQL += "unit_price,";
            SQL += "account_expense) ";
            SQL += "VALUES";
            SQL += "('" + elt_account_number;
            SQL += "','" + next_no;
            SQL += "','" + "AF";
            SQL += "','" + "Air Freight";
            SQL += "','" + "AIR FREIGHT";
            SQL += "','" + "0";
            SQL += "','" + gl_acct;
            SQL += "')";

            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();

            SQL = "UPDATE [user_profile] ";
            SQL += "set default_air_cost_item= '" + gl_acct + "'";
            SQL += "where elt_account_number = '" + elt_account_number;
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();


            trans.Commit();
            return_val = "true";
        }

        catch (Exception ex)
        {
            trans.Rollback();
            throw ex;
        }
        finally
        {
            Con.Close();
        }
     
        return return_val;
    }

  

    public string setDefaultOFCostAcct()
    {
        string return_val = "false";
        //---------
        SQL = "select   isnull(max(item_no),0) as item_no   from  item_cost  where elt_account_number = "
            + elt_account_number;

        DataTable dt = new DataTable();
        SqlDataAdapter ad2 = new SqlDataAdapter(SQL, Con);        
        ad2.Fill(dt);

        int next_no = Int32.Parse(dt.Rows[0]["item_no"].ToString());
        next_no += 1;
        dt.Clear();

        SQL = "select  top 1 * from  gl  where elt_account_number = " 
            + elt_account_number + "  and gl_account_type= '" + Account.COST_OF_SALES
            + "' and gl_master_type='EXPENSE' and gl_account_desc='Default Ocean Freight Cost'";

      //-----------------
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        GeneralUtility gUtil = new GeneralUtility();
        GLRecord gRec = new GLRecord();
        ad.Fill(dt);
        int gl_acct = 0;
        if (dt.Rows.Count == 0)
        {
            
            gl_acct = getNewGLAccount("EXPENSE");
            gRec = createGLAccount(gl_acct, "Default Ocean Freight Cost", "EXPENSE", Account.COST_OF_SALES);
        }
        else
        {
            gl_acct = Int32.Parse(dt.Rows[0]["gl_account_number"].ToString());
        }
        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;

        try
        {
            SQL = "INSERT INTO [item_cost] ";
            SQL += "( elt_account_number, ";
            SQL += "item_no,";
            SQL += "item_name,";
            SQL += "item_type,";
            SQL += "item_desc,";
            SQL += "unit_price,";
            SQL += "account_expense) ";
            SQL += "VALUES";
            SQL += "('" + elt_account_number;
            SQL += "','" + next_no;
            SQL += "','" + "OF";
            SQL += "','" + "Ocean Freight";
            SQL += "','" + "OCEAN FREIGHT";
            SQL += "','" + "0";
            SQL += "','" + gl_acct;
            SQL += "')";

            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();


            SQL = "UPDATE [user_profile] ";
            SQL += "set default_ocean_cost_item= '" + next_no + "'";
            SQL += "where elt_account_number = " + elt_account_number;
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();


            trans.Commit();
            return_val = "true";

        }
        catch (Exception ex)
        {
            trans.Rollback();
            throw ex;
        }
        finally
        {
            Con.Close();
        }
     
        return return_val;
    }

    public int getNewGLAccount(string gl_master_type)
    {
        DataTable dt = new DataTable();        
        GeneralUtility gUtil = new GeneralUtility();
        SQL = "SELECT max(gl_account_number) as gl_account_number from gl where elt_account_number=" 
            + elt_account_number + " and gl_master_type='" + gl_master_type+"'";
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);       
        int gl_acct = 0;
        try
        {
            ad.Fill(dt);
            gl_acct = Int32.Parse(dt.Rows[0]["gl_account_number"].ToString());
            gl_acct = gl_acct + 1;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return gl_acct;
    }


    public GLRecord createGLAccount(int gl_account_number,string gl_account_desc,string gl_master_type,string gl_account_type)
    {
        GLRecord gRec = new GLRecord();
        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;
        SQL = "INSERT INTO gl (elt_account_number, gl_account_number, gl_account_desc, gl_master_type, gl_account_type, gl_account_status, gl_account_cdate, gl_last_modified) VALUES ("
        + elt_account_number + ","
        + gl_account_number + ","
        + "'" + gl_account_desc + "'" + ","
        + "'" + gl_master_type + "'" + ","
        + "'" + gl_account_type + "'" + ","
        + "'A'" + ","
        + "'" + DateTime.Today.ToShortDateString() + "'" + ","
        + "'" + DateTime.Today.ToShortDateString() + "'"
        + ")";
        try
        {
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();
            trans.Commit();
        }
        catch (Exception ex)
        {
            trans.Rollback();
            throw ex;
        }
        finally
        {
            Con.Close();
        }
        gRec.Gl_account_type = gl_account_type;
        gRec.Gl_master_type = gl_master_type;
        gRec.Gl_account_desc = gl_account_desc;
        gRec.Gl_account_number = gl_account_number;
        gRec.Gl_account_status="A";

        return gRec;
    }

    public string getGLDescription(int gl_number)
    {
       string desc= (string)glDescriiption[gl_number];
       return desc;
    }

    public ArrayList getGLAcctList(string gl_account_type)
    {
        SQL = "select isnull(control_no,0) as control_no ,gl_account_balance,gl_account_cdate,gl_account_desc,gl_account_number,gl_account_status,gl_account_type,gl_begin_balance,gl_default,gl_last_modified,gl_master_type  from gl where elt_account_number = " 
            + elt_account_number + " and gl_account_type='" + gl_account_type + "'";
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        GeneralUtility gUtil = new GeneralUtility();
        ArrayList gRecList = new ArrayList();
        ad.Fill(dt);
        try
        {
            gUtil.removeNull(ref dt);
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                GLRecord gRec = new GLRecord();
                gRec.Control_no = dt.Rows[i]["control_no"].ToString();
                gRec.Gl_account_balance = Decimal.Parse(dt.Rows[i]["gl_account_balance"].ToString());
                gRec.Gl_account_number = Int32.Parse((dt.Rows[i]["gl_account_number"].ToString()));
                if (gl_account_type == Account.BANK)
                {
                    gRec.Gl_account_balance = getBankBalance(gRec.Gl_account_number);
                }
                gRec.Gl_account_cdate = dt.Rows[i]["gl_account_cdate"].ToString();
                gRec.Gl_account_desc = dt.Rows[i]["gl_account_desc"].ToString();                
                gRec.Gl_account_status = dt.Rows[i]["gl_account_status"].ToString();
                gRec.Gl_account_type = dt.Rows[i]["gl_account_type"].ToString();
                gRec.Gl_begin_balance = Decimal.Parse(dt.Rows[i]["gl_begin_balance"].ToString());
                gRec.Gl_default = dt.Rows[i]["gl_default"].ToString();
                gRec.Gl_last_modified = dt.Rows[i]["gl_last_modified"].ToString();
                gRec.Gl_master_type = dt.Rows[i]["gl_master_type"].ToString();   
                gRecList.Add(gRec);
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return gRecList;
    }

    public ArrayList getCheckingAcctList()
    {
        SQL = "select control_no, gl_account_balance,gl_account_cdate,gl_account_desc,gl_account_number,gl_account_status,gl_account_type,gl_begin_balance,gl_default,gl_last_modified,gl_master_type  from gl where isnull(control_no,0) > 0  and elt_account_number = " 
            + elt_account_number + " and gl_account_type='" + Account.BANK + "'";      
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        GeneralUtility gUtil = new GeneralUtility();
        ArrayList gRecList = new ArrayList();
        ad.Fill(dt);
        try
        {
            gUtil.removeNull(ref dt);
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                GLRecord gRec = new GLRecord();
                gRec.Control_no = dt.Rows[i]["control_no"].ToString();
                gRec.Gl_account_balance = Decimal.Parse(dt.Rows[i]["gl_account_balance"].ToString());
                gRec.Gl_account_number = Int32.Parse((dt.Rows[i]["gl_account_number"].ToString()));                
                gRec.Gl_account_balance = getBankBalance(gRec.Gl_account_number);             
                gRec.Gl_account_cdate = dt.Rows[i]["gl_account_cdate"].ToString();
                gRec.Gl_account_desc = dt.Rows[i]["gl_account_desc"].ToString();
                gRec.Gl_account_status = dt.Rows[i]["gl_account_status"].ToString();
                gRec.Gl_account_type = dt.Rows[i]["gl_account_type"].ToString();
                gRec.Gl_begin_balance = Decimal.Parse(dt.Rows[i]["gl_begin_balance"].ToString());
                gRec.Gl_default = dt.Rows[i]["gl_default"].ToString();
                gRec.Gl_last_modified = dt.Rows[i]["gl_last_modified"].ToString();
                gRec.Gl_master_type = dt.Rows[i]["gl_master_type"].ToString();
                gRecList.Add(gRec);
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return gRecList;
    }


    public ArrayList getAllGLAcctList()
    {
        SQL = "select isnull(control_no,0) as control_no ,gl_account_balance,gl_account_cdate,gl_account_desc,gl_account_number,gl_account_status,gl_account_type,gl_begin_balance,gl_default,gl_last_modified,gl_master_type  from gl where elt_account_number = "
            + elt_account_number;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        GeneralUtility gUtil = new GeneralUtility();
        ArrayList gRecList = new ArrayList();
        ad.Fill(dt);
        try
        {
            //gUtil.removeNull(ref dt);
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                GLRecord gRec = new GLRecord();
                gRec.Control_no = dt.Rows[i]["control_no"].ToString();
                try
                {
                    gRec.Gl_account_balance = Decimal.Parse(dt.Rows[i]["gl_account_balance"].ToString());
                }
                catch { }
                gRec.Gl_account_number = Int32.Parse((dt.Rows[i]["gl_account_number"].ToString()));                
                gRec.Gl_account_cdate = dt.Rows[i]["gl_account_cdate"].ToString();
                gRec.Gl_account_desc = dt.Rows[i]["gl_account_desc"].ToString();
                gRec.Gl_account_status = dt.Rows[i]["gl_account_status"].ToString();
                gRec.Gl_account_type = dt.Rows[i]["gl_account_type"].ToString();
                try
                {
                    gRec.Gl_begin_balance = Decimal.Parse(dt.Rows[i]["gl_begin_balance"].ToString());
                }
                catch { }
                gRec.Gl_default = dt.Rows[i]["gl_default"].ToString();
                gRec.Gl_last_modified = dt.Rows[i]["gl_last_modified"].ToString();
                gRec.Gl_master_type = dt.Rows[i]["gl_master_type"].ToString();
                gRecList.Add(gRec);
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return gRecList;
    }

    public bool updateNextCheckNumber(int gl_account_number, int current)
    {
        SQL = " update gl set control_no="+ (current +1) + "where elt_account_number = "
            + elt_account_number + " and gl_account_type='" + Account.BANK +"' and gl_account_number='" + gl_account_number + "'"; 
        Cmd = new SqlCommand(SQL, Con);
        try
        {
            Con.Open();
            Cmd.ExecuteNonQuery();            
        }
        catch (Exception ex)
        {            
            throw ex;
        }
        finally
        {
            Con.Close();
        }
        return false;
    }

    public int getNextCheckNumber(int gl_account_number)
    {
        SQL = " select isnull(control_no, 0) from gl where elt_account_number = "
            + elt_account_number + " and gl_account_type='" + Account.BANK +  "' and gl_account_number='" 
            + gl_account_number + "'"; 
        Cmd = new SqlCommand(SQL, Con);
        int return_val = 0;
        try
        {
            Con.Open();
            return_val = Int32.Parse(Cmd.ExecuteScalar().ToString());            
        }
        catch (Exception ex)
        {           
            return_val = -1;
        }
        finally
        {
            Con.Close();
        }
        return return_val;
    }

   public Decimal getBankBalance(int gl_account_number)
   {
       Decimal balance = 0;
       string last_date = get_last_date_of_fiscal_year(DateTime.Now.Year.ToString());
       string first_date = get_first_date_of_fiscal_year(last_date);
       SQL = "select sum(Round(ISNULL(a.credit_amount,0),2)+Round(ISNULL(a.debit_amount,0),2)+Round(ISNULL(a.debit_memo,0),2)+Round(ISNULL(a.credit_memo,0),2)) as balance from all_accounts_journal a, gl b where a.elt_account_number= " +
           elt_account_number + " and a.elt_account_number = b.elt_account_number and a.gl_account_number=" 
           + gl_account_number + " and a.gl_account_number=b.gl_account_number and b.gl_account_type='" + Account.BANK + "' and a.tran_date >='" 
           + first_date + "' and a.tran_date < DATEADD(day, 1,'" 
           + last_date + "') ";      
       Cmd = new SqlCommand(SQL, Con);
       Decimal return_val = 0;
       DataTable dt = new DataTable();
       SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
       GeneralUtility gUtil = new GeneralUtility();
       ArrayList gRecList = new ArrayList();
       try
       {
           ad.Fill(dt);
           gUtil.removeNull(ref dt);
           balance = Decimal.Parse(dt.Rows[0]["balance"].ToString());
           balance = Math.Round(balance, 2);
       }
       catch (Exception ex)
       {          
           throw ex;
       }
       finally
       {

       }
       return balance;
   }

    public Decimal getBankBalanceUptoADate(int gl_account_number,string last_date)
    {
        Decimal balance = 0;       
        string first_date = get_first_date_of_fiscal_year(last_date);
        SQL = "select sum(Round(ISNULL(a.credit_amount,0),2)+Round(ISNULL(a.debit_amount,0),2)+Round(ISNULL(a.debit_memo,0),2)+Round(ISNULL(a.credit_memo,0),2)) as balance from all_accounts_journal a, gl b where a.elt_account_number= " +
            elt_account_number + " and a.elt_account_number = b.elt_account_number and a.gl_account_number="
            + gl_account_number + " and a.gl_account_number=b.gl_account_number and b.gl_account_type='" + Account.BANK + "' and a.tran_date >='"
            + first_date + "' and a.tran_date < DATEADD(day, 1,'"
            + last_date + "') ";
        Cmd = new SqlCommand(SQL, Con);
        Decimal return_val = 0;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        GeneralUtility gUtil = new GeneralUtility();
        ArrayList gRecList = new ArrayList();
        try
        {
            ad.Fill(dt);
            gUtil.removeNull(ref dt);
            balance = Decimal.Parse(dt.Rows[0]["balance"].ToString());
            balance = Math.Round(balance, 2);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {

        }
        return balance;
    }

    string get_last_date_of_fiscal_year(string this_year)
    {
        string tmpYear, tmpMonth;
        string vFiscalFrom, vFiscalTo, vfiscalEndMonth;
        int vCalcYear;
        try
        {
            SQL = "select isnull(fiscalEndMonth,'12') as fiscalEndMonth  from user_profile where elt_account_number = "
                + elt_account_number;
            DataTable dt = new DataTable();
            SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
            GeneralUtility gUtil = new GeneralUtility();
            ArrayList gRecList = new ArrayList();
            ad.Fill(dt);
            vfiscalEndMonth = dt.Rows[0]["fiscalEndMonth"].ToString();
            tmpMonth = DateTime.Now.Month.ToString();
            vCalcYear = Int32.Parse(this_year);
            vFiscalTo = vfiscalEndMonth + "/" + "01" + "/" + vCalcYear.ToString();
            vFiscalTo = DateTime.Parse(vFiscalTo).AddMonths(1).AddDays(-1).ToShortDateString();
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return vFiscalTo;
    }


    string get_first_date_of_fiscal_year(string vFiscalTo)
    {
        string vFiscalFrom = "";
        vFiscalFrom = DateTime.Parse(vFiscalTo).AddMonths(-11).ToShortDateString();
        vFiscalFrom = DateTime.Parse(vFiscalFrom).Month.ToString() + "/01/" + DateTime.Parse(vFiscalFrom).Year.ToString();
        return vFiscalFrom;
    }
}
