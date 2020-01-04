CREATE TABLE [dbo].[customer_balance] (
    [elt_account_number] DECIMAL (8)     NULL,
    [gl_account_number]  DECIMAL (8)     NULL,
    [customer_name]      NVARCHAR (128)  NULL,
    [customer_acct]      DECIMAL (9)     NULL,
    [balance]            DECIMAL (12, 2) NULL,
    [last_modified]      DATETIME        NULL,
    [is_org_merged]      NCHAR (1)       NULL
);

