CREATE TABLE [dbo].[bill_detail] (
    [elt_account_number]   DECIMAL (8)     NULL,
    [invoice_no]           DECIMAL (12)    CONSTRAINT [DF_bill_detail_invoice_no] DEFAULT (0) NULL,
    [item_id]              INT             NULL,
    [bill_number]          DECIMAL (9)     NULL,
    [vendor_number]        DECIMAL (8)     NULL,
    [item_name]            NVARCHAR (64)   NULL,
    [item_no]              INT             NULL,
    [item_amt]             DECIMAL (12, 2) NULL,
    [item_amt_origin]      DECIMAL (18, 2) NULL,
    [item_expense_acct]    DECIMAL (5)     NULL,
    [item_ap]              DECIMAL (5)     NULL,
    [tran_date]            DATETIME        NULL,
    [ref]                  NVARCHAR (64)   NULL,
    [mb_no]                NVARCHAR (32)   NULL,
    [iType]                NCHAR (1)       NULL,
    [agent_debit_no]       NVARCHAR (64)   NULL,
    [is_org_merged]        NCHAR (1)       NULL,
    [is_manual]            NCHAR (1)       CONSTRAINT [DF_bill_detail_is_manual] DEFAULT ('N') NOT NULL,
    [hawb_master_hawb_num] NVARCHAR (64)   NULL,
    [import_export]        NVARCHAR (1)    NULL,
    [hb_no]                NVARCHAR (32)   NULL
);

