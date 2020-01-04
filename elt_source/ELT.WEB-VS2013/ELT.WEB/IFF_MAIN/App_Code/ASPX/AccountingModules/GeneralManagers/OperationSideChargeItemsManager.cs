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
/// Summary description for OperationSideItemsManager
/// </summary>
public class OperationSideChargeItemsManager:Manager
{
    private DataSet dsChItems;
    private int defaultAF, defaultOF, defaultDF;
    private string defaultAFDesc, defaultOFDesc, defaultDFDesc;
    private ELTUserProfileManager userProfile;
    GeneralUtility gUtil;
    
    private GLManager GLMgr;
    
    public OperationSideChargeItemsManager(string elt_acct)
        : base(elt_acct)
	{
        GLMgr = new GLManager(elt_account_number);
       
        userProfile = new ELTUserProfileManager(elt_account_number);
        userProfile.getDefaultAirFreightCharge(ref defaultAF, ref defaultAFDesc);
        if (defaultAF == -1)
        {
            GLMgr.setDefaultAFChargeAcct();
            userProfile.getDefaultAirFreightCharge(ref defaultAF, ref defaultAFDesc);
        }
        userProfile.getDefaultOceanFreightCharge(ref defaultOF, ref defaultOFDesc);
        if (defaultOF == -1)
        {
            GLMgr.setDefaultOFChargeAcct();
            userProfile.getDefaultOceanFreightCharge(ref defaultOF, ref defaultOFDesc);
        }

        userProfile.getDefaultDomesticFreightCharge(ref defaultDF, ref defaultDFDesc);
        if (defaultDF == -1)
        {
            GLMgr.setDefaultDFChargeAcct();
            userProfile.getDefaultDomesticFreightCharge(ref defaultDF, ref defaultDFDesc);
        }

        Con = new SqlConnection(ConnectStr);
        SQL = "";   
        gUtil=  new GeneralUtility();
	}

    


   /*****************************************************************************
    * Method:getFreightChargeItemsFromWaybill()
    * Todo:Takes a list of Invoice queue records for a customer, 
    * and delegate them to the sub  funtions according to the type of way bill to 
    * get all the freight charges for the list.
    * -Master only: get FC on master waybill.
    * -CONSOLIDATION HB is for invoice issued to an agent
    * -A house waybill has one FC item
    ******************************************************************************/

    public DataSet getChargeItemsFromWaybill(ArrayList qRecords)
    {
        DataSet dsFC, dsOC;

        dsFC = getFreightChargeItemsFromWaybill(qRecords);
        for (int i = 0; i < dsFC.Tables[0].Rows.Count; i++)
        {
            if (dsFC.Tables[0].Rows[i]["hb"].ToString() == "CONSOLIDATION")
            {
                dsFC.Tables[0].Rows[i]["description"] = dsFC.Tables[0].Rows[i]["description"].ToString() + "--HAWB:" + dsFC.Tables[0].Rows[i]["hb"].ToString();
            }
        }
        gUtil.removeNull(ref dsFC,0);
        dsOC = getOtherChargeItemsFromWaybill(qRecords);
        gUtil.removeNull(ref dsOC,0);


        if (dsFC.Tables[0].Rows.Count > 0 && dsOC.Tables[0].Rows.Count > 0)
        {
            for (int i = 0; i < dsOC.Tables[0].Rows.Count; i++)
            {
                DataRow dr = dsFC.Tables[0].NewRow();
                dr["row_id"] = dsOC.Tables[0].Rows[i]["row_id"].ToString();
                dr["url"] = dsOC.Tables[0].Rows[i]["url"].ToString();
                dr["hb"] = dsOC.Tables[0].Rows[i]["hb"].ToString();
                dr["item_no"] = dsOC.Tables[0].Rows[i]["item_no"].ToString();
                dr["item_id"] = dsOC.Tables[0].Rows[i]["item_no"].ToString();
                dr["mb"] = dsOC.Tables[0].Rows[i]["mb"].ToString();
                dr["waybill_type"] = dsOC.Tables[0].Rows[i]["waybill_type"].ToString();
                dr["amount"] = Decimal.Parse(dsOC.Tables[0].Rows[i]["amount"].ToString());
               
                dr["description"] = dsOC.Tables[0].Rows[i]["description"].ToString();
               
                dr["import_export"] = dsOC.Tables[0].Rows[i]["import_export"].ToString();
                dsFC.Tables[0].Rows.Add(dr);
            }
        }
        else if (dsFC.Tables[0].Rows.Count > 0)
        {
            return dsFC;
        }
        else if (dsOC.Tables[0].Rows.Count > 0)
        {

            return dsOC;
        }
        return dsFC;

    }



   

    private DataSet getFreightChargeItemsFromWaybill(ArrayList qRecords)
    {
        dsChItems = new DataSet();
        dsChItems.Tables.Add(new DataTable());
        for (int i = 0; i < qRecords.Count; i++)
        {
            string MB = ((IVQRecord)qRecords[i]).Mawb_num;
            string HB = ((IVQRecord)qRecords[i]).Hawb_num;
            int AgentNo = ((IVQRecord)qRecords[i]).Agent_org_acct;
            string Shipper_Agent = ((IVQRecord)qRecords[i]).Agent_shipper;
            string isMasterOnly = ((IVQRecord)qRecords[i]).Master_only;
            string AO = ((IVQRecord)qRecords[i]).Air_ocean;            
            DataTable dtTemp;
          
            if (isMasterOnly == "Y")
            {
                dtTemp= getFreightChargeItemFromMasterOnlyWaybill(MB, Shipper_Agent, AO);
            }
            else
            {
                if (HB == "CONSOLIDATION")// multiple HB's issued to an agent 
                {
                    dtTemp= getFreightCharegeItemsFromMultipleHBsForIVtoAgent( MB, AgentNo, AO);

                    for (int k = 0; k < dtTemp.Rows.Count;k++ )
                    {
                        dtTemp.Rows[k]["description"] = dtTemp.Rows[k]["description"].ToString() + "--HAWB:" + dtTemp.Rows[k]["hb"].ToString();
                    }
                }
                else
                {
                    dtTemp = getFreightChargeItemFromHB(MB, HB, AO, Shipper_Agent, AgentNo);
                }
            }
            try
            {
                dsChItems.Tables[0].Merge(dtTemp);
            }
            catch (Exception ex)
            {
                throw ex;
            }
           
        }
        return dsChItems;
    }
    /*****************************************************************************
    * Method:getFreightChargeItemFromMasterOnlyWaybill()
    * Todo:GetFC for the master waybill for shipper/consignee :'A' here stands for 
    * Consignee not Agent (DB design fault) 
    ******************************************************************************/
    private DataTable getFreightChargeItemFromMasterOnlyWaybill( string MB, string Shipper_Agent, string AO)
    {
        string SQL;
        string payOption;
        DataTable dt = new DataTable();
        if (AO == "A")
        {
            if (Shipper_Agent == "S")
            {
                payOption = "PPO_1='Y'";// this is for  MB's shipper
            }
            else// THIS WILL NOT BE REACHED --> DIRECT SHIPMENT CANNOT INVOICE TO AGENT
            {
                payOption = "COLL_1='Y'";// this is for MB's consignee
            }
            SQL = "select 'E' as import_export, newid() as row_id,-1 as item_id, '../../../ASP/air_export/new_edit_mawb.asp?MAWB='+mawb_num as url,  mawb_num as mb," + defaultAF + " as item_no,'" + defaultAFDesc + "' as description," + " '' as hb, 'MAWB'as waybill_type, Total_Weight_Charge_HAWB as amount from mawb_master where elt_account_number = " + elt_account_number + " and mawb_num='" + MB + "' and " + payOption;
        }
        else
        {
            if (Shipper_Agent == "S")
            {
                payOption = "weight_cp='P'";// this is for  MB's shipper
            }
            else // THIS WILL NOT BE REACHED--> DIRECT SHIPMENT CANNOT INVOICE TO AGENT
            {
                payOption = "weight_cp='C'";// this is for MB's consignee
            }
            SQL = "select 'E' as import_export,  newid() as row_id,-1 as item_id, '../../../ASP/ocean_export/new_edit_mbol.asp?BookingNum='+booking_num as url, booking_num as mb," + defaultOF + " as item_no,'" + defaultOFDesc + "' as description," + "'' as hb,'MBOL'as waybill_type, Total_Weight_Charge as amount from mbol_master where elt_account_number = " + elt_account_number + " and booking_num='" + MB + "' and " + payOption;		
        }
        try
        {
           // SQL = SQL;
            SqlDataAdapter adChItems = new SqlDataAdapter(SQL, Con);
            adChItems.Fill(dt);
            GeneralUtility util = new GeneralUtility();
            util.removeNull(ref dt);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return dt;
    }


   /*****************************************************************************
   * Method:getFreightCharegeItemsFromMultipleHBsForIVtoAgent()
   * Todo:Get FC from multiple House bills issued to an Agent 
   ******************************************************************************/
    private DataTable getFreightCharegeItemsFromMultipleHBsForIVtoAgent(string MB, int AgentNo, string AO)
    {       
        string SQL;
        DataTable dt = new DataTable();
        if (AO == "A")
        {
            SQL = "select 'E' as import_export, newid() as row_id,-1 as item_id, '../../../ASP/air_export/new_edit_hawb.asp?HAWB='+hawb_num as url, hawb_num as hb," + defaultAF + " as item_no,'" + defaultAFDesc + "' as description,'" + MB + "' as mb, 'HAWB'as waybill_type, Total_Weight_Charge_HAWB as amount";
			SQL += " from HAWB_master ";
            SQL += " where ((( isnull(is_master,'N')='Y' or isnull(is_sub,'N')='Y')";
            SQL += " and isnull(is_invoice_queued,'Y') <> 'N')";
            SQL += " or (( isnull(is_master,'N')='N' and isnull(is_sub,'N')='N')))";
            SQL += " and Total_Weight_Charge_HAWB > 0";
            SQL += " and  elt_account_number = " + elt_account_number;              
            SQL += " and MAWB_NUM='" + MB + "'";
            SQL += " and agent_no=" +AgentNo;
            SQL += " and " + "COLL_1='Y'"; 
            SQL += " order by HAWB_NUM";
         
        }
        else
        {
            SQL = "select 'E' as import_export, newid() as row_id,-1 as item_id, '../../../ASP/ocean_export/new_edit_hbol.asp?hbol='+hbol_num as url, hbol as hb," + defaultOF + " as item_no,'" + defaultOFDesc + "' as description,'" + MB + "'  as mb, 'HBOL'as waybill_type, Total_Weight_Charge as amount,hbol_num,shipper_acct_num ";
			SQL+=" from hbol_master ";
			SQL+=" where ((( isnull(is_master,'N')='Y' or isnull(is_sub,'N')='Y')";
			SQL+=" and isnull(is_invoice_queued,'Y') <> 'N')";
            SQL+=" OR (( isnull(is_master,'N')='N' and isnull(is_sub,'N')='N')))";
            SQL+= " and elt_account_number = " +elt_account_number;
            SQL+= " and booking_num='" + MB + "'";
            SQL+= " and agent_no=" + AgentNo +" and weight_cp='C' order by hbol_num";
         
        }
        try
        {
           // SQL = SQL;
            SqlDataAdapter adChItems = new SqlDataAdapter(SQL, Con);            
            adChItems.Fill(dt);
            GeneralUtility util = new GeneralUtility();
            util.removeNull(ref dt);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return dt;
    }


    /*****************************************************************************
     * Method:getFreightChargeItemFromHB()
     * Todo:Get FC for a HB belong to an MB for Shipper only 
     * (Agent Invoice is taken cared by getFreightCharegeItemsFromMultipleHBsForIVtoAgent)
     ******************************************************************************/
    private DataTable getFreightChargeItemFromHB(string MB, string HB, string AO, string Shipper_Agent, int agent_no)
    {
        string SQL;
        DataTable dt = new DataTable();

        if (Shipper_Agent == "A")
        {
            if (AO == "A")
            {
                SQL = "select 'E' as import_export, newid() as row_id,-1 as item_id, '../../../ASP/air_export/new_edit_hawb.asp?HAWB='+ hawb_num as url, hawb_num as hb," + defaultAF + " as item_no,'" + defaultAFDesc + "' as description,'" + MB + "' as mb, 'HAWB'as waybill_type, Total_Weight_Charge_HAWB as amount";
                SQL += " from HAWB_master ";
                SQL += " where ((( isnull(is_master,'N')='Y' or isnull(is_sub,'N')='Y')";
                SQL += " and isnull(is_invoice_queued,'Y') <> 'N')";
                SQL += " OR (( isnull(is_master,'N')='N' and isnull(is_sub,'N')='N')))";
                SQL += " and Total_Weight_Charge_HAWB > 0";
                SQL += " and  elt_account_number = " + elt_account_number;
                SQL += " and MAWB_NUM='" + MB + "'";
                SQL += " and HAWB_NUM='" + HB + "'";
                SQL += " and COLL_1='Y'";
                SQL += " order by HAWB_NUM";

            }
            else if (AO == "O")
            {
                SQL = "select 'E' as import_export, newid() as row_id,-1 as item_id, '../../../ASP/ocean_export/new_edit_hbol.asp?hbol='+ hbol_num as url, hbol_num as hb," + defaultOF + " as item_no,'" + defaultOFDesc + "' as description,'" + MB + "' as mb,  'HBOL'as waybill_type, Total_Weight_Charge as amount";
                SQL += " from hbol_master ";
                SQL += " where ((( isnull(is_master,'N')='Y' or isnull(is_sub,'N')='Y')";
                SQL += " and isnull(is_invoice_queued,'Y') <> 'N')";
                SQL += " OR (( isnull(is_master,'N')='N' and isnull(is_sub,'N')='N')))";
                SQL += " and elt_account_number = " + elt_account_number;
                SQL += " and booking_num='" + MB + "'";
                SQL += " and hbol_num='" + HB + "' and weight_cp='C' order by hbol_num";

            }
            else
            {
                SQL = "select 'E' as import_export, newid() as row_id,-1 as item_id, '../../../ASP/air_export/new_edit_hawb.asp?HAWB='+ hawb_num as url, hawb_num as hb," + defaultDF + " as item_no,'" + defaultDFDesc + "' as description,'" + MB + "' as mb, 'DOMESTIC'as waybill_type, Total_Weight_Charge_HAWB as amount";
                SQL += " from HAWB_master ";
                SQL += " where ((( isnull(is_master,'N')='Y' or isnull(is_sub,'N')='Y')";
                SQL += " and isnull(is_invoice_queued,'Y') <> 'N')";
                SQL += " OR (( isnull(is_master,'N')='N' and isnull(is_sub,'N')='N')))";
                SQL += " and Total_Weight_Charge_HAWB > 0";
                SQL += " and  elt_account_number = " + elt_account_number;
                SQL += " and MAWB_NUM='" + MB + "'";
                SQL += " and HAWB_NUM='" + HB + "'";
                //SQL += " and COLL_1='Y'";
                SQL += " order by HAWB_NUM";
            }
        }
        else
        {

            if (AO == "A")
            {
                SQL = "select 'E' as import_export, newid() as row_id,-1 as item_id, '../../../ASP/air_export/new_edit_hawb.asp?HAWB='+ hawb_num as url, hawb_num as hb," + defaultAF + " as item_no,'" + defaultAFDesc + "' as description,'" + MB + "' as mb, 'HAWB'as waybill_type, Total_Weight_Charge_HAWB as amount";
                SQL += " from HAWB_master ";
                SQL += " where ((( isnull(is_master,'N')='Y' or isnull(is_sub,'N')='Y')";
                SQL += " and isnull(is_invoice_queued,'Y') <> 'N')";
                SQL += " OR (( isnull(is_master,'N')='N' and isnull(is_sub,'N')='N')))";
                SQL += " and Total_Weight_Charge_HAWB > 0";
                SQL += " and  elt_account_number = " + elt_account_number;
                SQL += " and MAWB_NUM='" + MB + "'";
                SQL += " and HAWB_NUM='" + HB + "'";
                SQL += " and PPO_1='Y'";
                SQL += " order by HAWB_NUM";

            }
            else if (AO == "O")
            {
                SQL = "select 'E' as import_export, newid() as row_id,-1 as item_id, '../../../ASP/ocean_export/new_edit_hbol.asp?hbol='+ hbol_num as url, hbol_num as hb," + defaultOF + " as item_no,'" + defaultOFDesc + "' as description,'" + MB + "' as mb,  'HBOL'as waybill_type, Total_Weight_Charge as amount";
                SQL += " from hbol_master ";
                SQL += " where ((( isnull(is_master,'N')='Y' or isnull(is_sub,'N')='Y')";
                SQL += " and isnull(is_invoice_queued,'Y') <> 'N')";
                SQL += " OR (( isnull(is_master,'N')='N' and isnull(is_sub,'N')='N')))";
                SQL += " and elt_account_number = " + elt_account_number;
                SQL += " and booking_num='" + MB + "'";
                SQL += " and hbol_num='" + HB + "' and weight_cp='P' order by hbol_num";

            }
            else
            {
                SQL = "select 'E' as import_export, newid() as row_id,-1 as item_id, '../../../ASP/air_export/new_edit_hawb.asp?HAWB='+ hawb_num as url, hawb_num as hb," + defaultDF + " as item_no,'" + defaultDFDesc + "' as description,'" + MB + "' as mb, 'DOMESTIC'as waybill_type, Total_Weight_Charge_HAWB as amount";
                SQL += " from HAWB_master ";
                SQL += " where ((( isnull(is_master,'N')='Y' or isnull(is_sub,'N')='Y')";
                SQL += " and isnull(is_invoice_queued,'Y') <> 'N')";
                SQL += " OR (( isnull(is_master,'N')='N' and isnull(is_sub,'N')='N')))";
                SQL += " and Total_Weight_Charge_HAWB > 0";
                SQL += " and  elt_account_number = " + elt_account_number;
                SQL += " and MAWB_NUM='" + MB + "'";
                SQL += " and HAWB_NUM='" + HB + "'";
                //SQL += " and PPO_1='Y'";
                SQL += " order by HAWB_NUM";

            }
        }
        try
        {
          //  SQL = SQL;
            SqlDataAdapter adChItems = new SqlDataAdapter(SQL, Con);
            
            adChItems.Fill(dt);
            GeneralUtility util = new GeneralUtility();
            util.removeNull(ref dt);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return dt;
    }



    private DataSet getOtherChargeItemsFromWaybill(ArrayList qRecords)
    {
        dsChItems = new DataSet();
        dsChItems.Tables.Add(new DataTable());
        for (int i = 0; i < qRecords.Count; i++)
        {
            string MB = ((IVQRecord)qRecords[i]).Mawb_num;
            string HB = ((IVQRecord)qRecords[i]).Hawb_num;
            int AgentNo = ((IVQRecord)qRecords[i]).Agent_org_acct;
            string Shipper_Agent = ((IVQRecord)qRecords[i]).Agent_shipper;
            string isMasterOnly = ((IVQRecord)qRecords[i]).Master_only;
            string AO = ((IVQRecord)qRecords[i]).Air_ocean;
            DataTable dtTemp;

            if (isMasterOnly == "Y")
            {
                dtTemp = getOtherChargeItemsFromMasterOnlyWaybill(MB, Shipper_Agent, AO);
            }
            else
            {
                if (HB == "CONSOLIDATION")// multiple HB's issued to an agent 
                {
                    dtTemp = getOtherChargeItemsFromMultipleHBsForIVtoAgent(MB, AgentNo, AO);
                }
                else
                {
                    dtTemp = getOtherChargeItemsFromHB(MB, HB, AO, Shipper_Agent, AgentNo);
                }
            }
            try
            {
                dsChItems.Tables[0].Merge(dtTemp);
            }
            catch (Exception ex)
            {
                throw ex;

            }

        }
        return dsChItems;
    }

    private DataTable getOtherChargeItemsFromMasterOnlyWaybill(string MB, string Shipper_Agent, string AO)
    {
        string SQL;
        string payOption;
        DataTable dt = new DataTable();
        if (AO == "A")
        {
            if (Shipper_Agent == "S")
            {
                payOption = "Coll_Prepaid='P'";// this is for  MB's shipper
            }
            else// THIS WILL NOT BE REACHED --> DIRECT SHIPMENT CANNOT INVOICE TO AGENT
            {
                payOption = "Coll_Prepaid='C'";// this is for MB's consignee
            }
            SQL = "select  'E' as import_export, newid() as row_id,-1 as item_id, '../../../ASP/air_export/new_edit_mawb.asp?MAWB='+mawb_num as url, Charge_Desc as description, mawb_num as mb, charge_code as item_no," + " '' as hb, 'MAWB'as waybill_type, Amt_MAWB as amount from mawb_other_charge where Amt_MAWB <> 0 and elt_account_number = " + elt_account_number + " and mawb_num='" + MB + "' and " + payOption;
        }
        else
        {
            if (Shipper_Agent == "S")
            {
                payOption = "Coll_Prepaid='P'";// this is for  MB's shipper
            }
            else // THIS WILL NOT BE REACHED--> DIRECT SHIPMENT CANNOT INVOICE TO AGENT
            {
                payOption = "Coll_Prepaid='C'";// this is for MB's consignee
            }
            SQL = "select  'E' as import_export, newid() as row_id,-1 as item_id, '../../../ASP/ocean_export/new_edit_mbol.asp?BookingNum='+booking_num as url, Charge_Desc as description, booking_num as mb, charge_code as item_no," + "'' as hb,'MBOL'as waybill_type, charge_amt as amount from mbol_other_charge where charge_amt <> 0 and  elt_account_number = " + elt_account_number + " and booking_num='" + MB + "' and " + payOption;
        }
        try
        {
            //SQL = SQL;
            SqlDataAdapter adChItems = new SqlDataAdapter(SQL, Con);
            
            adChItems.Fill(dt);
            GeneralUtility util = new GeneralUtility();
            util.removeNull(ref dt);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return dt;
    }


    private DataTable getOtherChargeItemsFromMultipleHBsForIVtoAgent(string MB, int AgentNo, string AO)
    {
        string SQL;
        DataTable dt = new DataTable();
        if (AO == "A")
        {
            SQL = "select 'E' as import_export, newid() as row_id,-1 as item_id, '../../../ASP/air_export/new_edit_hawb.asp?HAWB='+a.hawb_num as url, a.Charge_Desc as description, a.hawb_num as hb, a.charge_code as item_no," + " b.mawb_num as mb, 'HAWB'as waybill_type, a.amt_hawb as amount";
            SQL += " from hawb_other_charge a, hawb_master b";
            SQL += " where ((( isnull(b.is_master,'N')='Y' or isnull(b.is_sub,'N')='Y')";
            SQL += " and isnull(b.is_invoice_queued,'Y') <> 'N')";
            SQL += " or (( isnull(b.is_master,'N')='N' and isnull(b.is_sub,'N')='N')))";
            SQL += " and a.amt_hawb <> 0";
            SQL += " and  a.elt_account_number = " + elt_account_number;
            SQL += " and  b.elt_account_number = a.elt_account_number";
            SQL += " and b.MAWB_NUM='" + MB + "'";
            SQL += " and a.HAWB_NUM= b.HAWB_NUM";
            SQL += " and b.agent_no=" + AgentNo;
            SQL += " and a.Coll_Prepaid = 'C'";
            SQL += " order by a.tran_no";
           
        }
        else
        {
            SQL = "select 'E' as import_export, newid() as row_id,-1 as item_id, '../../../ASP/ocean_export/new_edit_hbol.asp?hbol='+a.hbol_num as url, a.Charge_Desc as description, a.hbol as hb, a.charge_code as item_no," + " b.booking_num as mb, 'HBOL'as waybill_type, a.charge_amt as amount";
            SQL += " from hbol_other_charge a, hbol_master b ";
            SQL += " where ((( isnull(b.is_master,'N')='Y' or isnull(b.is_sub,'N')='Y')";
            SQL += " and isnull(b.is_invoice_queued,'Y') <> 'N')";
            SQL += " OR (( isnull(b.is_master,'N')='N' and isnull(b.is_sub,'N')='N')))";
            SQL += " and a.charge_amt <> 0";
            SQL += " and a.elt_account_number = " + elt_account_number;
            SQL += " and b.elt_account_number = a.elt_account_number";
            SQL += " and a.booking_num='" + MB + "'";
            SQL += " and a.hbol_num = b.hbol_num";
            SQL += " and b.agent_no=" + AgentNo;
            SQL += " and a.Coll_Prepaid='C' order by a.tran_no";
            
        }
        try
        {
           // SQL = SQL;
            SqlDataAdapter adChItems = new SqlDataAdapter(SQL, Con);
            
            adChItems.Fill(dt);
            GeneralUtility util = new GeneralUtility();
            util.removeNull(ref dt);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return dt;
    }


    private DataTable getOtherChargeItemsFromHB(string MB, string HB, string AO, string Shipper_Agent, int agent_no)
    {
        string SQL;
        DataTable dt = new DataTable();

        if (Shipper_Agent == "A")
        {
            if (AO == "A")
            {
                SQL = "select 'E' as import_export,  newid() as row_id,-1 as item_id, '../../../ASP/air_export/new_edit_hawb.asp?HAWB='+a.hawb_num as url, a.Charge_Desc as description, a.hawb_num as hb, a.charge_code as item_no,'" + MB + "'  as mb, 'HAWB'as waybill_type, a.amt_hawb as amount";
                SQL += " from hawb_other_charge a, HAWB_master b";
                SQL += " where ((( isnull(b.is_master,'N')='Y' or isnull(b.is_sub,'N')='Y')";
                SQL += " and isnull(b.is_invoice_queued,'Y') <> 'N')";
                SQL += " OR (( isnull(b.is_master,'N')='N' and isnull(b.is_sub,'N')='N')))";
                SQL += " and a.amt_hawb <> 0";
                SQL += " and  a.elt_account_number = " + elt_account_number;
                SQL += " and  b.elt_account_number = a.elt_account_number";
                SQL += " and b.MAWB_NUM='" + MB + "'";
                SQL += " and a.HAWB_NUM='" + HB + "'";
                SQL += " and a.HAWB_NUM= b.HAWB_NUM";
                SQL += " and a.Coll_Prepaid = 'C'";
                SQL += " order by a.HAWB_NUM";

            }
            else if (AO == "O")
            {
                SQL = "select 'E' as import_export,  newid() as row_id,-1 as item_id, '../../../ASP/ocean_export/new_edit_hbol.asp?hbol='+a.hbol_num as url, a.Charge_Desc as description,  a.hbol_num as hb, a.charge_code as item_no,'" + MB + "' as mb,  'HBOL'as waybill_type, a.charge_amt as amount";
                SQL += " from hbol_other_charge a, hbol_master b ";
                SQL += " where ((( isnull(b.is_master,'N')='Y' or isnull(b.is_sub,'N')='Y')";
                SQL += " and isnull(b.is_invoice_queued,'Y') <> 'N')";
                SQL += " OR (( isnull(b.is_master,'N')='N' and isnull(b.is_sub,'N')='N')))";
                SQL += " and a.charge_amt <> 0";
                SQL += " and  a.elt_account_number = " + elt_account_number;
                SQL += " and  b.elt_account_number = a.elt_account_number";
                SQL += " and b.booking_num='" + MB + "'";
                SQL += " and a.hbol_num='" + HB + "'";
                SQL += " and a.hbol_num= b.hbol_num";
                SQL += " and a.Coll_Prepaid = 'C'";
                SQL += " and a.hbol_num='" + HB + "' order by a.hbol_num";

            }
            else
            {
                SQL = "select 'E' as import_export,  newid() as row_id,-1 as item_id, '../../../ASP/air_export/new_edit_hawb.asp?HAWB='+a.hawb_num as url, a.Charge_Desc as description, a.hawb_num as hb, a.charge_code as item_no,'" + MB + "'  as mb, 'DOMESTIC'as waybill_type, a.amt_hawb as amount";
                SQL += " from hawb_other_charge a, HAWB_master b";
                SQL += " where ((( isnull(b.is_master,'N')='Y' or isnull(b.is_sub,'N')='Y')";
                SQL += " and isnull(b.is_invoice_queued,'Y') <> 'N')";
                SQL += " OR (( isnull(b.is_master,'N')='N' and isnull(b.is_sub,'N')='N')))";
                SQL += " and a.amt_hawb <> 0";
                SQL += " and  a.elt_account_number = " + elt_account_number;
                SQL += " and  b.elt_account_number = a.elt_account_number";
                SQL += " and b.MAWB_NUM='" + MB + "'";
                SQL += " and a.HAWB_NUM='" + HB + "'";
                SQL += " and a.HAWB_NUM= b.HAWB_NUM";
                //SQL += " and a.Coll_Prepaid = 'C'";
                SQL += " order by a.HAWB_NUM";
            }
        }
        else
        {

            if (AO == "A")
            {
                SQL = "select 'E' as import_export, newid() as row_id,-1 as item_id, '../../../ASP/air_export/new_edit_hawb.asp?HAWB='+a.hawb_num as url, a.Charge_Desc as description, a.hawb_num as hb, a.charge_code as item_no,'" + MB + "'  as mb, 'HAWB'as waybill_type, a.amt_hawb as amount";
                SQL += " from hawb_other_charge a, HAWB_master b";
                SQL += " where ((( isnull(b.is_master,'N')='Y' or isnull(b.is_sub,'N')='Y')";
                SQL += " and isnull(b.is_invoice_queued,'Y') <> 'N')";
                SQL += " OR (( isnull(b.is_master,'N')='N' and isnull(b.is_sub,'N')='N')))";
                SQL += " and a.amt_hawb <> 0";
                SQL += " and  a.elt_account_number = " + elt_account_number;
                SQL += " and  b.elt_account_number = a.elt_account_number";
                SQL += " and b.MAWB_NUM='" + MB + "'";
                SQL += " and a.HAWB_NUM='" + HB + "'";
                SQL += " and a.HAWB_NUM= b.HAWB_NUM";
                SQL += " and a.Coll_Prepaid = 'P'";
                SQL += " order by a.HAWB_NUM";

            }
            else if (AO == "O")
            {
                SQL = "select  'E' as import_export, newid() as row_id,-1 as item_id, '../../../ASP/ocean_export/new_edit_hbol.asp?hbol='+a.hbol_num as url, a.Charge_Desc as description,  a.hbol_num as hb, a.charge_code as item_no,'" + MB + "' as mb,  'HBOL'as waybill_type, a.charge_amt as amount";
                SQL += " from hbol_other_charge a, hbol_master b ";
                SQL += " where ((( isnull(b.is_master,'N')='Y' or isnull(b.is_sub,'N')='Y')";
                SQL += " and isnull(b.is_invoice_queued,'Y') <> 'N')";
                SQL += " OR (( isnull(b.is_master,'N')='N' and isnull(b.is_sub,'N')='N')))";
                SQL += " and a.charge_amt <> 0";
                SQL += " and  a.elt_account_number = " + elt_account_number;
                SQL += " and  b.elt_account_number = a.elt_account_number";
                SQL += " and b.booking_num='" + MB + "'";
                SQL += " and a.hbol_num='" + HB + "'";
                SQL += " and a.hbol_num= b.hbol_num";
                SQL += " and a.Coll_Prepaid = 'P'";
                SQL += " and a.hbol_num='" + HB + "' order by a.hbol_num";

            }
            else
            {
                SQL = "select 'E' as import_export, newid() as row_id,-1 as item_id, '../../../ASP/air_export/new_edit_hawb.asp?HAWB='+a.hawb_num as url, a.Charge_Desc as description, a.hawb_num as hb, a.charge_code as item_no,'" + MB + "'  as mb, 'DOMESTIC'as waybill_type, a.amt_hawb as amount";
                SQL += " from hawb_other_charge a, HAWB_master b";
                SQL += " where ((( isnull(b.is_master,'N')='Y' or isnull(b.is_sub,'N')='Y')";
                SQL += " and isnull(b.is_invoice_queued,'Y') <> 'N')";
                SQL += " OR (( isnull(b.is_master,'N')='N' and isnull(b.is_sub,'N')='N')))";
                SQL += " and a.amt_hawb <> 0";
                SQL += " and  a.elt_account_number = " + elt_account_number;
                SQL += " and  b.elt_account_number = a.elt_account_number";
                SQL += " and b.MAWB_NUM='" + MB + "'";
                SQL += " and a.HAWB_NUM='" + HB + "'";
                SQL += " and a.HAWB_NUM= b.HAWB_NUM";
                //SQL += " and a.Coll_Prepaid = 'P'";
                SQL += " order by a.HAWB_NUM";

            }
        }
       
        try
        {
           // SQL = SQL;
            SqlDataAdapter adChItems = new SqlDataAdapter(SQL, Con);

            adChItems.Fill(dt);

            GeneralUtility util = new GeneralUtility();
            util.removeNull(ref dt);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return dt;
    }
}
