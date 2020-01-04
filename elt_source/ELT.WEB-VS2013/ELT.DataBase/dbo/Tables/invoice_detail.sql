CREATE TABLE [dbo].[invoice_detail] (
    [elt_account_number] DECIMAL (8)     NOT NULL,
    [invoice_no]         DECIMAL (7)     NOT NULL,
    [item_id]            INT             NOT NULL,
    [item_no]            INT             NOT NULL,
    [item_desc]          NVARCHAR (128)  NULL,
    [qty]                INT             NULL,
    [ref_no]             NVARCHAR (128)  NULL,
    [charge_amount]      DECIMAL (12, 2) NULL,
    [cost_amount]        DECIMAL (12, 2) NULL,
    [vendor_no]          DECIMAL (7)     NULL,
    [is_org_merged]      NCHAR (1)       NULL
);

