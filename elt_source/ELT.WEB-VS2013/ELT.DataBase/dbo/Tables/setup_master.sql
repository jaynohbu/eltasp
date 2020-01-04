CREATE TABLE [dbo].[setup_master] (
    [page_id]    DECIMAL (18)   IDENTITY (1, 1) NOT NULL,
    [seq_id]     DECIMAL (18)   NULL,
    [title]      NVARCHAR (32)  NULL,
    [setup_type] NVARCHAR (32)  NULL,
    [setup_url]  NVARCHAR (128) NULL,
    [valid_url]  NVARCHAR (128) NULL,
    [remark]     NTEXT          NULL
);

