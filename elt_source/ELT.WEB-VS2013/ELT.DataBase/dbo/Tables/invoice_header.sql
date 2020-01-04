CREATE TABLE [dbo].[invoice_header] (
    [auto_id]            DECIMAL (18)   IDENTITY (1, 1) NOT NULL,
    [elt_account_number] DECIMAL (18)   NULL,
    [invoice_no]         DECIMAL (12)   NOT NULL,
    [mawb]               NVARCHAR (32)  NULL,
    [hawb]               NVARCHAR (32)  NULL,
    [ETA]                NVARCHAR (32)  NULL,
    [ETD]                NVARCHAR (32)  NULL,
    [Consignee]          NVARCHAR (256) NULL,
    [Shipper]            NVARCHAR (256) NULL,
    [FILE_NO]            NVARCHAR (32)  NULL,
    [GrossWeight]        NVARCHAR (32)  NULL,
    [ChargeableWeight]   NVARCHAR (32)  NULL,
    [unit]               NVARCHAR (32)  NULL,
    [Pieces]             NVARCHAR (32)  NULL,
    [Origin]             NVARCHAR (32)  NULL,
    [Destination]        NVARCHAR (32)  NULL,
    [Carrier]            NVARCHAR (32)  NULL
);

