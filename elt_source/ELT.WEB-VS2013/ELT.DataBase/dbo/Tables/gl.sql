CREATE TABLE [dbo].[gl] (
    [elt_account_number] DECIMAL (8)     NOT NULL,
    [gl_account_number]  DECIMAL (7)     NOT NULL,
    [gl_account_desc]    NVARCHAR (128)  NULL,
    [gl_master_type]     NVARCHAR (32)   NULL,
    [gl_account_type]    NVARCHAR (32)   NULL,
    [gl_account_balance] DECIMAL (12, 2) NULL,
    [gl_begin_balance]   DECIMAL (12, 2) CONSTRAINT [DF_gl_gl_begin_balance] DEFAULT (0) NULL,
    [gl_account_status]  NCHAR (1)       NULL,
    [gl_account_cdate]   DATETIME        NULL,
    [gl_last_modified]   DATETIME        NULL,
    [control_no]         DECIMAL (18)    NULL,
    [gl_default]         NCHAR (1)       NULL,
    [gl_vendor_no]       DECIMAL (18)    NULL,
    CONSTRAINT [PK_gl] PRIMARY KEY CLUSTERED ([elt_account_number] ASC, [gl_account_number] ASC)
);

