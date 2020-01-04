CREATE TABLE [dbo].[RateEntryRow] (
    [RouteID]     INT        NOT NULL,
    [ID]          INT        IDENTITY (1, 1) NOT NULL,
    [CarrierCode] INT        NOT NULL,
    [Share]       FLOAT (53) NULL,
    CONSTRAINT [PK_Rate] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Row_Route] FOREIGN KEY ([RouteID]) REFERENCES [dbo].[RateRoute] ([ID])
);

