CREATE TABLE [dbo].[RateBlockDefinition] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [RangeStart]     INT           NOT NULL,
    [Caption]        NVARCHAR (50) NOT NULL,
    [RateEntryRowID] INT           NOT NULL,
    [Value]          NVARCHAR (50) NULL,
    CONSTRAINT [PK_RateBlockDefinition] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_RateBlockDefinition_RateEntryRow] FOREIGN KEY ([RateEntryRowID]) REFERENCES [dbo].[RateEntryRow] ([ID])
);

