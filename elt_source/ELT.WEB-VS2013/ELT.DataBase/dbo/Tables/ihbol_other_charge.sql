CREATE TABLE [dbo].[ihbol_other_charge] (
    [elt_account_number] DECIMAL (8)     NULL,
    [hbol_num]           NVARCHAR (24)   NULL,
    [tran_no]            INT             NULL,
    [Coll_Prepaid]       NCHAR (1)       NULL,
    [charge_code]        INT             NULL,
    [charge_desc]        NVARCHAR (32)   NULL,
    [charge_amt]         DECIMAL (12, 2) NULL,
    [vendor_num]         DECIMAL (5)     NULL,
    [cost_amt]           DECIMAL (12, 2) NULL
);

