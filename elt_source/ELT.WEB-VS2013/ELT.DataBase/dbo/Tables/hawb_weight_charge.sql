﻿CREATE TABLE [dbo].[hawb_weight_charge] (
    [elt_account_number] DECIMAL (8)     NOT NULL,
    [HAWB_NUM]           NVARCHAR (32)   NOT NULL,
    [Tran_No]            INT             NOT NULL,
    [No_Pieces]          INT             NULL,
    [unit_qty]           NVARCHAR (8)    NULL,
    [Gross_Weight]       DECIMAL (10, 2) NULL,
    [Adjusted_Weight]    DECIMAL (10, 2) NULL,
    [Kg_Lb]              NCHAR (1)       NULL,
    [Service_Code]       NCHAR (4)       NULL,
    [Rate_Class]         NVARCHAR (1)    NULL,
    [Commodity_Item_No]  NVARCHAR (16)   NULL,
    [length]             DECIMAL (9, 2)  NULL,
    [width]              DECIMAL (9, 2)  NULL,
    [height]             DECIMAL (9, 2)  NULL,
    [cubic_inches]       DECIMAL (18)    NULL,
    [dimension_factor]   DECIMAL (18)    NULL,
    [Dimension]          DECIMAL (12, 2) NULL,
    [Dem_Detail]         NVARCHAR (1024) NULL,
    [Chargeable_Weight]  DECIMAL (12, 2) NULL,
    [Rate_Charge]        DECIMAL (10, 2) NULL,
    [Total_Charge]       DECIMAL (12, 2) NULL,
    [Desc1]              NVARCHAR (256)  NULL,
    [Desc2]              NVARCHAR (256)  NULL,
    [is_master]          NCHAR (1)       NULL,
    [invoice_only]       NVARCHAR (1)    CONSTRAINT [DF__hawb_weig__invoi__66D536B1] DEFAULT ('N') NULL
);
