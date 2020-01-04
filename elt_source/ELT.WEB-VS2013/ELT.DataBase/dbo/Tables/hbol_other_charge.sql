CREATE TABLE [dbo].[hbol_other_charge] (
    [elt_account_number] DECIMAL (8)     NOT NULL,
    [hbol_num]           NVARCHAR (128)  NOT NULL,
    [tran_no]            INT             NOT NULL,
    [Coll_Prepaid]       NCHAR (1)       NULL,
    [charge_code]        INT             NULL,
    [charge_desc]        NVARCHAR (128)  NULL,
    [charge_amt]         DECIMAL (12, 2) NULL,
    [vendor_num]         DECIMAL (18)    NULL,
    [cost_code]          INT             NULL,
    [cost_desc]          NVARCHAR (128)  NULL,
    [cost_amt]           DECIMAL (12, 2) NULL
);

