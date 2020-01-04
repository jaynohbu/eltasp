/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW dbo.vw_ocean_master
AS
SELECT     a.elt_account_number, a.booking_num, a.mbol_num, a.agent_name, a.agent_info, a.agent_acct_num, a.Shipper_Name, a.Shipper_Info, a.Shipper_acct_num, 
                      a.Consignee_Name, a.Consignee_Info, a.Consignee_acct_num, a.export_ref, a.origin_country, a.export_instr, a.loading_pier, a.move_type, a.containerized, 
                      a.pre_carriage, a.pre_receipt_place, a.export_carrier, a.loading_port, a.unloading_port, a.departure_date, a.delivery_place, a.desc1, a.desc2, a.desc3, a.desc4, 
                      a.desc5, a.pieces, a.gross_weight, a.measurement, a.tran_date, a.last_modified, a.Notify_Name, a.Notify_Info, a.Notify_acct_num, a.dest_country, a.vessel_name, 
                      a.manifest_desc, a.weight_cp, a.prepaid_other_charge, a.collect_other_charge, a.scale, a.width, a.length, a.height, a.dem_detail, a.charge_rate, a.total_weight_charge,
                       a.declared_value, a.tran_by, a.tran_place, a.prepaid_invoiced, a.collect_invoiced, a.ci, a.unit_qty, a.SalesPerson, a.CreatedBy, a.CreatedDate, a.ModifiedBy, 
                      a.ModifiedDate, a.total_other_charge, a.total_other_cost, a.is_org_merged, a.dimtext, a.of_cost, a.agent_profit, a.agent_profit_share, a.other_agent_profit_carrier, 
                      a.other_agent_profit_agent, a.Total_Freight_Cost, a.aes_xtn, a.sed_stmt, b.departure_date AS Expr4, b.arrival_date, b.receipt_place, b.origin_port_id, 
                      b.origin_port_aes_code, b.origin_port_location, b.origin_port_state, b.origin_port_country, b.dest_port_id, b.dest_port_aes_code, b.dest_port_location, 
                      b.dest_port_country, b.dest_country_code, b.carrier_desc, b.carrier_code, b.scac, b.consolidator_name, b.consolidator_code, b.voyage_no, b.vsl_name, b.cutoff_time, 
                      b.cutoff, b.fcl_lcl, b.container_type, b.file_no, b.status, b.booking_date
FROM         dbo.mbol_master AS a INNER JOIN
                      dbo.ocean_booking_number AS b ON a.booking_num = b.booking_num
WHERE     (a.elt_account_number = 20005000)
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_ocean_master';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[34] 4[27] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 27
         End
         Begin Table = "b"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 114
               Right = 469
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_ocean_master';

