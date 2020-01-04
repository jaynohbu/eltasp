CREATE TABLE [dbo].[MAWB_NUMBER] (
    [elt_account_number]    DECIMAL (8)    NOT NULL,
    [mawb_no]               NVARCHAR (32)  NOT NULL,
    [Carrier_Code]          NVARCHAR (16)  NULL,
    [Carrier_MC_ICC]        NVARCHAR (64)  NULL,
    [Carrier_acct]          DECIMAL (18)   NULL,
    [Carrier_Desc]          NVARCHAR (64)  NULL,
    [scac]                  NVARCHAR (32)  NULL,
    [Flight#]               NVARCHAR (8)   NULL,
    [File#]                 NVARCHAR (32)  NULL,
    [Created_Date]          DATETIME       NULL,
    [Origin_Port_ID]        NVARCHAR (3)   NULL,
    [origin_port_aes_code]  DECIMAL (6)    NULL,
    [Origin_Port_Location]  NVARCHAR (128) NULL,
    [Origin_Port_State]     NVARCHAR (8)   NULL,
    [Origin_Port_Country]   NVARCHAR (128) NULL,
    [Dest_Port_ID]          NVARCHAR (3)   NULL,
    [dest_port_aes_code]    DECIMAL (6)    NULL,
    [Dest_Port_Location]    NVARCHAR (128) NULL,
    [Dest_Port_Country]     NVARCHAR (128) NULL,
    [dest_country_code]     NVARCHAR (2)   NULL,
    [To]                    NVARCHAR (3)   NULL,
    [By]                    NVARCHAR (64)  NULL,
    [To_1]                  NVARCHAR (3)   NULL,
    [By_1]                  NVARCHAR (64)  NULL,
    [To_2]                  NVARCHAR (3)   NULL,
    [By_2]                  NVARCHAR (64)  NULL,
    [Flight#1]              NVARCHAR (32)  NULL,
    [Flight#2]              NVARCHAR (32)  NULL,
    [ETD_DATE1]             DATETIME       NULL,
    [ETD_DATE2]             DATETIME       NULL,
    [ETA_DATE1]             DATETIME       NULL,
    [ETA_DATE2]             DATETIME       NULL,
    [Weight_Reserved]       DECIMAL (18)   NULL,
    [Weight_Scale]          NVARCHAR (4)   NULL,
    [airline_staff]         NVARCHAR (64)  NULL,
    [Status]                NCHAR (1)      CONSTRAINT [DF_MAWB_NUMBER_Status] DEFAULT ('A') NULL,
    [used]                  NCHAR (1)      CONSTRAINT [DF_MAWB_NUMBER_used] DEFAULT ('N') NULL,
    [is_dome]               NVARCHAR (1)   CONSTRAINT [DF__mawb_numb__is_do__26EFBBC6] DEFAULT ('N') NOT NULL,
    [pieces]                DECIMAL (18)   NULL,
    [master_type]           NVARCHAR (2)   NULL,
    [service_level]         NVARCHAR (128) NULL,
    [service_level_other]   NVARCHAR (64)  NULL,
    [booking_date]          DATETIME       NULL,
    [is_inbound]            NVARCHAR (1)   CONSTRAINT [DF__mawb_numb__is_in__5A6F5FCC] DEFAULT ('N') NULL,
    [inbound_customer_acct] DECIMAL (18)   NULL,
    CONSTRAINT [PK_MAWB_NUMBER] PRIMARY KEY CLUSTERED ([elt_account_number] ASC, [mawb_no] ASC)
);




GO
CREATE NONCLUSTERED INDEX [mawb_number]
    ON [dbo].[MAWB_NUMBER]([elt_account_number] ASC, [Carrier_Code] ASC, [Carrier_Desc] ASC, [Status] ASC, [mawb_no] ASC);

