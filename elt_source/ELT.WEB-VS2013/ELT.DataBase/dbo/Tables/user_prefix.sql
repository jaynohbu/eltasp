CREATE TABLE [dbo].[user_prefix] (
    [elt_account_number] DECIMAL (8)   NULL,
    [branch]             INT           NULL,
    [seq_num]            INT           NULL,
    [prefix]             NVARCHAR (16) NULL,
    [type]               NVARCHAR (16) NULL,
    [next_no]            DECIMAL (9)   CONSTRAINT [DF_user_prefix_next_no] DEFAULT (1) NULL,
    [desc]               NVARCHAR (64) NULL
);

