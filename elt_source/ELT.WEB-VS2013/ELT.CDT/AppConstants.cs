using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ELT.COMMON
{

    public class AppConstants
    {
        public const int CustomerSellingRateHeaderColumCount = 15;
        public const int CustomerSellingRateDataColumnCount = 14;
        public const int CustomerSellingRateDataColumnStartIndex = 3;
        public const int CustomerSellingRateHeaderColumnStartIndex = 4;

        public const int AgentBuyingRateHeaderColumCount = 15;
        public const int AgentBuyingRateDataColumnCount = 14;
        public const int AgentBuyingRateDataColumnStartIndex = 3;
        public const int AgentBuyingRateHeaderColumnStartIndex = 4;

        public const int AirLineBuyingRateHeaderColumCount = 14;
        public const int AirLineBuyingRateDataColumnCount = 13;
        public const int AirLineBuyingRateDataColumnStartIndex = 2;
        public const int AirLineBuyingRateHeaderColumnStartIndex = 3;

        public const int IATARateHeaderColumnCount = 14;
        public const int IATARateDataColumnCount = 13;
        public const int IATARateDataColumnStartIndex = 2;
        public const int IATARateHeaderColumnStartIndex = 3;

        public const string DB_CONN_PROD = "PRDConnection";
        public const string VIEW_PATH_MENU_MAIN_AIREXPORT = "~/Views/Menu/TopLevel/_AirExportMenu.cshtml";
        public const string VIEW_PATH_MENU_MAIN_AIRIMPORT = "~/Views/Menu/TopLevel/_AirImportMenu.cshtml";
        public const string VIEW_PATH_MENU_MAIN_OCEANEXPORT = "~/Views/Menu/TopLevel/_OceanExportMenu.cshtml";
        public const string VIEW_PATH_MENU_MAIN_OCEANIMPORT = "~/Views/Menu/TopLevel/_OceanImportMenu.cshtml";
        public const string VIEW_PATH_MENU_MAIN_REPORT = "~/Views/Menu/TopLevel/_ReportMenu.cshtml";
        public const string VIEW_PATH_MENU_MAIN_MASTERDATA = "~/Views/Menu/TopLevel/_MasterDataMenu.cshtml";
        public const string VIEW_PATH_MENU_MAIN_SITEADMIN = "~/Views/Menu/TopLevel/_SiteAdminMenu.cshtml";
        public const string VIEW_PATH_MENU_MAIN_PUBLIC = "~/Views/Menu/TopLevel/_PublicMenu.cshtml";

        public const string VIEW_PATH_MENU_MAIN_DOMESTIC_FREIGHT = "~/Views/Menu/TopLevel/_Domestic_FreightMenu.cshtml";
        public const string VIEW_PATH_MENU_MAIN_DOMESTIC_REPORT = "~/Views/Menu/TopLevel/_Domestic_ReportMenu.cshtml";
        public const string VIEW_PATH_MENU_MAIN_ACCOUNTING_ACCOUNT_GENERAL = "~/Views/Menu/TopLevel/_Accounting_GeneralMenu.cshtml";
        public const string VIEW_PATH_MENU_MAIN_ACCOUNTING_ACCOUNT_PAYABLE = "~/Views/Menu/TopLevel/_Accounting_AccountPayableMenu.cshtml";
        public const string VIEW_PATH_MENU_MAIN_ACCOUNTING_ACCOUNT_RECEIVABLE = "~/Views/Menu/TopLevel/_Accounting_AccountReceivableMenu.cshtml";
        public const string VIEW_PATH_MENU_MAIN_ACCOUNTING_ACCOUNT_REPORT = "~/Views/Menu/TopLevel/_Accounting_AccountReportMenu.cshtml";
        public const string VIEW_PATH_MENU_MAIN_ACCOUNTING_BANK = "~/Views/Menu/TopLevel/_Accounting_BankMenu.cshtml";
        public const string VIEW_PATH_MENU_MAIN_ACCOUNTING_FINANCIAL = "~/Views/Menu/TopLevel/_Accounting_FinancialMenu.cshtml";
        public const string VIEW_PATH_MENU_MAIN_PRESHIPMENT = "~/Views/Menu/TopLevel/_PreshipmentMenu.cshtml";

        public const string VIEW_PATH_MENU_PROD_DROPDOWN_MENU = "~/Views/Menu/_ProductDropMenu.cshtml";

        public const string VIEW_PATH_MENU_PRODUCT_PUBLIC = "~/Views/Menu/_PublicMainMenu.cshtml";
        public const string VIEW_PATH_MENU_PRODUCT_INTERNATIONAL = "~/Views/Menu/_InternationalMainMenu.cshtml";
        public const string VIEW_PATH_MENU_PRODUCT_DOMESTIC = "~/Views/Menu/_DomesticMainMenu.cshtml";
        public const string VIEW_PATH_MENU_PRODUCT_ACCOUNTING = "~/Views/Menu/_AccountingMainMenu.cshtml";
        public static readonly string[] AllowedFileExtensions = new string[] {
            ".jpg", ".jpeg", ".gif", ".rtf", ".txt", ".avi", ".png", ".mp3", ".xml", ".doc", ".pdf"
        };

        public static readonly string[] OutputFileExtensions = new string[] {
            "application/jpg", "application/jpeg", "application/gif", "application/rtf", "application/txt", "application/avi", "application/png", "application/mp3", "application/xml", "application/doc", "application/pdf"
        };

        public const int TOKEN_PERIOD_FILE_ACCESS = 20;
        public const string URL_FILE_ACCESS_PAGE = "~/FileManagement/ViewFile";
        public const string ROOT_FOLDER_NAME = "My Files";
        public const string PROFILE_USER = "{0}@{1}.elt";
    }
}
