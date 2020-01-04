CREATE TABLE [dbo].[Ocean_sed_detail] (
    [elt_account_number] DECIMAL (8)     NOT NULL,
    [hbol_num]           NVARCHAR (32)   NOT NULL,
    [item_no]            INT             NOT NULL,
    [dfm]                NCHAR (1)       NULL,
    [b_number]           NVARCHAR (32)   NULL,
    [b_qty1]             INT             NULL,
    [unit1]              NVARCHAR (10)   NULL,
    [b_qty2]             INT             NULL,
    [unit2]              NVARCHAR (10)   NULL,
    [gross_weight]       DECIMAL (12, 2) NULL,
    [vin]                NVARCHAR (32)   NULL,
    [item_value]         DECIMAL (12)    NULL,
    [export_code]        NVARCHAR (10)   NULL,
    [license_type]       NVARCHAR (10)   NULL,
    [item_desc]          NVARCHAR (45)   NULL,
    [booking_num]        NVARCHAR (128)  NULL,
    [sed_id]             DECIMAL (18)    NULL
);

