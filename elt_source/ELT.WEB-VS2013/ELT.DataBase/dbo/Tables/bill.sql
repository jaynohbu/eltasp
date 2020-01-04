CREATE TABLE [dbo].[bill] (
    [elt_account_number] DECIMAL (8)     NOT NULL,
    [bill_number]        DECIMAL (9)     NOT NULL,
    [bill_type]          NCHAR (1)       NULL,
    [vendor_number]      DECIMAL (7)     NULL,
    [vendor_name]        NVARCHAR (128)  NULL,
    [bill_date]          DATETIME        NULL,
    [bill_due_date]      DATETIME        NULL,
    [bill_amt]           DECIMAL (12, 2) CONSTRAINT [DF_bill_bill_amt] DEFAULT (0) NULL,
    [bill_amt_paid]      DECIMAL (12, 2) CONSTRAINT [DF_bill_bill_amt_paid] DEFAULT (0) NULL,
    [bill_amt_due]       DECIMAL (12, 2) CONSTRAINT [DF_bill_bill_amt_due] DEFAULT (0) NULL,
    [ref_no]             NVARCHAR (256)  NULL,
    [bill_expense_acct]  DECIMAL (5)     NULL,
    [bill_ap]            DECIMAL (5)     NULL,
    [bill_status]        NCHAR (1)       NULL,
    [print_id]           DECIMAL (9)     NULL,
    [lock]               NCHAR (1)       CONSTRAINT [DF_bill_lock] DEFAULT ('N') NULL,
    [pmt_method]         NVARCHAR (32)   NULL,
    [is_org_merged]      NCHAR (1)       NULL
);

