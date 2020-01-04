CREATE TABLE [dbo].[import_mawb] (
    [elt_account_number] DECIMAL (8)     NOT NULL,
    [agent_elt_acct]     DECIMAL (8)     NULL,
    [export_agent_name]  NVARCHAR (256)  NULL,
    [agent_org_acct]     DECIMAL (8)     CONSTRAINT [DF_import_mawb_agent_org_acct] DEFAULT (0) NULL,
    [tran_dt]            DATETIME        NULL,
    [iType]              NCHAR (1)       NULL,
    [mawb_num]           NVARCHAR (64)   NOT NULL,
    [sec]                INT             NOT NULL,
    [sub_mawb]           NVARCHAR (64)   NULL,
    [process_dt]         DATETIME        NULL,
    [processed]          NVARCHAR (1)    CONSTRAINT [DF_import_mawb_processed] DEFAULT ('N') NULL,
    [carrier]            NVARCHAR (256)  NULL,
    [vessel_name]        NVARCHAR (256)  NULL,
    [file_no]            NVARCHAR (128)  NULL,
    [voyage_no]          NVARCHAR (64)   NULL,
    [flt_no]             NVARCHAR (64)   NULL,
    [etd]                NVARCHAR (64)   NULL,
    [eta]                NVARCHAR (64)   NULL,
    [dep_port]           NVARCHAR (128)  NULL,
    [arr_port]           NVARCHAR (128)  NULL,
    [cargo_location]     NVARCHAR (256)  NULL,
    [last_free_date]     DATETIME        NULL,
    [pieces]             NVARCHAR (128)  CONSTRAINT [DF_import_mawb_pieces] DEFAULT (0) NULL,
    [scale1]             NVARCHAR (4)    NULL,
    [gross_wt]           NVARCHAR (64)   CONSTRAINT [DF_import_mawb_gross_wt] DEFAULT (0) NULL,
    [scale2]             NVARCHAR (4)    NULL,
    [chg_wt]             NVARCHAR (64)   CONSTRAINT [DF_import_mawb_chg_wt] DEFAULT (0) NULL,
    [scale3]             NVARCHAR (4)    NULL,
    [agent_debit_no]     NVARCHAR (64)   NULL,
    [agent_debit_amt]    DECIMAL (12, 2) CONSTRAINT [DF_import_mawb_agent_debit_amt] DEFAULT (0) NULL,
    [it_number]          NVARCHAR (64)   NULL,
    [it_date]            NVARCHAR (64)   NULL,
    [it_entry_port]      NVARCHAR (64)   NULL,
    [place_of_delivery]  NVARCHAR (128)  NULL,
    [SalesPerson]        NVARCHAR (128)  NULL,
    [CreatedBy]          NVARCHAR (128)  NULL,
    [CreatedDate]        DATETIME        NULL,
    [ModifiedBy]         NVARCHAR (128)  NULL,
    [ModifiedDate]       DATETIME        NULL,
    [dep_code]           NVARCHAR (8)    NULL,
    [arr_code]           NVARCHAR (8)    NULL,
    [carrier_code]       NVARCHAR (64)   NULL,
    [is_org_merged]      NCHAR (1)       NULL
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-import_mawb]
    ON [dbo].[import_mawb]([elt_account_number] ASC, [mawb_num] ASC)
    INCLUDE([dep_code], [arr_code]);

