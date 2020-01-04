CREATE TABLE [dbo].[account_payable_journal] (
    [elt_account_number] DECIMAL (8)     NOT NULL,
    [gl_account_number]  DECIMAL (5)     NULL,
    [tran_date]          DATETIME        NULL,
    [tran_type]          NVARCHAR (8)    NULL,
    [invoice_No]         DECIMAL (12)    NULL,
    [customer_number]    DECIMAL (7)     NULL,
    [customer_name]      NVARCHAR (128)  NULL,
    [debit_amount]       DECIMAL (12, 2) NULL,
    [credit_amount]      DECIMAL (12, 2) NULL,
    [check_no]           NVARCHAR (12)   NULL,
    [po_no]              NVARCHAR (12)   NULL,
    [last_modified]      DATETIME        NULL,
    [is_org_merged]      NCHAR (1)       NULL
);

