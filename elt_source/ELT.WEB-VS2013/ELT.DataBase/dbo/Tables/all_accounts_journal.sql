CREATE TABLE [dbo].[all_accounts_journal] (
    [elt_account_number]  DECIMAL (8)     NOT NULL,
    [tran_seq_num]        DECIMAL (8)     NOT NULL,
    [gl_account_number]   DECIMAL (5)     NULL,
    [gl_account_name]     NVARCHAR (128)  NULL,
    [tran_type]           NVARCHAR (16)   NULL,
    [tran_num]            NVARCHAR (16)   NULL,
    [air_ocean]           NVARCHAR (1)    NULL,
    [tran_date]           DATETIME        CONSTRAINT [DF_all_accounts_journal_tran_date] DEFAULT (getdate()) NULL,
    [customer_name]       NVARCHAR (128)  NULL,
    [customer_number]     DECIMAL (9)     CONSTRAINT [DF_all_accounts_journal_customer_number] DEFAULT (0) NULL,
    [memo]                NVARCHAR (256)  NULL,
    [split]               NVARCHAR (128)  NULL,
    [check_no]            DECIMAL (7)     CONSTRAINT [DF_all_accounts_journal_check_no] DEFAULT (0) NULL,
    [debit_amount]        DECIMAL (12, 2) CONSTRAINT [DF_all_accounts_journal_debit_amount] DEFAULT (0) NULL,
    [credit_amount]       DECIMAL (12, 2) CONSTRAINT [DF_all_accounts_journal_credit_amount] DEFAULT (0) NULL,
    [balance]             DECIMAL (12, 2) CONSTRAINT [DF_all_accounts_journal_balance] DEFAULT (0) NULL,
    [previous_balance]    DECIMAL (12, 2) CONSTRAINT [DF_all_accounts_journal_previous_balance] DEFAULT (0) NULL,
    [gl_balance]          DECIMAL (12, 2) CONSTRAINT [DF_all_accounts_journal_gl_balance] DEFAULT (0) NULL,
    [gl_previous_balance] DECIMAL (12, 2) CONSTRAINT [DF_all_accounts_journal_gl_previous_balance] DEFAULT (0) NULL,
    [adjust_amount]       DECIMAL (12, 2) CONSTRAINT [DF__all_accou__adjus__4D7F7902] DEFAULT (0) NULL,
    [ModifiedBy]          NCHAR (10)      NULL,
    [ModifiedDate]        DATETIME        NULL,
    [debit_memo]          DECIMAL (12, 2) CONSTRAINT [DF__all_accou__debit__4E739D3B] DEFAULT (0) NULL,
    [credit_memo]         DECIMAL (12, 2) CONSTRAINT [DF__all_accou__credi__4F67C174] DEFAULT (0) NULL,
    [flag_close]          NCHAR (1)       NULL,
    [print_check_as]      NVARCHAR (128)  NULL,
    [chk_complete]        NCHAR (1)       NULL,
    [chk_void]            NCHAR (1)       NULL,
    [is_org_merged]       NCHAR (1)       NULL,
    [is_recon_cleared]    NCHAR (1)       NULL
);


GO
CREATE NONCLUSTERED INDEX [tran_date]
    ON [dbo].[all_accounts_journal]([elt_account_number] ASC, [gl_account_number] ASC, [tran_date] ASC);


GO
CREATE NONCLUSTERED INDEX [all2]
    ON [dbo].[all_accounts_journal]([elt_account_number] ASC, [gl_account_number] ASC, [customer_number] ASC, [tran_date] ASC);


GO
CREATE NONCLUSTERED INDEX [chk_void]
    ON [dbo].[all_accounts_journal]([elt_account_number] ASC, [tran_type] ASC, [tran_num] ASC, [chk_void] ASC);


GO
CREATE NONCLUSTERED INDEX [chk_complete]
    ON [dbo].[all_accounts_journal]([elt_account_number] ASC, [tran_type] ASC, [tran_num] ASC, [chk_complete] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-all_accounts_journal]
    ON [dbo].[all_accounts_journal]([tran_type] ASC)
    INCLUDE([elt_account_number], [tran_num]);

