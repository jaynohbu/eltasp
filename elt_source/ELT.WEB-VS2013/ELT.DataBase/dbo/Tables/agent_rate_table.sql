CREATE TABLE [dbo].[agent_rate_table] (
    [elt_account_number] DECIMAL (8)     NULL,
    [agent_no]           DECIMAL (7)     NULL,
    [agent_name]         NVARCHAR (128)  NULL,
    [item_no]            INT             NULL,
    [airline]            NVARCHAR (3)    NULL,
    [origin_port]        NVARCHAR (3)    NULL,
    [dest_port]          NVARCHAR (3)    NULL,
    [weight_break]       DECIMAL (10, 2) NULL,
    [rate]               DECIMAL (5, 2)  NULL,
    [share]              DECIMAL (5, 2)  NULL,
    [is_org_merged]      NCHAR (1)       NULL
);

