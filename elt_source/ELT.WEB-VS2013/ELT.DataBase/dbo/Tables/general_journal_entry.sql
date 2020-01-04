CREATE TABLE [dbo].[general_journal_entry] (
    [elt_account_number] DECIMAL (8)     NULL,
    [entry_no]           INT             NULL,
    [item_no]            INT             NULL,
    [gl_account_number]  DECIMAL (7)     NULL,
    [credit]             DECIMAL (12, 2) NULL,
    [debit]              DECIMAL (12, 2) NULL,
    [memo]               NVARCHAR (128)  NULL,
    [org_acct]           DECIMAL (6)     NULL,
    [dt]                 DATETIME        NULL,
    [is_org_merged]      NCHAR (1)       NULL
);

