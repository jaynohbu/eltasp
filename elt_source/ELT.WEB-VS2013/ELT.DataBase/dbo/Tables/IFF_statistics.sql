CREATE TABLE [dbo].[IFF_statistics] (
    [s_date]       DATETIME       NULL,
    [s_week]       NVARCHAR (250) COLLATE Korean_Wansung_Unicode_CI_AI_KS_WS NULL,
    [s_user_agent] NVARCHAR (250) COLLATE Korean_Wansung_Unicode_CI_AI_KS_WS NULL,
    [s_referer]    NVARCHAR (250) COLLATE Korean_Wansung_Unicode_CI_AI_KS_WS NULL,
    [ip]           NVARCHAR (50)  NULL
);

