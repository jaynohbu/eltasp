using System;
using System.Collections;
using System.Data;
using System.Web;
using System.IO;
using System.Xml;
using System.Net;

namespace RssFunctions
{
	public class RssChannel 
	{ 
		private string title; 
		private Uri link; 
		private string description; 
		private string language; 
		private string copyright; 
		private DateTime lastBuildDate;

		#region 
		public string Title
		{
			get
			{
				return title;
			}
			set
			{
				title = value;
			}
		}

		public Uri Link
		{
			get
			{
				return link;
			}
			set
			{
				link = value;
			}
		}

		public string Description
		{
			get
			{
				return description;
			}
			set
			{
				description = value;
			}
		}

		public string Language
		{
			get
			{
				return language;
			}
			set
			{
				language = value;
			}
		}

		public string Copyright
		{
			get
			{
				return copyright;
			}
			set
			{
				copyright = value;
			}
		}

		public DateTime LastBuildDate
		{
			get
			{
				return lastBuildDate;
			}
			set
			{
				lastBuildDate = value;
			}
		}
	
		#endregion 

	}

	public struct RssItem
	{
		public string Author;
		public string Category;
		public string Title;
		public Uri Link;
        public string Pubdate;
		public string Description;
	}

	public class RssItems : CollectionBase 
	{ 
		public RssItem this[int index]
		{ 
			get 
			{ 
				return (RssItem)List[index]; 
			} 
			set 
			{ 
				List[index] = value; 
			} 
		} 

		public int Add(RssItem value) 
		{ 
			return List.Add(value); 
		} 

		public int IndexOf(RssItem value) 
		{ 
			return List.IndexOf(value); 
		} 

		public void Insert(int index, RssItem value) 
		{ 
			List.Insert(index, value); 
		} 

		public void Remove(RssItem value) 
		{ 
			List.Remove(value); 
		} 

		public bool Contains(RssItem value) 
		{ 
			
			return List.Contains(value); 

		}
	}


	/// <summary>
	
	/// </summary>
	public class RssReader
	{
		private XmlDocument Document;
		private XmlNode DocumentRoot;
		private RssItems rssItems;
		private RssChannel rssChannel;

		public RssReader()
		{
			Document = new XmlDocument();
			rssItems = new RssItems();
		}

		#region 
		public RssItems Items
		{
			get
			{
				return rssItems;
			}
			set
			{
				rssItems = value;
			}
		}

		public RssChannel Channel
		{
			get
			{
				return rssChannel;
			}
			set
			{
				rssChannel = value;
			}
		}
	
		#endregion 

		#region
		public void Load(string filename) 
		{ 
			LoadFromFile(filename); 
			PopulateRssData(); 
		} 

		public void LoadFromHttp(string Url) 
		{ 
			LoadFromUrl(Url); 
			PopulateRssData(); 
		}

		#endregion 

		private XmlNode getNode(XmlNodeList list, string nodeName) 
		{ 
			for (int i = 0; i <= list.Count - 1; i++) 
			{ 
				if (list.Item(i).Name == nodeName) 
				{ 
					return list.Item(i); 
				}
			} 

			return null;
		}

		private void LoadFromFile(string filename) 
		{ 
			Document.Load(filename); 
		} 

		private void LoadFromUrl(string Url) 
		{ 
			HttpWebRequest request;
			string responseText = ""; 

			request = (HttpWebRequest)WebRequest.Create(Url); 
			HttpWebResponse response = (HttpWebResponse)request.GetResponse(); 
			Stream stream = response.GetResponseStream(); 

			StreamReader reader = new StreamReader(stream, System.Text.Encoding.GetEncoding(949)); 
			responseText = reader.ReadToEnd(); 

			response.Close(); 
			reader.Close(); 
			
			Document.LoadXml(responseText); 
		}


		private void PopulateRssData() 
		{ 
			XmlNode node; 
			XmlNode itemNode; 

			rssChannel = new RssChannel();
			rssChannel.Copyright = ""; 
			rssChannel.Description = ""; 
			rssChannel.Language = ""; 
			rssChannel.Title = ""; 

			DocumentRoot = getNode(Document.ChildNodes, "rss"); 
			DocumentRoot = getNode(DocumentRoot.ChildNodes, "channel"); 

			node = getNode(DocumentRoot.ChildNodes, "title");
			if (node != null) rssChannel.Title = node.InnerText; 
			node = getNode(DocumentRoot.ChildNodes, "link");
			if (node != null) rssChannel.Link = new Uri(node.InnerText); 
			node = getNode(DocumentRoot.ChildNodes, "description");
			if (node != null) rssChannel.Description = node.InnerText; 
			node = getNode(DocumentRoot.ChildNodes, "language");
			if (node != null) rssChannel.Language = node.InnerText; 
			node = getNode(DocumentRoot.ChildNodes, "copyright");
			if (node != null) rssChannel.Copyright = node.InnerText; 
			node = getNode(DocumentRoot.ChildNodes, "lastBuildDate");
			if (node != null) rssChannel.LastBuildDate = DateTime.Parse(node.InnerText);			
			
			rssItems.Clear(); 
			for (int i = 0; i <= DocumentRoot.ChildNodes.Count - 1; i++) 
			{ 
				if (DocumentRoot.ChildNodes[i].Name == "item") 
				{ 
					itemNode = DocumentRoot.ChildNodes[i]; 
					RssItem item = new RssItem();

                    node = getNode(itemNode.ChildNodes, "title");
                    if (node != null) item.Title = node.InnerText;

                    node = getNode(itemNode.ChildNodes, "link");
                    if (node != null) item.Link = new Uri(node.InnerText);

                    node = getNode(itemNode.ChildNodes, "description");
                    if (node != null) item.Description = node.InnerText;
                    
                    node = getNode(itemNode.ChildNodes, "author"); 
					if (node != null) item.Author = node.InnerText; 

                    node = getNode(itemNode.ChildNodes, "pubDate");
                    if (node != null) item.Pubdate = node.InnerText.Substring(0, 12);

                    node = getNode(itemNode.ChildNodes, "category");
                    if (node != null) item.Category = node.InnerText; 

					rssItems.Add(item); 
				} 
			} 
		}

		
	}
}
