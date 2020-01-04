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
/// Summary description for HAWBTracker
/// </summary>
public class HAWBTracker
{
    private string ConnectStr;
    private string elt_account_number;
    private DataSet ds;

    public HAWBTracker(string elt_account_number, string ConnectStr)
    {
        this.ConnectStr = ConnectStr;
        this.elt_account_number = elt_account_number;
    }

    public DataSet trackDoc(string refNo, string timeStart, string timeEnd)
    {
        MAWBsTrack MBs = new MAWBsTrack(elt_account_number, ConnectStr);
        HAWBsTrack HAWBs = new HAWBsTrack(elt_account_number, ConnectStr);
        IVsTrack IVs = new IVsTrack(elt_account_number, ConnectStr);
        RPsTrack RPs = new RPsTrack(elt_account_number, ConnectStr);
        int MAWB_count = 0;
        int HAWB_count = 0;
        int iv_count = 0;
        int rp_count = 0;
        ds = new DataSet();
        //---------------------------------------------------------------------------------------
        DataTable dtMAWB = new DataTable();
        dtMAWB.TableName = "MAWB";

        dtMAWB.Columns.Add(new DataColumn("Primary"));
        dtMAWB.Columns.Add(new DataColumn("IE"));
        dtMAWB.Columns.Add(new DataColumn("MAWB#"));
        dtMAWB.Columns.Add(new DataColumn("Date Issued"));
        DataColumn[] keys = new DataColumn[1];
        keys[0] = dtMAWB.Columns[0];
        dtMAWB.PrimaryKey = keys;


        //---------------------------------------------------------------------------------------
        DataTable dtHAWB = new DataTable();
        dtHAWB.TableName = "HAWB";
        dtHAWB.Columns.Add(new DataColumn("Primary"));
        dtHAWB.Columns.Add(new DataColumn("Foreign"));
        dtHAWB.Columns.Add(new DataColumn("IE"));
        dtHAWB.Columns.Add(new DataColumn("MAWB#"));
        dtHAWB.Columns.Add(new DataColumn("HAWB#"));
        dtHAWB.Columns.Add(new DataColumn("Date Issued"));
        keys = new DataColumn[1];
        keys[0] = dtHAWB.Columns[0];
        dtHAWB.PrimaryKey = keys;

        //---------------------------------------------------------------------------------------
        DataTable dtIVs = new DataTable();
        dtIVs.TableName = "IV";
        dtIVs.Columns.Add(new DataColumn("Primary"));
        dtIVs.Columns.Add(new DataColumn("Foreign"));
        dtIVs.Columns.Add(new DataColumn("IE"));
        dtIVs.Columns.Add(new DataColumn("MAWB#"));
        dtIVs.Columns.Add(new DataColumn("HAWB#"));
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


        DataTable dtHAWB_Tmp;
        if (refNo != "")
        {
            dtHAWB_Tmp = HAWBs.getHAWB(refNo);
        }
        else
        {
            dtHAWB_Tmp = HAWBs.getHAWBsDuring(timeStart, timeEnd);
        }

        for (int i = 0; i < dtHAWB_Tmp.Rows.Count; i++)
        {
            string mbString = dtHAWB_Tmp.Rows[i]["MAWB#"].ToString();
            DataTable dtMAWB_Tmp = new DataTable();
         
            if (mbString != "")
            {
               dtMAWB_Tmp = MBs.getMAWB(mbString);
            }
            DataRow newRow = dtMAWB.NewRow();
            if (dtMAWB_Tmp.Rows.Count != 0)
            {
                newRow.ItemArray = dtMAWB_Tmp.Rows[0].ItemArray;
            }
            newRow["Primary"] = MAWB_count;
            dtMAWB.Rows.Add(newRow);


            DataRow HAWB_row = dtHAWB.NewRow();
            HAWB_row.ItemArray = dtHAWB_Tmp.Rows[i].ItemArray;
            HAWB_row["Foreign"] = MAWB_count;
            HAWB_row["Primary"] = HAWB_count++;

            dtHAWB.Rows.Add(HAWB_row);
            MAWB_count++;
        }
        for (int j = 0; j < dtHAWB.Rows.Count; j++)
        {
            string hbString = dtHAWB.Rows[j]["HAWB#"].ToString();
            DataTable dtTempIVs  = new DataTable();
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
        ds.Tables.Add(dtMAWB);
        ds.Tables.Add(dtHAWB);
        ds.Tables.Add(dtIVs);
        ds.Tables.Add(dtRP);
        ds.Relations.Add(new DataRelation("MAWB_TO_HAWB", dtMAWB.Columns["Primary"], dtHAWB.Columns["Foreign"]));
        ds.Relations.Add(new DataRelation("HAWB_TO_IV", dtHAWB.Columns["Primary"], dtIVs.Columns["Foreign"]));
        ds.Relations.Add(new DataRelation("IV_TO_RP", dtIVs.Columns["Primary"], dtRP.Columns["Foreign"]));

        return ds;
    }

}
