CREATE TABLE [dbo].[ig_schedule_b_old] (
    [elt_account_number] DECIMAL (8)   NOT NULL,
    [org_account_number] DECIMAL (7)   NOT NULL,
    [sb]                 NVARCHAR (32) NOT NULL,
    [sb_unit1]           NVARCHAR (3)  NULL,
    [sb_unit2]           NVARCHAR (3)  NULL,
    [description]        NVARCHAR (45) NULL,
    [is_org_merged]      NCHAR (1)     NULL,
    [export_code]        NVARCHAR (2)  NULL,
    [license_type]       NVARCHAR (3)  NULL,
    [eccn]               NVARCHAR (5)  NULL,
    [sb_id]              DECIMAL (18)  NULL
);

