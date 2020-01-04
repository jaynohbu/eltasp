using DotNetOpenAuth.AspNet;
using ELT.BL;
using ELT.CDT;
using ELT.COMMON;
using ELT.WEB.Filters;
using ELT.WEB.Models;
using Microsoft.Web.WebPages.OAuth;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Mail;
using System.Transactions;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using WebMatrix.WebData;
namespace ELT.WEB.Controllers
{
    [Authorize]
    [InitializeSimpleMembership]
    public class AccountController : ControllerBase
    {
        //
        // GET: /Account/Login
        AdminToolBL adToolBL = new AdminToolBL();
        AuthenticationBL authBL = new AuthenticationBL();
        [AllowAnonymous]
        public ActionResult Login(string returnUrl)
        {
            ViewBag.ReturnUrl = returnUrl;
            return View();
        }

        [AllowAnonymous]
        [HttpGet]
        public ActionResult CreateDummyLogin(string returnUrl)
        {
            WebSecurity.CreateUserAndAccount("dummy", "elt1234_forever");
            return new EmptyResult();
        }

        //   
        //
        // POST: /Account/Login

        [HttpPost]
        [AllowAnonymous]
        //[ValidateAntiForgeryToken]
        public ActionResult Login(LoginModel model, string returnUrl)
        {
            if (ModelState.IsValid)
            {
                if (model.UserName.Contains("@") && WebSecurity.Login(model.UserName, model.Password))
                {
                    model.ProfileUser = model.UserName;
                    return DoLogin(model);
                }
                if (authBL.CheckLogin(Convert.ToInt32(model.ELT_account_number), model.UserName, model.Password))
                {
                    var profile_user= string.Format(COMMON.AppConstants.PROFILE_USER, model.UserName,model.ELT_account_number);
                    if (!authBL.CheckProfileExist(Convert.ToInt32(model.ELT_account_number), profile_user))
                    {
                        WebSecurity.CreateUserAndAccount(profile_user, "1234");
                        authBL.UpdateProfileEltAccount(Convert.ToInt32(model.ELT_account_number),profile_user);
                    }
                    model.ProfileUser = profile_user;
                    WebSecurity.Login(profile_user, "1234");
                    return DoLogin(model);
                }
            }

            // If we got this far, something failed, redisplay form
            ModelState.AddModelError("", "The user name or password provided is incorrect.");
            return View(model);
        }

        private ActionResult DoLogin(LoginModel model)
        {
            AuthenticationBL sMgr = new AuthenticationBL();
            string Msg = "";
           
            Session["login_name"] = model.UserName;

            var sessionId = Guid.NewGuid().ToString();
            Response.Cookies.Add(new HttpCookie("ELTSession", sessionId));

            bool isUserValid = sMgr.CheckSession(1, model.UserName, Convert.ToInt32(model.ELT_account_number),"", sessionId, Request.Url.PathAndQuery,
                out Msg);

            if (!isUserValid)
            {
                ModelState.AddModelError("", Msg);
                return View(model);
                //There are casese when Redirection already took place. In this case, the redirection will not work. 
            }

            System.Web.HttpContext.Current.Session["elt_account_number"] = model.ELT_account_number;
            return RedirectToAction("UserLandingPage", model);
        }

        public ActionResult UserLandingPage(LoginModel model)
        { 
            var context = new UsersContext();
            var username = model.ProfileUser;           
            var user = context.UserProfiles.SingleOrDefault(u => u.UserName == username);
            Session["UserID"] = user.UserId;
            if (string.IsNullOrEmpty(user.elt_account_number)) 
                return RedirectToAction("LogOff");
            if (model.UserName == "system")
            {
                Session["elt_account_number_for"] = model.ELT_account_number;
            }
            Session["elt_account_number"] = model.ELT_account_number;
            ELTUser ELTUser = authBL.GetELTUser( model.UserName);
            authBL.PerformCreateLoginInfoForLegacyASPNET(ELTUser,Session.SessionID);
            authBL.LinkWithAsp(ELTUser);
            return RedirectToAction("Index", "SiteAdmin");
        }
        //
        // POST: /Account/LogOff

       
        public ActionResult LogOff()
        {
            AuthenticationBL sMgr = new AuthenticationBL();
            string Msg = "";
            var httpCookie = Request.Cookies["ELTSession"];

            sMgr.CheckSession(3, Session["login_name"].ToString(),Convert.ToInt32(Session["elt_account_number"]), "", httpCookie.Value, "", out Msg);
            WebSecurity.Logout();          
            authBL.PerformDBLogOutFromLegacyASPNET();
            Session.Abandon();
            
           
            return RedirectToAction("Index", "Home");
        }
        public ActionResult SignOut()
        {
            AuthenticationBL sMgr = new AuthenticationBL();
            string Msg = "";
            var httpCookie = Request.Cookies["ELTSession"];

            sMgr.CheckSession(3, Session["login_name"].ToString(), Convert.ToInt32(Session["elt_account_number"]), "", httpCookie.Value, "", out Msg);
            WebSecurity.Logout();
            authBL.PerformDBLogOutFromLegacyASPNET();
            return RedirectToAction("Index", "Home");
        }
        //
        // GET: /Account/Register

        [AllowAnonymous]
        public ActionResult Register()
        {
            string UserEmail = Request.QueryString["UserEmail"];
            if (Request.QueryString["NewRegFromFileAccess"] != null)
            {
                FileRequestModel model = (FileRequestModel)Session["FileRequestModel"];
                UserEmail = model.UserEmail;
            }   
            if (!string.IsNullOrEmpty(UserEmail)) ViewBag.UserEmail = UserEmail;
            return View();
        }
        [AllowAnonymous]
        public ActionResult NewRegistrationViaFileAccess()
        {
           FileRequestModel model=(FileRequestModel) Session["FileRequestModel"];
           return View(model);
        }       

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Register(RegisterModel model)
        {
            if (ModelState.IsValid)
            {
                // Attempt to register the user
                try
                {
                    WebSecurity.CreateUserAndAccount(model.UserName, model.Password);
                    WebSecurity.Login(model.UserName, model.Password);
                    //ClientProfileBL bl = new ClientProfileBL();
                    //bl.CreateNewClientFileFolder(model.UserName);
                    //if (Session["FileRequestModel"] != null)
                    //{
                    //    MoveClientFiles(model);
                    //    Session["FileRequestModel"] = null;

                    //}
                    return RedirectToAction("UserLandingPage", new LoginModel() {  UserName=model.UserName, Password=model.Password});
                }
                catch (MembershipCreateUserException e)
                {
                    ModelState.AddModelError("", ErrorCodeToString(e.StatusCode));
                }
            }

            // If we got this far, something failed, redisplay form
            return View(model);
        }

        private void MoveClientFiles(RegisterModel model)
        {
            FileRequestModel FileRequestModel = (FileRequestModel)Session["FileRequestModel"];
            int GID = FileRequestModel.GID;
            //CreateRootFolder 
            FileSystemBL fBL = new FileSystemBL();
            string RootFolderName = AppConstants.ROOT_FOLDER_NAME;
            MessageBL mBL = new MessageBL();
            var GetAttachmentLog = mBL.GetAttachmentLog(GID);
            ELTFileSystemItem RootFolderItem = new ELTFileSystemItem() { Owner_Email = model.UserName, IsFolder = true, Name = RootFolderName, ParentID = -1 };
            fBL.InsertFile(RootFolderItem);
            string SenderEmailFolder = GetAttachmentLog[0].SenderEmail;
            ELTFileSystemItem SenderEmailFolderItem = new ELTFileSystemItem() { Owner_Email = model.UserName, IsFolder = true, Name = SenderEmailFolder, ParentID = RootFolderItem.ID };
            fBL.InsertFile(SenderEmailFolderItem);
            string DocFolder = GetAttachmentLog[0].ReferenceNo;
            ELTFileSystemItem DocFolderItem = new ELTFileSystemItem() { Owner_Email = model.UserName, IsFolder = true, Name = DocFolder, ParentID = SenderEmailFolderItem.ID };
            fBL.InsertFile(DocFolderItem);

            //mBL.CopyAttachment(GID, model.UserName, DocFolderItem.ID);
          
            Session["FileFolderToBeSet"] = DocFolderItem.Name;
        }
        public bool IsValidEmail(string emailaddress)
        {
            try
            {
                MailAddress m = new MailAddress(emailaddress);

                return true;
            }
            catch (FormatException)
            {
                return false;
            }
        }
        

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Disassociate(string provider, string providerUserId)
        {
            string ownerAccount = OAuthWebSecurity.GetUserName(provider, providerUserId);
            ManageMessageId? message = null;

            // Only disassociate the account if the currently logged in user is the owner
            if (ownerAccount == User.Identity.Name)
            {
                // Use a transaction to prevent the user from deleting their last login credential
                using (var scope = new TransactionScope(TransactionScopeOption.Required, new TransactionOptions { IsolationLevel = IsolationLevel.Serializable }))
                {
                    bool hasLocalAccount = OAuthWebSecurity.HasLocalAccount(WebSecurity.GetUserId(User.Identity.Name));
                    if (hasLocalAccount || OAuthWebSecurity.GetAccountsFromUserName(User.Identity.Name).Count > 1)
                    {
                        OAuthWebSecurity.DeleteAccount(provider, providerUserId);
                        scope.Complete();
                        message = ManageMessageId.RemoveLoginSuccess;
                    }
                }
            }

            return RedirectToAction("Manage", new { Message = message });
        }

        //
        // GET: /Account/Manage

        public ActionResult ResetPWD()
        {
            int user_id=Convert.ToInt32(Request.QueryString["user_id"]);
            string word = Request.QueryString["word"];
            AuthenticationBL bl = new AuthenticationBL();
            string elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            var me = bl.GetELTUser( User.Identity.Name);
            bool result = false;
            if (me.user_type == "9")
            {
                string user_login = bl.GetEltLoginName(int.Parse(elt_account_number), user_id);
                string token = WebSecurity.GeneratePasswordResetToken(user_login);
               result= WebSecurity.ResetPassword(token, word);
            }
            return new ContentResult() { Content = result.ToString() };
        }

        public ActionResult UpdateLogin()
        {            
            string newlogin = Request.QueryString["loginId"];
            string oldLoginId = Request.QueryString["oldLoginId"];
            string Content = "True";
            if (oldLoginId == User.Identity.Name) { Content = "Self"; }
            AuthenticationBL bl = new AuthenticationBL();
            string elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            var me = bl.GetELTUser(User.Identity.Name);
            bool result = false;
            string Msg = "";
            if (me.user_type == "9")
            {
                result = bl.UpdateLoginId(newlogin, oldLoginId, Convert.ToInt32(elt_account_number), out Msg);

                if (result == true)
                {
                    return new ContentResult() { Content = Content };
                }
                else
                {
                    if (Msg == "UserNotCreated")
                    {
                        Msg = "";
                        var OLD = bl.GetELTUser(oldLoginId);
                        if (OLD.login_name == oldLoginId)
                        {
                            WebSecurity.CreateUserAndAccount(oldLoginId, OLD.password);
                            using (UsersContext db = new UsersContext())
                            {
                                UserProfile user = db.UserProfiles.FirstOrDefault(u => u.UserName.ToLower() == oldLoginId.ToLower());
                                if (user !=null)
                                {
                                    user.elt_account_number = me.elt_account_number;
                                    db.SaveChanges();
                                }
                            }
                            result = bl.UpdateLoginId(newlogin, oldLoginId, Convert.ToInt32(elt_account_number), out Msg);
                            if (result)
                            {
                                result = bl.InitAuthorizePage(int.Parse(elt_account_number), int.Parse(OLD.userid), int.Parse(OLD.user_type));
                                if (!result) Msg = "Initial Authorization Failed!";
                            }
                        }
                        if (result == true)
                        {
                            return new ContentResult() { Content = Content };
                        }
                        else
                        {
                            return new ContentResult() { Content = Msg };
                        }
                    }
                    return new ContentResult() { Content = Msg };
                }
            }
            else
            {
                return new ContentResult() { Content = "You are not allowed to perform this action" };
            }
        }

        public ActionResult InitAuthPages()
        {
            //   public void InitAuthorizePage(int elt_account_number, int user_id, int user_type)
            int user_id = Convert.ToInt32(Request.QueryString["user_id"]);
            int user_type = Convert.ToInt32(Request.QueryString["user_type"]);
            AuthenticationBL bl = new AuthenticationBL();
            string elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            var me = bl.GetELTUser( User.Identity.Name);
            bool result = false;
            if (me.user_type == "9")
            {
               result= bl.InitAuthorizePage(int.Parse(elt_account_number), user_id, user_type);
            }
            return new ContentResult() { Content = result.ToString() };
        }

        public ActionResult CreateNewUser()
        {
            bool result = false;
           // if (ConfigurationManager.AppSettings["SysAdmin"] == "True")
            {
                int user_id = Convert.ToInt32(Request.QueryString["user_id"]);
                int user_type = Convert.ToInt32(Request.QueryString["user_type"]);
                string word = Request.QueryString["word"];
                AuthenticationBL bl = new AuthenticationBL();
                string elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
                var me = bl.GetELTUser( User.Identity.Name);
                
                if (me.user_type == "9")
                {
                    var newuser = bl.GetELTUser(elt_account_number, user_id);
                    try
                    {
                        string UserName = newuser.login_name;
                        if (!WebSecurity.UserExists(UserName))
                        {
                            WebSecurity.CreateUserAndAccount(UserName, word, new { elt_account_number = elt_account_number });

                        }
                    }
                    catch (MembershipCreateUserException e)
                    {
                        ModelState.AddModelError("", ErrorCodeToString(e.StatusCode));
                    }
                    result = bl.InitAuthorizePage(int.Parse(elt_account_number), user_id, user_type);
                }
            }
            return new ContentResult() { Content = result.ToString() };
        }

        public ActionResult CreateSystemUser()
        {
            if (ConfigurationManager.AppSettings["SysAdmin"] == "True")
            {
                string UserName = "System";
                if (!WebSecurity.UserExists(UserName))
                {
                    AuthenticationBL bl = new AuthenticationBL();
                    
                    WebSecurity.CreateUserAndAccount(UserName, "elt1234_forever", new { elt_account_number = 80002000 });
                    bl.CopyUser(80002000, bl.GetELTUser("80002000", 1000).login_name, "system");
                }
            }
            return new EmptyResult();
        }

        public ActionResult Manage(ManageMessageId? message)
        {
            ViewBag.StatusMessage =
                message == ManageMessageId.ChangePasswordSuccess ? "Your password has been changed."
                : message == ManageMessageId.SetPasswordSuccess ? "Your password has been set."
                : message == ManageMessageId.RemoveLoginSuccess ? "The external login was removed."
                : "";
            ViewBag.HasLocalPassword = OAuthWebSecurity.HasLocalAccount(WebSecurity.GetUserId(User.Identity.Name));
            ViewBag.ReturnUrl = Url.Action("Manage");
            return View();
        }

        //
        // POST: /Account/Manage

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Manage(LocalPasswordModel model)
        {
            bool hasLocalAccount = OAuthWebSecurity.HasLocalAccount(WebSecurity.GetUserId(User.Identity.Name));
            ViewBag.HasLocalPassword = hasLocalAccount;
            ViewBag.ReturnUrl = Url.Action("Manage");
            if (hasLocalAccount)
            {
                if (ModelState.IsValid)
                {
                  
                    // ChangePassword will throw an exception rather than return false in certain failure scenarios.
                    bool changePasswordSucceeded;
                    try
                    {
                        changePasswordSucceeded = WebSecurity.ChangePassword(User.Identity.Name, model.OldPassword, model.NewPassword);
                    }
                    catch (Exception)
                    {
                        
                        changePasswordSucceeded = false;
                    }

                    if (changePasswordSucceeded)
                    {
                        return RedirectToAction("Manage", new { Message = ManageMessageId.ChangePasswordSuccess });
                    }
                    else
                    {
                        ModelState.AddModelError("", "The current password is incorrect or the new password is invalid.");
                    }
                }
            }
            else
            {
                // User does not have a local password so remove any validation errors caused by a missing
                // OldPassword field
                ModelState state = ModelState["OldPassword"];
                if (state != null)
                {
                    state.Errors.Clear();
                }

                if (ModelState.IsValid)
                {
                    try
                    {
                        WebSecurity.CreateAccount(User.Identity.Name, model.NewPassword);
                        return RedirectToAction("Manage", new { Message = ManageMessageId.SetPasswordSuccess });
                    }
                    catch (Exception e)
                    {
                        ModelState.AddModelError("", e);
                    }
                }
            }

            // If we got this far, something failed, redisplay form
            return View(model);
        }

        //
        // POST: /Account/ExternalLogin

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult ExternalLogin(string provider, string returnUrl)
        {
            return new ExternalLoginResult(provider, Url.Action("ExternalLoginCallback", new { ReturnUrl = returnUrl }));
        }

        //
        // GET: /Account/ExternalLoginCallback

        [AllowAnonymous]
        public ActionResult ExternalLoginCallback(string returnUrl)
        {
            AuthenticationResult result = OAuthWebSecurity.VerifyAuthentication(Url.Action("ExternalLoginCallback", new { ReturnUrl = returnUrl }));
            if (!result.IsSuccessful)
            {
                return RedirectToAction("ExternalLoginFailure");
            }

            if (OAuthWebSecurity.Login(result.Provider, result.ProviderUserId, createPersistentCookie: false))
            {
                return RedirectToLocal(returnUrl);
            }

            if (User.Identity.IsAuthenticated)
            {
                // If the current user is logged in add the new account
                OAuthWebSecurity.CreateOrUpdateAccount(result.Provider, result.ProviderUserId, User.Identity.Name);
                return RedirectToLocal(returnUrl);
            }
            else
            {
                // User is new, ask for their desired membership name
                string loginData = OAuthWebSecurity.SerializeProviderUserId(result.Provider, result.ProviderUserId);
                ViewBag.ProviderDisplayName = OAuthWebSecurity.GetOAuthClientData(result.Provider).DisplayName;
                ViewBag.ReturnUrl = returnUrl;
                return View("ExternalLoginConfirmation", new RegisterExternalLoginModel { UserName = result.UserName, ExternalLoginData = loginData });
            }
        }

        //
        // POST: /Account/ExternalLoginConfirmation

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult ExternalLoginConfirmation(RegisterExternalLoginModel model, string returnUrl)
        {
            string provider = null;
            string providerUserId = null;

            if (User.Identity.IsAuthenticated || !OAuthWebSecurity.TryDeserializeProviderUserId(model.ExternalLoginData, out provider, out providerUserId))
            {
                return RedirectToAction("Manage");
            }

            if (ModelState.IsValid)
            {
                // Insert a new user into the database
                using (UsersContext db = new UsersContext())
                {
                    UserProfile user = db.UserProfiles.FirstOrDefault(u => u.UserName.ToLower() == model.UserName.ToLower());
                    // Check if user already exists
                    if (user == null)
                    {
                        // Insert name into the profile table
                        db.UserProfiles.Add(new UserProfile { UserName = model.UserName });
                        db.SaveChanges();

                        OAuthWebSecurity.CreateOrUpdateAccount(provider, providerUserId, model.UserName);
                        OAuthWebSecurity.Login(provider, providerUserId, createPersistentCookie: false);

                        return RedirectToLocal(returnUrl);
                    }
                    else
                    {
                        ModelState.AddModelError("UserName", "User name already exists. Please enter a different user name.");
                    }
                }
            }

            ViewBag.ProviderDisplayName = OAuthWebSecurity.GetOAuthClientData(provider).DisplayName;
            ViewBag.ReturnUrl = returnUrl;
            return View(model);
        }

        [AllowAnonymous]
        public ActionResult ExternalLoginFailure()
        {
            return View();
        }

        [AllowAnonymous]
        [ChildActionOnly]
        public ActionResult ExternalLoginsList(string returnUrl)
        {
            ViewBag.ReturnUrl = returnUrl;
            return PartialView("_ExternalLoginsListPartial", OAuthWebSecurity.RegisteredClientData);
        }

        [ChildActionOnly]
        public ActionResult RemoveExternalLogins()
        {
            ICollection<OAuthAccount> accounts = OAuthWebSecurity.GetAccountsFromUserName(User.Identity.Name);
            List<ExternalLogin> externalLogins = new List<ExternalLogin>();
            foreach (OAuthAccount account in accounts)
            {
                AuthenticationClientData clientData = OAuthWebSecurity.GetOAuthClientData(account.Provider);

                externalLogins.Add(new ExternalLogin
                {
                    Provider = account.Provider,
                    ProviderDisplayName = clientData.DisplayName,
                    ProviderUserId = account.ProviderUserId,
                });
            }

            ViewBag.ShowRemoveButton = externalLogins.Count > 1 || OAuthWebSecurity.HasLocalAccount(WebSecurity.GetUserId(User.Identity.Name));
            return PartialView("_RemoveExternalLoginsPartial", externalLogins);
        }

        #region Helpers
        private ActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }
            else
            {
                return RedirectToAction("Index", "Home");
            }
        }

        public enum ManageMessageId
        {
            ChangePasswordSuccess,
            SetPasswordSuccess,
            RemoveLoginSuccess,
        }

        internal class ExternalLoginResult : ActionResult
        {
            public ExternalLoginResult(string provider, string returnUrl)
            {
                Provider = provider;
                ReturnUrl = returnUrl;
            }

            public string Provider { get; private set; }
            public string ReturnUrl { get; private set; }

            public override void ExecuteResult(ControllerContext context)
            {
                OAuthWebSecurity.RequestAuthentication(Provider, ReturnUrl);
            }
        }

        private static string ErrorCodeToString(MembershipCreateStatus createStatus)
        {
            // See http://go.microsoft.com/fwlink/?LinkID=177550 for
            // a full list of status codes.
            switch (createStatus)
            {
                case MembershipCreateStatus.DuplicateUserName:
                    return "User name already exists. Please enter a different user name.";

                case MembershipCreateStatus.DuplicateEmail:
                    return "A user name for that e-mail address already exists. Please enter a different e-mail address.";

                case MembershipCreateStatus.InvalidPassword:
                    return "The password provided is invalid. Please enter a valid password value.";

                case MembershipCreateStatus.InvalidEmail:
                    return "The e-mail address provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.InvalidAnswer:
                    return "The password retrieval answer provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.InvalidQuestion:
                    return "The password retrieval question provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.InvalidUserName:
                    return "The user name provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.ProviderError:
                    return "The authentication provider returned an error. Please verify your entry and try again. If the problem persists, please contact your system administrator.";

                case MembershipCreateStatus.UserRejected:
                    return "The user creation request has been canceled. Please verify your entry and try again. If the problem persists, please contact your system administrator.";

                default:
                    return "An unknown error occurred. Please verify your entry and try again. If the problem persists, please contact your system administrator.";
            }
        }
        #endregion
    }
}
