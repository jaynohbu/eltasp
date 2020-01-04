CREATE TABLE [dbo].[user_right] (
    [object_name] NVARCHAR (256) NULL,
    [user_right]  INT            CONSTRAINT [DF_user_right_user_right] DEFAULT (0) NULL,
    [view_right]  INT            NULL
);

