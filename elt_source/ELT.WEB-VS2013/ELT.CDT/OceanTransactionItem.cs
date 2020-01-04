using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{

    //O I
    //	File#	MBOL#	HBOL#	Shipper	Consignee	Carrier	Origin	Destination	ETA	Sales Rep.	Processed By	
    //Quantity	Gross Wt.	Measurement	Freight Charge	Other Charge

    //OE
    //	File#	MBOL#	HBOL#	Shipper	Consignee	Carrier	Origin	Destination	ETD	Sales Rep.	Processed By	
    //Quantity	Gross Wt.	Measurement	Freight Charge	Other Charge

    //AI
    //	File#	MAWB#	HAWB#	Shipper	Consignee	Carrier	Origin	Destination	ETA	Sales Rep.	Processed By	
    //Quantity	Gross Wt.	Chargeable Wt.	Freight Charge	Other Charge
    
    //AE
    //	File#	MAWB#	HAWB#	Shipper	Consignee	Carrier	Origin	Destination	ETD	Sales Rep.	Processed By	
    //Quantity	Gross Wt.	Chargeable Wt.	Freight Charge	Other Charge


      [Serializable]
    public class OceanTransactionItem
    {
        public string Freight_Charge
        {
            get;
            set;
        }

        public string Other_Charge
        {
            get;
            set;
        }
        public string Gros_Wt
        {
            get;
            set;

        }
        public string FileNo
        {
            get;
            set;
        }
        public string Master
        {
            get;
            set;
        }
        public string House
        {
            get;
            set;
        }
        public string Shipper
        {
            get;
            set;
        }
        public string Consignee
        {
            get;
            set;
        }
        public string Agent
        {
            get;
            set;
        }
        public string Carrier
        {
            get;
            set;
        }
        public string Origin
        {
            get;
            set;
        }
        public string Destination
        {
            get;
            set;
        }
        public string Date
        {
            get;
            set;
        }
        public string Sale_Rep
        {
            get;
            set;
        }
        public string Processed_By
        {
            get;
            set;
        }
        public string Quantity
        {
            get;
            set;
        }

        public string Measurement
        {
            get;
            set;
        }
    }
}
