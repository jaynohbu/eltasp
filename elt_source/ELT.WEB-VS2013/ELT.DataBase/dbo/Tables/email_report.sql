CREATE TABLE [dbo].[email_report] (
    [auto_uid]           INT            IDENTITY (1, 1) NOT NULL,
    [session_id]         NVARCHAR (128) NULL,
    [sqlstr]             NTEXT          NULL,
    [status]             NVARCHAR (32)  NULL,
    [elt_account_number] DECIMAL (8)    NULL,
    [company]            INT            NULL,
    [message]            NVARCHAR (256) NULL,
    [sent_date]          DATETIME       NULL,
    [email]              NVARCHAR (256) NULL,
    [period]             NVARCHAR (64)  NULL,
    [is_org_merged]      NCHAR (1)      NULL
);


GO
CREATE NONCLUSTERED INDEX [email_report_elt_company]
    ON [dbo].[email_report]([elt_account_number] ASC, [company] ASC);

