CREATE TABLE [dbo].[ig_org_comments] (
    [elt_account_number] DECIMAL (8)     NOT NULL,
    [org_account_number] DECIMAL (7)     NOT NULL,
    [item_no]            NCHAR (3)       NOT NULL,
    [title]              NCHAR (32)      NULL,
    [comment]            NVARCHAR (1024) NULL,
    [date]               SMALLDATETIME   NULL,
    [editedby]           NCHAR (20)      NULL,
    [is_org_merged]      NCHAR (1)       NULL
);

