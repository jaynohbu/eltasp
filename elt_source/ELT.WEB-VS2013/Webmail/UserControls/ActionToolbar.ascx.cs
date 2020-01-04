using System;
using System.Web.UI;
using System.Xml;
using DevExpress.Utils;
using DevExpress.Web.ASPxMenu;
using DevExpress.Web.ASPxClasses;
using System.Collections.Generic;

public partial class UserControls_ActionToolbar : System.Web.UI.UserControl {

    protected void Page_Load(object sender, EventArgs e) {
        SearchBox.Visible = SearchBoxSpacer.Visible = IsSearchBoxVisible();

        ActionMenuDataSource.XPath = string.Format("Pages/{0}/Item", Utils.CurrentPageName);
        ActionMenu.ShowPopOutImages = InfoMenu.ShowPopOutImages = DefaultBoolean.False;
    }

    protected void ActionMenu_ItemDataBound(object sender, MenuItemEventArgs e) {
        IHierarchyData itemHierarchyData = (IHierarchyData)e.Item.DataItem;
        var element = (XmlElement)itemHierarchyData.Item;

        var classAttr = element.Attributes["SpriteClassName"];
        if(classAttr != null)
            e.Item.Image.SpriteProperties.CssClass = classAttr.Value;

        if(e.Item.Parent == e.Item.Menu.RootItem)
            e.Item.ClientVisible = false;
    }

    protected void InfoMenu_OnItemDataBound(object sender, MenuItemEventArgs e) {
        IHierarchyData itemHierarchyData = (IHierarchyData)e.Item.DataItem;
        var element = (XmlElement)itemHierarchyData.Item;

        var classAttr = element.Attributes["SpriteClassName"];
        if(classAttr != null)
            e.Item.Image.SpriteProperties.CssClass = classAttr.Value;

        if(e.Item.Parent.Name == "theme" && e.Item.Name == Utils.CurrentTheme)
            e.Item.Selected = true;

        if(e.Item.Name == "print") {
            var url = GetPrintItemNavigationUrl();
            if(string.IsNullOrEmpty(url))
                e.Item.Visible = false;
            else
                e.Item.NavigateUrl = url;
        }
        if(e.Item.Name == "DownloadTrial")
            e.Item.NavigateUrl = AssemblyInfo.DXLinkTrial;
        if(e.Item.Name == "BuyNow")
            e.Item.NavigateUrl = AssemblyInfo.DXLinkBuyNowASP;
    }

    protected string GetPrintItemNavigationUrl() {
        switch(Utils.CurrentPageName) {
            case "mail":
                return "../PrintMails.aspx";
            case "calendar":
                return "../PrintSchedule.aspx";
            case "contacts":
                return "../PrintContacts.aspx";
        }
        return string.Empty;
    }

    protected bool IsSearchBoxVisible() {
        switch(Utils.CurrentPageName) {
            case "mail":
            case "contacts":
            case "feeds":
                return true;
        }
        return false;
    }
}
