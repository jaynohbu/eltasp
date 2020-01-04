using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{

    public interface IContact
    {
        int ID { get; set; }
        string Name { get; set; }
        string Email { get; set; }
        string Address { get; set; }
        string Phone { get; set; }
        string Country { get; set; }
        string City { get; set; }
        string PhotoUrl { get; set; }
        bool Collected { get; set; }
    }
}
