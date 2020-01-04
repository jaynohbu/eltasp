<%
		select case code_str
			case "class_code" 
				code_type = 1
			case "business_city" 
				code_type = 2
			case "business_state" 
				code_type = 3
			case "business_zip" 
				code_type = 4
			case "owner_mail_city" 
				code_type = 2
			case "owner_mail_state" 
				code_type = 3
			case "owner_mail_zip" 
				code_type = 4
				code_desc = "ZIP Code"
			case "SubConsignee" 
				code_type = 11
			case "SubShipper" 
				code_type = 12
			case "SubAgent" 
				code_type = 13
			case "SubCarrier" 
				code_type = 14
			case "SubTrucker" 
				code_type = 15
			case "SubWarehousing" 
				code_type = 16
			case "SubCFS" 
				code_type = 17
			case "SubBroker" 
				code_type = 18
			case "SubVendor" 
				code_type = 19		
			case "SubCustomer" 
				code_type = 24				
			case "SubGovt" 
				code_type = 20
			case "SubSpecial" 
				code_type = 21
			case "salesperson" 
				code_type = 22
			case "refferedBy" 
				code_type = 23
		end select

		select case code_type
			case 1
				code_desc = code_str
			case 2 
				code_desc = "City"
			case 3 
				code_desc = "State/Province"
			case 4 
				code_desc = "ZIP Code"
			case 11
				code_desc = "Sub Category"
			case 12
				code_desc = "Sub Category"
			case 13
				code_desc = "Sub Category"
			case 14
				code_desc = "Sub Category"
			case 15
				code_desc = "Sub Category"
			case 16
				code_desc = "Sub Category"
			case 17
				code_desc = "Sub Category"
			case 18 
				code_desc = "Sub Category"
			case 19
				code_desc = "Sub Category"
			case 20 
				code_desc = "Sub Category"
			case 21
				code_desc = "Sub Category"
			case 22
				code_desc = "S/R Name"
			case 23
				code_desc = "Name for Reffer"

		end select
%>