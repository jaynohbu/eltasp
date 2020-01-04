CREATE TABLE [dbo].[invoice_charge_item] (
    [elt_account_number] DECIMAL (8)     NULL,
    [invoice_no]         DECIMAL (12)    NULL,
    [item_id]            INT             NULL,
    [item_no]            INT             NULL,
    [item_desc]          NVARCHAR (128)  NULL,
    [qty]                INT             NULL,
    [charge_amount]      DECIMAL (12, 2) NULL,
    [mb_no]              NVARCHAR (32)   NULL,
    [hb_no]              NVARCHAR (32)   NULL,
    [iType]              NVARCHAR (1)    NULL,
    [import_export]      NVARCHAR (1)    NULL,
    [invoice_header_id]  DECIMAL (18)    NULL
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-invoice_charge_item]
    ON [dbo].[invoice_charge_item]([elt_account_number] ASC, [invoice_no] ASC)
    INCLUDE([item_no], [item_desc], [charge_amount]);

