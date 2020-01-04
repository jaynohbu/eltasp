CREATE TABLE [dbo].[ihawb_Other_Charge] (
    [elt_account_number] DECIMAL (8)     NOT NULL,
    [HAWB_NUM]           NVARCHAR (32)   NOT NULL,
    [Tran_No]            INT             NOT NULL,
    [Coll_Prepaid]       NCHAR (1)       NULL,
    [Carrier_Agent]      NCHAR (1)       NULL,
    [charge_code]        INT             NULL,
    [Charge_Desc]        NVARCHAR (32)   NULL,
    [Amt_HAWB]           DECIMAL (12, 2) NULL,
    [Amt_Acct]           DECIMAL (12, 2) NULL,
    [Vendor_Num]         NVARCHAR (16)   NULL,
    [Cost_Amt]           DECIMAL (12, 2) NULL
);

