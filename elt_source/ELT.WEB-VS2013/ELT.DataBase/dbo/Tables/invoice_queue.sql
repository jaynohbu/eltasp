CREATE TABLE [dbo].[invoice_queue] (
    [elt_account_number] DECIMAL (8)     CONSTRAINT [DF_invoice_queue_elt_account_number] DEFAULT (0) NOT NULL,
    [queue_id]           DECIMAL (8)     CONSTRAINT [DF_invoice_queue_queue_id] DEFAULT (0) NOT NULL,
    [inqueue_date]       DATETIME        NOT NULL,
    [outqueue_date]      DATETIME        NULL,
    [agent_shipper]      NCHAR (1)       NULL,
    [hawb_num]           NVARCHAR (128)  NULL,
    [mawb_num]           NVARCHAR (128)  NULL,
    [bill_to]            NVARCHAR (1024) NULL,
    [bill_to_org_acct]   DECIMAL (8)     CONSTRAINT [DF_invoice_queue_bill_to_org_acct] DEFAULT (0) NULL,
    [agent_name]         NVARCHAR (1024) NULL,
    [agent_org_acct]     DECIMAL (8)     CONSTRAINT [DF_invoice_queue_agent_org_acct] DEFAULT (0) NULL,
    [master_agent]       NCHAR (1)       NULL,
    [air_ocean]          NCHAR (1)       NULL,
    [master_only]        NCHAR (1)       CONSTRAINT [DF_invoice_queue_master_only] DEFAULT ('N') NULL,
    [invoiced]           NCHAR (1)       NULL,
    [is_dome]            NVARCHAR (1)    CONSTRAINT [DF__invoice_q__is_do__475C8B58] DEFAULT ('N') NULL,
    CONSTRAINT [PK_invoice_queue] PRIMARY KEY CLUSTERED ([elt_account_number] ASC, [queue_id] ASC)
);

