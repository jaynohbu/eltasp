USE [PRDDB]
GO

/****** Object:  StoredProcedure [COMM].[AccessCommunicationToken]    Script Date: 05/02/2014 09:08:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--TEST 
----
--DECLARE @startdate datetime2 = '2007-05-05 12:10:09.3312722';
--DECLARE @enddate datetime2 = '2007-05-06 12:10:09.3312722'; 
--SELECT DATEDIFF(MINUTE, @startdate, @enddate);

CREATE PROCEDURE [COMM].[AccessCommunicationToken]
            @Command varchar(200)
		   ,@Token varchar(500) out 
           ,@TokenType tinyint out
           ,@TimeStart datetime =null out
           ,@TimeEnd   datetime =null out
           ,@Period    int  out
           ,@Expired   bit =0 out
           ,@RecipientEmail varchar(100) out
           ,@CreatedDate datetime out
AS
BEGIN
    If (@Command='Create')
       BEGIN 
		INSERT INTO [PRDDB].[COMM].[CommunicationToken]
			   ([Token]
			   ,[TokenType]
			   ,[TimeStart]
			   ,[TimeEnd]
			   ,[Period]
			   ,[Expired]
			   ,[RecipientEmail]
			   ,[CreatedDate])
		 VALUES
			   (
				NewID()
			   ,@TokenType
			   ,GetDate()
			   ,@TimeEnd
			   ,@Period
			   ,@Expired
			   ,@RecipientEmail
			   ,GetDate())
		SELECT @Token =  Token FROM [PRDDB].[COMM].[CommunicationToken] WHERE ID =@@IDENTITY 
	   END 

       If (@Command='CreateNoStart')
       BEGIN
       INSERT INTO [PRDDB].[COMM].[CommunicationToken]
			   ([Token]
			   ,[TokenType]
			   ,[TimeStart]
			   ,[TimeEnd]
			   ,[Period]
			   ,[Expired]
			   ,[RecipientEmail]
			   ,[CreatedDate])
		 VALUES
			   (
				NewID()
			   ,@TokenType
			   ,null
			   ,@TimeEnd
			   ,@Period
			   ,@Expired
			   ,@RecipientEmail
			   ,GetDate())
	    SELECT @Token =  Token FROM [PRDDB].[COMM].[CommunicationToken] WHERE ID =@@IDENTITY 
	   END    
	   If (@Command = 'Start')
	   BEGIN
			UPDATE [PRDDB].[COMM].[CommunicationToken]
			SET 			
			[TimeStart] = GetDate()			
			WHERE [Token] =@Token
        END 
        
       If (@Command = 'Expire')
	   BEGIN
			UPDATE [PRDDB].[COMM].[CommunicationToken]
			SET 			 
			 [TimeEnd] =  GetDate()			
			,[Expired] = 1			
			WHERE [Token] =@Token
        END 
       If (@Command = 'Extend')
	   BEGIN
			UPDATE [PRDDB].[COMM].[CommunicationToken]
			SET 
			 [Token] = @Token
			,[TokenType] = @TokenType
			,[TimeStart] = GetDate()
			,[TimeEnd] = null			
			,[Expired] = 0			
			WHERE [Token] =@Token
        END 
        
       If (@Command = 'GET')
	   BEGIN
	       SELECT @TimeStart=TimeStart, @TimeEnd=TimeEnd, @Period=Period FROM [PRDDB].[COMM].[CommunicationToken] WHERE Token=@Token
	       IF @TimeEnd IS NULL 
	       BEGIN 
			   IF (DATEDIFF ( minute , @TimeStart , Getdate() ) > @Period)
			   BEGIN 
					UPDATE [PRDDB].[COMM].[CommunicationToken]
					SET 
					 [TimeEnd] = GetDate()			
					,[Expired] = 1		
					WHERE [Token] =@Token
			   END 
	       END		       		
        END 
  
   SELECT
   @TimeStart=TimeStart, 
   @TimeEnd=TimeEnd, 
   @Period =Period,
   @Expired=Expired,
   @RecipientEmail=RecipientEmail,
   @CreatedDate=CreatedDate,
   @Token =Token 
   FROM [PRDDB].[COMM].[CommunicationToken] WHERE Token=@Token
    

END

GO

