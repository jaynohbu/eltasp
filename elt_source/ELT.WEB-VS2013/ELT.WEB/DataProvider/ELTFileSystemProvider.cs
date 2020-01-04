using System;
using System.Collections.Generic;
using System.Data.Linq;
using System.IO;
using System.Linq;
using System.Web;
using DevExpress.Web.ASPxFileManager;
using ELT.CDT;
using ELT.BL;
namespace ELT.WEB.DataProvider
{  

    public class ELTFileSystemProvider : FileSystemProviderBase
    {
        FileSystemBL ELTFileBL = new FileSystemBL();
        int RootItemID = 1;
        string rootFolderDisplayName;
        Dictionary<int, ELTFileSystemItem> folderCache;

        public string RecipientEmail{get;set;}
        public string Action{ get; set; }
        public ELTFileSystemProvider(string rootFolder)
            : base(rootFolder)
        {
            RootItemID = ELTFileBL.GetRootFileItemID(HttpContext.Current.User.Identity.Name);
            RefreshFolderCache();
        }
        public override string RootFolderDisplayName { get { return rootFolderDisplayName; } }
        public Dictionary<int, ELTFileSystemItem> FolderCache { get { return folderCache; } }
        public override IEnumerable<FileManagerFile> GetFiles(FileManagerFolder folder)
        {
            ELTFileSystemItem FileFolderItem = FindELTFolderItem(folder);
            var files= from FileItem in ELTFileBL.GetFiles()
                   where !FileItem.IsFolder && FileItem.ParentID == FileFolderItem.ID
                   select new FileManagerFile(this, folder, FileItem.Name);

            return files;
        }
        public override IEnumerable<FileManagerFolder> GetFolders(FileManagerFolder parentFolder)
        {
            ELTFileSystemItem FileFolderItem = FindELTFolderItem(parentFolder);
            var folders= from FileItem in FolderCache.Values
                   where FileItem.IsFolder && FileItem.ParentID == FileFolderItem.ID
                   select new FileManagerFolder(this, parentFolder, FileItem.Name);

            return folders;
        }
        public override bool Exists(FileManagerFile file)
        {
            return FindELTFileItem(file) != null;
        }
        public override bool Exists(FileManagerFolder folder)
        {
            return FindELTFolderItem(folder) != null;
        }
        public override Stream ReadFile(FileManagerFile file)
        {
            return new MemoryStream(FindELTFileItem(file).Data.ToArray());
        }
        public override DateTime GetLastWriteTime(FileManagerFile file)
        {
            var ELTFileItem = FindELTFileItem(file);
            return ELTFileItem.LastWriteTime;
        }
        public override long GetLength(FileManagerFile file)
        {
            var ELTFileItem = FindELTFileItem(file);
            return ELTFileItem.Data.Length;
        }
        public override void CreateFolder(FileManagerFolder parent, string name)
        {
            ELTFileBL.InsertFile(new ELTFileSystemItem
            {
                IsFolder = true,
                LastWriteTime = DateTime.Now,
                Name = name,
                Owner_Email=HttpContext.Current.User.Identity.Name,
                ParentID = FindELTFolderItem(parent).ID
            });
            RefreshFolderCache();
        }
        public override void RenameFile(FileManagerFile file, string name)
        {
            ELTFileBL.UpdateFile(FindELTFileItem(file), FileItem => FileItem.Name = name);
        }
        public override void RenameFolder(FileManagerFolder folder, string name)
        {
            ELTFileBL.UpdateFile(FindELTFolderItem(folder), FileItem => FileItem.Name = name);
            RefreshFolderCache();
        }
        public override void MoveFile(FileManagerFile file, FileManagerFolder newParentFolder)
        {
            ELTFileBL.UpdateFile(FindELTFileItem(file), FileItem => FileItem.ParentID = FindELTFolderItem(newParentFolder).ID);
        }
        public override void MoveFolder(FileManagerFolder folder, FileManagerFolder newParentFolder)
        {
            ELTFileBL.UpdateFile(FindELTFolderItem(folder), FileItem => FileItem.ParentID = FindELTFolderItem(newParentFolder).ID);
            RefreshFolderCache();
        }
        public override void UploadFile(FileManagerFolder folder, string fileName, Stream content)
        {
            ELTFileBL.InsertFile(new ELTFileSystemItem
            {
                IsFolder = false,
                LastWriteTime = DateTime.Now,
                Name = fileName,
                ParentID = FindELTFolderItem(folder).ID,
                Owner_Email = HttpContext.Current.User.Identity.Name,
                Data = ReadAllBytes(content)
            });
        }
        public override void DeleteFile(FileManagerFile file)
        {
            ELTFileBL.DeleteFile(FindELTFileItem(file));
        }
        public override void DeleteFolder(FileManagerFolder folder)
        {
            ELTFileBL.DeleteFile(FindELTFolderItem(folder));
            RefreshFolderCache();
        }
        protected ELTFileSystemItem FindELTFileItem(FileManagerFile file)
        {
            ELTFileSystemItem ELTFolderItem = FindELTFolderItem(file.Folder);
            if (ELTFolderItem == null)
                return null;
            return ELTFileBL.GetFiles().FindAll(item => (int)item.ParentID == ELTFolderItem.ID && !item.IsFolder && item.Name == file.Name).FirstOrDefault();
        }
        protected ELTFileSystemItem FindELTFolderItem(FileManagerFolder folder)
        {
            return (from FileFolderItem in FolderCache.Values
                    where FileFolderItem.IsFolder && GetRelativeName(FileFolderItem) == folder.RelativeName
                    select FileFolderItem).FirstOrDefault();
        }
        protected string GetRelativeName(ELTFileSystemItem FileFolderItem)
        {
            if (FileFolderItem.ID == RootItemID) return string.Empty;
            if (FileFolderItem.ParentID == RootItemID) return FileFolderItem.Name;
            if (!FolderCache.ContainsKey((int)FileFolderItem.ParentID)) return null;
            string name = GetRelativeName(FolderCache[(int)FileFolderItem.ParentID]);
            return name == null ? null : Path.Combine(name, FileFolderItem.Name);
        }
        protected void RefreshFolderCache()
        {
            this.folderCache = ELTFileBL.GetFiles().FindAll(FileItem => FileItem.IsFolder).ToDictionary(FileItem => FileItem.ID);
            this.rootFolderDisplayName = (from FileFolderItem in FolderCache.Values where FileFolderItem.ID == RootItemID select FileFolderItem.Name).First();
        }
        protected static byte[] ReadAllBytes(Stream stream)
        {
            byte[] buffer = new byte[16 * 1024];
            int readCount;
            using (MemoryStream ms = new MemoryStream())
            {
                while ((readCount = stream.Read(buffer, 0, buffer.Length)) > 0)
                {
                    ms.Write(buffer, 0, readCount);
                }
                return ms.ToArray();
            }
        }

    }
}