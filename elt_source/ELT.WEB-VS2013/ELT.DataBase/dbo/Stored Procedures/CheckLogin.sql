
CREATE PROCEDURE CheckLogin
	@elt_account_number int,
	@login_name varchar(100),
	@password varchar(100)
AS
BEGIN
	SELECT count(*)      
	FROM [PRDDB].[dbo].[users] WHERE  [elt_account_number] =@elt_account_number
	AND 
	[login_name] = @login_name
	AND [password] =@password
END
