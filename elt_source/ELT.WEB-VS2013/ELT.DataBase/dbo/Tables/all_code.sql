CREATE TABLE [dbo].[all_code] (
    [elt_account_number] DECIMAL (18)  NOT NULL,
    [type]               DECIMAL (18)  NOT NULL,
    [code]               NVARCHAR (32) NOT NULL,
    [description]        NVARCHAR (70) NULL,
    CONSTRAINT [PK_all_code] PRIMARY KEY CLUSTERED ([elt_account_number] ASC, [type] ASC, [code] ASC)
);

