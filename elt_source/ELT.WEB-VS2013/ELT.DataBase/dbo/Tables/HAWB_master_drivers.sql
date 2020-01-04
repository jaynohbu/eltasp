CREATE TABLE [dbo].[HAWB_master_drivers] (
    [auto_uid]           DECIMAL (18)   IDENTITY (1, 1) NOT NULL,
    [hawb_num]           NVARCHAR (64)  NULL,
    [mawb_num]           NVARCHAR (64)  NULL,
    [elt_account_number] DECIMAL (18)   NULL,
    [driver_acct]        DECIMAL (18)   NULL,
    [piece]              DECIMAL (18)   NULL,
    [weight]             DECIMAL (9, 2) NULL,
    [cost_item_no]       DECIMAL (18)   NULL,
    [cost_amount]        DECIMAL (9, 2) NULL,
    [cost_percent]       DECIMAL (9, 2) NULL,
    [remark]             NTEXT          NULL,
    [item_id]            DECIMAL (18)   NULL,
    [driver_paid]        DECIMAL (9, 2) NULL
);

