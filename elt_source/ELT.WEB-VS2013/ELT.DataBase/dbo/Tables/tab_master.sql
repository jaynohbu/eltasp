CREATE TABLE [dbo].[tab_master] (
    [elt_account_number] DECIMAL (18)   NULL,
    [user_id]            DECIMAL (18)   NULL,
    [page_label]         NVARCHAR (64)  NULL,
    [page_url]           NVARCHAR (256) NULL,
    [top_module]         NVARCHAR (64)  NULL,
    [sub_module]         NVARCHAR (64)  NULL,
    [page_status]        NVARCHAR (1)   CONSTRAINT [DF_tab_master_page_status] DEFAULT ('N') NULL,
    [access_level]       NVARCHAR (16)  CONSTRAINT [DF_tab_master_access_level] DEFAULT ('ALL') NULL,
    [page_seq_id]        DECIMAL (18)   NULL,
    [sub_seq_id]         DECIMAL (18)   NULL,
    [top_seq_id]         DECIMAL (18)   NULL,
    [page_id]            DECIMAL (18)   IDENTITY (1, 1) NOT NULL,
    [is_obsolete]        BIT            NULL,
    [master_url]         NVARCHAR (256) NULL
);

