CREATE TABLE [dbo].[UserSession] (
    [session_id]         NVARCHAR (50)  NULL,
    [elt_account_number] DECIMAL (8)    NULL,
    [ip]                 NVARCHAR (50)  NULL,
    [login_time]         DATETIME       NULL,
    [Requested_page]     NVARCHAR (100) NULL,
    [alive]              BIT            NULL,
    [login_name]         NVARCHAR (50)  NULL,
    [last_updated]       DATETIME       NULL,
    [kick_out_reason]    NVARCHAR (500) NULL
);

