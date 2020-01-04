CREATE TABLE [dbo].[SubscriptionDefinition] (
    [ID]         INT            IDENTITY (1, 1) NOT NULL,
    [Code]       NVARCHAR (50)  NOT NULL,
    [Descripton] NVARCHAR (200) NOT NULL,
    [is_product] BIT            NULL
);

