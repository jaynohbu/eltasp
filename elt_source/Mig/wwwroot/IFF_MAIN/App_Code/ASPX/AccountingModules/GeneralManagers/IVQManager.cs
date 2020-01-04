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

public class IVQManager :Manager
{
    public IVQManager(string elt_acct)
        : base(elt_acct)
    {
        
    }
    /*********************************************************************
     * Method:getEntries
     * Todo:get all the invoice queue entries for a specific customer 
     *********************************************************************/
    public DataSet getEntriesForCustomer(int customer, string start, string end)
    {
        DataSet dsIVQ = new DataSet();

        SQL = "select newid() as row_id, 0 as is_selected, queue_id, '<input type=*checkbox* id=*'+ltrim(str(queue_id))+'_'+ltrim(str(bill_to_org_acct))+'*   onclick=*ajax_add_or_remove_selection(this)*  />'  as CheckBox, queue_id,inqueue_date,isnull(hawb_num,'') as hawb_num,isnull(mawb_num,'') as mawb_num, replace(bill_to,char(39),'`') as bill_to ,agent_shipper,bill_to_org_acct,agent_name,master_agent,master_only,air_ocean,isnull(agent_org_acct,0) as agent_org_acct,   CASE WHEN air_ocean='A'THEN '../../ASP/air_export/new_edit_hawb.asp?HAWB='+hawb_num " +
              " ELSE '../../ASP/ocean_export/new_edit_hbol.asp?hbol='+hawb_num End as url_hawb," +
              " CASE WHEN air_ocean='A'THEN '../../ASP/air_export/new_edit_mawb.asp?MAWB='+mawb_num" +
             " ELSE '../../ASP/ocean_export/new_edit_mbol.asp?BookingNum='+mawb_num End as url_mawb," +
             " is_dome from invoice_queue where  invoiced = 'N' and elt_account_number ='" + elt_account_number;

        if (start != "")
        {
            SQL += "' AND inqueue_date >='" + start + "'";
        }
        SQL += " and inqueue_date <= '" + end + "'";
       
        try
        {
            if (customer != 0)
            {
                SQL += " and bill_to_org_acct =" + customer + " ";
            }
            SQL += " order by inqueue_date, bill_to ";
            SqlDataAdapter adIVQ = new SqlDataAdapter(SQL, Con);
            adIVQ.Fill(dsIVQ);
            GeneralUtility util = new GeneralUtility();
            util.removeNull(ref dsIVQ,0);
            for (int i = 0; i < dsIVQ.Tables[0].Rows.Count; i++)
            {
                dsIVQ.Tables[0].Rows[i]["CheckBox"]=dsIVQ.Tables[0].Rows[i]["CheckBox"].ToString().Replace("*", "\"");
            }           
        }
        catch (Exception ex)
        {           
            throw ex;
        }

        dsIVQ.Tables[0].Columns.Add(new DataColumn("ETD", System.Type.GetType("System.String")));
        dsIVQ.Tables[0].Columns.Add(new DataColumn("ETA", System.Type.GetType("System.String")));
        dsIVQ.Tables[0].Columns.Add(new DataColumn("Consignee", System.Type.GetType("System.String")));
        dsIVQ.Tables[0].Columns.Add(new DataColumn("Shipper", System.Type.GetType("System.String")));
        dsIVQ.Tables[0].Columns.Add(new DataColumn("FILE", System.Type.GetType("System.String")));
        dsIVQ.Tables[0].Columns.Add(new DataColumn("GrossWeight", System.Type.GetType("System.Decimal")));
        dsIVQ.Tables[0].Columns.Add(new DataColumn("ChargeableWeight", System.Type.GetType("System.Decimal")));
        dsIVQ.Tables[0].Columns.Add(new DataColumn("Pieces", System.Type.GetType("System.Decimal")));
        dsIVQ.Tables[0].Columns.Add(new DataColumn("Origin", System.Type.GetType("System.String")));
        dsIVQ.Tables[0].Columns.Add(new DataColumn("Destination", System.Type.GetType("System.String")));
        dsIVQ.Tables[0].Columns.Add(new DataColumn("Carrier", System.Type.GetType("System.String")));
        

        
        return dsIVQ;
    }

    public void getHeaderInfoForSelection(ref DataSet dsIVQ)
    {
        OperationManager opMgr = new OperationManager(elt_account_number);

        for (int i = 0; i < dsIVQ.Tables[0].Rows.Count; i++)
        {
            if (dsIVQ.Tables[0].Rows[i]["is_selected"].ToString() == "1")
            {

                int Pieces = 0;
                Decimal GrossWeight = 0;
                Decimal ChargeableWeight = 0;
                string unit = "";
                GeneralUtility gUtil = new GeneralUtility();

                if (dsIVQ.Tables[0].Rows[i]["is_dome"].ToString() == "Y")
                {
                    dsIVQ.Tables[0].Rows[i]["air_ocean"] = "D";
                }

                if (dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString() != String.Empty && dsIVQ.Tables[0].Rows[i]["air_ocean"].ToString() == "A")
                {
                    dsIVQ.Tables[0].Rows[i]["ETD"] = opMgr.getETDFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "A");
                    dsIVQ.Tables[0].Rows[i]["ETA"] = opMgr.getETAFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "A");
                    dsIVQ.Tables[0].Rows[i]["FILE"] = opMgr.getFileNoFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "A");

                    dsIVQ.Tables[0].Rows[i]["Consignee"] = opMgr.getConsigneeFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "A");
                    dsIVQ.Tables[0].Rows[i]["Shipper"] = opMgr.getShipperFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "A");

                    dsIVQ.Tables[0].Rows[i]["Origin"] = opMgr.getOriginFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "A");
                    dsIVQ.Tables[0].Rows[i]["Destination"] = opMgr.getDestinationFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "A");
                    dsIVQ.Tables[0].Rows[i]["Carrier"] = opMgr.getCarrierFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "A");

                    opMgr.getWeightsAndPiecesFromOperation(ref Pieces, ref GrossWeight, ref ChargeableWeight, ref unit, dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "A");

                    try
                    {
                        dsIVQ.Tables[0].Rows[i]["Pieces"] = Pieces;
                    }
                    catch { }
                    try
                    {
                        dsIVQ.Tables[0].Rows[i]["GrossWeight"] = GrossWeight;
                    }
                    catch { }
                    try
                    {
                        dsIVQ.Tables[0].Rows[i]["ChargeableWeight"] = ChargeableWeight;
                    }
                    catch { }

                }

                if (dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString() != String.Empty && dsIVQ.Tables[0].Rows[i]["air_ocean"].ToString() == "O")
                {
                    dsIVQ.Tables[0].Rows[i]["ETD"] = opMgr.getETDFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "O");
                    dsIVQ.Tables[0].Rows[i]["ETA"] = opMgr.getETAFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "O");
                    dsIVQ.Tables[0].Rows[i]["FILE"] = opMgr.getFileNoFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "O");

                    dsIVQ.Tables[0].Rows[i]["Consignee"] = opMgr.getConsigneeFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "O");
                    dsIVQ.Tables[0].Rows[i]["Shipper"] = opMgr.getShipperFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "O");
                    dsIVQ.Tables[0].Rows[i]["Origin"] = opMgr.getOriginFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "O");
                    dsIVQ.Tables[0].Rows[i]["Destination"] = opMgr.getDestinationFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "O");
                    dsIVQ.Tables[0].Rows[i]["Carrier"] = opMgr.getCarrierFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "O");
                    opMgr.getWeightsAndPiecesFromOperation(ref Pieces, ref GrossWeight, ref  ChargeableWeight, ref unit, dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "O");
                    try
                    {
                        dsIVQ.Tables[0].Rows[i]["Pieces"] = Pieces;
                    }
                    catch { }
                    try
                    {
                        dsIVQ.Tables[0].Rows[i]["GrossWeight"] = GrossWeight;
                    }
                    catch { }
                    try
                    {
                        dsIVQ.Tables[0].Rows[i]["ChargeableWeight"] = ChargeableWeight;
                    }
                    catch { }

                }
                if (dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString() != String.Empty && dsIVQ.Tables[0].Rows[i]["air_ocean"].ToString() == "A")
                {

                    dsIVQ.Tables[0].Rows[i]["Consignee"] = opMgr.getConsigneeFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "A");
                    dsIVQ.Tables[0].Rows[i]["Shipper"] = opMgr.getShipperFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "A");
                    dsIVQ.Tables[0].Rows[i]["Origin"] = opMgr.getOriginFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "A");
                    dsIVQ.Tables[0].Rows[i]["Destination"] = opMgr.getDestinationFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "A");
                    dsIVQ.Tables[0].Rows[i]["Carrier"] = opMgr.getCarrierFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "A");
                    opMgr.getWeightsAndPiecesFromOperation(ref Pieces, ref GrossWeight, ref ChargeableWeight, ref unit, dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "A");
                    try
                    {
                        dsIVQ.Tables[0].Rows[i]["Pieces"] = Pieces;
                    }
                    catch { }
                    try
                    {
                        dsIVQ.Tables[0].Rows[i]["GrossWeight"] = GrossWeight;
                    }
                    catch { }
                    try
                    {
                        dsIVQ.Tables[0].Rows[i]["ChargeableWeight"] = ChargeableWeight;
                    }
                    catch { }

                }

                if (dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString() != String.Empty && dsIVQ.Tables[0].Rows[i]["air_ocean"].ToString() == "O")
                {
                    dsIVQ.Tables[0].Rows[i]["Consignee"] = opMgr.getConsigneeFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "O");
                    dsIVQ.Tables[0].Rows[i]["Shipper"] = opMgr.getShipperFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "O");
                    dsIVQ.Tables[0].Rows[i]["Origin"] = opMgr.getOriginFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "O");
                    dsIVQ.Tables[0].Rows[i]["Destination"] = opMgr.getDestinationFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "O");
                    dsIVQ.Tables[0].Rows[i]["Carrier"] = opMgr.getCarrierFromOperation(dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "O");
                    opMgr.getWeightsAndPiecesFromOperation(ref Pieces, ref GrossWeight, ref ChargeableWeight, ref unit, dsIVQ.Tables[0].Rows[i]["mawb_num"].ToString(), dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString(), "O");
                    try
                    {
                        dsIVQ.Tables[0].Rows[i]["Pieces"] = Pieces;
                    }
                    catch { }
                    try
                    {
                        dsIVQ.Tables[0].Rows[i]["GrossWeight"] = GrossWeight;
                    }
                    catch { }
                    try
                    {
                        dsIVQ.Tables[0].Rows[i]["ChargeableWeight"] = ChargeableWeight;
                    }
                    catch { }

                }
                if (dsIVQ.Tables[0].Rows[i]["hawb_num"].ToString() == "CONSOLIDATION")
                {
                    //dsIVQ.Tables[0].Rows[i]["Consignee"] = "";
                    //dsIVQ.Tables[0].Rows[i]["Shipper"] = "";
                    //dsIVQ.Tables[0].Rows[i]["Origin"] = "";
                    //dsIVQ.Tables[0].Rows[i]["Destination"] = "";
                    //dsIVQ.Tables[0].Rows[i]["Carrier"] = "";
                    //dsIVQ.Tables[0].Rows[i]["ETD"] = "";
                    //dsIVQ.Tables[0].Rows[i]["ETA"] = "";
                    //dsIVQ.Tables[0].Rows[i]["FILE"] = "";
                }
            }
        }           

    }

    public bool updateIVQRecord(IVQRecord IVQ)
    {
        IVQ.replaceQuote();
        SQL = "update invoice_queue set ";       
        SQL += "invoiced= '" + IVQ.Invoiced + "' ";
        SQL += " WHERE elt_account_number = " + elt_account_number + " and queue_id="
        + IVQ.Queue_id;

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
        Con.Close();
        return true;       
    }


    public string debugQuery()
    {
        return SQL;
    }

    public bool deleteIVQRecord(IVQRecord IVQ)
    {
        SQL = "delete from invoice_queue  ";      
        SQL += " WHERE elt_account_number = " + elt_account_number + " and queue_id="
        + IVQ.Queue_id;

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
        Con.Close();
        return true;   
    }
}