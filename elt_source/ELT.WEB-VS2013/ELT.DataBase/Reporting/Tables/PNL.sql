CREATE TABLE [Reporting].[PNL] (
    [ID]                 DECIMAL (18)   IDENTITY (1, 1) NOT NULL,
    [Type]               VARCHAR (10)   NULL,
    [ImportExport]       CHAR (1)       NULL,
    [AirOcean]           CHAR (1)       NULL,
    [Master_House]       CHAR (1)       NULL,
    [elt_account_number] DECIMAL (18)   NULL,
    [MBL_NUM]            NVARCHAR (50)  NULL,
    [HBL_NUM]            NVARCHAR (50)  NULL,
    [Item_Code]          NVARCHAR (50)  NULL,
    [Description]        NVARCHAR (500) NULL,
    [Customer_ID]        DECIMAL (18)   NULL,
    [Amount]             FLOAT (53)     NULL,
    [ORIGIN]             NVARCHAR (10)  NULL,
    [DEST]               NVARCHAR (10)  NULL,
    [Customer_Name]      NVARCHAR (500) NULL,
    [Date]               DATETIME       NULL
);

