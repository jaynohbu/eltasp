CREATE TABLE [dbo].[reconcile] (
    [recon_id]                       DECIMAL (18) NOT NULL,
    [elt_account_number]             DECIMAL (18) NULL,
    [modified_date]                  DATETIME     NULL,
    [recon_state]                    NVARCHAR (1) NULL,
    [created_date]                   DATETIME     NULL,
    [statement_ending_date]          DATETIME     NULL,
    [opening_balance]                FLOAT (53)   NULL,
    [statement_ending_balance]       FLOAT (53)   NULL,
    [total_cleared]                  FLOAT (53)   NULL,
    [total_uncleared]                FLOAT (53)   NULL,
    [system_balance_asof_statement]  FLOAT (53)   NULL,
    [system_balance_asof_recon_date] FLOAT (53)   NULL,
    [total_unclear_after_statement]  FLOAT (53)   NULL,
    [service_charge_date]            DATETIME     NULL,
    [interested_earned_date]         DATETIME     NULL,
    [service_charge]                 FLOAT (53)   NULL,
    [interest_earned]                FLOAT (53)   NULL,
    [bank_account_number]            DECIMAL (7)  NOT NULL,
    [recon_beginning_date]           DATETIME     NULL,
    [gj_entry_no]                    DECIMAL (18) NULL,
    CONSTRAINT [PK_reconcile] PRIMARY KEY CLUSTERED ([recon_id] ASC)
);

