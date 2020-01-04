CREATE TABLE [dbo].[reconcile_receivement_detail] (
    [recon_id]           DECIMAL (18)    NOT NULL,
    [elt_account_number] DECIMAL (8)     NOT NULL,
    [tran_seq_num]       DECIMAL (8)     NOT NULL,
    [gl_account_number]  DECIMAL (5)     NULL,
    [gl_account_name]    NVARCHAR (128)  NULL,
    [tran_type]          NVARCHAR (16)   NULL,
    [tran_num]           NVARCHAR (16)   NULL,
    [tran_date]          DATETIME        NULL,
    [customer_name]      NVARCHAR (128)  NULL,
    [customer_number]    DECIMAL (9)     NULL,
    [debit_amount]       DECIMAL (12, 2) NULL,
    [ModifiedBy]         NCHAR (10)      NULL,
    [ModifiedDate]       DATETIME        NULL,
    [memo]               NVARCHAR (128)  NULL,
    [is_recon_cleared]   NCHAR (1)       NULL
);

