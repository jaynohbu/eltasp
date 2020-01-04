CREATE TABLE [dbo].[customer_payment_detail] (
    [elt_account_number] DECIMAL (8)    NOT NULL,
    [payment_no]         DECIMAL (9)    NOT NULL,
    [item_id]            INT            NOT NULL,
    [invoice_date]       DATETIME       NULL,
    [type]               NVARCHAR (16)  NULL,
    [invoice_no]         DECIMAL (12)   NULL,
    [orig_amt]           DECIMAL (9, 2) NULL,
    [amt_due]            DECIMAL (9, 2) NULL,
    [payment]            DECIMAL (9, 2) NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_customer_payment_detail]
    ON [dbo].[customer_payment_detail]([elt_account_number] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_customer_payment_detail_1]
    ON [dbo].[customer_payment_detail]([payment_no] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_customer_payment_detail_2]
    ON [dbo].[customer_payment_detail]([invoice_no] ASC);

