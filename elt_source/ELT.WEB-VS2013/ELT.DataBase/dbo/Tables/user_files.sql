CREATE TABLE [dbo].[user_files] (
    [elt_account_number] DECIMAL (8)    NOT NULL,
    [org_no]             DECIMAL (8)    NOT NULL,
    [file_name]          NVARCHAR (256) NOT NULL,
    [file_size]          DECIMAL (8)    NULL,
    [file_type]          NVARCHAR (128) NULL,
    [file_content]       IMAGE          NULL,
    [file_checked]       NCHAR (1)      NULL,
    [in_dt]              DATETIME       NULL
);

