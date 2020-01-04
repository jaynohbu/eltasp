CREATE TABLE [dbo].[user_profile] (
    [elt_account_number]           DECIMAL (8)   CONSTRAINT [DF_user_profile_elt_account_number] DEFAULT (0) NULL,
    [branch]                       INT           CONSTRAINT [DF_user_profile_branch] DEFAULT (0) NULL,
    [invoice_prefix]               NVARCHAR (16) NULL,
    [next_invoice_no]              DECIMAL (9)   CONSTRAINT [DF_user_profile_next_invoice_no] DEFAULT (1) NULL,
    [default_invoice_date]         NVARCHAR (16) NULL,
    [next_check_no]                DECIMAL (9)   CONSTRAINT [DF_user_profile_next_check_no] DEFAULT (1) NULL,
    [uom]                          NVARCHAR (8)  NULL,
    [currency]                     NVARCHAR (4)  NULL,
    [default_cgs]                  DECIMAL (5)   NULL,
    [invoiceAttn]                  NVARCHAR (50) NULL,
    [default_asset]                DECIMAL (5)   NULL,
    [fiscalEndMonth]               NCHAR (2)     NULL,
    [default_air_charge_item]      DECIMAL (5)   NULL,
    [default_ocean_charge_item]    DECIMAL (5)   NULL,
    [default_air_cost_item]        DECIMAL (5)   NULL,
    [default_ocean_cost_item]      DECIMAL (5)   NULL,
    [default_domestic_charge_item] DECIMAL (5)   NULL,
    [uom_qty]                      NVARCHAR (16) NULL,
    [international_pdf]            NVARCHAR (1)  CONSTRAINT [DF__user_prof__inter__5B837F96] DEFAULT ('N') NULL,
    [default_invoice_term]         DECIMAL (18)  NULL,
    [sed_statement]                NTEXT         NULL
);

