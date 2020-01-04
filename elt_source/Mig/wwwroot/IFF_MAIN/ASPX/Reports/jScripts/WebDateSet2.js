
function myRadioButtonforDateSet2CheckDate(r) {

		myRadioButtonforDateSet2setMyDate(r.value);
		return false;
}

function myRadioButtonforDateSet2setMyDate(r) {

var	Wedit1 = igedit_getById('Webdatetimeedit3')
var	Wedit2 = igedit_getById('Webdatetimeedit4')

now = new Date(); 
year = now.getYear(); 
month = (now.getMonth()+1); 
date = now.getDate(); 	
				if(r== 'Select' ) { 
					Wedit1.setValue("");
					Wedit2.setValue("");
				}
				else if(r== 'Today' ) { 
					Wedit1.setValue(now);
					Wedit2.setValue(now);
				}

				else if(r== 'Month to Date') {
					fromDate = new Date(year,month-1,1);
					Wedit1.setValue(fromDate);
					Wedit2.setValue(now);
				}

				else if(r== 'Quarter to Date') {

					tq=month;
					if (tq>=1 && tq<=3) {
						fromDate=new Date(year,1-1,1);
						}
					else if (tq>=4 && tq<=6 ) {
						fromDate=new Date(year,4-1,1);
						}
					else if (tq>=7 && tq<=9 ) {
						fromDate=new Date(year,7-1,1);
						}
					else { 
						fromDate=new Date(year,10-1,1);
						}
					
					Wedit1.setValue(fromDate);
					Wedit2.setValue(now);
					
				}

				else if(r== 'Year to Date') {
						fromDate=new Date(year,1-1,1);
						Wedit1.setValue(fromDate);
						Wedit2.setValue(now);
				}

				else if(r== 'This Month') {
						fromDate=new Date(year,month-1,1);
						toDate = new Date(year,month,0);
						Wedit1.setValue(fromDate);
						Wedit2.setValue(toDate);
				}

				else if(r== 'This Quarter') {

					tq=month;
					if (tq>=1 && tq<=3) {
						fromDate=new Date(year,1-1,1);
						toDate = new Date(year,3-1,31);
						}
					else if (tq>=4 && tq<=6 ) {
						fromDate=new Date(year,4-1,1);
						toDate = new Date(year,6-1,30);
						}
					else if (tq>=7 && tq<=9 ) {
						fromDate=new Date(year,7-1,1);
						toDate = new Date(year,9-1,30);
						}
					else { 
						fromDate=new Date(year,10-1,1);
						toDate = new Date(year,12-1,31);
						}
					
					Wedit1.setValue(fromDate);
					Wedit2.setValue(toDate);
				}

				else if(r== 'This Year') {
						fromDate=new Date(year,1-1,1);
						toDate = new Date(year,12-1,31);
						Wedit1.setValue(fromDate);
						Wedit2.setValue(toDate);
				}

				else if(r== 'Last Month') {
						fromDate=new Date(year,month-2,1);
						toDate = new Date(year,month-1,1-1);
						Wedit1.setValue(fromDate);
						Wedit2.setValue(toDate);
				}

				else if(r== 'Last Quarter') {
					tq=month;
					if (tq>=1 && tq<=3) {
						fromDate=new Date(year,10-1,1);
						toDate = new Date(year,12-1,31);
						}
					else if (tq>=4 && tq<=6 ) {
						fromDate=new Date(year,1-1,1);
						toDate = new Date(year,3-1,31);
						}
					else if (tq>=7 && tq<=9 ) {
						fromDate=new Date(year,4-1,1);
						toDate = new Date(year,6-1,30);
						}
					else { 
						fromDate=new Date(year,7-1,1);
						toDate = new Date(year,9-1,30);
						}
					
					Wedit1.setValue(fromDate);
					Wedit2.setValue(toDate);
				}

				else if(r== 'Last Year'){
						fromDate=new Date(year-1,1-1,1);
						toDate = new Date(year-1,12-1,31);
						Wedit1.setValue(fromDate);
						Wedit2.setValue(toDate);
				}
				
				return true;
}

