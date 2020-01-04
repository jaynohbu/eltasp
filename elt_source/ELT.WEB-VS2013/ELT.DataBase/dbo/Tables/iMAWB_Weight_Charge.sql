CREATE TABLE [dbo].[iMAWB_Weight_Charge] (
    [elt_account_number] DECIMAL (8)     NOT NULL,
    [MAWB_NUM]           NVARCHAR (32)   NOT NULL,
    [Tran_No]            INT             NOT NULL,
    [No_Pieces]          INT             NULL,
    [Gross_Weight]       DECIMAL (10, 2) NULL,
    [Kg_Lb]              NCHAR (1)       NULL,
    [Service_Code]       NCHAR (4)       NULL,
    [Rate_Class]         NCHAR (1)       NULL,
    [Commodity_Item_No]  NVARCHAR (16)   NULL,
    [Dem_Detail]         NVARCHAR (1024) NULL,
    [Chargeable_Weight]  DECIMAL (12, 2) NULL,
    [Rate_Charge]        DECIMAL (10, 2) NULL,
    [Total_Charge]       DECIMAL (12, 2) NULL,
    [Desc1]              NVARCHAR (256)  NULL,
    [Desc2]              NVARCHAR (256)  NULL
);

