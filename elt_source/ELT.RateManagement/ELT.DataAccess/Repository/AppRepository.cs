using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using ELT.Shared.Entities;
using ELT.Shared.Model;

namespace ELT.DataAccess.Repository
{
    public class AppRepository : BaseRepository, IAppRepository
    {
        public void InitDbSession()
        {
            try
            {
                EltUnitOfWorkContainer.Context.Database.ExecuteSqlCommand("EXEC ASPState.[dbo].[CreateTempTables]");
            }
            catch (Exception)
            {
                //ignored
            }
        }
    }
}
