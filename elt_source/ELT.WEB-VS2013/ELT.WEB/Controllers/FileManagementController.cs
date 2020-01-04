using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DevExpress.Web.ASPxUploadControl;
using System.Web.UI;
using System.IO;
using ELT.CDT;
using ELT.COMMON;
using ELT.BL;
using System.Collections.Specialized;
using ELT.WEB.Models;
using ELT.WEB.DataProvider;

namespace ELT.WEB.Controllers
{
    [Authorize]
    public class FileManagementController : ControllerBase
    {
        public ActionResult DocumentManager(string param)
        {
            string RootFolder = string.Empty;
            ELTFileSystemProvider provider = new ELTFileSystemProvider(RootFolder);
            FileSystemBL bl = new FileSystemBL();
            int id = bl.GetRootFileItemID(User.Identity.Name);
            var rootfolder = bl.GetFileByID(id);
            ViewBag.InitialFolder = rootfolder.Name;
            if (Session["FileFolderToBeSet"] != null)
            {
                ViewBag.InitialFolder = (string)Session["FileFolderToBeSet"];
                Session["FileFolderToBeSet"] = null;
            }

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View(provider);
        }

      
         [ValidateInput(false)]
        public ActionResult FileAttacher()
        {
            string ItemID = Request.QueryString["itemid"];
            string EmailType = Request.QueryString["EmailType"];

            ViewBag.ItemID = ItemID;
            ViewBag.EmailType = EmailType;

             //these two will be viewbag item to the client !
            string RootFolder = string.Empty;
            ELTFileSystemProvider provider = new ELTFileSystemProvider(RootFolder);
            FileSystemBL bl = new FileSystemBL();
            int id = bl.GetRootFileItemID(User.Identity.Name);
            var rootfolder = bl.GetFileByID(id);
            ViewBag.InitialFolder = rootfolder.Name;
            if (Session["FileFolderToBeSet"] != null)
            {
                ViewBag.InitialFolder = (string)Session["FileFolderToBeSet"];
                Session["FileFolderToBeSet"] = null;
            }
            return View("FileAttacher", provider);
        }
        public ActionResult ViewFile()
        {
            if (string.IsNullOrEmpty(Request.QueryString["FileID"])
                || string.IsNullOrEmpty(Request.QueryString["Token"])
                || string.IsNullOrEmpty(Request.QueryString["UserEmail"]))
                return RedirectToAction("ErrorView", new ELTError()
                {
                    Type = ELTErrorType.Input_format_is_not_correct,
                    Description = ELTErrorType.Input_format_is_not_correct.ToString(),
                    ReferenceID = ErrorConstant.ERROR_REF10000
                });

            //Check if Cookie is Expired.
            TokenBL tBL = new TokenBL();
            FileSystemBL fBL = new FileSystemBL();
            ELTToken token = tBL.GetToken(Request.QueryString["Token"]);
            //If so return a view that the file is no longer availabe and you need to get the file from the sender.
            if (token.Expired) return RedirectToAction("ErrorView", new ELTError()
            {
                Type = ELTErrorType.Token_has_been_expired,
                Description = ELTErrorType.Token_has_been_expired.ToString(),
                ReferenceID = ErrorConstant.ERROR_REF10002
            });


            if (Request.Cookies["TempUser"] != null )
            {
                if (Request.Cookies["TempUser"]["ReadFileAllowedToken"] == Request.QueryString["Token"])
                    return ReturnELTFile(Convert.ToInt32(Request.QueryString["FileID"]));
               
            }

            if (!User.Identity.IsAuthenticated)
            {
                Session["NewUserFromFileAccess"] = Request.Url.Query;
                //NameValueCollection qscoll=    HttpUtility.ParseQueryString(Request.Url.Query);
                return RedirectToAction("Index", "Home");
            }
            else
            {
                int FileID = fBL.GetFileIDforParentID(User.Identity.Name, Convert.ToInt32(Request.QueryString["FileID"]));
                if (FileID == 0)
                    return RedirectToAction("ErrorView", new ELTError()
                    {
                        Type = ELTErrorType.File_does_not_exist,
                        Description = ELTErrorType.File_does_not_exist.ToString(),
                        ReferenceID = ErrorConstant.ERROR_REF10001
                    });
                return ReturnELTFile(FileID);
            }

            
        }
        public ActionResult ViewFileTester()
        {
          FileSystemBL fBL = new FileSystemBL();
          return ReturnELTFile(int.Parse(Request.QueryString["FileID"]));
        }
        public ActionResult RejectOffer()
        {
            FileRequestModel FileRequestModel= (FileRequestModel) Session["FileRequestModel"];
            int GID = FileRequestModel.GID;
            MessageBL BL = new MessageBL();
           var logs= BL.GetAttachmentLog(GID);
           
           if (logs[0].RecipientEmail == FileRequestModel.UserEmail)
           {
               Response.Cookies["TempUser"]["ReadFileAllowedToken"] = FileRequestModel.Token;
               Session["FileRequestModel"] = null;
               return Json(new { Status = "Sucess" }, JsonRequestBehavior.AllowGet);
           }
           else
           {
               Session["FileRequestModel"] = null;
               return Json(new { Status = "Fail", ErrorMsg = "The specified file does not belong to the user." }, JsonRequestBehavior.AllowGet);
              
               //Return Error and let the View calls th error 
           }          
            //start Token
          
        }

        public ActionResult Index()
        {
            return View();
        }

        [HttpGet]
        public ActionResult MultiFileUpload()
        {
            Session["Storage"] = new UploadControlFilesStorage();
            return View("MultiFileUpload");
        }
        [HttpPost]
        public ActionResult MultiFileUpload(UploadedFile[] ucMultiFile)
        {
            if (Request.Params["add"] != null)
            {
              
            }
            else if (Request.Params["clear"] != null)
            {
               
            }
            return View("MultiFileUpload");
        }

    }
}
public class UploadFileHelper
{
    public const string UploadDirectory = "~/Content/UploadControl/UploadFolder/";
    public const string ThumbnailFormat = "Thumbnail{0}{1}";

    public static readonly ValidationSettings ValidationSettings = new ValidationSettings
    {
        AllowedFileExtensions = new string[] { ".doc", ".pdf", ".xlsx", ".xlsm", ".xls", ".xlw", ".xls", ".xml", ".jpg", ".jpeg", ".jpe", ".gif" },
        MaxFileSize = 20971520
    };
    
    public static List<string> Files
    {
        get
        {
            UploadControlFilesStorage storage = HttpContext.Current.Session["Storage"] as UploadControlFilesStorage;
            if (storage != null)
                return storage.Files;
            return new List<string>();
        }
    }
    public static int FileInputCount
    {
        get
        {
            UploadControlFilesStorage storage = HttpContext.Current.Session["Storage"] as UploadControlFilesStorage;
            if (storage != null)
                return storage.FileInputCount;
            return 2;
        }
    }

   
    public static void ucCallbacks_FileUploadComplete(object sender, FileUploadCompleteEventArgs e)
    {
        if (e.UploadedFile.IsValid)
        {
            string resultFilePath = UploadDirectory + string.Format(ThumbnailFormat, "", Path.GetExtension(e.UploadedFile.FileName));
          //  using (Image original = Image.FromStream(e.UploadedFile.FileContent))
            //using (Image thumbnail = PhotoUtils.Inscribe(original, 100))
            //{
            //    PhotoUtils.SaveToJpeg(thumbnail, HttpContext.Current.Request.MapPath(resultFilePath));
            //}
            //IUrlResolutionService urlResolver = sender as IUrlResolutionService;
            //if (urlResolver != null)
            //    e.CallbackData = urlResolver.ResolveClientUrl(resultFilePath) + "?refresh=" + Guid.NewGuid().ToString();
        }
    }
   
}
public class UploadControlFilesStorage
{
    List<string> files;

    public UploadControlFilesStorage()
    {
        this.files = new List<string>();
        FileInputCount = 2;
    }

    public int FileInputCount { get; set; }
    public List<string> Files { get { return files; } }
}
