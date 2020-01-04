using System;
using System.Linq;
using DevExpress.Utils;
using DevExpress.Web.ASPxMenu;

public partial class UserControls_NavigationToolbar : System.Web.UI.UserControl {
    protected void NavigationMenu_Init(object sender, EventArgs e) {
        var menu = (ASPxMenu)sender;
        var rootItem = Utils.NavigationItems.First(i => i.Text.ToLower() == Utils.CurrentPageName.ToLower());

        var rootMenuItem = new DevExpress.Web.ASPxMenu.MenuItem();
        menu.Items.Add(rootMenuItem);
        rootMenuItem.Text = rootItem.Text;
        rootMenuItem.Image.SpriteProperties.CssClass = rootItem.SpriteClassName;
        rootMenuItem.PopOutImage.SpriteProperties.CssClass = "Sprite_Arrow";

        foreach(var item in Utils.NavigationItems) {
            var menuItem = new DevExpress.Web.ASPxMenu.MenuItem();
            rootMenuItem.Items.Add(menuItem);
            menuItem.Text = item.Text;
            menuItem.NavigateUrl = item.NavigationUrl;
            menuItem.Selected = item == rootItem;
        }
        menu.ShowPopOutImages = DefaultBoolean.True;
    }
}
