﻿CREATE TABLE [dbo].[view_login] (
    [session_id]              NVARCHAR (50)  NULL,
    [elt_account_number]      DECIMAL (8)    NULL,
    [user_id]                 NVARCHAR (50)  NULL,
    [user_name]               NVARCHAR (50)  NULL,
    [ip]                      NVARCHAR (50)  NULL,
    [server_name]             NVARCHAR (50)  NULL,
    [login_time]              NVARCHAR (50)  NULL,
    [u_time]                  NVARCHAR (50)  NULL,
    [logout]                  INT            NULL,
    [Requested_page]          NVARCHAR (100) NULL,
    [alive]                   INT            NULL,
    [user_type]               INT            NULL,
    [user_right]              INT            NULL,
    [login_name]              NVARCHAR (16)  NULL,
    [password]                NVARCHAR (16)  NULL,
    [org_acct]                DECIMAL (8)    CONSTRAINT [DF_view_login_org_acct] DEFAULT (0) NULL,
    [user_lname]              NVARCHAR (32)  NULL,
    [user_fname]              NVARCHAR (32)  NULL,
    [user_title]              NVARCHAR (32)  NULL,
    [user_address]            NVARCHAR (64)  NULL,
    [user_city]               NVARCHAR (32)  NULL,
    [user_state]              NVARCHAR (128) NULL,
    [user_zip]                NVARCHAR (32)  NULL,
    [user_country]            NVARCHAR (32)  NULL,
    [user_phone]              NVARCHAR (32)  NULL,
    [user_email]              NVARCHAR (64)  NULL,
    [create_date]             DATETIME       NULL,
    [pw_change_date]          DATETIME       NULL,
    [last_modified]           DATETIME       NULL,
    [last_login_date]         DATETIME       NULL,
    [default_warehouse]       INT            CONSTRAINT [DF_view_login_default_warehouse] DEFAULT (0) NULL,
    [awb_port]                NVARCHAR (32)  CONSTRAINT [DF_view_login_awb_port] DEFAULT ('LPT1') NULL,
    [bol_port]                NVARCHAR (32)  CONSTRAINT [DF_view_login_bol_port] DEFAULT ('LPT1') NULL,
    [sed_port]                NVARCHAR (32)  CONSTRAINT [DF_view_login_sed_port] DEFAULT ('LPT1') NULL,
    [invoice_port]            NVARCHAR (32)  CONSTRAINT [DF_view_login_invoice_port] DEFAULT ('LPT1') NULL,
    [check_port]              NVARCHAR (32)  CONSTRAINT [DF_view_login_check_port] DEFAULT ('LPT1') NULL,
    [shipping_label_port]     NVARCHAR (32)  CONSTRAINT [DF_view_login_shipping_label_port] DEFAULT ('LPT1') NULL,
    [awb_queue]               NVARCHAR (128) NULL,
    [bol_queue]               NVARCHAR (128) NULL,
    [sed_queue]               NVARCHAR (128) NULL,
    [invoice_queue]           NVARCHAR (128) NULL,
    [check_queue]             NVARCHAR (128) NULL,
    [shipping_label_queue]    NVARCHAR (128) NULL,
    [ig_user_ssn]             NCHAR (9)      NULL,
    [ig_user_dob]             NCHAR (10)     NULL,
    [ig_user_cell]            NVARCHAR (16)  NULL,
    [ig_recent_work]          INT            NULL,
    [intIP]                   NVARCHAR (64)  NULL,
    [awb_prn_name]            NVARCHAR (64)  NULL,
    [bol_prn_name]            NVARCHAR (64)  NULL,
    [sed_prn_name]            NVARCHAR (64)  NULL,
    [invoice_prn_name]        NVARCHAR (64)  NULL,
    [check_prn_name]          NVARCHAR (64)  NULL,
    [shipping_label_prn_name] NVARCHAR (64)  NULL,
    [kick_out_reason]         NVARCHAR (500) NULL
);

