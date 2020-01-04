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
/// Summary description for MBOLTracker
/// </summary>
public class MBOLTracker
{
    private string ConnectStr;
    private string elt_account_number;
    private DataSet ds;

    public MBOLTracker(string elt_account_number, string ConnectStr)
    {
        this.ConnectStr = ConnectStr;
        this.elt_account_number = elt_account_number;
    }

    public DataSet trackDoc(string refNo, string timeStart, string timeEnd)
    {
        MBOLsTrack MBs = new MBOLsTrack(elt_account_number, ConnectStr);
        HBOLsTrack HBOLs = new HBOLsTrack(elt_account_number, ConnectStr);
        IVsTrack IVs = new IVsTrack(elt_account_number, ConnectStr);
        RPsTrack RPs = new RPsTrack(elt_account_number, ConnectStr);
        int MBOL_count = 0;
        int HBOL_count = 0;
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

        DataTable dtMBOL_Tmp;
        if (refNo != "")
        {
            dtMBOL_Tmp = MBs.getMBOL(refNo);
        }
        else
        {
            dtMBOL_Tmp = MBs.getMBOLsDuring(timeStart, timeEnd);
        }


        foreach (DataRow dr in dtMBOL_Tmp.Rows)
        {
            DataRow newRow = dtMBOL.NewRow();
            newRow.ItemArray = dr.ItemArray;
            newRow["Primary"] = MBOL_count++;
            dtMBOL.Rows.Add(newRow);
        }

        //dtMBOL.Merge(dtMBOL_Tmp);

        if (dtMBOL.Rows.Count > 0)
        {
            for (int i = 0; i < dtMBOL.Rows.Count; i++)
            {
                DataTable dtHBOL_Tmp = new DataTable();
                string mbString1 = dtMBOL.Rows[i]["MBOL#"].ToString();
                if (mbString1 != "")
                {
                    dtHBOL_Tmp = HBOLs.getHBOLsByMBOL(mbString1);
                }

                if (dtHBOL_Tmp.Rows.Count == 0)
                {
                    string mbString = dtMBOL.Rows[i]["MBOL#"].ToString();
                    DataTable dtTempIVs = new DataTable(); ;
                    if (mbString != "")
                    {
                        dtTempIVs = IVs.getIVsByMB_Ocean(mbString);
                    }
                    DataRow HBOL_row = dtHBOL.NewRow();
                    HBOL_row["Foreign"] = i.ToString();
                    HBOL_row["Primary"] = HBOL_count;
                    dtHBOL.Rows.Add(HBOL_row);

                    if (dtTempIVs.Rows.Count > 0)
                    {

                        string ivNo = "";
                        DataTable dtRP_Tmp;
                        foreach (DataRow dr in dtTempIVs.Rows)
                        {
                            DataRow iv_row = dtIVs.NewRow();
                            iv_row.ItemArray = dr.ItemArray;
                            iv_row["Foreign"] = HBOL_count;
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
                    HBOL_count++;
                }
                else
                {

                    for (int j = 0; j < dtHBOL_Tmp.Rows.Count; j++)
                    {
                        DataRow HBOL_row = dtHBOL.NewRow();
                        HBOL_row.ItemArray = dtHBOL_Tmp.Rows[j].ItemArray;
                        HBOL_row["Foreign"] = i.ToString();
                        HBOL_row["Primary"] = HBOL_count;
                        dtHBOL.Rows.Add(HBOL_row);

                        string hbstring = dtHBOL_Tmp.Rows[j]["HBOL#"].ToString();
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

                                iv_row["Foreign"] = HBOL_count;
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
                        HBOL_count++;
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
        return ds;
    }
}
