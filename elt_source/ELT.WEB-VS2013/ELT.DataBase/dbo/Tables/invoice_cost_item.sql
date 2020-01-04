CREATE TABLE [dbo].[invoice_cost_item] (
    [elt_account_number] DECIMAL (8)     NULL,
    [invoice_no]         DECIMAL (12)    NULL,
    [item_id]            INT             NULL,
    [item_no]            INT             NULL,
    [item_desc]          NVARCHAR (128)  NULL,
    [qty]                INT             NULL,
    [ref_no]             NVARCHAR (128)  NULL,
    [cost_amount]        DECIMAL (12, 2) NULL,
    [vendor_no]          DECIMAL (7)     NULL,
    [is_org_merged]      NCHAR (1)       NULL,
    [mb_no]              NVARCHAR (32)   NULL,
    [hb_no]              NVARCHAR (32)   NULL,
    [iType]              NVARCHAR (1)    NULL,
    [import_export]      NVARCHAR (1)    NULL,
    [ap_lock]            NVARCHAR (1)    NULL,
    [invoice_header_id]  DECIMAL (18)    NULL
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-invoice_cost_item]
    ON [dbo].[invoice_cost_item]([elt_account_number] ASC)
    INCLUDE([invoice_no], [item_no], [item_desc], [cost_amount], [vendor_no]);

