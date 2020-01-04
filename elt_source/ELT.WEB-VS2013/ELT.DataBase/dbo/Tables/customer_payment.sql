CREATE TABLE [dbo].[customer_payment] (
    [elt_account_number]  DECIMAL (8)     CONSTRAINT [DF_customer_payment_elt_account_number] DEFAULT (0) NOT NULL,
    [branch]              INT             CONSTRAINT [DF_customer_payment_branch] DEFAULT (0) NULL,
    [payment_no]          DECIMAL (9)     CONSTRAINT [DF_customer_payment_payment_no] DEFAULT (0) NOT NULL,
    [payment_date]        DATETIME        NULL,
    [ref_no]              NVARCHAR (32)   NULL,
    [customer_number]     DECIMAL (8)     CONSTRAINT [DF_customer_payment_customer_number] DEFAULT (0) NULL,
    [customer_name]       NVARCHAR (250)  NULL,
    [third_party_number]  DECIMAL (8)     CONSTRAINT [DF_customer_payment_third_party_number] DEFAULT (0) NULL,
    [third_party_name]    NVARCHAR (250)  NULL,
    [accounts_receivable] DECIMAL (7)     CONSTRAINT [DF_customer_payment_accounts_receivable] DEFAULT (0) NULL,
    [deposit_to]          DECIMAL (7)     CONSTRAINT [DF_customer_payment_deposit_to] DEFAULT (0) NULL,
    [received_amt]        DECIMAL (12, 2) CONSTRAINT [DF_customer_payment_received_amt] DEFAULT (0) NULL,
    [balance]             DECIMAL (12, 2) CONSTRAINT [DF_customer_payment_balance] DEFAULT (0) NULL,
    [pmt_method]          NVARCHAR (32)   NULL,
    [existing_credits]    DECIMAL (12, 2) CONSTRAINT [DF_customer_payment_existing_credits] DEFAULT (0) NULL,
    [unapplied_amt]       DECIMAL (12, 2) CONSTRAINT [DF_customer_payment_unapplied_amt] DEFAULT (0) NULL,
    [added_amt]           DECIMAL (12, 2) CONSTRAINT [DF_customer_payment_added_amt] DEFAULT (0) NULL,
    [is_org_merged]       NCHAR (1)       NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_customer_payment]
    ON [dbo].[customer_payment]([elt_account_number] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_customer_payment_1]
    ON [dbo].[customer_payment]([payment_no] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_customer_payment_2]
    ON [dbo].[customer_payment]([payment_date] ASC);

