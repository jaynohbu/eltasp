CREATE TABLE [dbo].[AspNetUsers] (
    [Id]                 NVARCHAR (128) NOT NULL,
    [UserName]           NVARCHAR (MAX) NULL,
    [PasswordHash]       NVARCHAR (MAX) NULL,
    [SecurityStamp]      NVARCHAR (MAX) NULL,
    [elt_account_number] INT            NULL,
    [Discriminator]      NVARCHAR (128) NOT NULL,
    CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED ([Id] ASC)
);

