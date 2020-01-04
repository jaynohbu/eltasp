CREATE TABLE [dbo].[check_queue] (
    [elt_account_number] DECIMAL (8)     NOT NULL,
    [print_id]           DECIMAL (9)     NOT NULL,
    [check_no]           DECIMAL (15)    NULL,
    [check_type]         NVARCHAR (8)    CONSTRAINT [DF_check_queue_check_type] DEFAULT ('BP') NULL,
    [check_amt]          DECIMAL (12, 2) NULL,
    [vendor_number]      DECIMAL (7)     NULL,
    [vendor_name]        NVARCHAR (256)  NULL,
    [vendor_info]        NVARCHAR (256)  NULL,
    [bank]               DECIMAL (7)     NULL,
    [ap]                 DECIMAL (7)     CONSTRAINT [DF_check_queue_ap] DEFAULT (0) NULL,
    [print_status]       NCHAR (1)       NULL,
    [bill_date]          DATETIME        NULL,
    [bill_due_date]      DATETIME        CONSTRAINT [check_queue_bill_due_date] DEFAULT (getdate()) NULL,
    [print_date]         DATETIME        NULL,
    [memo]               NVARCHAR (512)  NULL,
    [pmt_method]         NVARCHAR (32)   NULL,
    [print_check_as]     NVARCHAR (128)  NULL,
    [is_org_merged]      NCHAR (1)       NULL,
    [chk_complete]       NCHAR (1)       NULL,
    [chk_void]           NCHAR (1)       NULL
);

