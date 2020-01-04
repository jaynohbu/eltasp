using System;
using System.Web;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Reflection;
using ELT.COMMON;
using ELT.CDT;
namespace ELT.DA
{
    public class AESDA : DABase
    {

        public ScheduleBItem GetScheduleB(string elt_account_number, string description)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.[GetScheduleB]" };
            ScheduleBItem itemToReturn = new ScheduleBItem();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@elt_account_number", elt_account_number));
                cmd.Parameters.Add(new SqlParameter("@description", description));
             
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        ScheduleBItem item = new ScheduleBItem()
                        {
                            sb = Convert.ToString(reader["sb"]),
                            sb_unit1 = Convert.ToString(reader["sb_unit1"]),
                            sb_unit2 = Convert.ToString(reader["sb_unit2"]),
                            description = Convert.ToString(reader["description"]),
                            eccn = Convert.ToString(reader["eccn"]),
                            export_code = Convert.ToString(reader["export_code"]),
                            license_type = Convert.ToString(reader["license_type"])                        

                        };
                        itemToReturn = item;                        
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return itemToReturn;
        }
        public List<AESLineItem> GetAESLineItems(int AESID, int ELT_ACCOUNT_NUMBER, string MAWB, string HAWB, string FileType)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.[GetAESLineItems]" };
            List<AESLineItem> list = new List<AESLineItem>();
          
            try
            {
                cmd.Parameters.Add(new SqlParameter("@ELT_ACCOUNT_NUMBER", ELT_ACCOUNT_NUMBER));
                cmd.Parameters.Add(new SqlParameter("@AESID", AESID));
                cmd.Parameters.Add(new SqlParameter("@MAWB", MAWB));
                cmd.Parameters.Add(new SqlParameter("@HAWB", HAWB));
                cmd.Parameters.Add(new SqlParameter("@file_type", FileType));
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        AESLineItem item = new AESLineItem()
                        {
                            AesID = AESID,
                            ID = Convert.ToInt32(reader["ID"]),
                            Origin = Convert.ToString(reader["dfm"]),
                            VehicleID = Convert.ToString(reader["vin"]),
                            ScheduleB = Convert.ToString(reader["b_number"]),
                            Qty1 = Convert.ToInt32(reader["b_qty1"]),
                            Qty2 = Convert.ToInt32(reader["b_qty2"]),
                            Unit1 = Convert.ToString(reader["unit1"]),
                            Unit2 = Convert.ToString(reader["unit2"]),
                            GrossWeight = Convert.ToString(reader["gross_weight"]),
                            ItemValue = Convert.ToString(reader["item_value"]),
                            ItemDesc = Convert.ToString(reader["item_desc"]),
                            ExportCode = Convert.ToString(reader["export_code"]),
                            LicenseType = Convert.ToString(reader["license_type"]),
                            LicenseNumber = Convert.ToString(reader["license_number"]),
                            VehicleIDType = Convert.ToString(reader["vin_type"]),
                            VehicleTitle = Convert.ToString(reader["vc_title"]),
                            VihicleState = Convert.ToString(reader["vc_state"]),
                            ECCN = Convert.ToString(reader["eccn"]),

                        };

                        list.Add(item);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return list;
        }
      

        public void DeleteAESLineItem(int ID)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.[DeleteAESLineItem]" };

            try
            {
                cmd.Parameters.Add(new SqlParameter("@id", ID));
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }

        }
        public void InsertAESLineItem(AESLineItem AESAirLineItem)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.[InsertAESLineItem]" };

            try
            {
                cmd.Parameters.Add(new SqlParameter("@elt_account_number", AESAirLineItem.ELT_ACCOUNT_NUMBER));
                cmd.Parameters.Add(new SqlParameter("@item_no", AESAirLineItem.ItemNo));
                cmd.Parameters.Add(new SqlParameter("@dfm", AESAirLineItem.Origin));
                cmd.Parameters.Add(new SqlParameter("@b_number", AESAirLineItem.ScheduleB));
                cmd.Parameters.Add(new SqlParameter("@item_desc", AESAirLineItem.ItemDesc));
                cmd.Parameters.Add(new SqlParameter("@b_qty1", AESAirLineItem.Qty1));
                cmd.Parameters.Add(new SqlParameter("@unit1", AESAirLineItem.Unit1));
                cmd.Parameters.Add(new SqlParameter("@b_qty2", AESAirLineItem.Qty2));
                cmd.Parameters.Add(new SqlParameter("@unit2", AESAirLineItem.Unit2));
                cmd.Parameters.Add(new SqlParameter("@gross_weight", AESAirLineItem.GrossWeight));
                cmd.Parameters.Add(new SqlParameter("@vin_type", AESAirLineItem.VehicleIDType));
                cmd.Parameters.Add(new SqlParameter("@vin", AESAirLineItem.VehicleID));
                cmd.Parameters.Add(new SqlParameter("@vc_title", AESAirLineItem.VehicleTitle));
                cmd.Parameters.Add(new SqlParameter("@vc_state", AESAirLineItem.VihicleState));
                cmd.Parameters.Add(new SqlParameter("@item_value", AESAirLineItem.ItemValue));
                cmd.Parameters.Add(new SqlParameter("@export_code", AESAirLineItem.ExportCode));
                cmd.Parameters.Add(new SqlParameter("@license_type", AESAirLineItem.LicenseType));
                cmd.Parameters.Add(new SqlParameter("@aes_id", AESAirLineItem.AesID));
                cmd.Parameters.Add(new SqlParameter("@eccn", AESAirLineItem.ECCN));
                cmd.Parameters.Add(new SqlParameter("@license_number", AESAirLineItem.LicenseNumber));
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }

        }
        public void UpdateAESLineItem(AESLineItem AESAirLineItem)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.[UpdateAESLineItem]" };

            try
            {
                cmd.Parameters.Add(new SqlParameter("@id", AESAirLineItem.ID));
                cmd.Parameters.Add(new SqlParameter("@item_no", AESAirLineItem.ItemNo));
                cmd.Parameters.Add(new SqlParameter("@dfm", AESAirLineItem.Origin));
                cmd.Parameters.Add(new SqlParameter("@b_number", AESAirLineItem.ScheduleB));
                cmd.Parameters.Add(new SqlParameter("@item_desc", AESAirLineItem.ItemDesc));
                cmd.Parameters.Add(new SqlParameter("@b_qty1", AESAirLineItem.Qty1));
                cmd.Parameters.Add(new SqlParameter("@unit1", AESAirLineItem.Unit1));
                cmd.Parameters.Add(new SqlParameter("@b_qty2", AESAirLineItem.Qty2));
                cmd.Parameters.Add(new SqlParameter("@unit2", AESAirLineItem.Unit2));
                cmd.Parameters.Add(new SqlParameter("@gross_weight", AESAirLineItem.GrossWeight));
                cmd.Parameters.Add(new SqlParameter("@vin_type", AESAirLineItem.VehicleIDType));
                cmd.Parameters.Add(new SqlParameter("@vin", AESAirLineItem.VehicleID));
                cmd.Parameters.Add(new SqlParameter("@vc_title", AESAirLineItem.VehicleTitle));
                cmd.Parameters.Add(new SqlParameter("@vc_state", AESAirLineItem.VihicleState));
                cmd.Parameters.Add(new SqlParameter("@item_value", AESAirLineItem.ItemValue));
                cmd.Parameters.Add(new SqlParameter("@export_code", AESAirLineItem.ExportCode));
                cmd.Parameters.Add(new SqlParameter("@license_type", AESAirLineItem.LicenseType));
                cmd.Parameters.Add(new SqlParameter("@aes_id", AESAirLineItem.AesID));
                cmd.Parameters.Add(new SqlParameter("@eccn", AESAirLineItem.ECCN));
                cmd.Parameters.Add(new SqlParameter("@license_number", AESAirLineItem.LicenseNumber));

                conn.Open();
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }

        }
//        public List<Tuple<string, string>> GetPorts(string EmailItemID)
//        {
//            SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
//            SqlCommand Cmd = new SqlCommand();
//            Cmd.Connection = Con;
//            Cmd.CommandText = " SELECT port_code + ' - ' + port_desc as port_name,port_code FROM port WHERE EmailItemID='" + EmailItemID + "' AND ISNULL(port_id,'')<>'' ORDER BY port_desc";
//            List<Tuple<string, string>> list = new List<Tuple<string, string>>();
//            try
//            {
//                Con.Open();
//                SqlDataAdapter adap = new SqlDataAdapter(Cmd);
//                Cmd.ExecuteNonQuery();
//                var ds = new DataSet();
//                adap.Fill(ds);
//                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
//                {
//                    list.Add(new Tuple<string, string>(
//                        Convert.ToString(ds.Tables[0].Rows[i]["port_code"]),
//                        Convert.ToString(ds.Tables[0].Rows[i]["port_name"])
//                    ));
//                }
//            }
//            catch (Exception ex)
//            {
//                throw ex;
//            }
//            finally
//            {
//                Con.Close();
//                Con.Dispose();
//            }
//            return list;
//        }

//        public List<Tuple<string, string>> GetCountries(string EmailItemID)
//        {
//            SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
//            SqlCommand Cmd = new SqlCommand();
//            Cmd.Connection = Con;
//            Cmd.CommandText = " SELECT * FROM country_code WHERE EmailItemID='" + EmailItemID + "' order by country_name";
//            List<Tuple<string, string>> list = new List<Tuple<string, string>>();
//            try
//            {
//                Con.Open();
//                SqlDataAdapter adap = new SqlDataAdapter(Cmd);
//                Cmd.ExecuteNonQuery();
//                var ds = new DataSet();
//                adap.Fill(ds);
//                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
//                {
//                    list.Add(new Tuple<string, string>(
//                        Convert.ToString(ds.Tables[0].Rows[i]["country_code"]),
//                        Convert.ToString(ds.Tables[0].Rows[i]["country_name"])
//                    ));
//                }


//            }
//            catch (Exception ex)
//            {
//                throw ex;
//            }
//            finally
//            {
//                Con.Close();
//                Con.Dispose();
//            }
//            return list;
//        }

//        public List<TextValuePair> GetAESCodes(string code_type)
//        {
//            SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
//            SqlCommand Cmd = new SqlCommand();
//            Cmd.Connection = Con;
//            Cmd.CommandText = "SELECT code_id,code_desc FROM aes_codes WHERE code_type='" + code_type + "' order by code_id";
//            List<TextValuePair> list = new List<TextValuePair>();
//            try
//            {
//                Con.Open();
//                SqlDataAdapter adap = new SqlDataAdapter(Cmd);
//                Cmd.ExecuteNonQuery();
//                var ds = new DataSet();
//                adap.Fill(ds);
//                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
//                {
//                    list.Add(new TextValuePair
//                    {
//                        Value = Convert.ToString(ds.Tables[0].Rows[i]["code_id"]),
//                        Text = Convert.ToString(ds.Tables[0].Rows[i]["code_desc"])
//                    });


//                }



//            }
//            catch (Exception ex)
//            {
//                throw ex;
//            }
//            finally
//            {
//                Con.Close();
//                Con.Dispose();
//            }
//            return list;
//        }

//        public List<Tuple<string, string>> GetCarriers(string EmailItemID)
//        {
//            SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
//            SqlCommand Cmd = new SqlCommand();
//            Cmd.Connection = Con;
//            Cmd.CommandText = "SELECT ISNULL(carrier_id,'') AS carrier_code,LEFT(dba_name,22) AS carrier_name FROM organization WHERE is_carrier='Y' AND ISNULL(carrier_id,'') <> '' AND ISNULL(carrier_code,'')<>'' AND EmailItemID='" + EmailItemID + "' ORDER BY dba_name";
//            List<Tuple<string, string>> list = new List<Tuple<string, string>>();
//            try
//            {
//                Con.Open();
//                SqlDataAdapter adap = new SqlDataAdapter(Cmd);
//                Cmd.ExecuteNonQuery();
//                var ds = new DataSet();
//                adap.Fill(ds);
//                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
//                {
//                    list.Add(new Tuple<string, string>(
//                        Convert.ToString(ds.Tables[0].Rows[i]["carrier_code"]),
//                        Convert.ToString(ds.Tables[0].Rows[i]["carrier_name"])
//                    ));
//                }



//            }
//            catch (Exception ex)
//            {
//                throw ex;
//            }
//            finally
//            {
//                Con.Close();
//                Con.Dispose();
//            }
//            return list;
//        }

//        public AESMasterItems GetAESMasterItems(string EmailItemID, string aes_no)
//        {

//            SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
//            SqlCommand Cmd = new SqlCommand();
//            Cmd.Connection = Con;
//            Cmd.CommandText = "SELECT * FROM aes_master WHERE EmailItemID='"
//                + EmailItemID + "' AND auto_uid=" + aes_no;
//            AESMasterItems item = new AESMasterItems();
//            try
//            {

//                Con.Open();

//                using (SqlDataReader reader = Cmd.ExecuteReader())
//                {
//                    while (reader.Read())
//                    {

//                        item.EltAccountNumber = Convert.ToString(reader["EmailItemID"]);
//                        item.AESNo = Convert.ToString(reader["auto_uid"]);
//                        item.FileType = Convert.ToString(reader["file_type"]);

//                        item.HAWB = Convert.ToString(reader["house_num"]);
//                        item.MAWB = Convert.ToString(reader["master_num"]);
//                        item.ShipmentReferenceNumber = Convert.ToString(reader["shipment_ref_no"]);
//                        item.TransportationReferenceNumber = Convert.ToString(reader["tran_ref_no"]);
//                        item.StateOfOrigin = Convert.ToString(reader["origin_state"]);

//                        item.PortOfExport = Convert.ToString(reader["export_port"]);
//                        item.CountryOfDestination = Convert.ToString(reader["dest_country"]);
//                        item.PortOfUnloading = Convert.ToString(reader["unloading_port"]);
//                        item.DepartureDate = ConvertToDateTime(reader["export_date"]);
//                        item.ModeOfTransportation = Convert.ToString(reader["tran_method"]);

//                        item.CarrierID = Convert.ToString(reader["carrier_id_code"]);
//                        item.CarrierName = Convert.ToString(reader["export_carrier"]);
//                        item.PartiesToTransaction = Convert.ToString(reader["party_to_transaction"]);
//                        item.HazardousCargo = Convert.ToString(reader["hazardous_materials"]);
//                        item.RoutedExportTransaction = Convert.ToString(reader["route_export_tran"]);
//                        item.InbondType = Convert.ToString(reader["in_bond_type"]);

//                        item.ForeignTradeZone = Convert.ToString(reader["ftz"]);
//                        item.InbondNumber = Convert.ToString(reader["in_bond_no"]);
//                        item.ITNNo = Convert.ToString(reader["aes_itn"]);
//                        item.AESStatus = Convert.ToString(reader["aes_status"]);
//                        item.AESSubmitDate = ConvertToDateTime(reader["tran_date"]);

//                        item.LastUpdated = ConvertToDateTime(reader["last_modified"]);
//                        item.ExporterID = Convert.ToString(reader["shipper_acct"]);
//                        item.FreightForwarderID = Convert.ToString(reader["EmailItemID"]);// Convert.ToString(reader["agent_acct"]);
//                        item.UltimateConsigneeID = Convert.ToString(reader["consignee_acct"]);
//                        item.IntermediateConsigneeID = Convert.ToString(reader["inter_consignee_acct"]);

//                        //item.LineItems = new List<AESLineItem>{
//                        //    new AESLineItem{}
//                        //}
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                throw ex;
//            }
//            finally
//            {
//                Con.Close();
//                Con.Dispose();
//            }

//            return item;
//        }
//        //public List<AESAirLineItem> GetAESDetailItems(string EmailItemID, string aes_no)
//        //{

//        //    SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
//        //    SqlCommand Cmd = new SqlCommand();
//        //    Cmd.Connection = Con;
//        //    Cmd.CommandText = "SELECT * FROM aes_detail WHERE EmailItemID='" + EmailItemID + "'  and aes_id=" + aes_no + " order by item_no";
//        //    List<AESAirLineItem> list = new List<AESAirLineItem>();
//        //    try
//        //    {

//        //        Con.Open();
//        //        SqlDataAdapter adap = new SqlDataAdapter(Cmd);
//        //        Cmd.ExecuteNonQuery();
//        //        var ds = new DataSet();
//        //        adap.Fill(ds);
//        //        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
//        //        {
//        //            list.Add(new AESAirLineItem{
//        //                ID = Convert.ToString(ds.Tables[0].Rows[i]["id"]),                   
//        //                Origin = Convert.ToString(ds.Tables[0].Rows[i]["dfm"]),
//        //                ScheduleB = Convert.ToString(ds.Tables[0].Rows[i]["b_number"]),
//        //                ItemDesc = Convert.ToString(ds.Tables[0].Rows[i]["item_desc"]),

//        //                Qty1 = Convert.ToString(ds.Tables[0].Rows[i]["b_qty1"]),
//        //                Unit1 = Convert.ToString(ds.Tables[0].Rows[i]["unit1"]),
//        //                Qty2 = Convert.ToString(ds.Tables[0].Rows[i]["b_qty2"]),
//        //                Unit2 = Convert.ToString(ds.Tables[0].Rows[i]["unit2"]),
//        //                GrossWeight = Convert.ToString(ds.Tables[0].Rows[i]["gross_weight"]),

//        //                VehicleIDType = Convert.ToString(ds.Tables[0].Rows[i]["vin_type"]),
//        //                VehicleID = Convert.ToString(ds.Tables[0].Rows[i]["vin"]),
//        //                VehicleTitle = Convert.ToString(ds.Tables[0].Rows[i]["vc_title"]),
//        //                VihicleState = Convert.ToString(ds.Tables[0].Rows[i]["vc_state"]),
//        //                ItemValue = Convert.ToString(ds.Tables[0].Rows[i]["item_value"]),

//        //                ExportCode = Convert.ToString(ds.Tables[0].Rows[i]["export_code"]),
//        //                LicenseType = Convert.ToString(ds.Tables[0].Rows[i]["license_type"]),
//        //                AesID = Convert.ToString(ds.Tables[0].Rows[i]["aes_id"]),
//        //                ECCN = Convert.ToString(ds.Tables[0].Rows[i]["eccn"]),
//        //                LicenseNumber = Convert.ToString(ds.Tables[0].Rows[i]["license_number"])
//        //            });
//        //        }
//        //    }
//        //    catch (Exception ex)
//        //    {
//        //        throw ex;
//        //    }
//        //    finally
//        //    {
//        //        Con.Close();
//        //        Con.Dispose();
//        //    }
//        //    return list;
//        //}
//        public void UpdateAESMasterItems(AESMasterItems item)
//        {
//            SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
//            SqlCommand Cmd = new SqlCommand();
//            Cmd.Connection = Con;

//            Cmd.CommandText = "UPDATE aes_master SET "
//            + " party_to_transaction=@party_to_transaction,"
//            + " export_date=@export_date,"
//            + " tran_ref_no=@tran_ref_no,"
//            + " consignee_acct=@consignee_acct,"
//            + " inter_consignee_acct=@inter_consignee_acct,"

//            + " origin_state=@origin_state,"
//            + " dest_country=@dest_country,"
//            + " tran_method=@tran_method,"
//            + " export_port=@export_port,"
//            + " unloading_port=@unloading_port,"

//            + " carrier_id_code=@carrier_id_code,"
//            + " export_carrier=@export_carrier,"
//            + " shipment_ref_no=@shipment_ref_no,"
//            + " hazardous_materials=@hazardous_materials,"
//            + " route_export_tran=@route_export_tran,"

//            + " in_bond_type=@in_bond_type,"
//            + " in_bond_no=@in_bond_no,"
//            + " ftz=@ftz,"
//            + " last_modified=@last_modified, "
//            + " shipper_acct=@shipper_acct,"

//            + " file_type=@file_type,"
//            + " house_num=@house_num,"
//            + " master_num=@master_num"
//            + " WHERE EmailItemID=@EmailItemID  and auto_uid=@aes_no";

//            Cmd.Parameters.AddWithValue("@party_to_transaction", item.PartiesToTransaction);
//            Cmd.Parameters.AddWithValue("@export_date", item.DepartureDate);
//            Cmd.Parameters.AddWithValue("@tran_ref_no", item.TransportationReferenceNumber);
//            Cmd.Parameters.AddWithValue("@consignee_acct", item.UltimateConsigneeID);
//            Cmd.Parameters.AddWithValue("@inter_consignee_acct", item.IntermediateConsigneeID);

//            Cmd.Parameters.AddWithValue("@origin_state", item.StateOfOrigin);
//            Cmd.Parameters.AddWithValue("@dest_country", item.CountryOfDestination);
//            Cmd.Parameters.AddWithValue("@tran_method", item.ModeOfTransportation);
//            Cmd.Parameters.AddWithValue("@export_port", item.PortOfExport);
//            Cmd.Parameters.AddWithValue("@unloading_port", item.PortOfUnloading);

//            Cmd.Parameters.AddWithValue("@carrier_id_code", item.CarrierID);
//            Cmd.Parameters.AddWithValue("@export_carrier", item.CarrierName);
//            Cmd.Parameters.AddWithValue("@shipment_ref_no", item.ShipmentReferenceNumber);
//            Cmd.Parameters.AddWithValue("@hazardous_materials", item.HazardousCargo);
//            Cmd.Parameters.AddWithValue("@route_export_tran", item.RoutedExportTransaction);

//            Cmd.Parameters.AddWithValue("@in_bond_type", item.InbondType);
//            Cmd.Parameters.AddWithValue("@in_bond_no", item.InbondNumber);
//            Cmd.Parameters.AddWithValue("@ftz", item.ForeignTradeZone);
//            Cmd.Parameters.AddWithValue("@last_modified", DateTime.Now);
//            Cmd.Parameters.AddWithValue("@shipper_acct", item.ExporterID);

//            Cmd.Parameters.AddWithValue("@file_type", item.FileType);
//            Cmd.Parameters.AddWithValue("@house_num", item.HAWB);
//            Cmd.Parameters.AddWithValue("@master_num", item.MAWB);
//            Cmd.Parameters.AddWithValue("@EmailItemID", item.EltAccountNumber);
//            Cmd.Parameters.AddWithValue("@aes_no", item.AESNo);
//            Cmd.CommandType = CommandType.Text;
//            try
//            {
//                Con.Open();
//                Cmd.ExecuteNonQuery();
//            }
//            catch (Exception ex)
//            {
//                throw ex;
//            }
//            finally
//            {
//                Con.Close();
//                Con.Dispose();
//            }
//        }

//        public void InsertAESDetailItem(string EmailItemID, string aes_no, AESAirLineItem item)
//        {
//            SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
//            SqlCommand Cmd = new SqlCommand();
//            Cmd.Connection = Con;
//            string sql = "INSERT INTO aes_detail(EmailItemID,item_no,dfm,b_number,item_desc,b_qty1,unit1,b_qty2,unit2,gross_weight,item_value,export_code,license_type,license_number,eccn,vin_type,vin,vc_title,vc_state,aes_id)VALUES("
//                        + EmailItemID //EmailItemID,item_no,dfm,b_number,item_desc,
//                        + ",-1 "
//                        + ",'" + item.Origin.Replace("\"", "").Replace("null", "") + "'"
//                        + ",'" + item.ScheduleB.Replace("\"", "").Replace("null", "") + "'"
//                        + ",'" + item.ItemDesc.Replace("\"", "").Replace("null", "") + "'"

//                        //                        +","+ aes_no
//                //b_qty1,unit1,b_qty2,unit2,gross_weight,
//                        + "," + item.Qty1.Replace("\"", "")
//                        + ",'" + item.Unit1.Replace("\"", "").Replace("null", "") + "'"
//                        + "," + item.Qty2.Replace("\"", "")
//                        + ",'" + item.Unit2.Replace("\"", "").Replace("null", "") + "'"
//                        + "," + item.GrossWeight.Replace("\"", "")

//                        //item_value,export_code,license_type,license_number,eccn,
//                        + "," + item.ItemValue.Replace("\"", "")
//                        + ",'" + item.ExportCode.Replace("\"", "").Replace("null", "") + "'"
//                        + ",'" + item.LicenseType.Replace("\"", "").Replace("null", "") + "'"
//                        + ",'" + item.LicenseNumber.Replace("\"", "").Replace("null", "") + "'"
//                        + ",'" + item.ECCN.Replace("\"", "").Replace("null", "") + "'"
//                //vin_type,vin,vc_title,vc_state,aes_id)
//                        + ",'" + item.VehicleIDType.Replace("\"", "").Replace("null", "") + "'"
//                        + ",'" + item.VehicleID.Replace("\"", "").Replace("null", "") + "'"
//                        + ",'" + item.VehicleTitle.Replace("\"", "").Replace("null", "") + "'"
//                        + ",'" + item.VihicleState.Replace("\"", "").Replace("null", "") + "'"
//                        + "," + aes_no
//                        + ")";
//            Cmd.CommandText = sql;
//            Cmd.CommandType = CommandType.Text;
//            try
//            {
//                Con.Open();
//                Cmd.ExecuteNonQuery();
//            }
//            catch (Exception ex)
//            {
//                throw ex;
//            }
//            finally
//            {
//                Con.Close();
//                Con.Dispose();
//            }
//            UpdateItemNumbers(EmailItemID, aes_no);
//        }

//        public void UpdateAESDetailItem(string EmailItemID, string id, AESAirLineItem item)
//        {
//            SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
//            SqlCommand Cmd = new SqlCommand();
//            Cmd.Connection = Con;



//            string sql = "UPDATE aes_detail SET " +
//                "dfm='" + item.Origin.Replace("\"", "").Replace("null", "") + "'" +
//                ",b_number='" + item.ScheduleB.Replace("\"", "").Replace("null", "") + "'" +
//                ",item_desc='" + item.ItemDesc.Replace("\"", "").Replace("null", "") + "'" +
//                ",b_qty1=" + item.Qty1.Replace("\"", "") +
//                ",unit1='" + item.Unit1.Replace("\"", "").Replace("null", "") + "'" +
//                ",b_qty2=" + item.Qty2.Replace("\"", "") +
//                ",unit2='" + item.Unit2.Replace("\"", "").Replace("null", "") + "'" +
//                ",gross_weight=" + item.GrossWeight.Replace("\"", "") +
//                ",item_value=" + item.ItemValue.Replace("\"", "") +
//                ",export_code='" + item.ExportCode.Replace("\"", "").Replace("null", "") + "'" +
//                ",license_type='" + item.LicenseType.Replace("\"", "").Replace("null", "") + "'" +
//                ",license_number='" + item.LicenseNumber.Replace("\"", "").Replace("null", "") + "'" +
//                ",eccn='" + item.ECCN.Replace("\"", "").Replace("null", "") + "'" +
//                ",vin_type='" + item.VehicleIDType.Replace("\"", "").Replace("null", "") + "'" +
//                ",vin='" + item.VehicleID.Replace("\"", "").Replace("null", "") + "'" +
//                ",vc_title='" + item.VehicleTitle.Replace("\"", "").Replace("null", "") + "'" +
//                ",vc_state='" + item.VihicleState.Replace("\"", "").Replace("null", "") + "'" +
//               " WHERE id= " + id;

//            Cmd.CommandText = sql;
//            Cmd.CommandType = CommandType.Text;
//            try
//            {
//                Con.Open();
//                Cmd.ExecuteNonQuery();
//            }
//            catch (Exception ex)
//            {
//                throw ex;
//            }
//            finally
//            {
//                Con.Close();
//                Con.Dispose();
//            }
//        }
//        public void DeleteAESDetailItem(string EmailItemID, string id)
//        {
//            SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
//            SqlCommand Cmd = new SqlCommand();
//            Cmd.Connection = Con;
//            Cmd.CommandText = @"DELETE aes_detail
//                                    WHERE id=" + id;
//            try
//            {
//                Con.Open();
//                Cmd.ExecuteNonQuery();

//            }
//            catch (Exception ex)
//            {
//                throw ex;
//            }
//            finally
//            {
//                Con.Close();
//                Con.Dispose();
//            }
//        }
//        private void UpdateItemNumbers(string EmailItemID, string aes_no)
//        {
//            SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
//            SqlCommand Cmd = new SqlCommand();
//            Cmd.Connection = Con;
//            Cmd.CommandText = @"UPDATE aes_detail SET item_no = id 
//                                    WHERE EmailItemID='" + EmailItemID
//                                    + "' AND aes_id=" + aes_no
//                                    + " order by item_no";
//            try
//            {
//                Con.Open();
//                Cmd.ExecuteNonQuery();

//            }
//            catch (Exception ex)
//            {
//                throw ex;
//            }
//            finally
//            {
//                Con.Close();
//                Con.Dispose();
//            }


//        }
//        public agent GetAgent(string EmailItemID)
//        {
//            PRODDBDataContext db = new PRODDBDataContext(GetConnectionString(AppConstants.DB_CONN_PROD));
//            return (from a in db.agents
//                    where a.EmailItemID.ToString() == EmailItemID
//                    select a).First();

//        }
//        public Company GetCompany(string EmailItemID, string org_account_number)
//        {
//            Company item = new Company();
//            if (org_account_number != null && org_account_number != "")
//            {
//                SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
//                SqlCommand Cmd = new SqlCommand();
//                Cmd.Connection = Con;
//                Cmd.CommandText = @"SELECT a.*,
//                                (CASE WHEN ISNULL(a.b_country_code,'')<>''                
//                                    THEN a.b_country_code ELSE b.country_code END) AS country_code_find 
//                                FROM organization a                 
//                                LEFT OUTER JOIN country_code b 
//                                    ON (a.EmailItemID=b.EmailItemID 
//                                            AND a.b_country_code=b.country_code) 
//                                WHERE a.EmailItemID='" + EmailItemID
//                                        + "' AND org_account_number=" + org_account_number;


//                try
//                {

//                    Con.Open();

//                    using (SqlDataReader reader = Cmd.ExecuteReader())
//                    {
//                        while (reader.Read())
//                        {

//                            item.CompanyName = Convert.ToString(reader["dba_name"]);
//                            item.CompanyId = Convert.ToInt32(reader["org_account_number"]);
//                            item.AccountNumber = Convert.ToString(reader["org_account_number"]);
//                            item.TaxID = Convert.ToString(reader["business_fed_taxid"]);

//                            item.Contacts = new List<Contact>{
//                            new Contact{
//                                Fname=Convert.ToString(reader["owner_fname"]),
//                                Mname=Convert.ToString(reader["owner_mname"]),
//                                Lname=Convert.ToString(reader["owner_lname"]),
//                                OfficePhone=Convert.ToString(reader["business_phone"]),
//                                Email=Convert.ToString(reader["owner_email"])
//                            }
//                        };

//                            item.Address = new Address
//                            {
//                                Address1 = Convert.ToString(reader["business_address"]),
//                                Address2 = Convert.ToString(reader["business_address2"]),
//                                ZipCode = Convert.ToString(reader["business_zip"]),
//                                City = Convert.ToString(reader["business_city"]),
//                                State = Convert.ToString(reader["business_state"]),
//                                Country = Convert.ToString(reader["business_country"])
//                            };
//                        }
//                    }
//                }
//                catch (Exception ex)
//                {
//                    throw ex;
//                }
//                finally
//                {
//                    Con.Close();
//                    Con.Dispose();
//                }
//            }
//            return item;
//        }
//        public List<Company> GetCompanies(string EmailItemID)
//        {
//            Company item = new Company();

//            SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
//            SqlCommand Cmd = new SqlCommand();
//            Cmd.Connection = Con;
//            Cmd.CommandText = @"SELECT *
//                                FROM organization               
//                                WHERE EmailItemID='" + EmailItemID + "'";

//            List<Company> list = new List<Company>();
//            try
//            {
//                Con.Open();
//                SqlDataAdapter adap = new SqlDataAdapter(Cmd);
//                Cmd.ExecuteNonQuery();
//                var ds = new DataSet();
//                adap.Fill(ds);
//                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
//                {
//                    list.Add(
//                        new Company
//                        {
//                            CompanyName = Convert.ToString(ds.Tables[0].Rows[i]["dba_name"]),
//                            CompanyId = Convert.ToInt32(ds.Tables[0].Rows[i]["org_account_number"]),
//                            AccountNumber = Convert.ToString(ds.Tables[0].Rows[i]["org_account_number"]),
//                            TaxID = Convert.ToString(ds.Tables[0].Rows[i]["business_fed_taxid"]),

//                            Contacts = new List<Contact>{
//                                new Contact{
//                                    Fname=Convert.ToString(ds.Tables[0].Rows[i]["owner_fname"]),
//                                    Mname=Convert.ToString(ds.Tables[0].Rows[i]["owner_mname"]),
//                                    Lname=Convert.ToString(ds.Tables[0].Rows[i]["owner_lname"]),
//                                    OfficePhone=Convert.ToString(ds.Tables[0].Rows[i]["business_phone"]),
//                                    Email=Convert.ToString(ds.Tables[0].Rows[i]["owner_email"])
//                                }
//                            },
//                            Address = new Address
//                            {
//                                Address1 = Convert.ToString(ds.Tables[0].Rows[i]["business_address"]),
//                                Address2 = Convert.ToString(ds.Tables[0].Rows[i]["business_address2"]),
//                                ZipCode = Convert.ToString(ds.Tables[0].Rows[i]["business_zip"]),
//                                City = Convert.ToString(ds.Tables[0].Rows[i]["business_city"]),
//                                State = Convert.ToString(ds.Tables[0].Rows[i]["business_state"]),
//                                Country = Convert.ToString(ds.Tables[0].Rows[i]["business_country"])
//                            }
//                        }
//                    );
//                }
//            }
//            catch (Exception ex)
//            {
//                throw ex;
//            }
//            finally
//            {
//                Con.Close();
//                Con.Dispose();
//            }

//            return list;
//        }
//        private DateTime ConvertToDateTime(object value)
//        {
//            value = value.ToString();
//            DateTime convertedDate;
//            try
//            {
//                convertedDate = Convert.ToDateTime(value);
//                return convertedDate;
//            }
//            catch (FormatException)
//            {
//                return DateTime.Today;
//            }
//        }
//        public List<TextValuePair> GetScheduleB(string EmailItemID)
//        {
//            SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
//            SqlCommand Cmd = new SqlCommand();
//            Cmd.Connection = Con;
//            Cmd.CommandText = @"SELECT * FROM scheduleB WHERE EmailItemID='" + EmailItemID
//                + "' ORDER BY description";

//            List<TextValuePair> list = new List<TextValuePair>();
//            try
//            {
//                Con.Open();
//                SqlDataAdapter adap = new SqlDataAdapter(Cmd);
//                Cmd.ExecuteNonQuery();
//                var ds = new DataSet();
//                adap.Fill(ds);
//                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
//                {
//                    list.Add(new TextValuePair
//                    {
//                        Value = Convert.ToString(ds.Tables[0].Rows[i]["sb"]),
//                        Text = Convert.ToString(ds.Tables[0].Rows[i]["description"])
//                    });
//                }

//            }
//            catch (Exception ex)
//            {
//                throw ex;
//            }
//            finally
//            {
//                Con.Close();
//                Con.Dispose();
//            }
//            return list;


//        }

//        //SELECT * FROM scheduleB WHERE EmailItemID=" + EmailItemID + " ORDER BY description
//        //feData.AddToDataSet("ExportCode", "SELECT code_id,LEFT(code_id+'-'+CAST(code_desc AS NVARCHAR),32) AS code_desc FROM aes_codes WHERE code_type='Export Code' ORDER BY code_id");
//        //feData.AddToDataSet("LicenseCode", "SELECT code_id,LEFT(code_id+'-'+CAST(code_desc AS NVARCHAR),32) AS code_desc FROM aes_codes WHERE code_type='License Code' ORDER BY code_id");
    }
}
