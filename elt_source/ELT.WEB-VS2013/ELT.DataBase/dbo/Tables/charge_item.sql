CREATE TABLE [dbo].[charge_item] (
    [elt_account_number] DECIMAL (8)     NOT NULL,
    [item_no]            INT             NOT NULL,
    [item_name]          NVARCHAR (32)   NULL,
    [item_type]          NVARCHAR (32)   NULL,
    [item_desc]          NVARCHAR (32)   NULL,
    [unit_price]         DECIMAL (10, 2) NULL,
    [account_revenue]    DECIMAL (5)     NULL,
    [account_expense]    DECIMAL (5)     NULL
);

