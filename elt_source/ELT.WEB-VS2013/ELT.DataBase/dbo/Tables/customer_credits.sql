CREATE TABLE [dbo].[customer_credits] (
    [elt_account_number] DECIMAL (8)     CONSTRAINT [DF_customer_credits_elt_account_number] DEFAULT (0) NOT NULL,
    [customer_no]        DECIMAL (8)     NOT NULL,
    [customer_name]      NVARCHAR (128)  NULL,
    [credit]             DECIMAL (12, 2) CONSTRAINT [DF_customer_credits_credit] DEFAULT (0) NULL,
    [is_org_merged]      NCHAR (1)       NULL,
    CONSTRAINT [PK_customer_credits] PRIMARY KEY CLUSTERED ([elt_account_number] ASC, [customer_no] ASC)
);

