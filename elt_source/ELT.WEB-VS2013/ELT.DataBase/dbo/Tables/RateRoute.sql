CREATE TABLE [dbo].[RateRoute] (
    [ID]                          INT            IDENTITY (1, 1) NOT NULL,
    [Origin]                      NVARCHAR (50)  NOT NULL,
    [Dest]                        NVARCHAR (50)  NOT NULL,
    [Unit]                        NVARCHAR (50)  NOT NULL,
    [UnitText]                    NVARCHAR (50)  NOT NULL,
    [CustomerOrgName]             NVARCHAR (500) NULL,
    [customer_org_account_number] INT            NULL,
    [AgentOrgName]                NVARCHAR (500) NULL,
    [agent_org_account_number]    INT            NULL,
    [elt_account_number]          INT            NOT NULL,
    [RateType]                    INT            NOT NULL,
    [Share]                       NVARCHAR (50)  NULL,
    CONSTRAINT [PK_RateRoute] PRIMARY KEY CLUSTERED ([ID] ASC)
);

