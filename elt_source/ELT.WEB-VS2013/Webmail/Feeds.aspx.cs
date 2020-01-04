using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel.Syndication;
using System.Web.UI;
using System.Xml;
using DevExpress.Web.ASPxClasses;
using DevExpress.Web.ASPxSplitter;
using DevExpress.Web.ASPxGridView;
using System.Text.RegularExpressions;
using DevExpress.Data.Filtering;
using System.Web.UI.WebControls;

public partial class Feeds : System.Web.UI.Page {
    const string
        FeedItemPreviewFormat =
            "<div class='FeedPreview'>" +
                    "<div class='Subject'>{0}</div>" +
                    "<div class='Info'>" +
                        "<span>{1}</span>" +
                        "<a href='{2}' target='_blank'>View on Web</a>" +
                    "</div>" +
                    "<div class='Separator'></div>" +
                    "<div class='Body'>{3}</div>" +
                "</div>";

    static readonly Dictionary<string, string> FeedRegistry = new Dictionary<string, string>();    
    static DateTime LastFeedFetchTime = DateTime.MinValue;
    static readonly TimeSpan FeedTTL = TimeSpan.FromHours(2);
    static Dictionary<string, SyndicationFeed> FetchedFeeds = new Dictionary<string, SyndicationFeed>();
    static readonly object FeedFetchLock = new object();

    static Feeds() {
        FeedRegistry["Blogs"] = "http://community.devexpress.com/blogs/MainFeed.aspx";
        FeedRegistry["Videos"] = "http://tv.devexpress.com/rss.ashx";
        FeedRegistry["Webinars"] = "http://www.devexpress.com/rss/webinars/";
        FeedRegistry["News"] = "http://www.devexpress.com/rss/news/news20.xml";
        FeedRegistry["BBC News"] = "http://feeds.bbci.co.uk/news/rss.xml";
        FeedRegistry["Engadget"] = "http://www.engadget.com/rss.xml";
        FeedRegistry["Stack Overflow"] = "http://stackoverflow.com/feeds/tag?tagnames=devexpress&sort=newest";
    }

    protected string SearchText { get { return Utils.GetSearchText(this); } }

    protected void Page_PreInit(object sender, EventArgs e) {
        Utils.ApplyTheme(this);
    }
    
    protected void Page_Load(object sender, EventArgs e) {
        LoadFeedToGrid();
        PrepareMasterSplitter();
    }

    protected void FeedItemPreviewPanel_Callback(object sender, CallbackEventArgsBase e) {
        string text = string.Format("Can't find feed with the key = {0}", e.Parameter);
        if(!string.IsNullOrEmpty(e.Parameter)) {
            var feedItem = CurrentFeed.Items.FirstOrDefault(i => i.Id == e.Parameter);
            if(feedItem != null)
                text = FormatFeedItem(feedItem);
        }
        FeedItemPreviewPanel.Controls.Add(new LiteralControl(text));
    }

    protected void FeedGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e) {
        if(e.Parameters == "FeedChanged" || e.Parameters == "Search" && string.IsNullOrEmpty(SearchText))
            FeedGrid.FilterExpression = "";
        else if(e.Parameters == "Search") {
            FeedGrid.FilterExpression = new GroupOperator(GroupOperatorType.Or,
                new FunctionOperator(FunctionOperatorType.Contains, new OperandProperty("Title"), SearchText),
                new FunctionOperator(FunctionOperatorType.Contains, new OperandProperty("From"), SearchText)
            ).ToString();
        }
    }

    protected void FeedGrid_CustomColumnDisplayText(object sender, ASPxGridViewColumnDisplayTextEventArgs e) {
        if(!string.IsNullOrEmpty(SearchText) && (e.Column.FieldName == "From" || e.Column.FieldName == "Title")) {
            string text = string.IsNullOrEmpty(e.DisplayText) ? e.Value.ToString() : e.DisplayText;
            e.DisplayText = new Regex(SearchText, RegexOptions.IgnoreCase).Replace(text, "<span class='hgl'>$0</span>");
        }
    }

    protected string FormatFeedItem(SyndicationItem feedItem) {
        return 
            string.Format(FeedItemPreviewFormat,
                feedItem.Title.Text,
                GetCreator(CurrentFeed, feedItem), 
                feedItem.Links[0].Uri.AbsoluteUri,
                feedItem.Summary.Text
            );
    }

    protected SyndicationFeed CurrentFeed {
        get { return GetFeed(FeedNavBar.SelectedItem.Text); }
    }

    SyndicationFeed GetFeed(string key) {
        if(!FetchedFeeds.ContainsKey(key) || DateTime.Now - LastFeedFetchTime > FeedTTL) {
            lock(FeedFetchLock) {
                using(var reader = new XmlTextReader(FeedRegistry[key])) {
                    FetchedFeeds[key] = SyndicationFeed.Load(reader);
                }
                LastFeedFetchTime = DateTime.Now;
            }
        }
        return FetchedFeeds[key];
    }

    void LoadFeedToGrid() {
        var data = SelectData();
        if(data.Count > 0) {
            FeedGrid.DataSource = data;
            FeedGrid.DataBind();
        } else {
            FeedGrid.SettingsText.EmptyDataRow = string.Format(
                "Please accept our apologies for the inconvenience. The feed URL is currently unavailable: {0}", FeedRegistry[FeedNavBar.SelectedItem.Text]);
            FeedGrid.Settings.ShowFooter = false;
        }
    }

    List<object> SelectData() {
        var list = new List<object>();
        foreach(var item in CurrentFeed.Items) {
            var summary = item.Summary;
            if(summary == null) continue;
            var description = summary.Text;
            if(description.Contains("<object") || description.Contains("<embed") || description.Contains("<iframe") || description.Contains("Server Error"))
                continue;
            try {
                list.Add(new {
                    ID = item.Id,
                    Date = item.PublishDate,
                    From = GetCreator(CurrentFeed, item),
                    Title = item.Title.Text,
                    Description = description,
                    Url = item.Links[0].Uri.AbsoluteUri
                });
            }
            catch { }
        }
        return list;
    }

    string GetCreator(SyndicationFeed feed, SyndicationItem item) {
        if(item.Authors.Count > 0)
            return item.Authors[0].Name ?? item.Authors[0].Email;
        var creator = item.ElementExtensions.FirstOrDefault(e => e.OuterName == "creator");
        if(creator != null)
            return creator.GetReader().ReadInnerXml();
        return feed.Title.Text;
    }

    void PrepareMasterSplitter() {
        var rootHolder = Page.Master.Master.FindControl("RootHolder") as ContentPlaceHolder;
        var pane = ((ASPxSplitter)rootHolder.FindControl("LayoutSplitter")).GetPaneByName("LeftPane");
        pane.PaneStyle.BorderTop.BorderWidth = 0;
    }
}
