
CREATE PROCEDURE [dbo].[GetAESLineItems]
	@AESID decimal=0,
	@HAWB varchar(50)='',
	@MAWB varchar(50)='',
	@elt_account_number decimal,
	@file_type varchar(10) =''
AS
BEGIN	
	SET NOCOUNT ON;
       --New AES
	IF @file_type='AE'
		BEGIN
			IF @AESID = 0
			BEGIN       
				if @HAWB <> '' AND @MAWB <> '' 
					Begin
						SELECT 0 as id , 'D' AS dfm,commodity_item_no AS b_number,commodity_item_no AS b_number_copy,'' as item_desc,
							 No_pieces AS b_qty1,'' AS unit1,0 AS b_qty2,'' AS unit2,
							 (CASE WHEN (Kg_Lb='L' OR Kg_Lb='LB') THEN CAST(gross_weight/2.20462262 AS INT)  ELSE gross_weight END) AS gross_weight
							 ,0 AS item_value,'' AS export_code,'' AS license_type,'' AS license_number,'' AS eccn,'' AS vin_type,'' AS vin,'' AS vc_title,'' AS vc_state 
							 FROM hawb_weight_charge 
							 WHERE elt_account_number=  @elt_account_number   AND hawb_num=@HAWB  
					End
				ELSE             
					if (@HAWB='' AND @MAWB <> '' )
						Begin
							SELECT 0 AS ID ,  'D' AS dfm,commodity_item_no AS b_number,commodity_item_no AS b_number_copy,'' as item_desc,
							 No_pieces AS b_qty1,'' AS unit1,0 AS b_qty2,'' AS unit2,
							 (CASE WHEN (Kg_Lb='L' OR Kg_Lb='LB') THEN CAST(gross_weight/2.20462262 AS INT)  ELSE gross_weight END) AS gross_weight
							 ,0 AS item_value,'' AS export_code,'' AS license_type,'' AS license_number,'' AS eccn,'' AS vin_type,'' AS vin,'' AS vc_title,'' AS vc_state 
							 FROM mawb_weight_charge WHERE elt_account_number=  @elt_account_number   AND mawb_num= @MAWB 
						End
			End
			 -- Saved AES
		  ELSE
			SELECT id ,  dfm,b_number,b_number as b_number_copy,b_qty1,unit1,b_qty2,unit2, item_desc,
			gross_weight,item_value,export_code,license_type,license_number,eccn,vin_type,vin,vc_title,vc_state FROM aes_detail 
			WHERE elt_account_number=  @elt_account_number   AND aes_id=  @AESID   ORDER BY item_no
		END
    ELSE
		BEGIN
	
		   IF @AESID = 0
			BEGIN       
			
				if @HAWB <> '' AND @MAWB <> ''
					Begin
						 SELECT 0 AS ID , 'D' AS dfm,'' AS b_number,'' AS b_number_copy, pieces AS b_qty1,'' AS unit1,0 AS b_qty2,'' AS unit2,gross_weight,0 AS item_value,'' AS export_code,'' AS license_type,'' AS license_number,'' AS eccn,'' AS vin_type,'' AS vin,'' AS vc_title,'' AS vc_state ,'' as item_desc
						FROM hbol_master WHERE elt_account_number= @elt_account_number AND hbol_num=@HAWB AND booking_num=@MAWB
					End
				ELSE             
					if (@HAWB='' AND @MAWB <> '' )
						Begin
							
							SELECT 0 AS ID ,  'D' AS dfm,'' AS b_number,'' AS b_number_copy,
							pieces AS b_qty1,'' AS unit1,0 AS b_qty2,'' AS unit2,gross_weight,0 AS item_value,
							'' AS export_code,'' AS license_type,'' AS license_number,'' AS eccn,'' AS vin_type,'' AS vin,'' AS vc_title,'' AS vc_state ,'' as item_desc
							FROM mbol_master WHERE elt_account_number=@elt_account_number AND booking_num=@MAWB
						End
			End
			 -- Saved AES
		  ELSE
			SELECT id ,  dfm,b_number,b_number as b_number_copy,b_qty1,unit1,b_qty2,unit2, item_desc,
			gross_weight,item_value,export_code,license_type,license_number,eccn,vin_type,vin,vc_title,vc_state FROM aes_detail 
			WHERE elt_account_number=  elt_account_number   AND aes_id=  @AESID   ORDER BY item_no
		END		 
END


--SELECT 0 AS ID ,  'D' AS dfm,'' AS b_number,'' AS b_number_copy,
--                            pieces AS b_qty1,'' AS unit1,0 AS b_qty2,'' AS unit2,gross_weight,0 AS item_value,
--                    '' AS export_code,'' AS license_type,'' AS license_number,'' AS eccn,'' AS vin_type,'' AS vin,'' AS vc_title,'' AS vc_state 
--                    FROM mbol_master WHERE elt_account_number=80002000 AND booking_num='20052191PYL'
