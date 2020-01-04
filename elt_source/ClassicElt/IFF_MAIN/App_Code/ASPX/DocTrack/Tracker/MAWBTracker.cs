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
/// Summary description for MAWBTracker
/// </summary>
public class MAWBTracker
{
    private string ConnectStr;
    private string elt_account_number;
    private DataSet ds;

    public MAWBTracker(string elt_account_number, string ConnectStr)
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

        DataTable dtMAWB_Tmp;
        if (refNo != "")
        {
            dtMAWB_Tmp = MBs.getMAWB(refNo);
        }
        else
        {
            dtMAWB_Tmp = MBs.getMAWBsDuring(timeStart, timeEnd);
        }


        foreach (DataRow dr in dtMAWB_Tmp.Rows)
        {
            DataRow newRow = dtMAWB.NewRow();
            newRow.ItemArray = dr.ItemArray;
            newRow["Primary"] = MAWB_count++;
            dtMAWB.Rows.Add(newRow);
        }

        //dtMAWB.Merge(dtMAWB_Tmp);

        if (dtMAWB.Rows.Count > 0)
        {
            for (int i = 0; i < dtMAWB.Rows.Count; i++)
            {
                DataTable dtHAWB_Tmp=new DataTable();
                string mbString1 = dtMAWB.Rows[i]["MAWB#"].ToString();
                if (mbString1 != "")
                {
                    dtHAWB_Tmp = HAWBs.getHAWBsByMAWB(mbString1);
                }

                if (dtHAWB_Tmp.Rows.Count == 0)
                {
                    string mbString = dtMAWB.Rows[i]["MAWB#"].ToString();
                    DataTable dtTempIVs = new DataTable(); ;
                    if (mbString != "")
                    {
                        dtTempIVs = IVs.getIVsByMB_Ocean(mbString);
                    }
                    DataRow HAWB_row = dtHAWB.NewRow();
                    HAWB_row["Foreign"] = i.ToString();
                    HAWB_row["Primary"] = HAWB_count;
                    dtHAWB.Rows.Add(HAWB_row);

                    if (dtTempIVs.Rows.Count > 0)
                    {
                        
                        string ivNo = "";
                        DataTable dtRP_Tmp;
                        foreach (DataRow dr in dtTempIVs.Rows)
                        {
                            DataRow iv_row = dtIVs.NewRow();
                            iv_row.ItemArray = dr.ItemArray;
                            iv_row["Foreign"] = HAWB_count;
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
                    HAWB_count++;
                }
                else
                {

                    for (int j = 0; j < dtHAWB_Tmp.Rows.Count; j++)
                    {
                        DataRow HAWB_row = dtHAWB.NewRow();
                        HAWB_row.ItemArray = dtHAWB_Tmp.Rows[j].ItemArray;
                        HAWB_row["Foreign"] = i.ToString();
                        HAWB_row["Primary"] = HAWB_count;
                        dtHAWB.Rows.Add(HAWB_row);

                        string hbstring = dtHAWB_Tmp.Rows[j]["HAWB#"].ToString();
                        DataTable dtTempIVs = new DataTable(); ;
                        if (hbstring != "")
                        {
                           dtTempIVs = IVs.getIVsByHB_Ocean(hbstring);
                        }
                        string ivNo = "";
                        DataTable dtRP_Tmp;

                        if (dtTempIVs.Rows.Count > 0)
                        {
                            foreach (DataRow dr in dtTempIVs.Rows)
                            {
                                DataRow iv_row = dtIVs.NewRow();
                                iv_row.ItemArray = dr.ItemArray;

                                iv_row["Foreign"] = HAWB_count;
                                iv_row["Primary"] = iv_count;
                                dtIVs.Rows.Add(iv_row);
                                dtRP_Tmp = new DataTable();
                                ivNo = dr["IV#"].ToString();
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
                        HAWB_count++;
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
        return ds;
    }
}
