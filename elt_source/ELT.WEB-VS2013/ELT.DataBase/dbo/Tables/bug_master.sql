CREATE TABLE [dbo].[bug_master] (
    [auto_uid]           DECIMAL (18)   IDENTITY (1, 1) NOT NULL,
    [asp_code]           NVARCHAR (32)  NULL,
    [err_number]         NVARCHAR (64)  NULL,
    [source]             NVARCHAR (128) NULL,
    [source_file]        NVARCHAR (128) NULL,
    [err_line]           DECIMAL (18)   NULL,
    [err_desc]           NTEXT          NULL,
    [err_asp_desc]       NTEXT          NULL,
    [last_sql]           NTEXT          NULL,
    [err_date]           DATETIME       NULL,
    [elt_account_number] DECIMAL (18)   NULL,
    [user_id]            DECIMAL (18)   NULL
);

