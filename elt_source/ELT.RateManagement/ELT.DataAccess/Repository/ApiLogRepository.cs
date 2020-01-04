//using ELT.Shared.Entities;
//using System;
//using System.Threading.Tasks;

//namespace WarpLX.DataAccess.Repositories
//{
//    public interface IApiLogRepository
//    {
//        Task RespondedMessageAsync(string correlationId, string requestInfo, string responseBody,
//            string requestingSystem,
//            string requestingSystemIp,
//            string userId,
//            short messageType);

//        Task RequestingMessageAsync(string correlationId, string requestInfo, string requestBody, string requestingSystem,
//            string requestingSystemIp,
//            string userId,
//            short messageType);
//    }

//    public class ApiLogRepository : IApiLogRepository
//    {
//        public async Task RespondedMessageAsync(string correlationId, string requestInfo, string responseBody,
//                                  string requestingSystem,
//                                  string requestingSystemIp,
//                                  string userId,
//                                  short messageType)
//        {

//            await
//                  Task.Run(() =>
//                  {
//                      using (var entities = new PRDDBEntities())
//                      {
//                          entities.ApiLogs.Add(new ApiLog()
//                          {
//                              CorrelationId = correlationId,
//                              ResponseBody = responseBody,
//                              RequestDetail = requestInfo,
//                              ResponseTime = DateTime.UtcNow,
//                              RequestingSystem = requestingSystem,
//                              RequestingSystemIp = requestingSystemIp,
//                              UserId = userId,
//                              MessageType = messageType
//                          });
//                          entities.SaveChanges();
//                      }


//                  });
//        }

//        public async Task RequestingMessageAsync(string correlationId, string requestInfo, string requestBody, string requestingSystem,
//                                 string requestingSystemIp,
//                                 string userId,
//                                 short messageType)
//        {

//            await Task.Run(() =>
//            {
//                using (var entities = new PRDDBEntities())
//                {
//                    entities.ApiLogs.Add(new ApiLog()
//                    {
//                        CorrelationId = correlationId,
//                        RequestDetail = requestInfo,
//                        RequestBody = requestBody,
//                        RequestTime = DateTime.UtcNow,
//                        RequestingSystem = requestingSystem,
//                        RequestingSystemIp = requestingSystemIp,
//                        UserId = userId,
//                        MessageType = messageType
//                    });
//                    entities.SaveChanges();
//                }

//            });

//        }
//    }
//}