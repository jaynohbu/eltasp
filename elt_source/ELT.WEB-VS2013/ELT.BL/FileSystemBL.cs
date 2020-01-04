using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ELT.CDT;
using System.Web;
using ELT.DA;
namespace ELT.BL
{
    public class FileSystemBL
    {
        public int GetRootFileItemID(string UserEmail)
        {
            FileSystemDA da = new FileSystemDA();
            return da.GetRootFileItemID(UserEmail);
        }
        public ELTFileSystemItem GetFileByID(int FileID)
        {
            FileSystemDA da = new FileSystemDA();
            return da.GetFileByID(FileID);
        }

        public int GetFileIDforParentID(string OwnerEmail, int ParentID)
        {
            FileSystemDA da = new FileSystemDA();
            return da.GetFileIDforParentID(OwnerEmail, ParentID);
        }
        public  List<ELTFileSystemItem> GetFiles()
        {
            string  UserID = HttpContext.Current.User.Identity.Name;           
            List<ELTFileSystemItem> files = (List<ELTFileSystemItem>)HttpContext.Current.Session["ELTFiles"];
            if (files == null)
            {
                FileSystemDA da = new FileSystemDA();
                files = da.GetFiles(UserID);
                HttpContext.Current.Session["ELTFiles"] = files;
            }
            return files;
        }
        public  void InsertFile(ELTFileSystemItem newFile)
        {
            FileSystemDA da = new FileSystemDA();
            da.InsertFile(newFile);           
            GetFiles().Add(newFile);
        }
        public  void DeleteFile(ELTFileSystemItem File)
        {
            if (File.IsFolder)
            {
                List<ELTFileSystemItem> childFolders = GetFiles().FindAll(item => item.IsFolder && item.ParentID == File.ID);
                if (childFolders != null)
                {
                    foreach (ELTFileSystemItem childFolder in childFolders)
                    {
                        DeleteFile(childFolder);
                    }
                }
            }
            GetFiles().Remove(File);
        }
        public  void UpdateFile(ELTFileSystemItem File, Action<ELTFileSystemItem> update)
        {
            update(File);
        }

         int GetNewFileID()
        {
            IEnumerable<ELTFileSystemItem> Files = GetFiles();
            return (Files.Count() > 0) ? Files.Last().ID + 1 : 0;
        }
    }
}
