using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web.ASPxCallback;
using DevExpress.Web.ASPxClasses;
using DevExpress.Web.ASPxDataView;
using DevExpress.Web.ASPxEditors;
using DevExpress.Web.ASPxSplitter;
using DevExpress.Web.ASPxUploadControl;
using ELT.BL;
using ELT.CDT;
public partial class Contacts : System.Web.UI.Page {
    protected string SearchText { get { return Utils.GetSearchText(this); } }

    protected void Page_PreInit(object sender, EventArgs e) {
        Utils.ApplyTheme(this);
    }

    protected void Page_Load(object sender, EventArgs e) {
        if(!IsPostBack)
            ContactForm.Visible = false;
        BindDataView();
        PrepareMasterSplitter();
    }

    protected void ContactCountryEditor_Load(object sender, EventArgs e)
    {
        if (ContactFormPanel.IsCallback || IsPostBack && !IsCallback)
        {
            var combo = (ASPxComboBox)sender;
            ContactsBL BL = new ContactsBL();
            combo.DataSource = BL.GetCountries();
            combo.DataBindItems();
        }

        ContactDataView.ContentStyle.Border.BorderWidth = 0;
    }
    protected void ContactCityEditor_Callback(object sender, CallbackEventArgsBase e) {
        if(string.IsNullOrEmpty(e.Parameter)) 
            return;
        var combo = (ASPxComboBox)sender;
        ContactsBL bl = new ContactsBL();
        combo.DataSource = bl.GetCities(e.Parameter);
        combo.DataBindItems();
    }

    protected void ContactDataView_CustomCallback(object sender, CallbackEventArgsBase e) {
        if(string.IsNullOrEmpty(e.Parameter))
            return;
        var args = e.Parameter.Split('|');
        if(args[0] == "Delete" && args.Length == 2) {
            int id;
            if(!int.TryParse(args[1], out id))
                return;
            ContactsBL bl = new ContactsBL();
            bl.DeleteContact(id);
            BindDataView();
        }
        if(args[0] == "SaveContact") {
            var name = ContactNameEditor.Text;
            var email = ContactEmailEditor.Text;
            var address = ContactAddressEditor.Text;
            var country = ContactCountryEditor.Text;
            var city = ContactCityEditor.Text;
            var phone = ContactPhoneEditor.Text;
            var photoUrl = Utils.GetUploadedPhotoUrl(args[2]);
            int id;
            if (args.Length == 4 && args[1] == "Edit" && int.TryParse(args[3], out id))
            {
                ContactsBL bl = new ContactsBL();
                bl.UpdateContact(id, name, email, address, country, city, phone, photoUrl);

            }
            else if (args.Length == 3 && args[1] == "New")
            {
                ContactsBL bl = new ContactsBL();
               bl.AddContact(name, email, address, country, city, photoUrl, photoUrl);

            }

            BindDataView();
        }
    }

    protected void CallbackControl_Callback(object sender, CallbackEventArgs e) {
        var args = e.Parameter.Split('|');
        if(args[0] == "Edit" && args.Length == 2) {
            int id;
            if(!int.TryParse(args[1], out id)) {
                e.Result = "NotFound";
                return;
            }
            ContactsBL bl = new ContactsBL();
            var Contacts = bl.GetAllContacts("");
            var contact = Contacts.FirstOrDefault(c => c.ID == id);
            if(contact == null) {
                e.Result = "NotFound";
                return;
            }
            var dict = new Dictionary<string, object>();
            dict["Name"] = contact.Name;
            dict["Email"] = contact.Email;
            dict["Address"] = contact.Address;
            dict["City"] = contact.City;
            dict["Country"] = contact.Country;
            dict["Phone"] = contact.Phone;
            dict["ImageUrl"] = Utils.GetContactPhotoUrl(contact.PhotoUrl);
            
            CallbackControl.JSProperties["cpContact"] = dict;
            e.Result = "Edit";
        }
    }

    protected void ContactPhotoImage_CustomJsProperties(object sender, CustomJSPropertiesEventArgs e) {
        e.Properties["cpEmptyImageUrl"] = Utils.GetContactPhotoUrl(string.Empty);
    }

    void BindDataView() {
        ContactDataView.DataSource = SelectContacts();
        ContactDataView.DataBind();
    }

    List<Contact> SelectContacts() {
        ContactsBL bl = new ContactsBL();
        var Contacts = bl.GetAllContacts("");
        var result = Contacts.AsQueryable();
        var showCollectedAdresses = Convert.ToInt32(FindAddressBookList().Value) == 1;
        result = result.Where(c => object.Equals(c.Collected, showCollectedAdresses));

        if(!string.IsNullOrEmpty(SearchText)) {
            var text = SearchText.ToLower();
            result = result.Where(c => c.Name.ToLower().Contains(text) || Utils.GetAddressString(c).ToLower().Contains(text) );
        }
        var sortedFieldName = FindSortByCombo().Value.ToString();
        var isDescending = Convert.ToInt32(FindSortDirectionCombo().Value) == 1;
        result = Utils.MakeContactsOrderBy(result, sortedFieldName, isDescending);
        return result.ToList();
    }

    protected string GetName(DataViewItemTemplateContainer container) {
        var contact = (IContact)container.DataItem;
        return HighlightText(contact.Name);
    }

    protected string GetEmail(DataViewItemTemplateContainer container) {
        var contact = (IContact)container.DataItem;
        return HighlightText(contact.Email);
    }

    protected string GetAddress(DataViewItemTemplateContainer container) {
        var contact = (IContact)container.DataItem;
        return HighlightText(Utils.GetAddressString(contact));
        
    }

    protected string HighlightText(string text) {
        if(string.IsNullOrEmpty(SearchText))
            return text;
        return new Regex(SearchText, RegexOptions.IgnoreCase).Replace(text, "<span class='hgl'>$0</span>");
    }

    ASPxRadioButtonList FindAddressBookList() {
        return ContactViewBar.Groups.FindByName("AddressBooks").FindControl("AddressBookList") as ASPxRadioButtonList;
    }

    ASPxComboBox FindSortByCombo() {
        return ContactViewBar.Groups.FindByName("Sort").FindControl("SortByCombo") as ASPxComboBox;
    }

    ASPxComboBox FindSortDirectionCombo() {
        return ContactViewBar.Groups.FindByName("Sort").FindControl("SortDirectionCombo") as ASPxComboBox;
    }

    protected string GetContactImageUrl(DataViewItemTemplateContainer container) {
        var contact = (IContact)container.DataItem;
        return Utils.GetContactPhotoUrl(contact.PhotoUrl);
    }

    protected bool HasAddress(DataViewItemTemplateContainer container) {
        var contact = (IContact)container.DataItem;
        if(string.IsNullOrEmpty(contact.Address) && string.IsNullOrEmpty(contact.City) && string.IsNullOrEmpty(contact.Country))
            return false;
        return true;
    }
    protected bool HasPhone(DataViewItemTemplateContainer container) {
        var contact = (IContact)container.DataItem;
        return !string.IsNullOrEmpty(contact.Phone);
    }

    protected void EditContactImage_Load(object sender, EventArgs e) {
        PrepareContactCommandImage((ASPxImage)sender);
    }

    protected void DeleteContactImage_Load(object sender, EventArgs e) {
        PrepareContactCommandImage((ASPxImage)sender);
    }

    protected void PrepareContactCommandImage(ASPxImage image) {
        var container = (DataViewItemTemplateContainer)image.NamingContainer;
        var contact = (IContact)container.DataItem;
        image.JSProperties["cpContactKey"] = contact.ID;
    }

    protected void ContactPhotoUpload_FileUploadComplete(object sender, FileUploadCompleteEventArgs e) {
        var uploadControl = (ASPxUploadControl)sender;
        if(!e.UploadedFile.IsValid)
            return;
        Guid imageKey;
        var path = Utils.SaveContactPhoto(e.UploadedFile.FileContent, out imageKey);
        e.CallbackData = string.Format("{0}|{1}", path, imageKey);
    }

    void PrepareMasterSplitter() {
        var rootHolder = Page.Master.Master.FindControl("RootHolder") as ContentPlaceHolder;
        var splitter = rootHolder.FindControl("LayoutSplitter") as ASPxSplitter;
        splitter.GetPaneByName("MainPane").ScrollBars = ScrollBars.Auto;
    }
}
