CREATE TABLE [dbo].[setup_session] (
    [sid]                NVARCHAR (128) NULL,
    [email]              NVARCHAR (128) NULL,
    [password]           NVARCHAR (16)  NULL,
    [page_id]            DECIMAL (18)   NULL,
    [created_date]       DATETIME       NULL,
    [updated_date]       DATETIME       NULL,
    [elt_account_number] DECIMAL (18)   NULL,
    [application_log]    NTEXT          NULL,
    [support_ask]        NTEXT          NULL,
    [support_answer]     NTEXT          NULL,
    [payment_id]         DECIMAL (18)   NULL
);

