using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ELT.CDT
{
    public enum TokenType
    {
        Agent_PreAlert = 1,
        Shipping_Notice = 2,
        E_Arrival_Notice = 3,
        Proof_Of_Delivery = 4

    }
    public enum EmailType
    {
        AirExport_Agent_PreAlert = 1,
        AirExport_Shipping_Notice = 2,
        OceanExport_Agent_PreAlert = 3,
        OceanExport_Shipping_Notice = 4,
        AirImport_E_Arrival_Notice = 5,
        AirImport_Proof_Of_Delivery = 6,
        OceanImport_E_Arrival_Notice = 7,
        OceanImport_Proof_Of_Delivery = 8, 
        DomesticFreight_Agent_PreAlert = 9,
        DomesticFreight_Shipping_Notice = 10

    }

    public enum BillType
    {
        AirExport_House=1,
        AirEXport_Master=2,
        AirExport_File=3,
        OceanExport_House=4,
        OceanEXport_Master=5,
        OceanExport_File=6,
        OceanImport_House=7,
        OceanImport_Master=8,
        OceanImport_File=9,
        AirImport_House=10,
        AirImport_Master=11,
        AirImport_File=12
    }
    public enum PortBound
    {
        Departure,
        Arrival
    }
    public enum PortType
    {
        Air,
        Ocean,
        Domestic
    }
    public enum ProductMenuContext
    {
        Public=0,
        International = 1,
        Domestic = 2,
        Accounting = 3
    }
    public enum MainMenuContext
    {
        AirExport,
        AirImport,
        OceanExport,
        OceanImport,
        SiteAdmin,
        MasterData,
        PreShipment,
        Report,
        DomesticFreight,
        DomesticReport,
        Accounting_General,
        Accounting_AccountReceivable,
        Accounting_AccountPayable,
        Accounting_Bank,
        Accounting_Report,
        Accounting_Financial,
        Public
    }

    public enum OperationalRole
    {
        Shipper,
        Agent,
        Consignee
    }
    public enum RateType
    {
        CustomerSellingRate=4,
        AirLineBuyingRate=3,
        AgentBuyingRate=1,
        IATARate=5
    }
  
}
