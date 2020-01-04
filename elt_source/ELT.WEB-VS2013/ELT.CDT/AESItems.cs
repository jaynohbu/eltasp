using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
namespace ELT.CDT
{
    [Serializable]
    public class AESMasterItems
    {
        public AESMasterItems()
            : base()
        {

        }
        public AESMasterItems(AESMasterItems aes)
        {

            this.AESNo = aes.AESNo;
            this.EltAccountNumber = aes.EltAccountNumber;
            this.FileType = aes.FileType;
            this.HAWB = aes.HAWB;
            this.MAWB = aes.MAWB;
            this.ShipmentReferenceNumber = aes.ShipmentReferenceNumber;
            this.TransportationReferenceNumber = aes.TransportationReferenceNumber;
            this.StateOfOrigin = aes.StateOfOrigin;
            this.PortOfExport = aes.PortOfExport;
            this.CountryOfDestination = aes.CountryOfDestination;
            this.PortOfUnloading = aes.PortOfUnloading;
            this.DepartureDate = aes.DepartureDate;
            this.ModeOfTransportation = aes.ModeOfTransportation;
            this.CarrierID = aes.CarrierID;
            this.CarrierName = aes.CarrierName;
            this.PartiesToTransaction = aes.PartiesToTransaction;
            this.HazardousCargo = aes.HazardousCargo;
            this.RoutedExportTransaction = aes.RoutedExportTransaction;
            this.InbondType = aes.InbondType;
            this.ForeignTradeZone = aes.ForeignTradeZone;
            this.InbondNumber = aes.InbondNumber;
            this.ITNNo = aes.ITNNo;
            this.AESStatus = aes.AESStatus;
            this.AESSubmitDate = aes.AESSubmitDate;
            this.LastUpdated = aes.LastUpdated;
            this.ExporterID = aes.ExporterID;
            this.FreightForwarderID = aes.FreightForwarderID;
            this.UltimateConsigneeID = aes.UltimateConsigneeID;
            this.IntermediateConsigneeID = aes.IntermediateConsigneeID;
            this.Exporter = aes.Exporter;
            this.FreightForwarder = aes.FreightForwarder;
            this.UltimateConsignee = aes.UltimateConsignee;
            this.IntermediateConsignee = aes.IntermediateConsignee;
            this.LineItems = aes.LineItems;


        }

        /*
         * auto_uid 
         * EmailItemID 
         * file_type
         */
        public string AESNo { get; set; }
        public string EltAccountNumber { get; set; }
        public string FileType { get; set; }
        /*
         * house_num      
         * master_num    
         * shipment_ref_no 
         * tran_ref_no
         * origin_state        
         */
        public string HAWB { get; set; }
        public string MAWB { get; set; }
        public string ShipmentReferenceNumber { get; set; }
        public string TransportationReferenceNumber { get; set; }
        public string StateOfOrigin { get; set; } //
        /*
         * export_port
         * dest_country
         * unloading_port
         * export_date
         * tran_method
         */
        public string PortOfExport { get; set; } //
        public string CountryOfDestination { get; set; }
        public string PortOfUnloading { get; set; } //
        public DateTime DepartureDate { get; set; }
        public string ModeOfTransportation { get; set; } //
        /*
        * carrier_id_code
         * shipper_acct
         * party_to_transaction
         * hazardous_materials
         * route_export_tran
         * in_bond_type
        */
        public string CarrierID { get; set; }//
        public string CarrierName { get; set; }//
        public string PartiesToTransaction { get; set; } //// RL
        public string HazardousCargo { get; set; }//// RL
        public string RoutedExportTransaction { get; set; }//// RL

        public string InbondType { get; set; }//
        /*
        * ftz
         * in_bond_no
         * aes_itn
         * aes_status
         * tran_date
        */
        public string ForeignTradeZone { get; set; }
        public string InbondNumber { get; set; }
        public string ITNNo { get; set; }
        public string AESStatus { get; set; }
        public DateTime AESSubmitDate { get; set; }
        /*
         * last_modified
         * export_carrier
         * agent_acct
         * consignee_acct
         * inter_consignee_acct

         * entry_no      
        */

        public DateTime LastUpdated { get; set; }
        public string ExporterID { get; set; }
        public string FreightForwarderID { get; set; }
        public string UltimateConsigneeID { get; set; }
        public string IntermediateConsigneeID { get; set; }

        public virtual Company Exporter { get; set; }
        public virtual Company FreightForwarder { get; set; }
        public virtual Company UltimateConsignee { get; set; }
        public virtual Company IntermediateConsignee { get; set; }

        public virtual List<AESLineItem> LineItems { get; set; }



    }
    [Serializable]
    public class AESLineItem
    {
        /*
         * EmailItemID               
         * item_no   
         * dfm  
         * b_number     
         * item_desc   
         * 
         * b_qty1     
         * unit1          
         * b_qty2     
         * unit2           
         * gross_weight  
         * 
         * vin_type 
         * vin     
         * vc_title       
         * vc_state 
         * item_value   
         * 
         * export_code     
         * license_type  
         * aes_id              
         * eccn  
         * license_number
         * 
         * id
         */

       // ID	dfm	b_number	b_number_copy	b_qty1	unit1	b_qty2	unit2	gross_weight	item_value	export_code	license_type	license_number	eccn	vin_type	vin	vc_title	vc_state
							


        public virtual int ELT_ACCOUNT_NUMBER { get; set; }
        public virtual int ID { get; set; }
        public virtual int ItemNo { get; set; }// 0,1,2,3...
        public virtual string Origin { get; set; }// dfm D, F 
        public virtual string ScheduleB { get; set; }
        public virtual string ItemDesc { get; set; }

        public virtual int Qty1 { get; set; }//
        public virtual string Unit1 { get; set; }
        public virtual int Qty2 { get; set; }//
        public virtual string Unit2 { get; set; }
        public virtual string GrossWeight { get; set; }

        public virtual string VehicleIDType { get; set; }//
        public virtual string VehicleID { get; set; }//
        public virtual string VehicleTitle { get; set; }//
        public virtual string VihicleState { get; set; }
        public virtual string ItemValue { get; set; }

        public virtual string ExportCode { get; set; }
        public virtual string LicenseType { get; set; }
        public virtual int AesID { get; set; }
        public virtual string ECCN { get; set; }
        public virtual string LicenseNumber { get; set; }
        public bool IsModified { get; set; }
    }
}
