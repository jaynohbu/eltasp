CREATE TABLE [dbo].[warehouse_history] (
    [auto_uid]           DECIMAL (18)  IDENTITY (1, 1) NOT NULL,
    [wr_num]             NVARCHAR (64) NULL,
    [so_num]             NVARCHAR (64) NULL,
    [elt_account_number] DECIMAL (18)  NULL,
    [history_type]       NVARCHAR (32) NULL,
    [history_date]       DATETIME      CONSTRAINT [DF_warehouse_history_history_date] DEFAULT (getdate()) NULL,
    [item_piece_remain]  DECIMAL (18)  CONSTRAINT [DF__warehouse__item___66EA454A] DEFAULT (0) NULL,
    [item_piece_origin]  DECIMAL (18)  CONSTRAINT [DF__warehouse__item___67DE6983] DEFAULT (0) NULL,
    [item_piece_shipout] DECIMAL (18)  CONSTRAINT [DF__warehouse__item___68D28DBC] DEFAULT (0) NULL
);

