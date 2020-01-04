CREATE TABLE [dbo].[Countries] (
    [CountryId] INT            IDENTITY (1, 1) NOT NULL,
    [Country]   NVARCHAR (255) NULL,
    [CapitalId] INT            NULL,
    CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED ([CountryId] ASC)
);

