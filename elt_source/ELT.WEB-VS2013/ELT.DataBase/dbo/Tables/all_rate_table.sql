CREATE TABLE [dbo].[all_rate_table] (
    [elt_account_number] DECIMAL (8)    NULL,
    [item_no]            DECIMAL (5)    NULL,
    [rate_type]          INT            NULL,
    [agent_no]           INT            NULL,
    [customer_no]        INT            NULL,
    [airline]            NVARCHAR (8)   NULL,
    [origin_port]        NVARCHAR (8)   NULL,
    [dest_port]          NVARCHAR (8)   NULL,
    [weight_break]       DECIMAL (8)    NULL,
    [rate]               DECIMAL (8, 2) NULL,
    [kg_lb]              NCHAR (1)      NULL,
    [share]              DECIMAL (8, 2) NULL,
    [is_org_merged]      NCHAR (1)      NULL,
    [fl_rate]            DECIMAL (8, 2) NULL,
    [sec_rate]           DECIMAL (8, 2) NULL,
    [include_fl_rate]    NVARCHAR (1)   NULL,
    [include_sec_rate]   NVARCHAR (1)   NULL,
    [id]                 INT            IDENTITY (1, 1) NOT NULL,
    [rate_table_id]      DECIMAL (18)   CONSTRAINT [DF_all_rate_table_rate_table_id] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [FK_all_rate_table_rate_table] FOREIGN KEY ([rate_table_id]) REFERENCES [dbo].[rate_table] ([id])
);



GO


GO


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-all_rate_table]
    ON [dbo].[all_rate_table]([rate_type] ASC, [airline] ASC);

