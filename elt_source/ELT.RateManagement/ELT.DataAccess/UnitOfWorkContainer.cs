using System;
using System.Collections.Generic;
using ELT.Shared.Entities;

namespace ELT.DataAccess
{
    public interface IUnitOfWorkContainer
    {
        T Wrap<T>(Func<T> func, UnitOfWorkAction action = UnitOfWorkAction.Read);

        void Wrap(Action func, UnitOfWorkAction action = UnitOfWorkAction.Read);
        
    }

    public enum UnitOfWorkAction
    {
        Unknown = 0,
        Read,
        Write
    }

    public class EltUnitOfWorkContainer : IUnitOfWorkContainer
    {
        [ThreadStatic]
        public static PRDDBEntities Context;

        public T Wrap<T>(Func<T> func, UnitOfWorkAction action = UnitOfWorkAction.Read)
        {

            using (Context = new PRDDBEntities())
            {
                var result = func.Invoke();

                if (action == UnitOfWorkAction.Write)
                {
                    try
                    {
                        Context.SaveChanges();
                    }
                    catch (Exception ex)
                    {
                        throw new Exception(ex.StackTrace);
                    }
                }

                return result;
            }
        }

        public void Wrap(Action func, UnitOfWorkAction action = UnitOfWorkAction.Read)
        {
            using (Context = new PRDDBEntities())
            {
                func.Invoke();

                if (action == UnitOfWorkAction.Write)
                {
                    try
                    {
                        Context.SaveChanges();
                    }
                    catch (Exception ex)
                    {
                        throw new Exception(ex.StackTrace);
                    }
                }
            }
        }
    }


}