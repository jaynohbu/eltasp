using System;
using System.Collections.Generic;
using System.Configuration;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Xml.Linq;
using DevExpress.Web.ASPxClasses.Internal;
using DevExpress.Web.ASPxHiddenField;
using ELT.CDT;
public static class Utils {
    public const string ThomasEmail = "thomas.hardy@example.com";
    static bool? _isSiteMode;
    static List<NavigationItem> _navigationItems;
    static object lockObject = new object();
    static Thread backgroundThread;

    static HttpContext Context { get { return HttpContext.Current; } }
    static string UploadImagesFolder { get { return Context.Server.MapPath("~/Content/Photo/UploadImages/"); } }
    
    public static bool IsIE7 { get { return RenderUtils.Browser.IsIE && RenderUtils.Browser.Version < 8; } }
    public static bool IsSiteMode {
        get {
            if(!_isSiteMode.HasValue)
                _isSiteMode = ConfigurationManager.AppSettings["SiteMode"].Equals("true", StringComparison.InvariantCultureIgnoreCase);
            return _isSiteMode.Value;
        }
    }

    public static void ApplyTheme(Page page) {
        var themeName = CurrentTheme;
        if(string.IsNullOrEmpty(themeName))
            themeName = "Default";
        page.Theme = themeName;
    }

    public static string CurrentTheme {
        get {
            var themeCookie = Context.Request.Cookies["MailDemoCurrentTheme"];
            return themeCookie == null ? "Moderno" : HttpUtility.UrlDecode(themeCookie.Value);
        }
    }
    
    public static bool IsDarkTheme {
        get { 
            var theme = CurrentTheme;
            return theme == "Office2010Black" || theme == "PlasticBlue" || theme == "RedWine" || theme == "BlackGlass";
        }
    }

    public static string CurrentPageName {
        get {
            var key = "CE1167E3-A068-4E7C-8BFD-4A7D308BEF43";
            if(Context.Items[key] == null)
                Context.Items[key] = GetCurrentPageName();
            return Context.Items[key].ToString();
        }
    }

    public static List<NavigationItem> NavigationItems {
        get {
            if(_navigationItems == null) {
                _navigationItems = new List<NavigationItem>();
                PopuplateNavigationItems(_navigationItems);
            }
            return _navigationItems;
        }
    }

    public static string GetSearchText(Page page) {
        var key = "D672659E-FF11-40FF-A63B-FAFB0BFE760B";
        if(Context.Items[key] == null) {
            string value = null;
            if(!TryGetClientStateValue<string>(page, "SearchText", out value))
                value = string.Empty;
            Context.Items[key] = value;
        }
        return Context.Items[key].ToString();
    }

    public static bool TryGetClientStateValue<T>(Page page, string key, out T result) {
        var hiddenField = page.Master.Master.FindControl("HiddenField") as ASPxHiddenField;
        if(hiddenField == null || !hiddenField.Contains(key)) {
            result = default(T);
            return false;
        }
        result = (T)hiddenField[key];
        return true;
    }

    public static IQueryable<Contact> MakeContactsOrderBy(IQueryable<Contact> query, string name, bool isDesc) {
        var type = typeof(Contact);
        var property = type.GetProperty(name);
        var parameter = Expression.Parameter(type, "p");
        var propertyAccess = Expression.MakeMemberAccess(parameter, property);
        var orderByExp = Expression.Lambda(propertyAccess, parameter);
        MethodCallExpression resultExp = Expression.Call(
            typeof(Queryable),
            isDesc ? "OrderByDescending" : "OrderBy",
            new Type[] { type, property.PropertyType },
            query.Expression,
            Expression.Quote(orderByExp)
        );
        return query.Provider.CreateQuery<Contact>(resultExp);
    }

    public static string GetAddressString(IContact contact) {
        var list = new List<string>();
        foreach(var item in new string[] { contact.Address, contact.City, contact.Country }) {
            if(!string.IsNullOrEmpty(item))
                list.Add(item);
        }
        if(list.Count == 0)
            return string.Empty;
        return string.Join(", ", list);
    }

    public static string GetContactPhotoUrl(string relativePath) {
        if(string.IsNullOrEmpty(relativePath))
            return "Content/Photo/User.png";
        return "Content/Photo/" + relativePath;
    }

    public static string GetUploadedPhotoUrl(string imageKeyString) {
        Guid imageKey;
        if(string.IsNullOrEmpty(imageKeyString) || !Guid.TryParse(imageKeyString, out imageKey))
            return "";
        return string.Format("UploadImages/{0}.jpg", imageKey);
    }

    public static string SaveContactPhoto(Stream stream, out Guid imageKey) {
        imageKey = Guid.NewGuid();
        var filePath = Path.Combine(UploadImagesFolder, imageKey.ToString() + ".jpg");
        using(var original = Image.FromStream(stream))
        using(var thumbnail = InscribeImage(original, 200))
            SaveToJpeg(thumbnail, filePath);
        return string.Format("Content/Photo/UploadImages/{0}.jpg", imageKey);
    }

    public static void StartClearExpiredFilesBackgroundThread() {
        lock(lockObject) {
            if(backgroundThread == null)
                backgroundThread = new Thread(RemoveTempFilesWorker);
            if(!backgroundThread.IsAlive)
                backgroundThread.Start(UploadImagesFolder);
        }
    }

    static void RemoveTempFilesWorker(object startParam) { 
        if(startParam == null)
            return;
        var directory = startParam.ToString();
        while(true) {
            Thread.Sleep(60000);
            RemoveExpiredTempFiles(directory);
        }
    }

    static void RemoveExpiredTempFiles(string directory) {
        var expirationTime = DateTime.UtcNow - new TimeSpan(0, 15, 0);
        try {
            foreach(var file in new DirectoryInfo(directory).GetFiles("*")) {
                if(file.CreationTimeUtc < expirationTime)
                    try {
                        file.Delete();
                    }
                    catch { }
            }
        }
        catch { }
    }

    static Image InscribeImage(Image image, int size) {
        return InscribeImage(image, size, size);
    }

    static Image InscribeImage(Image image, int width, int height) {
        Bitmap result = new Bitmap(width, height);
        using(Graphics graphics = Graphics.FromImage(result)) {
            double factor = 1.0 * width / image.Width;
            if(image.Height * factor < height)
                factor = 1.0 * height / image.Height;
            Size size = new Size((int)(width / factor), (int)(height / factor));
            Point sourceLocation = new Point((image.Width - size.Width) / 2, (image.Height - size.Height) / 2);

            SmoothGraphics(graphics);
            graphics.DrawImage(image, new Rectangle(0, 0, width, height), new Rectangle(sourceLocation, size), GraphicsUnit.Pixel);
        }
        return result;
    }

    static void SmoothGraphics(Graphics g) {
        g.SmoothingMode = SmoothingMode.AntiAlias;
        g.InterpolationMode = InterpolationMode.HighQualityBicubic;
        g.PixelOffsetMode = PixelOffsetMode.HighQuality;
    }

    static void SaveToJpeg(Image image, Stream output) {
        image.Save(output, ImageFormat.Jpeg);
    }

    static void SaveToJpeg(Image image, string fileName) {
        image.Save(fileName, ImageFormat.Jpeg);
    }

    static string GetCurrentPageName() {
        var fileName = Path.GetFileName(Context.Request.Path);
        var result = fileName.Substring(0, fileName.Length - 5);
        if(result.ToLower() == "default")
            result = "mail";
        if(result.ToLower().Contains("print"))
            result = "print";
        return result.ToLower();
    }

    static void PopuplateNavigationItems(List<NavigationItem> list) {
        var path = Utils.Context.Server.MapPath("~/App_Data/Navigation.xml");
        list.AddRange(XDocument.Load(path).Descendants("Item").Select(n => new NavigationItem() {
            Text = n.Attribute("Text").Value,
            NavigationUrl = n.Attribute("NavigateUrl").Value,
            SpriteClassName = n.Attribute("SpriteClassName").Value
        }));
    }
}

public class NavigationItem {
    public string Text { get; set; }
    public string NavigationUrl { get; set; }
    public string SpriteClassName { get; set; }
}
