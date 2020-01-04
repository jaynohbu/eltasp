CREATE TABLE [dbo].[check_detail] (
    [elt_account_number] DECIMAL (8)     CONSTRAINT [DF_check_detail_elt_account_number] DEFAULT (0) NOT NULL,
    [print_id]           DECIMAL (9)     CONSTRAINT [DF_check_detail_print_id] DEFAULT (0) NOT NULL,
    [tran_id]            INT             NOT NULL,
    [bill_number]        DECIMAL (9)     CONSTRAINT [DF_check_detail_bill_number] DEFAULT (0) NULL,
    [due_date]           DATETIME        NULL,
    [invoice_no]         NVARCHAR (64)   NULL,
    [bill_amt]           DECIMAL (12, 2) CONSTRAINT [DF_check_detail_bill_amt] DEFAULT (0) NULL,
    [amt_due]            DECIMAL (12, 2) CONSTRAINT [DF_check_detail_amt_due] DEFAULT (0) NULL,
    [amt_paid]           DECIMAL (12, 2) CONSTRAINT [DF_check_detail_amt_paid] DEFAULT (0) NULL,
    [amt_dispute]        DECIMAL (18, 2) NULL,
    [memo]               NVARCHAR (512)  NULL,
    [pmt_method]         NVARCHAR (32)   NULL
);

