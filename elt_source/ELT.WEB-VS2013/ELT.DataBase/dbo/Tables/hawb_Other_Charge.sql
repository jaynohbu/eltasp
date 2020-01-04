CREATE TABLE [dbo].[hawb_Other_Charge] (
    [elt_account_number] DECIMAL (8)     NOT NULL,
    [HAWB_NUM]           NVARCHAR (128)  NOT NULL,
    [Tran_No]            INT             NOT NULL,
    [Coll_Prepaid]       NCHAR (1)       NULL,
    [Carrier_Agent]      NCHAR (1)       NULL,
    [charge_code]        INT             NULL,
    [Charge_Desc]        NVARCHAR (128)  NULL,
    [Amt_HAWB]           DECIMAL (12, 2) NULL,
    [Amt_Acct]           DECIMAL (12, 2) NULL,
    [vendor_num]         DECIMAL (18)    NULL,
    [cost_code]          INT             NULL,
    [cost_desc]          NVARCHAR (128)  NULL,
    [cost_amt]           DECIMAL (12, 2) NULL,
    [invoice_only]       NVARCHAR (1)    CONSTRAINT [DF__hawb_othe__invoi__5F3414E9] DEFAULT ('N') NULL
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-hawb_Other_Charge]
    ON [dbo].[hawb_Other_Charge]([elt_account_number] ASC, [HAWB_NUM] ASC)
    INCLUDE([Coll_Prepaid], [charge_code], [Charge_Desc], [Amt_HAWB]);

