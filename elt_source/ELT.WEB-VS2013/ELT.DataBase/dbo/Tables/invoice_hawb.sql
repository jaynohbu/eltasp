CREATE TABLE [dbo].[invoice_hawb] (
    [elt_account_number] DECIMAL (8)     NULL,
    [invoice_no]         DECIMAL (12)    NULL,
    [invoice_type]       NCHAR (1)       NULL,
    [import_export]      NVARCHAR (1)    NULL,
    [air_ocean]          NVARCHAR (1)    NULL,
    [hawb_num]           NVARCHAR (64)   NULL,
    [hawb_url]           NVARCHAR (1024) NULL
);

