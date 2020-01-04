CREATE TABLE [dbo].[mb_cost_item] (
    [auto_uid]           DECIMAL (18)    IDENTITY (1, 1) NOT NULL,
    [elt_account_number] DECIMAL (8)     NULL,
    [mb_no]              NVARCHAR (32)   NULL,
    [item_id]            INT             NULL,
    [item_no]            INT             NULL,
    [item_desc]          NVARCHAR (128)  NULL,
    [qty]                INT             NULL,
    [ref_no]             NVARCHAR (128)  NULL,
    [cost_amount]        DECIMAL (12, 2) NULL,
    [vendor_no]          DECIMAL (8)     NULL,
    [iType]              NCHAR (1)       NULL,
    [lock_ap]            NCHAR (1)       NULL,
    [is_org_merged]      NCHAR (1)       NULL,
    [bill_number]        DECIMAL (9)     NULL,
    [rate]               DECIMAL (10, 2) NULL
);

