using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.COMMON
{
    public class SQLConstants
    {
        public const String SELECT_LIST_SCHEDULE_B = "SELECT * FROM scheduleB WHERE elt_account_number={0} ORDER BY description";
        public const String SELECT_LIST_EXPORT_CODE = "SELECT code_id,LEFT(code_id+'-'+CAST(code_desc AS NVARCHAR),32) AS code_desc FROM aes_codes WHERE code_type='Export Code' ORDER BY code_id";
        public const String SELECT_LIST_LICENSE_CODE = "SELECT code_id,LEFT(code_id+'-'+CAST(code_desc AS NVARCHAR),32) AS code_desc FROM aes_codes WHERE code_type='License Code' ORDER BY code_id";
        public const String SELECT_LIST_UOM_CODE = "SELECT code_id,LEFT(CAST(code_desc AS NVARCHAR),32) AS code_desc FROM aes_codes WHERE code_type='UOM' ORDER BY code_desc";
        public const String SELECT_LIST_PORT = "SELECT port_code + ' - ' + port_desc as port_name,port_code FROM port WHERE elt_account_number={0} AND ISNULL(port_id,'')<>'' ORDER BY port_desc";
       
        public const String SELECT_LIST_COUNTRIES = "SELECT * FROM country_code WHERE elt_account_number={0} order by country_name";
        public const String SELECT_LIST_MOT = "SELECT code_id,code_desc FROM aes_codes WHERE code_type='Transport Code' ORDER BY code_id";
       
        public const String SELECT_LIST_AGENT=@"SELECT	dba_name,org_account_number FROm organization WHERE	elt_account_number = @elt_account_number AND  isnull(dba_name,'') <> '' AND  is_agent = 'Y' order by dba_name";

        public const String SELECT_LIST_CARRIERS = "SELECT org_account_number, ISNULL(carrier_id,'') AS carrier_code,LEFT(dba_name,22) AS carrier_name FROM organization WHERE is_carrier='Y' AND ISNULL(carrier_id,'') <> '' AND ISNULL(carrier_code,'')<>'' AND elt_account_number={0}  Union SELECT '-1' AS org_account_number, 'All Carrier' AS carrier_id, 'All' as carrier_name ORDER BY carrier_name";
        public const String SELECT_LIST_STATES = "SELECT [CountryCode],[Type],[Code],[Name] FROM [dbo].[RegionCode] WHERE CountryCode ='US' AND TYPE='STATE'";


        public const String SELECT_LIST_ORGANIZATION_AGENT = @"SELECT  * FROM (SELECT [elt_account_number]
        ,[org_account_number]
        , CASE WHEN isnull(class_code,'') = '' THEN dba_name
        ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']' END as dba_name
        ,[class_code]
        ,[isFrequently]
        ,[business_legal_name]     
        ,[OrgId]
        ,is_agent
        ,row_number()over(order by t.dba_name) as [rn]
        FROM [dbo].[organization]
        as t ) as st where  elt_account_number = @elt_account_number AND is_agent='Y'";

        public const String SELECT_LIST_ORGANIZATION_AGENT_WITH_FILTER_START_END_INDEX = @"SELECT * FROM (SELECT [elt_account_number]
        ,[org_account_number]
        , CASE WHEN isnull(class_code,'') = '' THEN dba_name
        ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']' END as dba_name
        ,[class_code]
        ,[isFrequently]
        ,[business_legal_name]     
        ,[OrgId]
        ,is_agent
        ,row_number()over(order by t.dba_name) as [rn]
        FROM [dbo].[organization]
        as t where t.dba_name LIKE @filter) as st where st.[rn] between @startIndex and @endIndex
        AND elt_account_number = @elt_account_number  AND is_agent='Y'";


        public const string SELECT_LIST_ORGANIZATION_AGENT_FOR_VALUE = @"SELECT [elt_account_number]
        ,[org_account_number]
        , CASE WHEN isnull(class_code,'') = '' THEN dba_name
        ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']' END as dba_name
        ,[class_code]
        ,[isFrequently]
        ,[business_legal_name]     
        ,[OrgId]
        ,is_agent
        ,row_number()over(order by dba_name) as [rn]
        FROM [dbo].[organization]
        where org_account_number =@org_account_number  AND is_agent='Y'";


        
        public const String SELECT_LIST_ORGANIZATION_ALL = @"SELECT  * FROM (SELECT [elt_account_number]
        ,[org_account_number]
        , CASE WHEN isnull(class_code,'') = '' THEN dba_name
        ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']' END as dba_name
        ,[class_code]
        ,[isFrequently]
        ,[business_legal_name]     
        ,[OrgId]
        ,row_number()over(order by t.dba_name) as [rn]
        FROM [dbo].[organization]
        as t ) as st where  elt_account_number = @elt_account_number ";

        public const String SELECT_LIST_ORGANIZATION_WITH_FILTER_START_END_INDEX= @"SELECT * FROM (SELECT [elt_account_number]
        ,[org_account_number]
        , CASE WHEN isnull(class_code,'') = '' THEN dba_name
        ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']' END as dba_name
        ,[class_code]
        ,[isFrequently]
        ,[business_legal_name]     
        ,[OrgId]
        ,row_number()over(order by t.dba_name) as [rn]
        FROM [dbo].[organization]
        as t where t.dba_name LIKE @filter) as st where st.[rn] between @startIndex and @endIndex
        AND elt_account_number = @elt_account_number";


        public const string SELECT_LIST_ORGANIZATION_FOR_VALUE = @"SELECT [elt_account_number]
        ,[org_account_number]
        , CASE WHEN isnull(class_code,'') = '' THEN dba_name
        ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']' END as dba_name
        ,[class_code]
        ,[isFrequently]
        ,[business_legal_name]     
        ,[OrgId]
        ,row_number()over(order by dba_name) as [rn]
        FROM [dbo].[organization]
        where org_account_number =@org_account_number";


        public const string RATE_MANAGEMENT_INSERT_RATE =@" INSERT INTO ALL_RATE_TABLE 
													(
														elt_account_number,
														item_no,
														rate_type,
														agent_no,
														customer_no,
														airline,
														origin_port,
														dest_port,
														weight_break,
														rate,
														kg_lb,
														share	
													)
											VALUES 
														(
														@elt_account_number,
														@item_no,
														@rate_type,
														@agent_no,
														@customer_no,
														@airline,
														@origin_port,
														@dest_port,
														@weight_break,
														@rate,
														@kg_lb,
														@share	
													)";

        public const string CreateNewClientFolder = @"
            INSERT INTO [dbo].[Files]
            ([LastWriteTime]
            ,[Name]
            ,[ParentID]
            ,[IsFolder]
            ,[Data]
            ,[OptimisticLockField]
            ,[GCRecord]
            ,[OrgId]
            ,[OwnerEmail]
            ,[ContentID])
            VALUES
            (getdate()
            ,'My Files'
            ,-1
            ,1
            ,null
            ,0
            ,null
            ,null
            ,@email
            ,null)
       ";

    }
}
