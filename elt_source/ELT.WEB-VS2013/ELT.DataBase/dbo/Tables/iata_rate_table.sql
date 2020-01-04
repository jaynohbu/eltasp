CREATE TABLE [dbo].[iata_rate_table] (
    [item_no]      INT             NULL,
    [airline]      NVARCHAR (3)    NULL,
    [origin_port]  NVARCHAR (3)    NULL,
    [dest_port]    NVARCHAR (3)    NULL,
    [weight_break] DECIMAL (10, 2) NULL,
    [rate]         DECIMAL (5, 2)  NULL
);

