CREATE TABLE [dbo].[item_charge] (
    [elt_account_number] DECIMAL (8)     NULL,
    [item_no]            INT             NULL,
    [item_name]          NVARCHAR (32)   NULL,
    [item_type]          NVARCHAR (32)   NULL,
    [item_desc]          NVARCHAR (32)   NULL,
    [unit_price]         DECIMAL (10, 2) NULL,
    [account_revenue]    DECIMAL (5)     NULL,
    [item_def]           NVARCHAR (32)   NULL
);

