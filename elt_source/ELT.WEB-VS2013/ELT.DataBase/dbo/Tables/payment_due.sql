CREATE TABLE [dbo].[payment_due] (
    [auto_uid]           DECIMAL (18)    IDENTITY (1, 1) NOT NULL,
    [elt_account_number] DECIMAL (18)    NULL,
    [create_date]        DATETIME        CONSTRAINT [DF_payment_due_create_date] DEFAULT (getdate()) NULL,
    [pmt_amount]         DECIMAL (18, 2) NULL,
    [pmt_desc]           NVARCHAR (128)  NULL,
    [pmt_status]         NVARCHAR (1)    NULL,
    [tran_id]            NVARCHAR (64)   NULL,
    [resp_code]          DECIMAL (18)    NULL,
    [resp_res_code]      DECIMAL (18)    NULL,
    [resp_res_text]      NTEXT           NULL,
    [auth_code]          NVARCHAR (64)   NULL,
    [avs_code]           NVARCHAR (8)    NULL,
    [auth_date]          DATETIME        CONSTRAINT [DF_payment_due_auth_date] DEFAULT (getdate()) NULL
);

