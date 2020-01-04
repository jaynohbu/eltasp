CREATE TABLE [dbo].[ELT_NOTIFICATION] (
    [elt_account_number] DECIMAL (8)    NOT NULL,
    [userid]             DECIMAL (8)    NOT NULL,
    [message]            NVARCHAR (128) NULL,
    [expired_to]         DATETIME       NULL
);

