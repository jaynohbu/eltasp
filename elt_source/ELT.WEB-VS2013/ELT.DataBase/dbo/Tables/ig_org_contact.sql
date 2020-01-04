CREATE TABLE [dbo].[ig_org_contact] (
    [elt_account_number] DECIMAL (8)    NOT NULL,
    [org_account_number] DECIMAL (7)    NOT NULL,
    [item_no]            INT            NOT NULL,
    [name]               NVARCHAR (128) NULL,
    [job_title]          NVARCHAR (32)  NULL,
    [phone]              NVARCHAR (32)  NULL,
    [fax]                NVARCHAR (32)  NULL,
    [email]              NVARCHAR (128) NULL,
    [remark]             NVARCHAR (64)  NULL,
    [date]               SMALLDATETIME  NULL,
    [editedby]           NCHAR (20)     NULL,
    [cellPhone]          NVARCHAR (32)  NULL,
    [phoneExt]           NVARCHAR (32)  NULL,
    [is_org_merged]      NCHAR (1)      NULL
);

