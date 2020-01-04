CREATE TABLE [dbo].[customer_credit_info] (
    [auto_uid]           DECIMAL (18)    IDENTITY (1, 1) NOT NULL,
    [elt_account_number] DECIMAL (8)     NULL,
    [customer_no]        DECIMAL (8)     NULL,
    [memo]               NVARCHAR (256)  NULL,
    [credit]             DECIMAL (12, 2) NULL,
    [tran_date]          DATETIME        NULL,
    [customer_name]      NVARCHAR (256)  NULL,
    [entry_no]           DECIMAL (5)     NULL,
    [invoice_no]         DECIMAL (5)     NULL,
    [ref_no]             NVARCHAR (256)  NULL,
    [is_refund]          NVARCHAR (1)    NULL
);

