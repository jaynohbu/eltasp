using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ELT.DataAccess;
using ELT.DataAccess.Repository;
using ELT.Shared.Model;
using Ninject;

namespace ELT.Logic
{
    public class AppLogic : IAppLogic
    {
        [Inject]
        public IAppRepository AppRepository { get; set; }
        [Inject]
        public IUnitOfWorkContainer UnitOfWork { get; set; }


        public void InitDbSession()
        {
             UnitOfWork.Wrap(() => AppRepository.InitDbSession());
        }
        
    }
}
