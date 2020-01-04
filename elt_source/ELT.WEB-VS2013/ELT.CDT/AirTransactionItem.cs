using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{

    [Serializable]
    public class AirTransactionItem
    {
        //File#	Master	House	Shipper	Consignee	Agent	Carrier	Origin	Destination	Date	Sales Rep.	Processed By	Quantity	Gross Wt.	Chargeable Wt.	Freight Charge	Other Charge
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

        public string ChargeableWeight
        {
            get;
            set;
        }


    }
}
