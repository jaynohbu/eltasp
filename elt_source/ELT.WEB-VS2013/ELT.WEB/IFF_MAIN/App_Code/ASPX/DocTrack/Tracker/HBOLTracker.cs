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
/// Summary description for HBOLTracker
/// </summary>
public class HBOLTracker
{
    private string ConnectStr;
    private string elt_account_number;
    private DataSet ds;

    public HBOLTracker(string elt_account_number, string ConnectStr)
    {
        this.ConnectStr=ConnectStr;
        this.elt_account_number=elt_account_number;
    }


    public DataSet trackDoc(string refNo, string timeStart, string timeEnd)
    {
        MBOLsTrack MBs = new MBOLsTrack(elt_account_number, ConnectStr);
        HBOLsTrack HBOLs = new HBOLsTrack(elt_account_number, ConnectStr);
        IVsTrack IVs = new IVsTrack(elt_account_number, ConnectStr);
        RPsTrack RPs = new RPsTrack(elt_account_number, ConnectStr);
        int mbol_count = 0;
        int hbol_count = 0;
        int iv_count = 0;
        int rp_count = 0;
        ds = new DataSet();

        //---------------------------------------------------------------------------------------
        DataTable dtMBOL = new DataTable();
        dtMBOL.TableName = "MBOL";
        dtMBOL.Columns.Add(new DataColumn("Primary"));
        dtMBOL.Columns.Add(new DataColumn("IE"));
        dtMBOL.Columns.Add(new DataColumn("MBOL#"));
        dtMBOL.Columns.Add(new DataColumn("Date Issued"));
        DataColumn[] keys = new DataColumn[1];
        keys[0] = dtMBOL.Columns[0];
        dtMBOL.PrimaryKey = keys;


        //---------------------------------------------------------------------------------------
        DataTable dtHBOL = new DataTable();
        dtHBOL.TableName = "HBOL";
        dtHBOL.Columns.Add(new DataColumn("Primary"));
        dtHBOL.Columns.Add(new DataColumn("Foreign"));
        dtHBOL.Columns.Add(new DataColumn("IE"));
        dtHBOL.Columns.Add(new DataColumn("MBOL#"));
        dtHBOL.Columns.Add(new DataColumn("HBOL#"));
        dtHBOL.Columns.Add(new DataColumn("Date Issued"));
        keys = new DataColumn[1];
        keys[0] = dtHBOL.Columns[0];
        dtHBOL.PrimaryKey = keys;

        //---------------------------------------------------------------------------------------
        DataTable dtIVs = new DataTable();
        dtIVs.TableName = "IV";
        dtIVs.Columns.Add(new DataColumn("Primary"));
        dtIVs.Columns.Add(new DataColumn("Foreign"));
        dtIVs.Columns.Add(new DataColumn("IE"));
        dtIVs.Columns.Add(new DataColumn("MBOL#"));
        dtIVs.Columns.Add(new DataColumn("HBOL#"));
        dtIVs.Columns.Add(new DataColumn("IV#", System.Type.GetType("System.Decimal")));
        dtIVs.Columns.Add(new DataColumn("Date Issued"));
        keys = new DataColumn[1];
        keys[0] = dtIVs.Columns[0];
        dtIVs.PrimaryKey = keys;

        //---------------------------------------------------------------------------------------
        DataTable dtRP = new DataTable();
        dtRP.TableName = "RP";
        dtRP.Columns.Add(new DataColumn("Primary"));
        dtRP.Columns.Add(new DataColumn("Foreign"));
        dtRP.Columns.Add(new DataColumn("RP#"));      
        dtRP.Columns.Add(new DataColumn("Date Issued"));      
        dtRP.Columns.Add(new DataColumn("Paid"));
        keys = new DataColumn[1];
        keys[0] = dtRP.Columns[0];
        dtRP.PrimaryKey = keys;
        //---------------------------------------------------------------------------------------


        DataTable dtHBOL_Tmp;
        if (refNo != "")
        {
            dtHBOL_Tmp = HBOLs.getHBOL(refNo);
        }
        else
        {
            dtHBOL_Tmp = HBOLs.getHBOLsDuring(timeStart, timeEnd);
        }

        for (int i = 0; i < dtHBOL_Tmp.Rows.Count; i++)
        {
            string mbString = dtHBOL_Tmp.Rows[i]["MBOL#"].ToString();
            DataTable dtMBOL_Tmp=new DataTable();
            if (mbString != "")
            {
                dtMBOL_Tmp = MBs.getMBOL(mbString);
            }
            DataRow newRow = dtMBOL.NewRow();            
            if (dtMBOL_Tmp.Rows.Count != 0)
            {
                newRow.ItemArray = dtMBOL_Tmp.Rows[0].ItemArray;
            }
            newRow["Primary"] = mbol_count;
            dtMBOL.Rows.Add(newRow);


            DataRow hbol_row = dtHBOL.NewRow();
            hbol_row.ItemArray = dtHBOL_Tmp.Rows[i].ItemArray;
            hbol_row["Foreign"] = mbol_count;
            hbol_row["Primary"] = hbol_count++;
            
            dtHBOL.Rows.Add(hbol_row);
            mbol_count++;
        }
        for (int j = 0; j < dtHBOL.Rows.Count; j++)
        {
            string hbString = dtHBOL.Rows[j]["HBOL#"].ToString();
            DataTable dtTempIVs = new DataTable();
           
           if (hbString != "")
           {
               dtTempIVs = IVs.getIVsByHB_Ocean(hbString);
           }
            string ivNo = "";
            DataTable dtRP_Tmp;

            if (dtTempIVs.Rows.Count > 0)
            {
                foreach (DataRow dr in dtTempIVs.Rows)
                {
                    DataRow iv_row = dtIVs.NewRow();
                    iv_row.ItemArray = dr.ItemArray;
                    iv_row["Foreign"] = j;
                    iv_row["Primary"] = iv_count;
                    dtIVs.Rows.Add(iv_row);
                    ivNo = dr["IV#"].ToString();
                    dtRP_Tmp = new DataTable();
                    if (ivNo != "")
                    {
                        dtRP_Tmp = RPs.getRPsByIV(ivNo);
                    }

                    if (dtRP_Tmp.Rows.Count > 0)
                    {
                        foreach (DataRow dr2 in dtRP_Tmp.Rows)
                        {
                            DataRow rp_row = dtRP.NewRow();
                            rp_row.ItemArray = dr2.ItemArray;
                            rp_row["Foreign"] = iv_count;
                            rp_row["Primary"] = rp_count++;
                            dtRP.Rows.Add(rp_row);
                        }
                    }
                    iv_count++;
                }
            }           
        }

        ds.Tables.Add(dtMBOL);
        ds.Tables.Add(dtHBOL);
        ds.Tables.Add(dtIVs);
        ds.Tables.Add(dtRP);
        ds.Relations.Add(new DataRelation("MBOL_TO_HBOL", dtMBOL.Columns["Primary"], dtHBOL.Columns["Foreign"]));
        ds.Relations.Add(new DataRelation("HBOL_TO_IV", dtHBOL.Columns["Primary"], dtIVs.Columns["Foreign"]));
        ds.Relations.Add(new DataRelation("IV_TO_RP", dtIVs.Columns["Primary"], dtRP.Columns["Foreign"]));

        return ds;

       
    }
       
}
