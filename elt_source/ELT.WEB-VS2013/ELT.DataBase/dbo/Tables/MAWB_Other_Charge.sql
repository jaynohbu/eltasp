CREATE TABLE [dbo].[MAWB_Other_Charge] (
    [elt_account_number] DECIMAL (8)     NOT NULL,
    [MAWB_NUM]           NVARCHAR (128)  NOT NULL,
    [Tran_No]            INT             NOT NULL,
    [Coll_Prepaid]       NCHAR (1)       NULL,
    [Carrier_Agent]      NCHAR (1)       NULL,
    [charge_code]        NVARCHAR (8)    NULL,
    [Charge_Desc]        NVARCHAR (128)  NULL,
    [Amt_MAWB]           DECIMAL (12, 2) NULL,
    [Amt_Acct]           DECIMAL (12, 2) NULL,
    [vendor_num]         DECIMAL (18)    NULL,
    [cost_code]          INT             NULL,
    [cost_desc]          NVARCHAR (128)  NULL,
    [Cost_Amt]           DECIMAL (12, 2) NULL,
    [is_org_merged]      NCHAR (1)       NULL
);

