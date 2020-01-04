CREATE TABLE [dbo].[carrier_master] (
    [auto_uid]           DECIMAL (18)  IDENTITY (1, 1) NOT NULL,
    [elt_account_number] DECIMAL (18)  NULL,
    [carrier_name]       NVARCHAR (64) NULL,
    [carrier_code_type]  NVARCHAR (8)  NULL,
    [carrier_code]       NVARCHAR (8)  NULL,
    [tran_type]          NVARCHAR (8)  NULL,
    [org_account_number] DECIMAL (18)  NULL
);

