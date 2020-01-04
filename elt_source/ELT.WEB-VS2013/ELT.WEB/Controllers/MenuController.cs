using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ELT.COMMON;
using ELT.WEB.Models;
using ELT.CDT;
using ELT.BL;
using System.Web.UI.WebControls;
namespace ELT.WEB.Controllers
{
    [Authorize]
    public class MenuController : ControllerBase 
    {
        public ActionResult FavoriteMenu()
        {
            TreeMenu AllMenu = new TreeMenu();
            TreeMenu SupportMenuItem = new TreeMenu("Support Center", "javascript:PopWindowURL('"+Url.Content("~/IFF_MAIN/ASPX/misc/support_main.aspx'")+",400,300)");
            TreeMenu ClientSearchMenuItem = new TreeMenu("Client Search", "javascript:PopWindowURL('"+Url.Content("~/IFF_MAIN/ASPX/onlines/companyconfig/companysearch.aspx'")+",800,600)");
            TreeMenu DocMenuItem = new TreeMenu("Document Status", "javascript:PopWindowURL('"+Url.Content("~/IFF_MAIN/ASPX/doctrack/operationdoctracking.aspx'")+",800,600)");
            TreeMenu RecentWorkMenuItem = new TreeMenu("Recent Works", "javascript:PopWindowURL('"+Url.Content("~/IFF_MAIN/ASPX/misc/recentwork2.aspx'")+",800,600)");
            TreeMenu FavoirteMenuItems = new TreeMenu("Favorites", "javascript:PopWindowURL('" + Url.Content("~/asp/site_admin/favorite_manager.asp'") + ",800,600)");
            TreeMenu BoardMenuItem = new TreeMenu("Company Board", "javascript:viewPrivateBoard();");
           
            AllMenu.Children.Add(SupportMenuItem);
            AllMenu.Children.Add(ClientSearchMenuItem);
            AllMenu.Children.Add(DocMenuItem);
            AllMenu.Children.Add(RecentWorkMenuItem);
            AllMenu.Children.Add(FavoirteMenuItems);
            AllMenu.Children.Add(BoardMenuItem);
            string elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            string user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
            TabsBL tbBL = new TabsBL();
            var items = tbBL.GetAllFavoriteTabItem(elt_account_number, user_id);   
            var tops = (from c in items select c.top_module).Distinct();
            foreach (var t in tops)
            {
                var FirstMenuItem = new TreeMenu(t, "javascript:void(0)");
                FavoirteMenuItems.Children.Add(FirstMenuItem);
                var seconds = (from c in items where c.top_module == t select c.sub_module).Distinct();
                foreach (var s in seconds)
                {
                    var SecondMenuItem = new TreeMenu(s, "javascript:void(0)");
                    FirstMenuItem.Children.Add(SecondMenuItem);
                    var third = (from c in items where c.sub_module == s && c.top_module == t select c);
                    foreach (var thr in third)
                    {
                        SecondMenuItem.Children.Add(new TreeMenu(thr.page_label, "javascript:PopWindowURL('" + Url.Content("~/"+thr.page_url) + "',800,600)"));
                    }
                }
            }



            var model = new HierarchicalModelDataSource<TreeMenu> { DataSource = AllMenu.Children };
            return PartialView("_FavoriteMenu", model);

        }

        public ActionResult Index()
        {
            return View();
        }
    
        public ActionResult ProductDropDownMenu()
        {
            SetUserProductMenu();
            if (Request["ProductMenuList"] != null)
            {
                CurrentMenu.Context = (ProductMenuContext)Convert.ToInt32(Request["ProductMenuList"]);//this determines the MainMenu menu
                if (CurrentMenu.Context == ProductMenuContext.Accounting)
                {
                    return Redirect("~/Accounting/");
                }
                if (CurrentMenu.Context == ProductMenuContext.Domestic)
                {
                    return Redirect("~/SiteAdmin/");
                }

                if (CurrentMenu.Context == ProductMenuContext.Public)
                {
                    return Redirect("~/Public/");
                }
                return Redirect("~/SiteAdmin/");
            }          
           
            return PartialView(AppConstants.VIEW_PATH_MENU_PROD_DROPDOWN_MENU, CurrentMenu);         
        }

        private void SetUserProductMenu()
        {
            //BASED ON User's contract
            List<SelectListItem> ProductMenuList = new List<SelectListItem>();
            //ProductMenuList.Add(new SelectListItem() { Text = ProductMenuContext.Public.ToString(), Value = Convert.ToString((int)ProductMenuContext.Public) });
            ProductMenuList.Add(new SelectListItem() { Text = ProductMenuContext.International.ToString(), Value = Convert.ToString((int)ProductMenuContext.International) });
            ProductMenuList.Add(new SelectListItem() { Text = ProductMenuContext.Domestic.ToString(), Value = Convert.ToString((int)ProductMenuContext.Domestic) });
            ProductMenuList.Add(new SelectListItem() { Text = ProductMenuContext.Accounting.ToString(), Value = Convert.ToString((int)ProductMenuContext.Accounting) });

            ViewBag.ProductMenuList = ProductMenuList;
        }

       


        public ActionResult ProductMenu()
        {
            if (CurrentMenu.Context == ProductMenuContext.International)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_PRODUCT_INTERNATIONAL, CurrentMenu);
            }
            if (CurrentMenu.Context == ProductMenuContext.Domestic)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_PRODUCT_DOMESTIC, CurrentMenu);
            }
            if (CurrentMenu.Context == ProductMenuContext.Accounting)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_PRODUCT_ACCOUNTING, CurrentMenu);
            }
            if (CurrentMenu.Context == ProductMenuContext.Public)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_PRODUCT_PUBLIC, CurrentMenu);
            }
           
             return PartialView(AppConstants.VIEW_PATH_MENU_PRODUCT_INTERNATIONAL, CurrentMenu);//base menu
                //depends on the product, for now international  for example we can determin light version here
        }

        public ActionResult MainMenu()
        {
            if (CurrentMenu.SubContext == MainMenuContext.SiteAdmin)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_MAIN_SITEADMIN);
            }
            else if (CurrentMenu.SubContext == MainMenuContext.MasterData)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_MAIN_MASTERDATA);  
            }
            else if (CurrentMenu.SubContext == MainMenuContext.AirExport)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_MAIN_AIREXPORT);  
            }
            else if (CurrentMenu.SubContext == MainMenuContext.AirImport)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_MAIN_AIRIMPORT);  
            }
            else if (CurrentMenu.SubContext == MainMenuContext.OceanExport)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_MAIN_OCEANEXPORT);  
            }
            else if (CurrentMenu.SubContext == MainMenuContext.OceanImport)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_MAIN_OCEANIMPORT);  
            }
            else if (CurrentMenu.SubContext == MainMenuContext.Report)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_MAIN_REPORT);  
            }
            else if (CurrentMenu.SubContext == MainMenuContext.DomesticFreight)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_MAIN_DOMESTIC_FREIGHT);
            }
            else if (CurrentMenu.SubContext == MainMenuContext.DomesticReport)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_MAIN_DOMESTIC_REPORT);
            }
            else if (CurrentMenu.SubContext == MainMenuContext.Accounting_General)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_MAIN_ACCOUNTING_ACCOUNT_GENERAL);
            }
            else if (CurrentMenu.SubContext == MainMenuContext.Accounting_AccountPayable)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_MAIN_ACCOUNTING_ACCOUNT_PAYABLE);
            }
            else if (CurrentMenu.SubContext == MainMenuContext.Accounting_AccountReceivable)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_MAIN_ACCOUNTING_ACCOUNT_RECEIVABLE);
            }
            else if (CurrentMenu.SubContext == MainMenuContext.Accounting_Bank)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_MAIN_ACCOUNTING_BANK);
            }
            else if (CurrentMenu.SubContext == MainMenuContext.Accounting_Financial)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_MAIN_ACCOUNTING_FINANCIAL);
            }
            else if (CurrentMenu.SubContext == MainMenuContext.Accounting_Report)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_MAIN_ACCOUNTING_ACCOUNT_REPORT);
            }
            else if (CurrentMenu.SubContext == MainMenuContext.PreShipment)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_MAIN_PRESHIPMENT);
            }
            else if (CurrentMenu.SubContext == MainMenuContext.Public)
            {
                return PartialView(AppConstants.VIEW_PATH_MENU_MAIN_PUBLIC);
            }
            return PartialView(AppConstants.VIEW_PATH_MENU_MAIN_AIREXPORT);//should return a error view
        }

    }
}
