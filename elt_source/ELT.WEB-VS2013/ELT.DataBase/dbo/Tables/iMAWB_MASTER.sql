﻿CREATE TABLE [dbo].[iMAWB_MASTER] (
    [elt_account_number]                  DECIMAL (8)     NOT NULL,
    [agent_elt_acct]                      DECIMAL (8)     NULL,
    [tran_dt]                             DATETIME        NULL,
    [MAWB_NUM]                            NVARCHAR (32)   NOT NULL,
    [carrier]                             NVARCHAR (128)  NULL,
    [file_no]                             NVARCHAR (128)  NULL,
    [etd]                                 DATETIME        NULL,
    [eta]                                 DATETIME        NULL,
    [dep_port]                            NVARCHAR (64)   NULL,
    [arr_port]                            NVARCHAR (64)   NULL,
    [cargo_location]                      NVARCHAR (128)  NULL,
    [storage_begin_date]                  DATETIME        NULL,
    [it_number]                           NVARCHAR (64)   NULL,
    [it_date]                             DATETIME        NULL,
    [job_file_no]                         NVARCHAR (64)   NULL,
    [agent_debit_no]                      NVARCHAR (64)   NULL,
    [agent_debit_amt]                     DECIMAL (12, 2) NULL,
    [freight_collect]                     DECIMAL (12, 2) NULL,
    [profit]                              DECIMAL (12, 2) NULL,
    [DEP_AIRPORT_CODE]                    NVARCHAR (3)    NULL,
    [master_agent]                        DECIMAL (5)     NULL,
    [airline_vendor_num]                  DECIMAL (5)     NULL,
    [Shipper_Name]                        NVARCHAR (128)  NULL,
    [Shipper_Info]                        NTEXT           NULL,
    [Shipper_account_number]              NVARCHAR (16)   NULL,
    [Consignee_Name]                      NVARCHAR (128)  NULL,
    [Consignee_Info]                      NTEXT           NULL,
    [Consignee_acct_num]                  NVARCHAR (32)   NULL,
    [Issue_Carrier_agent]                 NTEXT           NULL,
    [Agent_IATA_Code]                     NVARCHAR (32)   NULL,
    [Account_No]                          NVARCHAR (32)   NULL,
    [Departure_Airport]                   NVARCHAR (32)   NULL,
    [DEPARTURE_STATE]                     NVARCHAR (16)   NULL,
    [IssuedBy]                            NVARCHAR (128)  NULL,
    [Account_Info]                        NTEXT           NULL,
    [to_1]                                NVARCHAR (8)    NULL,
    [by_1]                                NVARCHAR (32)   NULL,
    [to_2]                                NVARCHAR (8)    NULL,
    [by_2]                                NVARCHAR (32)   NULL,
    [to_3]                                NVARCHAR (8)    NULL,
    [by_3]                                NVARCHAR (32)   NULL,
    [Currency]                            NVARCHAR (3)    NULL,
    [Charge_Code]                         NVARCHAR (2)    NULL,
    [PPO_1]                               NVARCHAR (1)    NULL,
    [COLL_1]                              NVARCHAR (1)    NULL,
    [PPO_2]                               NVARCHAR (1)    NULL,
    [COLL_2]                              NVARCHAR (1)    NULL,
    [Declared_Value_Carriage]             NVARCHAR (16)   NULL,
    [Declared_Value_Customs]              NVARCHAR (16)   NULL,
    [Dest_Airport]                        NVARCHAR (32)   NULL,
    [Flight_Date_1]                       NVARCHAR (10)   NULL,
    [Flight_Date_2]                       NVARCHAR (10)   NULL,
    [Insurance_AMT]                       NVARCHAR (16)   NULL,
    [Handling_Info]                       NTEXT           NULL,
    [dest_country]                        NVARCHAR (32)   NULL,
    [SCI]                                 NVARCHAR (16)   NULL,
    [Total_Pieces]                        DECIMAL (4)     NULL,
    [Adjusted_Weight]                     DECIMAL (12, 2) NULL,
    [Total_Gross_Weight]                  DECIMAL (12, 2) NULL,
    [Weight_Scale]                        NCHAR (1)       NULL,
    [Total_Weight_Charge_HAWB]            DECIMAL (12, 2) NULL,
    [Total_Weight_Charge_ACCT]            DECIMAL (12, 2) NULL,
    [Total_Other_Charges]                 DECIMAL (12, 2) NULL,
    [Prepaid_Weight_Charge]               DECIMAL (12, 2) NULL,
    [Collect_Weight_Charge]               DECIMAL (12, 2) NULL,
    [Prepaid_Valuation_Charge]            DECIMAL (12, 2) NULL,
    [Collect_Valuation_Charge]            DECIMAL (12, 2) NULL,
    [Prepaid_Tax]                         DECIMAL (12, 2) NULL,
    [Collect_Tax]                         DECIMAL (12, 2) NULL,
    [Prepaid_Due_Agent]                   DECIMAL (12, 2) NULL,
    [Collect_Due_Agent]                   DECIMAL (12, 2) NULL,
    [Prepaid_Due_Carrier]                 DECIMAL (12, 2) NULL,
    [Collect_Due_Carrier]                 DECIMAL (12, 2) NULL,
    [Prepaid_Unused]                      DECIMAL (12, 2) NULL,
    [Collect_Unused]                      DECIMAL (12, 2) NULL,
    [Prepaid_Total]                       DECIMAL (12, 2) NULL,
    [Collect_Total]                       DECIMAL (12, 2) NULL,
    [Signature]                           NVARCHAR (64)   NULL,
    [Date_Executed]                       DATETIME        NULL,
    [Place_Executed]                      NVARCHAR (64)   NULL,
    [Execution]                           NVARCHAR (128)  NULL,
    [Date_Last_Modified]                  DATETIME        NULL,
    [Currency_Conv_Rate]                  DECIMAL (10, 2) NULL,
    [CC_Charge_Dest_Rate]                 DECIMAL (10, 2) NULL,
    [Charge_at_Dest]                      DECIMAL (12, 2) NULL,
    [Total_Collect_Charge]                DECIMAL (12, 2) NULL,
    [Desc1]                               NTEXT           NULL,
    [Desc2]                               NTEXT           NULL,
    [Show_Weight_Charge_Shipper]          NCHAR (1)       NULL,
    [Show_Weight_Charge_Consignee]        NCHAR (1)       NULL,
    [Show_Prepaid_Other_Charge_Shipper]   NCHAR (1)       NULL,
    [Show_Collect_Other_Charge_Shipper]   NCHAR (1)       NULL,
    [Show_Prepaid_Other_Charge_Consignee] NCHAR (1)       NULL,
    [Show_Collect_Other_Charge_Consignee] NCHAR (1)       NULL,
    [Invoiced]                            NCHAR (1)       NULL
);

