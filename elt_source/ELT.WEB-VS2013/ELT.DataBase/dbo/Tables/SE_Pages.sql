CREATE TABLE [dbo].[SE_Pages] (
    [Page_Id]      INT            NOT NULL,
    [Module_Id]    INT            NULL,
    [Name]         NVARCHAR (40)  NOT NULL,
    [Extention]    NVARCHAR (4)   NULL,
    [Description]  NVARCHAR (80)  NULL,
    [Type]         NVARCHAR (50)  NULL,
    [PhysicalPage] NVARCHAR (100) NULL,
    [Deleted]      NVARCHAR (1)   NULL,
    [morder]       INT            NULL
);

