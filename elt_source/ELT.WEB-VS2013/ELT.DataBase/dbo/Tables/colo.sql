CREATE TABLE [dbo].[colo] (
    [colodee_elt_acct] DECIMAL (8)    NULL,
    [colodee_name]     NVARCHAR (128) NULL,
    [coloder_elt_acct] DECIMAL (8)    NULL,
    [coloder_name]     NVARCHAR (128) NULL,
    [colodee_org_num]  DECIMAL (5)    NULL,
    [tran_date]        DATETIME       NULL,
    [is_org_merged]    NCHAR (1)      NULL,
    [coloder_org_num]  DECIMAL (5)    NULL
);

