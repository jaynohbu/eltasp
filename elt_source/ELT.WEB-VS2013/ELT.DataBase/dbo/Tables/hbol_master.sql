﻿CREATE TABLE [dbo].[hbol_master] (
    [elt_account_number]         DECIMAL (8)     NOT NULL,
    [hbol_num]                   NVARCHAR (32)   NOT NULL,
    [booking_num]                NVARCHAR (32)   NULL,
    [mbol_num]                   NVARCHAR (32)   NULL,
    [agent_name]                 NVARCHAR (128)  NULL,
    [agent_info]                 NTEXT           NULL,
    [agent_no]                   DECIMAL (6)     NULL,
    [forward_agent_name]         NVARCHAR (128)  NULL,
    [forward_agent_info]         NTEXT           NULL,
    [forward_agent_acct_num]     DECIMAL (7)     NULL,
    [Shipper_Name]               NVARCHAR (128)  NULL,
    [Shipper_Info]               NTEXT           NULL,
    [Shipper_acct_num]           DECIMAL (7)     NULL,
    [Consignee_Name]             NVARCHAR (128)  NULL,
    [Consignee_Info]             NTEXT           NULL,
    [Consignee_acct_num]         DECIMAL (7)     NULL,
    [export_ref]                 NTEXT           NULL,
    [origin_country]             NVARCHAR (32)   NULL,
    [dest_country]               NVARCHAR (64)   NULL,
    [export_instr]               NTEXT           NULL,
    [loading_pier]               NVARCHAR (64)   NULL,
    [move_type]                  NVARCHAR (32)   NULL,
    [containerized]              NCHAR (1)       NULL,
    [pre_carriage]               NVARCHAR (64)   NULL,
    [pre_receipt_place]          NVARCHAR (64)   NULL,
    [export_carrier]             NVARCHAR (64)   NULL,
    [vessel_name]                NVARCHAR (64)   NULL,
    [loading_port]               NVARCHAR (64)   NULL,
    [unloading_port]             NVARCHAR (64)   NULL,
    [departure_date]             DATETIME        NULL,
    [delivery_place]             NVARCHAR (64)   NULL,
    [desc1]                      NTEXT           NULL,
    [desc2]                      NTEXT           NULL,
    [desc3]                      NTEXT           NULL,
    [desc4]                      NTEXT           NULL,
    [desc5]                      NTEXT           NULL,
    [manifest_desc]              NVARCHAR (128)  NULL,
    [weight_cp]                  NCHAR (1)       NULL,
    [prepaid_other_charge]       NCHAR (1)       NULL,
    [collect_other_charge]       NCHAR (1)       NULL,
    [pieces]                     INT             NULL,
    [scale]                      NCHAR (1)       NULL,
    [gross_weight]               DECIMAL (12, 2) NULL,
    [measurement]                DECIMAL (12, 2) NULL,
    [width]                      DECIMAL (10, 2) NULL,
    [length]                     DECIMAL (10, 2) NULL,
    [height]                     DECIMAL (10, 2) NULL,
    [dem_detail]                 NTEXT           NULL,
    [charge_rate]                FLOAT (53)      NULL,
    [total_weight_charge]        DECIMAL (12, 2) NULL,
    [Show_Prepaid_Weight_Charge] NCHAR (1)       NULL,
    [Show_Collect_Weight_Charge] NCHAR (1)       NULL,
    [Show_Prepaid_Other_Charge]  NCHAR (1)       NULL,
    [Show_Collect_Other_Charge]  NCHAR (1)       NULL,
    [declared_value]             DECIMAL (12, 2) NULL,
    [tran_by]                    NVARCHAR (64)   NULL,
    [tran_date]                  DATETIME        NULL,
    [tran_place]                 NVARCHAR (32)   NULL,
    [last_modified]              DATETIME        NULL,
    [prepaid_invoiced]           NCHAR (1)       NULL,
    [collect_invoiced]           NCHAR (1)       NULL,
    [ci]                         NVARCHAR (128)  NULL,
    [Notify_Name]                NVARCHAR (128)  NULL,
    [Notify_Info]                NTEXT           NULL,
    [Notify_acct_num]            DECIMAL (7)     NULL,
    [unit_qty]                   NVARCHAR (8)    NULL,
    [SalesPerson]                NVARCHAR (64)   NULL,
    [CreatedBy]                  NVARCHAR (64)   NULL,
    [CreatedDate]                DATETIME        NULL,
    [ModifiedBy]                 NVARCHAR (64)   NULL,
    [ModifiedDate]               DATETIME        NULL,
    [total_other_charge]         DECIMAL (12)    NULL,
    [total_other_cost]           DECIMAL (18, 2) NULL,
    [lc]                         NVARCHAR (64)   NULL,
    [aes_xtn]                    NVARCHAR (64)   NULL,
    [colo]                       NCHAR (1)       NULL,
    [coloder_elt_acct]           DECIMAL (8)     NULL,
    [colo_pay]                   NCHAR (1)       NULL,
    [coloder_invoiced]           NCHAR (1)       NULL,
    [is_sub]                     NCHAR (1)       NULL,
    [is_master]                  NCHAR (1)       NULL,
    [sub_to_no]                  NVARCHAR (32)   NULL,
    [sub_no]                     INT             NULL,
    [is_master_closed]           NCHAR (1)       NULL,
    [is_invoice_queued]          NCHAR (1)       NULL,
    [is_org_merged]              NCHAR (1)       NULL,
    [master_weight_charge]       DECIMAL (12, 2) NULL,
    [master_pieces]              DECIMAL (4)     NULL,
    [master_gross_weight]        DECIMAL (12, 2) NULL,
    [master_chargeable_weight]   DECIMAL (12, 2) NULL,
    [dimtext]                    NTEXT           NULL,
    [sub_count]                  NCHAR (1)       NULL,
    [of_cost]                    DECIMAL (12, 2) NULL,
    [agent_profit]               DECIMAL (12, 2) NULL,
    [agent_profit_share]         DECIMAL (3, 2)  NULL,
    [other_agent_profit_carrier] DECIMAL (12, 2) NULL,
    [other_agent_profit_agent]   DECIMAL (12, 2) NULL,
    [sed_stmt]                   NVARCHAR (128)  NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PK_hbol_master]
    ON [dbo].[hbol_master]([elt_account_number] ASC, [hbol_num] ASC, [booking_num] ASC);

