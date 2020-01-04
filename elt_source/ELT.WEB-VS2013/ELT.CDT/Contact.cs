using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace ELT.CDT
{
    [Serializable]
    public class Contact:IContact
    {
        public  string Fname { get; set; }
        public  string Lname { get; set; }
        public  string Mname { get; set; }
        public  string type { get; set; }
        public  string Email { get; set; }
        public  string HomePhone { get; set; }
        public  string OfficePhone { get; set; }
        public  string CellPhone { get; set; }
        public  Address DivisibleAddress { get; set; }
        public int ID { get; set; }
        public string Name { get; set; }    
        public string Address { get; set; }
        public string Phone { get; set; }
        public string Country { get; set; }
        public string City { get; set; }
        public string PhotoUrl { get; set; }
        public bool Collected { get; set; }

    }
}
