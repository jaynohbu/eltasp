CREATE TABLE [dbo].[agent_view_object] (
    [elt_account_number] DECIMAL (8)   NULL,
    [agent_no]           DECIMAL (5)   NULL,
    [object_id]          NVARCHAR (64) NULL,
    [dt]                 DATETIME      NULL,
    [is_org_merged]      NCHAR (1)     NULL
);

