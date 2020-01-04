CREATE TABLE [dbo].[USCounties] (
    [ID]                INT            IDENTITY (1, 1) NOT NULL,
    [Name]              NVARCHAR (MAX) NULL,
    [StateAbbreviation] NVARCHAR (MAX) NULL,
    [StateName]         NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_dbo.USCounties] PRIMARY KEY CLUSTERED ([ID] ASC)
);

