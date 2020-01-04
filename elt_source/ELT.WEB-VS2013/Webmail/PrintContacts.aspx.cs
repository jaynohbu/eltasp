using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using DevExpress.XtraReports.Web;
using DevExpress.Web.ASPxEditors;
using ELT.CDT;
using ELT.BL;
public partial class PrintContacts : System.Web.UI.Page {
    protected void Page_PreInit(object sender, EventArgs e) {
        Utils.ApplyTheme(this);
    }

    protected string SelectedAddressBook {
        get { 
            string result = null;
            if(Utils.TryGetClientStateValue<string>(this, "AddressBook", out result))
                return result;
            return "Personal";
        }
    }

    protected bool ShowAllContacts { get { return SelectedAddressBook == "All"; } }
    protected bool ShowOnlyPersonalAddresses { get { return SelectedAddressBook == "Personal"; } }

    protected void Page_Load(object sender, EventArgs e) {
        ContactReportViewer.Report = new ContactReport(GetContacts());
    }

    protected IEnumerable GetContacts() {
        ContactsBL bl = new ContactsBL();
        var contacts = bl.GetAllContacts("").AsEnumerable();
        if(!ShowAllContacts) {
            var showOnlyPersonal = ShowOnlyPersonalAddresses;
            contacts = contacts.Where(c => !object.Equals(c.Collected, showOnlyPersonal));
        }
        return contacts.Select(c => new {
            PhotoUrl = "~/" + Utils.GetContactPhotoUrl(c.PhotoUrl),
            Name = c.Name,
            Email = c.Email,
            Address = Utils.GetAddressString(c),
            Phone = c.Phone
        });
    }

    string GetPhotoUrl(IContact contact) {
        var relativePath = Utils.GetContactPhotoUrl(contact.PhotoUrl);
        return Server.MapPath(relativePath);
    }
}
