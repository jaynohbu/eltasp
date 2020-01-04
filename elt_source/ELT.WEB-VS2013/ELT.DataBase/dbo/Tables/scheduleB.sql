CREATE TABLE [dbo].[scheduleB] (
    [auto_uid]           DECIMAL (18)  IDENTITY (1, 1) NOT NULL,
    [elt_account_number] DECIMAL (8)   NOT NULL,
    [sb]                 NVARCHAR (32) NOT NULL,
    [sb_unit1]           NVARCHAR (3)  NULL,
    [sb_unit2]           NVARCHAR (3)  NULL,
    [description]        NVARCHAR (45) NULL,
    [export_code]        NVARCHAR (2)  NULL,
    [license_type]       NVARCHAR (3)  NULL,
    [eccn]               NVARCHAR (5)  NULL
);

