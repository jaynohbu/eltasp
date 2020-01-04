CREATE TABLE [dbo].[aes_detail] (
    [elt_account_number] DECIMAL (8)     NOT NULL,
    [item_no]            INT             NOT NULL,
    [dfm]                NVARCHAR (1)    NULL,
    [b_number]           NVARCHAR (32)   NULL,
    [item_desc]          NVARCHAR (128)  NULL,
    [b_qty1]             INT             NULL,
    [unit1]              NVARCHAR (16)   NULL,
    [b_qty2]             INT             NULL,
    [unit2]              NVARCHAR (16)   NULL,
    [gross_weight]       DECIMAL (12, 2) NULL,
    [vin_type]           NVARCHAR (1)    NULL,
    [vin]                NVARCHAR (32)   NULL,
    [vc_title]           NVARCHAR (15)   NULL,
    [vc_state]           NVARCHAR (2)    NULL,
    [item_value]         DECIMAL (12, 2) NULL,
    [export_code]        NVARCHAR (32)   NULL,
    [license_type]       NVARCHAR (32)   NULL,
    [aes_id]             DECIMAL (18)    NULL,
    [eccn]               NVARCHAR (5)    NULL,
    [license_number]     NVARCHAR (12)   NULL,
    [id]                 INT             IDENTITY (1, 1) NOT NULL
);

