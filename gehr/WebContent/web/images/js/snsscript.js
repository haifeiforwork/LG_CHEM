/*-------------------------------------------------------------------
 Description   : 문자 치환
 -------------------------------------------------------------------*/
function replace(Data,str1,str2)
{
	var len  = Data.length;
	var temp = "";
	for ( i=0;i<len;i++) {
		if( Data.substr(i,1) != str1)
			temp = temp + Data.substr(i,1);
		else
			temp = temp + str2;
	}

	return temp;
}



//연말정산입력시 음수를 입력받기위해서 추가로 생성(2002.12.24.)
function addComma_1(obj)
{
	var want_val = '';
	var want_val2 = '';
	var resultVal = obj.value;
	var imsi = '';
	var dotcnt = 0;
	var reVal = 0;
	var dot = ',';
	var num="-0123456789.,";   //숫자만 들어갈때(음수처리도 포함)
	if (resultVal.length != 0) {
		for (var i=0; i < resultVal.length ;i++)
			if (-1 == num.indexOf(resultVal.charAt(i)))
				reVal = 1;
		if( reVal == 0){
			if(resultVal.length==1 && resultVal.charAt(0)=='.') resultVal='0.';

			for(i=0; i < resultVal.length; i++)    //<,>단위의 표기법을 연산 형식으로 변환
			{
				var digit = resultVal.charAt(i);   //i 이전의 문자를 반영한다
				if(dot != '.' && digit != '.'){		//<,>가 아닌 문자는 누적
					if(digit != ",") want_val = want_val + digit;
				} else {
					dot = '.';
					want_val2 = want_val2 + digit;   //소수이하 숫자
					if(digit == '.') dotcnt = dotcnt + 1;
				}
			}// end for
			var want_amt = want_val;
			for(j=want_amt.length; j > 3; j-=3)         //금액의 마지막 부터 3자리씩 검색
			{
				if(j != want_amt.length)                  //두번째 자리수 부터의 처리루틴
					imsi = "," + want_amt.substring(j-3,j) +  imsi;
				else                                      //처음 처리시 사용 (예)10000=>10,000
					imsi = "," + want_amt.substring(j-3,j);
			}
			//모두 처리된후의 나머지 앞단위의 수치를 처리
			if(j<=3)
			{
				var last_val = want_amt.substring(0,j);  //앞 자리
				var prev_val = imsi;                     //이미 처리된 값들
				var end_val  = '';
				imsi = last_val + prev_val;  //최종 값을 입력
				if(want_val2.length > 0)
				{
					end_val = imsi + want_val2;
				} else {
					end_val = imsi;
				}
			}//end if 1
			// 소숫점이 두개이상인 경우
			if(dotcnt < 2){
				obj.value = end_val;
			} else {
				alert("정확한 데이타를 넣어주세요");
				obj.value = end_val.substring(0,end_val.length-1);
			}
		} else {   // end if 2
			alert("정확한 데이타를 넣어주세요");
			obj.value = '';
		}
	}//end if 3

	// 2004.12.07  -(마이너스) 이상하게 나오는 부분 수정 -,999,999 => - 999,999
	var minusnum = '';
	if( obj.value.charAt(0) == '-' && obj.value.charAt(1) == ',') {
		for ( var a = 0; a < obj.value.length; a++ ) {
			if( a == 1 ) continue;
			minusnum = minusnum+ obj.value.charAt(a)
		}
		obj.value= minusnum;
	}

	obj.focus();
	return;
	//수량을 입력되지 않을 경우
	if (resultVal.length == 0)
	{
		obj.focus();            //입력 필드로 이동
		return false;
	}
}

function insertComma(value)
{
	var want_val = '';
	var want_val2 = '';
	var resultVal = value;
	var imsi = '';
	var dotcnt = 0;
	var reVal = 0;
	var dot = ',';

	for(i=0; i < resultVal.length; i++)    //<,>단위의 표기법을 연산 형식으로 변환
	{
		var digit = resultVal.charAt(i);   //i 이전의 문자를 반영한다
		if(dot != '.' && digit != '.'){		//<,>가 아닌 문자는 누적
			if(digit != ",") want_val = want_val + digit;
		} else {
			dot = '.';
			want_val2 = want_val2 + digit;   //소수이하 숫자
			if(digit == '.') dotcnt = dotcnt + 1;
		}
	}// end for

	var want_amt = want_val;
	for(j=want_amt.length; j > 3; j-=3)         //금액의 마지막 부터 3자리씩 검색
	{
		if(j != want_amt.length)                  //두번째 자리수 부터의 처리루틴
			imsi = "," + want_amt.substring(j-3,j) +  imsi;
		else                                      //처음 처리시 사용 (예)10000=>10,000
			imsi = "," + want_amt.substring(j-3,j);
	}
	//모두 처리된후의 나머지 앞단위의 수치를 처리
	if(j<=3)
	{
		var last_val = want_amt.substring(0,j);  //앞 자리
		var prev_val = imsi;                     //이미 처리된 값들
		var end_val  = '';
		imsi = last_val + prev_val;  //최종 값을 입력
		if(want_val2.length > 0)
		{
			end_val = imsi + want_val2;
		} else {
			end_val = imsi;
		}
	}
	return end_val;
}

function removeComma(value)
{
	var want_val = '';
	var resultVal = value;	//입력한 값

	//값이 존재하여야만 연산을 수행함
	if (resultVal.length != 0)
	{
		for(i=0; i < resultVal.length; i++)    //<,>단위의 표기법을 연산 형식으로 변환
		{
			var digit = resultVal.charAt(i);   //i 이전의 문자를 반영한다
			if(digit != ",")                   //<,>가 아닌 문자는 누적
				want_val = want_val + digit;
		}
	}
	return want_val;
}

// 소숫점 이하 자리수 포맷설정하기..
function pointFormat(str, pointnum) {
	var s = str + '';

	if( str == "" ) return s;

	num1  = s.indexOf(".")             //소숫점이 위치한 곳의 좌표값을 구함
	s2    = s.length;                  //총길이 구하기

	if( num1 != -1 ) {                    // 소숫점이 있는 경우
		num2 = s.slice(num1+1, s2);     //소숫점 이후의 값저장
		if( num2.length == pointnum ) {
			s = s;
		} else if(num2.length < pointnum) {
			for( i = 0 ; i < pointnum - num2.length ; i++ ) {
				s = s + "0";
			}
		} else if(num2.length > pointnum) {
			s = s.substr(0, (s2 - (num2.length - pointnum)));
		}
	} else {                           // 소숫점이 없는 경우
		for( i = 0 ; i < pointnum ; i++ ) {
			if( i == 0 ) {
				s = s + ".0";
			} else {
				s = s + "0";
			}
		}
	}

	if(s.charAt(0)=="."){ s = "0" + s;	}
	return s;
}

//형식 체크후 문자형태의 시간 00:00을 0000으로 바꾼다 값이 없을시는 ""을 리턴
function removeColon(text){
	text = rtrim(ltrim(text));
	if( text!="" ){
		if( text.length == 5 ){
			var tmpTime = text.substring(0,2)+text.substring(3,5);
			return tmpTime;
		} else {
			var tmpTime = text.substring(0,1)+text.substring(2,4);
			return tmpTime;
		}
	} else {
		return "";
	}
}

function removeColonKsc(text){
	if (text != undefined ){
		text = rtrim(ltrim(text));
		if( text!="" ){
			return text.replace(/\:/g, "");
		} else {
			return "";
		}
	}
	return "0000";
}

////////////////////////////////////////////////
function addPointAtDate(date_value)  // 날짜값세팅.....  "20020116"   --> "2002.02.16"
{
	if(date_value.length == 8){
		return ( date_value.substring(0,4)+"."+date_value.substring(4,6)+"."+date_value.substring(6,8) );
	}else{
		return date_value;
	}
}
/////////////////////////////////////////////////
function removePoint(value)
{
	var want_val = '';
	var resultVal = value;	//입력한 값

	//값이 존재하여야만 연산을 수행함
	if (resultVal.length != 0)
	{
		for(i=0; i < resultVal.length; i++)    //<,>단위의 표기법을 연산 형식으로 변환
		{
			var digit = resultVal.charAt(i);   //i 이전의 문자를 반영한다
			if(digit != "."&&digit != "-")                   //<.>가 아닌 문자는 누적
				want_val = want_val + digit;
		}
	}
	return want_val;
}


//////////// 전화번호 첵크 /////////////////////
// true, false를 리턴


function phone(obj) {
	var resultVal = obj.value;
	var num="0123456789-";
	var reVal = 0;
	var tmp = '';
	var tmp2 = '';
	var tmp3 = '';
	var tmpEnd = '';
	var tmpEnd2 = '';
	var tmpEnd3 = '';
	var count = 0;

	if (resultVal.length != 0)
	{
		for (var i=0; i < resultVal.length ;i++)
		{
			if (-1 == num.indexOf(resultVal.charAt(i)))
			{
				alert("잘못된 값을 입력하셨습니다.");
				obj.focus();
				return false;
			}
			if (resultVal.charAt(i)=="-")
			{
				count=count+1;
			}
		}
		if(count>=3){
			tmp     = resultVal.substring(0,resultVal.indexOf('-'));//국가코드
			tmpEnd  = resultVal.substring(resultVal.indexOf('-')+1, resultVal.length);
			tmp2    = tmpEnd.substring(0, tmpEnd.indexOf('-'));//지역번호
			tmpEnd2 = tmpEnd.substring(tmpEnd.indexOf('-')+1, tmpEnd.length);
			tmp3    = tmpEnd2.substring(0,tmpEnd2.indexOf('-'));//국번
			tmpEnd3 = tmpEnd2.substring(tmpEnd2.indexOf('-')+1, tmpEnd2.length);//전화번호
			//alert(tmp+"  "+tmp2+"  "+tmp3+"  "+tmpEnd3);
			if( tmp.length > 3 || tmp==null){
				alert("국가코드가 바르지 못합니다");
				obj.focus();
				obj.select();
				return false;
			}

			if ( tmp2.length > 3 || tmp2.charAt(0)!='0' || tmp2==null )
			{
				alert("지역번호가 바르지 못합니다");
				obj.focus();
				obj.select();
				return false;
			}

			if ( tmp3.length > 4 || tmp3.length<=2 || tmp3==null)
			{
				alert("국번이 바르지 못합니다");
				obj.focus();
				obj.select();
				return false;
			}

			if ( tmpEnd3.length > 4 || tmpEnd3.length<=2 || tmpEnd3==null)
			{
				alert("번호가 바르지 못합니다");
				obj.focus();
				obj.select();
				return false;
			}

			if ( tmp3.length+tmpEnd3.length < 7)
			{
				alert("전화번호가 바르지 못합니다");
				obj.focus();
				obj.select();
				return false;
			}

		} else {

			tmp = resultVal.substring(0,resultVal.indexOf('-'));
			tmp2 = resultVal.substring(resultVal.indexOf('-')+1, resultVal.length);
			if(tmp.length > 3 || tmp.charAt(0)!='0'){
				alert("지역번호가 잘못되었습니다.");
				obj.focus();
				obj.select();
				return false;
			}

			tmp = tmp2.substring(0, tmp2.indexOf('-'));
			tmp2 = tmp2.substring(tmp2.indexOf('-')+1, tmp2.length);
			if(tmp.length>4 || tmp.length<=2 || tmp==null){
				alert("국번이 잘못되었습니다.");
				obj.focus();
				obj.select();
				return false;
			}

			tmp = tmp2.substring(tmp2.indexOf('-')+1, tmp2.length);
			tmp2 = tmp2.indexOf('-');
			if(tmp.length>4 || tmp.length < 3 || tmp2!=-1){
				alert("번호가 잘못되었습니다.");
				obj.focus();
				obj.select();
				return false;
			}
		}
		return true;
	}else{
		//alert("전화번호를 입력하여 주십시오");
		return false;
	}
}

// 단순히 숫자와 '-'만을 체크한다.
function phone_1(obj) {
	var resultVal = obj.value;
	var num="0123456789-";

	if( resultVal.length != 0 )	{
		for( var i=0; i < resultVal.length ;i++ ) {
			if( -1 == num.indexOf(resultVal.charAt(i)) ) {
				alert("잘못된 값을 입력하셨습니다.");
				obj.focus();
				obj.select();
				return false;
			}
		}
	}
	return true;
}

// 전화번호 형식이 'XXX-XXXX-XXXX'형식으로 넣어야 한다. 숫자와 '-'만을 체크한다.
function phone_bar(obj) {
	var resultVal = obj.value;
	var num="0123456789-";
	var count = 0;

	if( resultVal.length != 0 ) {
		for( var i=0; i < resultVal.length ;i++ ) {
			if( -1 == num.indexOf(resultVal.charAt(i)) ) {
				alert("잘못된 값을 입력하셨습니다.");
				obj.focus();
				obj.select();
				return false;
			}
			if (resultVal.charAt(i)=="-") {
				count = count+1;
			}

		}
		if ( count < 2 ) {
			alert("전화번호 형식은 'XXX-XXXX-XXXX'형식으로 넣어야 합니다.");
			obj.focus();
			obj.select();
			return false;
		}
	}
	return true;
}
/////////////////////////null Check///////////////////////

////////////// 날짜 확인 //////////////////

// isDate를 추가해야함

function getAfterDate(time, interval)//2000/01/01 or 2000,01,01
{
	var yyyy;
	var mm;
	var dd;
	var year;
	var month;
	var day;
	var dday;
	var intervalDay;
	var tmpMilliday;
	var newdate;
	if (!isDate(time))
	{
		alert("날짜형식이 유효하지 않습니다.");
		return;
	}

	if(time.length == 10){
		yyyy = time.substring(0,4);
		mm	 = time.substring(5,7);
		dd	 = time.substring(8,10);
	} else if( time.length==8){
		yyyy = time.substring(0,4);
		mm	 = time.substring(4,6);
		dd	 = time.substring(6,8);
	}

	dday = new Date(yyyy,mm-1,dd);
	intervalDay = Number(interval)*24*60*60*1000;
	tmpMilliday = dday.getTime();
	newdate = new Date(tmpMilliday+intervalDay);

	year = newdate.getFullYear();
	month = newdate.getMonth()+1;
	day = newdate.getDate();
	for(i = (year+"").length; i < 4 ; i++ ){
		year = "0"+year;
	}
	if((month+"").length < 2){
		month = "0"+month;
	}
	if((day+"").length < 2){
		day = "0"+day;
	}
	return year+""+month+""+day;
}

function getAfterMonth(time, interval)
{
	var yyyy;
	var mm;
	var dd;
	var year;
	var month;
	var day;
	var yearInterval;
	var monthInterval;
	var nMonth = new Array(31,28,31,30,31,30,31,31,30,31,30,31);
	var yMonth = new Array(31,29,31,30,31,30,31,31,30,31,30,31);

	if (!isDate(time))
	{
		alert("날짜형식이 유효하지 않습니다.");
		return;
	}

	if(time.length == 10){
		yyyy = time.substring(0,4);
		mm	 = time.substring(5,7);
		dd	 = time.substring(8,10);
	} else if( time.length==8){
		yyyy = time.substring(0,4);
		mm	 = time.substring(4,6);
		dd	 = time.substring(6,8);
	}

	day = dd;
	yearInterval = Math.floor((Number(mm)+Number(interval)-1)/12) ;
	year = Number(yyyy)+yearInterval;
	monthInterval = (Number(mm)+Number(interval))-Math.floor((Number(mm)+Number(interval))/12)*12;
	if( (Number(year) % 4) == 0 && ((Number(year) % 100 ) != 0 || (Number(year) % 400) == 0) )
	{
		if(monthInterval == 0){
			month = 12;
		} else {
			month = monthInterval;
		}

		if(day > yMonth[Number(month)-1]) {
			day = yMonth[Number(month)-1];
		} else {
			day = dd;
		}
	} else {
		if(monthInterval == 0){
			month = 12;
		} else {
			month = monthInterval;
		}
		if(day > nMonth[Number(month)-1]) {
			day = nMonth[Number(month)-1];
		} else {
			day = dd;
		}
	}
	for(i = (year+"").length; i < 4 ; i++ ){
		year = "0"+year;
	}
	if((month+"").length < 2){
		month = "0"+month;
	}
	if((day+"").length < 2){
		day = "0"+day;
	}
	return year+""+month+""+day;
}

/*
 * 주의; 입력은 8,10자리 상관없으나 리턴은 8자리
 */
function getAfterYear(time, interval)
{
	var yyyy;
	var mm;
	var dd;
	var year;
	var month;
	var day;
	var nMonth = new Array(31,28,31,30,31,30,31,31,30,31,30,31);
	var yMonth = new Array(31,29,31,30,31,30,31,31,30,31,30,31);
	if (!isDate(time))
	{
		alert("날짜형식이 유효하지 않습니다.");
		return;
	}
	if(time.length == 10){
		yyyy = time.substring(0,4);
		mm	 = time.substring(5,7);
		dd	 = time.substring(8,10);
	} else if( time.length==8){
		yyyy = time.substring(0,4);
		mm	 = time.substring(4,6);
		dd	 = time.substring(6,8);
	}
	month = mm;
	day = dd;
	year = Number(yyyy)+Number(interval);
	if( (Number(year) % 4) == 0 && ((Number(year) % 100 ) != 0 || (Number(year) % 400) == 0) )
	{
		if(dd > yMonth[Number(month)-1]) {
			day = yMonth[Number(month)-1];
		} else {
			day = dd;
		}
	} else {
		if(dd > nMonth[Number(month)-1]) {
			day = nMonth[Number(month)-1];
		} else {
			day = dd;
		}
	}
	for(i = (year+"").length; i < 4 ; i++ ){
		year = "0"+year;
	}
	if((month+"").length < 2){
		month = "0"+month;
	}
	if((day+"").length < 2){
		day = "0"+day;
	}
	return year+""+month+""+day;
}

////////////////날짜계산/////////////////
function getLastDay( year, month ){


	var nMonth = new Array(31,28,31,30,31,30,31,31,30,31,30,31);
	var yMonth = new Array(31,29,31,30,31,30,31,31,30,31,30,31);

	if( (Number(year) % 4) == 0 && ((Number(year) % 100 ) != 0 || (Number(year) % 400) == 0) )
	{
		day = yMonth[Number(month)-1];
	} else {
		day = nMonth[Number(month)-1];
	}
	for(i = (year+"").length; i < 4 ; i++ ){
		year = "0"+year;
	}
	if((month+"").length < 2){
		month = "0"+month;
	}
	if((day+"").length < 2){
		day = "0"+day;
	}
	return year+month+day;

}









///////////// 유효값 /////////////

function checkMinMax(Obj, opt0, opt1, opt2)
{
	var t = Obj.value;
	var min = 100; //최저값  디폴트;
	var max = 200; // 최대값 디폴트;
	var ValidFlag = true;
	var title = "이필드";

	if(opt0!=undefined){
		title = opt0;
	}

	if(opt1!=undefined){
		if(!isNaN(Number(opt1))){
			min=Number(opt1);
		}
	}

	if(opt2!=undefined){
		if(!isNaN(Number(opt2))){
			max=Number(opt2);
		}
	}

	var msg = t+"는 입력범위를 벗어났습니다.\n"
	var msg = msg+title+"의 범위는 : "+min+" 에서 "+max+" 까지";

	if (t.length <= 0)
	{
		alert( "값을 입력하여 주십시오" );
		Obj.focus();//사용여부?
		ValidFlag = false;
	} else if ( isNaN(Number(t)) ){
		alert ( "숫자를 입력하여 주십시오" );
		//Object.value="";
		Obj.focus();
		Obj.select();
		ValideFlag = false;
	} else {
		if(min<=Number(t) && max >= Number(t))
		{
			ValidFlag = true;
		} else {
			ValidFlag = false;
			alert (msg);
			Obj.value="";
			Obj.focus();
			Obj.select();
		}
	}
	return ValidFlag;
}


///////////// 이메일 첵크 ///////////////

function emailChk(obj){
	var t = obj.value;
	var ValidFlag = false;
	var atCount = 0;
	var SpecialFlag;
	var atLoop;
	var atChr;
	var atCodeChr;
	var BadFlag = false;
	var tAry1;
	var UserName ;
	var DomainName;

	if ( t.length > 0 && t.indexOf("@") > 0 && t.indexOf(".") > 0 )
	{
		atCount = 0;
		SpecialFlag = false;
		for( atLoop=0; atLoop<t.length; atLoop++ ) {
			atChr = t.charAt( atLoop);
			atCodeChr = t.charCodeAt(atLoop);
			if ( atChr == "@" ) atCount = atCount + 1;
			if ( (atCodeChr >= 32) && (atCodeChr <= 44) ) SpecialFlag = true;
			if ( (atCodeChr == 47) || (atCodeChr == 96) || (atChr >= 123) ) SpecialFlag = true;
			if ( (atCodeChr >= 58) && (atCodeChr <= 63) ) SpecialFlag = true;
			if ( (atCodeChr >= 91) && (atCodeChr <= 94) ) SpecialFlag = true;
		}

		if ( ( atCount == 1 ) && (SpecialFlag == false ) ) {
			BadFlag = false;
			tAry1 = t.split("@");
			UserName = tAry1[0];
			DomainName = tAry1[1];
			if ( (UserName.length <= 0 ) || (DomainName.length <= 0 ) ) BadFlag = true;
			if ( DomainName.substring( 0, 1 ) == "." ) BadFlag = true;
			if ( DomainName.substring( DomainName.length-1, DomainName.length) == "." ) BadFlag = true;
			ValidFlag = true;
		}
	}

	if ( BadFlag == true || SpecialFlag == true || ValidFlag == false) {
		alert("이메일 형식이 정확하지 않습니다.");
		obj.focus();
		obj.select();
		ValidFlag = false;
	}

	return ValidFlag;

}


//////////////////// 김성일씨///////////////////////

// 새창열기//////////////////////////////////////////////////////////////////////////////

function openWindow( url , opt0, opt1, opt2, opt3, opt4, opt5, opt6, opt7, opt8, opt9, opt10, opt11 ){
	var width = 0 ;
	var height = 0 ;
	var left = 0 ;
	var top = 0 ;

	var j = 1 ;
	var str = "" ;
	var win_name = "";

	for ( i = 0 ; i < 12 ; i++ ){

		option = eval("opt"+i);
		if(option == undefined){
			break;
		}else if(!isNaN(option)){
			if(j == 1) width  = option ;
			if(j == 2) height = option ;
			if(j == 3) left   = option ;
			if(j == 4) top    = option ;
			j++;
		}else if(option == 'menubar' || option == 'toolbar' || option == 'location' || option == 'directories' || option == 'resizable' || option == 'status' || option == 'scrollbars' ){
			if(str == ""){
				str = option + "=yes";
			} else {
				str = str + "," + option + "=yes";
			}
		}else{
			win_name = option;
		}
	}

	if(width != 0) {
		if(str == "") {
			str = "width=" + width;
		} else {
			str = str + ",width=" + width;
		}
	}
	if(height != 0) str = str + ",height=" + height;
	if(left != 0) str = str + ",left=" + left;
	if(top != 0) str = str + ",top=" + top;

	if( str != "") {
		win = window.open( url, win_name, str)
	} else {
		win = window.open( url, win_name)
	}

	win.focus();
	return win;
}

function openPopup( url , opt0, opt1, opt2, opt3 ){
	var width = 450;
	var height = 300;

	var j = 1 ;
	var str = "" ;
	var win_name = "";

	for ( i = 0 ; i < 4 ; i++ ){

		option = eval("opt"+i);
		if(option == undefined){
			break;
		}else if(!isNaN(option)){
			if(j == 1) width  = option ;
			if(j == 2) height = option ;
			if(j == 3) left   = option ;
			if(j == 4) top    = option ;
			j++;
		}else if( option == 'scrollbars' ){
			if(str == ""){
				str = option + "=yes";
			} else {
				str = str + "," + option + "=yes";
			}
		}else{
			win_name = option;
		}
	}

	var left = (screen.availWidth - width) * 0.5;
	var top = (screen.availHeight - height) * 0.5;

	if(str == "") {
		str = "width=" + width;
	} else {
		str = str + ",width=" + width;
	}
	str = str + ",height=" + height;
	str = str + ",left=" + left;
	str = str + ",top=" + top;

	win = window.open( url, win_name, str)

	win.focus();
	return win;
}

// debug용 폼정보 경고창으로 보이기..
function debug(){

	str = "form 수 : " + document.forms.length +" 개 \n\n";

	for ( i = 0 ; i < document.forms.length ; i++ ){
		str += "**************"+ document.forms[i].name +"***************\n";
		for ( j = 0 ; j < document.forms[i].elements.length ; j++ ){
			str += j +" ["+document.forms[i].elements[j].type+"] [name = '"+document.forms[i].elements[j].name;
			str += "', value = '" + document.forms[i].elements[j].value +"' ]\n";
		}
	}
	alert( str );
}


// 특정문자로 바꾸기
function changeChar( str, fromChar, toChar ){

	var sb = "";
	var i = 0;
	if(fromChar.length == 0){
		return str;
	}
	while ( i < (str.length) ){
		if( !(str.substring(i ,i+fromChar.length) == fromChar) ){
			sb = sb + str.charAt(i) ;
			i++;
		}else{
			sb = sb + toChar ;
			i=i+fromChar.length;
		}
	}
	sb = sb + str.substring(i, str.length);
	return sb;

}

// checkbox 에 체크된 항목 개수 가져오기

function checkboxNum( form_name, check_name, total_length ){		// form_name = this

	var checkboxnum = 0;
	for ( j = 0 ; j < total_length ; j++ ){
		checkbox_name = check_name + j ;
		if( eval("document."+form_name+"."+checkbox_name+".checked") ){
			checkboxnum = checkboxnum + 1 ;
		}
	}
	return checkboxnum ;
}

////////////////////////// 이형석///////////////////////////
/****************************************************number****************************************************/

//////////////////////////숫자만 들어가기//////////////////////////

function fCheckDigit(obj, Digit){
	var t = obj.value;

	if (ltrim(rtrim(t)) != "") {
		for (i=0; i<t.length; i++){
			if(Digit.indexOf(t.substring(i,i+1))<0) {
				return false;
			}
		}
	}
	return true;
}

function onlyNumber(obj, title) {      // 숫자만 .. onBlur event 시에 사용하자..
	Digit = "0123456789";
	if( fCheckDigit(obj, Digit) == false) {
		alert(title +checkHangulVowel(title)+" 숫자만 사용 가능합니다.");
		obj.focus();
		obj.select();
		return false;
	}
	return true;
}

function isNumber(str) {
	Digit = "0123456789";
	if( fCheckDigit(str, Digit) == false) {
		return false;
	}
	return true;
}

/***************************************************문자*********************************************************/
function unusableChar(obj, unusableChar) {     // 입력값은 사용할수 없다.. onBlur, onKeyUp event 시에 사용하자..
	var t = obj.value;
	if (ltrim(rtrim(t)) != "") {
		for (i=0; i<t.length; i++){
			if(unusableChar.indexOf(t.substring(i,i+1)) >= 0 ) {
				obj.value = t.substring(0 , i) + t.substring(i+1 , t.length);
				alert("\""+t.substring(i,i+1) +"\"은(는) 입력이 허용되지 않습니다.");
				obj.focus();

				return false;
			}
		}
	}
	return true;
}

function usableChar(obj, usableChar) {     // 입력값만 사용할수 있다.. onBlur, onKeyUp event 시에 사용하자..
	var t = obj.value;
	if (ltrim(rtrim(t)) != "") {
		for (i=0; i<t.length; i++){
			if(usableChar.indexOf(t.substring(i,i+1)) < 0 ) {
				if( t.substring(i,i+1) == "." ) {
					obj.value = t.substring(0 , i);
				} else {
					obj.value = t.substring(0 , i) + t.substring(i+1 , t.length);
				}
				alert("\""+ t.substring(i,i+1) +"\"은(는) 입력이 허용되지 않습니다.");
				obj.focus();
				//obj.select();
				return false;
			}
		}
	}
	return true;
}

function unusableFirstChar(obj, unusableChar) {     // 첫 문자가 unusableChar 중에 있는경우 입력값은 사용할수 없다.. onBlur, onKeyUp event 시에 사용하자..
	var t = obj.value;
	if (ltrim(rtrim(t)) != "") {
		if(unusableChar.indexOf(t.substring(0,1)) >= 0 ) {
			obj.value = t.substring(1 , t.length);
			alert("\""+t.substring(0,1) +"\"은(는) 첫문자로 입력이 허용되지 않습니다.");
			obj.focus();
			//obj.select();
			return false;
		}
	}
	return true;
}

function usableFirstChar(obj, usableChar) {     // 입력값만 사용할수 있다.. onBlur, onKeyUp event 시에 사용하자..
	var t = obj.value;
	if (ltrim(rtrim(t)) != "") {
		if(usableChar.indexOf(t.substring(0,1)) < 0 ) {
			obj.value = t.substring(1 , t.length);
			alert("\""+t.substring(0,1) +"\"은(는) 첫문자로 입력이 허용되지 않습니다.");
			obj.focus();
			//obj.select();
			return false;
		}
	}
	return true;
}

////////////////////////////////길이제한/////////////////////////////////
function limitLength(obj,title,len){
	if(ltrim(rtrim(obj.value))!=""){
		if (obj.value.length>len){
			alert(title+'길이를 초과하였습니다.');
			obj.focus();
			obj.select();
			return false;
		}
	}
	return true;
}

////////////////////////////////trim/////////////////////////////////
function ltrim(parm_str) {
	str_temp = parm_str ;
	while (str_temp.length != 0) {
		if (str_temp.substring(0, 1) == " ") {
			str_temp = str_temp.substring(1, str_temp.length) ;
		} else {
			return str_temp ;
		}
	}
	return str_temp ;
}

function rtrim(parm_str) {
	str_temp = parm_str ;
	while (str_temp.length != 0) {
		int_last_blnk_pos = str_temp.lastIndexOf(" ");
		if ((str_temp.length - 1) == int_last_blnk_pos) {
			str_temp = str_temp.substring(0, str_temp.length - 1);
		} else {
			return str_temp;
		}
	}
	return str_temp;

}

/***************************************************날짜*********************************************************/
////////////////////////////////날짜 포맷1/////////////////////////////////
function dateFormat(obj)
{
	valid_chk = true;

	t = obj.value;
	if(!_.isEmpty(t)) t = t.replace(/[^\d]/g, "");
	if(t.length == 8)
	{
		tempStr = t.substring(0,4) + "." + t.substring(4,6) + "." + t.substring(6,8);
	} else if(t.length == 10) {
		if( t.substring(4,5) != "." || t.substring(7,8) != "." ) {
			valid_chk = false;
		}

		tempStr = t.substring(0,4) + "." + t.substring(5,7) + "." + t.substring(8,10);
	} else {
		tempStr = t;

		if( tempStr.length != 0 ) {
			valid_chk = false;
		}
	}

	if( (!isDate(tempStr) && tempStr.length != 0) || (valid_chk == false) ) {
		alert("날짜 형식이 틀립니다.\n\'YYYYMMDD\' 형식으로 입력하세요.");
		obj.focus();
		obj.select();
		return false;
	}
	obj.value = tempStr;
	return true;
}

////////////////////////////////날짠지 아닌지/////////////////////////////////

function isDate(dateStr) {

    return checkDate(dateStr);	/*날짜 체크 부분 수정 함 - common.js*/

	var datePat = /^(\d{1,4})(\/|-|.)(\d{1,2})(\/|-|.)(\d{1,2})$/;
	var matchArray = new Array;
	matchArray = dateStr.match(datePat);
	if (matchArray == null) {
		return false;
	}

	var year = matchArray[1];
	var month = matchArray[3];
	var day = matchArray[5];

	alert(year + ", " + month + ", " + day);
	if (month < 1 || month > 12) {
		return false;
	}
	if (day < 1 || day > 31) {
		return false;
	}
	if ((month==4 || month==6 || month==9 || month==11) && day==31) {
		return false;
	}
	if (month == 2) {
		var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
		if (day>29 || (day==29 && !isleap)) {
			return false;
		}
	}
	return true;
}

////////////////////////////////날짜 비교/////////////////////////////////
function dayDiff(d1,d2) {
	if( isDate(d1)==true && isDate(d2)==true ) {
		var date1;
		var date2;

		if(d1.length==8){
			date1 = new Date(d1.substring(0,4) + "/" + d1.substring(4,6) + "/" + d1.substring(6,8));
		}else if(d1.length==10){
			date1 = new Date(d1.substring(0,4) + "/" + d1.substring(5,7) + "/" + d1.substring(8,10));
		}

		if(d2.length==8){
			date2 = new Date(d2.substring(0,4) + "/" + d2.substring(4,6) + "/" + d2.substring(6,8));
		}else if(d2.length==10){
			date2 = new Date(d2.substring(0,4) + "/" + d2.substring(5,7) + "/" + d2.substring(8,10));
		}
//		alert("차이는"+Math.ceil((date2 - date1) / 1000 / 24 / 60 / 60));
		return Math.ceil((date2 - date1) / 1000 / 24 / 60 / 60);
	}
	return false;
}


// 20011010 or 2001.10.10  --> 2001/10/10
function addSlash(befor) {
	var ret ;
	if(befor.length==8){
		ret = befor.substring(0,4) + "/" + befor.substring(4,6) + "/" + befor.substring(6,8);
	}else if(befor.length==10){
		ret = befor.substring(0,4) + "/" + befor.substring(5,7) + "/" + befor.substring(8,10);
	}else {
		ret = false;
	}
	return ret;
}

// 요일로 변환하는 함수. 20011010 or 2001.10.10  --> 10/10/2001(월/일/년도)
//0 : 일요일   1 : 월요일   2 : 화요일   3 : 수요일   4 : 목요일   5 : 금요일   6 : 토요일
function dateparse(dateStr){
	var ret ;
	if( dateStr.length==8 ) {
		ret = dateStr.substring(4,6) + "/" + dateStr.substring(6,8)  + "/" + dateStr.substring(0,4);
	} else if(dateStr.length==10){
		ret = dateStr.substring(5,7) + "/" + dateStr.substring(8,10) + "/" + dateStr.substring(0,4);
	}

	d = new Date(ret);

	return d.getDay();
}

/***************************************************시간*********************************************************/
////////////////////////////////시간 포맷1/////////////////////////////////
function timeFormat(obj) {
	valid_chk = true;

	t = obj.value;
	if(t.length == 4)
	{
		tempStr = t.substring(0,2) + ":" + t.substring(2,4);
	} else if(t.length == 5) {
		if( t.substring(2,3) != ":" ) {
			valid_chk = false;
		}

		tempStr = t;
	} else {
		tempStr = t;

		if( tempStr.length != 0 ) {
			valid_chk = false;
		}
	}

	if( (!isTime(tempStr) && tempStr.length != 0) || (valid_chk == false) ) {
		alert("시간 형식이 틀립니다.\n\'HHMM\' 형식으로 입력하세요.");
		obj.focus();
		obj.select();
		return false;
	}
	obj.value = tempStr;
	return true;
}

////////////////////////////////시간인지 아닌지/////////////////////////////////
function isTime(timeStr) {
	if( timeStr == "24:00" ){
		return true
	} else {
		var datePat = /^(\d{1,2})(\:)(\d{1,2})$/;
		var matchArray = new Array;
		matchArray = timeStr.match(datePat);
		if (matchArray == null) {
			return false;
		}
		hh = matchArray[1];
		mm = matchArray[3];
		if (hh < 0 || hh > 23) {
			return false;
		}
		if (mm < 0 || mm > 59) {
			return false;
		}
	}

	return true;
}

////////////////////////////////시간계산 범위 계산/////////////////////////////////
function isTime2(timeStr) {

	var datePat = /^(\d{1,2})(\.)(\d{1,2})$/;
	var matchArray = new Array;
	matchArray = timeStr.match(datePat);
	if (matchArray == null) {
		return false;
	}
	hh = matchArray[1];
	mm = matchArray[3];
	if (hh < 0 || hh > 99) {
		return false;
	}
	if (mm < 0 || mm > 99) {
		return false;
	}
	return true;
}

//////////////////////////////////////////////////////////브라우저 정보////////////////////////////////
function getBrowserName()   {
	document.forms[0].elements[0].value =navigator.appName;
}

function getBrowserVersion()   {
	document.forms[0].elements[0].value =  navigator.appVersion;
}

function getBrowserCodeName()   {
	document.forms[0].elements[0].value = navigator.appCodeName;
}

function getBrowserUserAgent()   {
	document.forms[0].elements[0].value =  navigator.userAgent;
}

function getBrowserNameVersion()   {
	document.forms[0].elements[0].value = navigator.appName + " " + navigator.appVersion;
}

//////////////////////////////////////////////////////////주민등록번호 체크////////////////////////////////
function chkResnoObj(obj){
	resno = obj.value;
	if(resno.length == 0){
		return;
	}
	if(resno.length == 13){
		tempStr = resno.substring(0,6) + "-" + resno.substring(6,13);
	} else if(resno.length == 14){
		tempStr = resno;
	} else {
		alert("주민등록번호 형식이 적당하지 않습니다.");
		obj.focus();
		obj.select();
		return;
	}

	if(chkResno(tempStr)){
		obj.value = tempStr;
	} else {
		alert("주민등록번호가 유효하지 않습니다.");
		obj.focus();
		obj.select();
		return;
	}
}

// return 값을 가지는 함수 - 유효한 주민번호일 경우 true리턴..
function chkResnoObj_1(obj){
	resno = obj.value;

	if( resno.length == 13 ){
		tempStr = resno.substring(0,6) + "-" + resno.substring(6,13);
	} else if( resno.length == 14 ){
		tempStr = resno;
	} else if( resno.length == 10 ){//@2014 연말정산 사업자번호도 등록가능하도록 수정
		tempStr = resno.substring(0,3) + "-" + resno.substring(3,5) + "-" + resno.substring(5,10);
	} else if( resno.length == 12 ){
		tempStr = resno;
	}else if( resno.length == 0 ){
		return true;
	} else {
		alert("형식이 적당하지 않습니다.");
		obj.focus();
		obj.select();
		return false;
	}

	if(fgn_chkResno(tempStr)){
		obj.value = tempStr;
		alert("외국인등록번호입니다.");
		return true;
	} else {
		if(chkResno(tempStr)){
			obj.value = tempStr;
			return true;
		} else if (businoFormat01(obj)){
			obj.value = tempStr;
			return true;
		}
		else {
			alert("등록번호가 유효하지 않습니다.");
			obj.focus();
			obj.select();
			return false;
		}
	}
}

// 주민등록번호에 '-' 추가
function addResBar(resno){
	tempStr=resno;
	if(resno.length == 13){
		tempStr = resno.substring(0,6) + "-" + resno.substring(6,13);
	} else if(resno.length == 14){
		tempStr = resno;
	}
	return tempStr;
}

// 주민등록번호에 '-' 삭제
function removeResBar(resno){
	if(resno.length != 14){
		return resno;
	}
	return resno.substring(0,6) + resno.substring(7,14);
}

function chkResno(resno) {
	fmt = /^\d{6}-[1234]\d{6}$/;
	if (!fmt.test(resno)) {
		return false;
	}
	birthYear = (resno.charAt(7) <= "2") ? "19" : "20";
	birthYear += resno.substr(0, 2);
	birthMonth = resno.substr(2, 2) - 1;
	birthDate = resno.substr(4, 2);
	birth = new Date(birthYear, birthMonth, birthDate);

	if ( birth.getFullYear() % 100 != resno.substr(0, 2) || birth.getMonth() != birthMonth || birth.getDate() != birthDate)
	{
		return false;
	}

	buf = new Array(13);
	for (i = 0; i < 6; i++) buf[i] = parseInt(resno.charAt(i));
	for (i = 6; i < 13; i++) buf[i] = parseInt(resno.charAt(i + 1));

	multipliers = [2,3,4,5,6,7,8,9,2,3,4,5];
	for (i = 0, sum = 0; i < 12; i++) sum += (buf[i] *= multipliers[i]);

	if ((11 - (sum % 11)) % 10 != buf[12]) {
		return false;
	}

	return true;
}

//외국인등록번호 체크
function fgn_chkResno(resno) {
	var sum = 0;
	var odd = 0;
	var regno = removeResBar(resno);
	buf = new Array(13);
	for (i = 0; i < 13; i++) buf[i] = parseInt(regno.charAt(i));

	odd = buf[7]*10 + buf[8];

	if (odd%2 != 0) {
		return false;
	}

	if ((buf[11] != 6)&&(buf[11] != 7)&&(buf[11] != 8)&&(buf[11] != 9)) {
		return false;
	}

	multipliers = [2,3,4,5,6,7,8,9,2,3,4,5];
	for (i = 0, sum = 0; i < 12; i++) sum += (buf[i] *= multipliers[i]);


	sum=11-(sum%11);

	if (sum>=10) sum-=10;

	sum += 2;

	if (sum>=10) sum-=10;

	if ( sum != buf[12]) {
		return false;
	}
	else {
		return true;
	}
}

// 매개변수로 주민번호를 받아서 앞에 6자리에 해당하는 생년월일을 리턴한다.
function getBirthday(resno) {
	if(chkResno(resno)==true||fgn_chkResno(resno)==true)
	{
		birthYear  = resno.substr(0, 2);
		birthMonth = resno.substr(2, 2);
		birthDate  = resno.substr(4, 2);
		if( resno.charAt(7) == '1' || resno.charAt(7) == '2' || resno.charAt(7) == '5' || resno.charAt(7) == '6'){
			birthYear = "19" + birthYear;
		} else {
			birthYear = "20" + birthYear;
		}
		birth = birthYear+birthMonth+birthDate;
		return birth;
	}
}

// 만나이 계산..
function getAge(resno) {
	if(chkResno(resno)==true||fgn_chkResno(resno)==true) {
		birthYear  = resno.substr(0, 2);
		birthMonth = resno.substr(2, 2);
		birthDate  = resno.substr(4, 2);
		if( resno.charAt(7) == '1' || resno.charAt(7) == '2'|| resno.charAt(7) == '5'|| resno.charAt(7) == '6'){
			birthYear = "19" + birthYear;
		} else {
			birthYear = "20" + birthYear;
		}

		ageYear  = 0;
		ageMonth = 0;
		ageDate  = 0;

		d = new Date();
		ageYear  = d.getFullYear() - birthYear;

		ageMonth = (d.getMonth() + 1) - birthMonth;
		if( ageMonth < 0 ) {          // 아직 생일이 지나지 않은 경우..
			ageYear = ageYear - 1;
		} else if( ageMonth == 0 ) {
			ageDate = d.getDate() - birthDate;
			if( ageDate <= 0 ) {          // 아직 생일이 지나지 않은 경우..
				ageYear = ageYear - 1;
			}
		}

		return ageYear;
	}
}

// 매개변수로 주민번호를 받아서 남자일경우 true를 리턴한다.
function isMan(resno) {
	if(chkResno(resno)==true||fgn_chkResno(resno)==true)	{
		var man = resno.substring(8,7);
		if(man == 1 || man == 3 || man == 5 || man == 7) {
			return true;
		} else if(man == 2 || man== 4 || man == 6 || man == 8) {
			return false;
		}
	}
	return false;
}

////////////////////////////////////////////////////////////
// 문자의 길이를 구한다.(1 byte 문자 length 1 2byte 문자 length 2);
function checkLength(text){
	val = text;
	var leng = 0;
	for( i = 0; i<val.length; i++ ){
		codeChr = val.charCodeAt(i);
		if( codeChr>255 ){
			leng = leng+2;
		} else {
			leng = leng+1;
		}
	}
	return leng;
}

function limitKoText( text, maxlength ){
	val = "";
	var limit = 0;

	for( i = 0; i < text.length; i++ ){
		codeChr = text.charCodeAt(i);

		if( codeChr > 255 ){
			limit = limit + 2;
		} else {
			limit = limit + 1;
		}

		if( limit > maxlength) {
			return val;
		} else {
			val = val + text.charAt(i);
		}
	}
	return val;
}

//[CSR ID:2849215] G-Portal 내 신주소 시스템 구축 요청 byte로 잘린 나머지 글자 반환
function limitKoText2( text, maxlength ){
	val = "";
	var limit = 0;
	val2 = "";

	for( i = 0; i < text.length; i++ ){
		codeChr = text.charCodeAt(i);

		if( codeChr > 255 ){
			limit = limit + 2;
		} else {
			limit = limit + 1;
		}

		if( limit > maxlength) {
			val2 = val2 + text.charAt(i);
		} else {
			val = val + text.charAt(i);
		}
	}
	return val2;
}

///////////// 문자가 영문인지 한글인지를 확인하고  영문일경우 true를 리턴한다./////////
function checkEnglish(text){
	val = text;
	for( i = 0; i<val.length; i++ ){
		codeChr = val.charCodeAt(i);
		if( codeChr>255 ){
			return false;
		}
	}
	return true;
}

///////////// 금액 체크 ////////////////////////////////////////////////////////////////////////////////////
/*  화면상에 통화키 select list 가 있는경우 이 메소드를 사용한다. 소숫점, 유효문자 체크 통합 */
/*  onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS');  WAERS => select Field의 name  */
function moneyChkForLGchemR3(obj, select_field_name){
	x_field = eval("document.form1."+select_field_name);
	x_value = x_field[x_field.selectedIndex].value;
	decimal_size = 2;
//이부분은 RFC에 의해 변형
	if( x_value == "KRW" ){
		decimal_size = 0 ;
	}
	if( x_value == "USD" ){
		decimal_size = 2 ;
	}
//이부분은 RFC에 의해 변형
	moneyChkEvent(obj, x_value);
	moneyChkEventWithDecimal(obj, decimal_size);
}

/*  소수점절사단위                                                                 */
/*  일반적으로 moneyChkForLGchemR3() 내부에서만 호출된다                            */
/*  onBlur="javascript:moneyChkEventWithDecimal(this, 3); ==> 소수세째자리에서 절삭 */
/*  직접입력시에만 절사한다.                                                        */
/*  이미 moneyChkEvent 등이 onKeyUp() 실행되었다고 가정한다.                        */
/*  그래서 obj.value 는 정상적인 값이다.                                            */
function moneyChkEventWithDecimal(obj, decimal_size){
	d_value = obj.value;
	d_index = d_value.indexOf(".");
	if(d_index == 0){ // ex) .1234  ==> 0.12
		d_other = d_value.substring(d_index, d_value.length ); //d_other = 1234
		d_other = removeComma(removePoint(d_other));
		d_length = d_other.length; //d_length = 4
		if( d_length > decimal_size ){
			obj.value = "0" + d_other.substring(0, decimal_size);
		}else{
			obj.value = "0" + d_other.substring(0, d_length);
		}
	} else if(d_index > 0){ // ex) 123.4567
		d_other = d_value.substring(d_index+1, d_value.length); //d_other = 4567
		d_other = removeComma(removePoint(d_other));
		d_length = d_other.length; //d_length = 4
		if( d_length > decimal_size ){
			obj.value = d_value.substring(0, d_index+1 ) + d_other.substring(0, decimal_size);
		}else{
			obj.value = d_value.substring(0, d_index+1 ) + d_other.substring(0, d_length);
		}
	} else {
		obj.value = d_value;
	}
}

/*  통화키단위                                                                      */
/*  onKeyUp="javascript:moneyChkEvent(this);  ==>  원화 아닌 것                     */
/*  onKeyUp="javascript:moneyChkEvent(this,'\\');                                   */
/*  onKeyUp="javascript:moneyChkEvent(this,'KRW');                                  */
/*  onKeyUp="javascript:moneyChkEvent(this,'WAERS');  WAERS => select Field의 name  */
/*  주의] select Field의 name을 받을경우는 form의 갯수가 하나여야 한다                */
function moneyChkEvent(obj, key){
	function_len = moneyChkEvent.arguments.length;
	/*원화가 아닐경우 콤마, 숫자, point 허용*/
	if(function_len == 1){
		moneyChkEventForWorld(obj);
		return;
		/* 원화인 경우 */
	}else if(key=="\\" || key=="KRW" ){
		moneyChkEventForWon(obj);
		return;
	}else{
		for ( j = 0 ; j < document.form1.elements.length ; j++ ){
			if( ( document.form1.elements[j].type=="select-one" ) && (key == document.form1.elements[j].name) && (document.form1.elements[j].value == "KRW") ){
				moneyChkEventForWon(obj);
				return;
			}
		}
		moneyChkEventForWorld(obj);
		return;
	}
}

/****** 달러등 일반화폐일때 포멧 체크 : onKeyUp="javascript:moneyChkEventForWorld(this);" *******/
function moneyChkEventForWorld(obj){
	val = obj.value;
	if( unusableFirstChar(obj,',') && usableChar(obj,'0123456789,.') ){ // unusableFirstChar에 0 을 뺐다
		addComma(obj);
	}
	/*  onKeyUp="addComma(this)" onBlur="javascript:unusableChar(this,'.');"  */
}

/****** 원화일때 포멧 체크 : onKeyUp="javascript:moneyChkEventForWon(this);" *******/
function moneyChkEventForWon(obj){
	val = obj.value;
	if( unusableFirstChar(obj,'0,') && usableChar(obj,'0123456789,') ){
		addComma(obj);
	}
	/*  onKeyUp="addComma(this)" onBlur="javascript:unusableChar(this,'.');"  */
}

//연말정산입력시 음수를 입력받기위해서 추가로 생성(2002.12.24.)
function moneyChkEventForWon_1(obj){
	val = obj.value;
	if( unusableFirstChar(obj,'0,') && usableChar(obj,'-0123456789,') ){
		addComma_1(obj);
	}
	/*  onKeyUp="addComma(this)" onBlur="javascript:unusableChar(this,'.');"  */
}

//=================== onBlur시 사용 ===========================================================================//
function moneyChkForLGchemR3_onBlur(obj, select_field_name){
	x_field = eval("document.form1."+select_field_name);
	x_value = x_field[x_field.selectedIndex].value;

	if(!obj  && obj.value == "" ) return;             // 값이 입력되지 않은경우..리턴..

	decimal_size = 2;
//이부분은 RFC에 의해 변형
	if( x_value == "KRW" ){
		decimal_size = 0 ;
	}
	if( x_value == "USD" ){
		decimal_size = 2 ;
	}
//이부분은 RFC에 의해 변형
//    moneyChkEvent(obj, x_value);
	moneyChkEventWithDecimal_onBlur(obj, decimal_size);
}

function moneyChkEventWithDecimal_onBlur(obj, decimal_size){
	d_value = obj.value;
	d_index = d_value.indexOf(".");
	if(d_index == 0){ // ex) .1234  ==> 0.12
		d_other = d_value.substring(d_index, d_value.length ); //d_other = 1234
		d_other = removeComma(removePoint(d_other));
		d_length = d_other.length; //d_length = 4
		if( d_length > decimal_size ){
			obj.value = "0" + d_other.substring(0, decimal_size);
		}else{
			obj.value = "0" + d_other.substring(0, d_length);
		}
	} else if(d_index > 0){ // ex) 123.4567
		d_other = d_value.substring(d_index+1, d_value.length ) + "00000"; //d_other = 456700000
		d_other = removeComma(removePoint(d_other));
		d_length = d_other.length; //d_length = 4
		if( d_length > decimal_size ){
			if( decimal_size == 0 ) {           // KRW경우
				obj.value = d_value.substring(0, d_index);
			} else {
				obj.value = d_value.substring(0, d_index+1) + d_other.substring(0, decimal_size);
			}
		}else{
			if( decimal_size == 0 ) {           // KRW경우
				obj.value = d_value.substring(0, d_index);
			} else {
				obj.value = d_value.substring(0, d_index+1) + d_other.substring(0, d_length);
			}
		}
	} else {
		if( decimal_size == 0 ) {           // KRW경우
			obj.value = d_value;
		} else {
			d_other = "00000"; //d_other = 00000
			d_other = removeComma(removePoint(d_other));
			d_length = d_other.length; //d_length = 5
			if( d_length > decimal_size ){
				obj.value = d_value + "." + d_other.substring(0, decimal_size);
			}else{
				obj.value = d_value + "." + d_other.substring(0, d_length);
			}
		}
	}
}
//=================== onBlur시 사용 ===========================================================================//
/* *************************************************************** 문의 :  김성일 *** */

// online 도움말..
function open_help(param) {
//결재진행현황이 인포멀 간사 결재 위로 옮겨가면서 index1, index2를 변경해준다.
	small_window=window.open("/web/help_online/help.jsp?param="+param,"essHelp","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=no,width=850,height=600,left=100,top=100");
	small_window.focus();
}

// online 규정
function open_rule(param) {
	small_window=window.open("/web/help_online/help/rule.jsp?param="+param,"ruleHelp","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=yes,width=1070,height=600,left=100,top=100,scrollbars=yes" );
	small_window.focus();
}

function MM_swapImgRestore() { //v3.0
	var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
	var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
		var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
			if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.0
	var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
	var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
		if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

//////////////////////////////////////////////////////////신청버튼 중복클릭방지. 2005.4.25. mkbae.////////////////////////////////
function buttonDisabled() {
//	sc_button.innerHTML = "&nbsp;";
}

function buttonEnabled() {
//	sc_button.innerHTML = "<a href=javascript:doSubmit()><img src=/images/btn_build.gif name=image align=absmiddle border=0></a>";
}

// 사업자등록번호 포맷 (2005.05.06)
function businoFormat(obj)
{
	valid_chk = true;

	t = obj.value;
	if(t.length == 10) {
		tempStr = t.substring(0,3) + t.substring(3,5) + t.substring(5,10);
	} else if(t.length == 12) {
		if( t.substring(3,4) != "-" || t.substring(6,7) != "-" ) {
			valid_chk = false;
		}
		tempStr = t.substring(0,3) + t.substring(4,6) + t.substring(7,12);
	} else {
		tempStr = t;

		if( tempStr.length != 0 ) {
			valid_chk = false;
		}
	}

	if( (!check_busino(tempStr) && tempStr.length != 0) || (valid_chk == false) ) {
		alert("사업자등록번호가 유효하지 않거나 형식이 틀립니다.\n숫자 10자리 형식으로 입력하세요.");
		obj.focus();
		obj.select();
		return false;
// 사업자등록번호 "-"으로 구분 3자리-2자리-5자리
	} else {
		if( tempStr.length != 0 ) {
			tempStr = tempStr.substring(0,3) + "-" + tempStr.substring(3,5) + "-" + tempStr.substring(5,10);
		}
	}
	obj.value = tempStr;
	return true;
}

// 사업자등록번호 포맷 (2005.05.06)
function businoFormat01(obj)
{
	valid_chk = true;

	t = obj.value;
	if(t.length == 10) {
		tempStr = t.substring(0,3) + t.substring(3,5) + t.substring(5,10);
	} else if(t.length == 12) {
		if( t.substring(3,4) != "-" || t.substring(6,7) != "-" ) {
			valid_chk = false;
		}
		tempStr = t.substring(0,3) + t.substring(4,6) + t.substring(7,12);
	} else {
		tempStr = t;

		if( tempStr.length != 0 ) {
			valid_chk = false;
		}
	}

	if( (!check_busino(tempStr) && tempStr.length != 0) || (valid_chk == false) ) {
		//alert("사업자등록번호가 유효하지 않거나 형식이 틀립니다.\n숫자 10자리 형식으로 입력하세요.");
		obj.focus();
		obj.select();
		return false;
// 사업자등록번호 "-"으로 구분 3자리-2자리-5자리
	} else {
		if( tempStr.length != 0 ) {
			tempStr = tempStr.substring(0,3) + "-" + tempStr.substring(3,5) + "-" + tempStr.substring(5,10);
		}
	}
	obj.value = tempStr;
	return true;
}

// 사업자등록번호 체크 로직 추가 (2005.05.06)
function check_busino(businoStr) {
	var sum = 0;
	var getlist =new Array(10);
	var chkvalue =new Array("1","3","7","1","3","7","1","3","5");

	for(var i=0; i<10; i++) { getlist[i] = businoStr.substring(i, i+1); }
	for(var i=0; i<9; i++) { sum += getlist[i]*chkvalue[i]; }
	sum = sum + parseInt((getlist[8]*5)/10);
	sidliy = sum % 10;
	sidchk = 0;
	if(sidliy != 0) { sidchk = 10 - sidliy; }
	else { sidchk = 0; }
	if(sidchk != getlist[9]) {
//    alert("사업자등록번호가 유효하지 않습니다.");
		return false;
	}
	return true;
}

// 사업자등록번호에 '-' 삭제
function removeResBar2(busino){
	if(busino.length != 12){
		return busino;
	}
	return busino.substring(0,3) + busino.substring(4,6) + busino.substring(7,12);
}

// 한글 모음 체크 : text의 마지막 글자의 모음 여부 체크 (2005.7.12. mkbae)
function checkHangulVowel(text){
	val = text;
	i = val.length;
	codeChr = val.charCodeAt(i-1);
	if( codeChr>255 ){
		hanChr = val.charAt(i-1);
		if (hanChr.search(/[가|개|갸|걔|거|게|겨|계|고|과|괴|교|구|궈|귀|그|긔|기|까|깨|꺄|꺼|께|꼐|껴|꼬|꽈|꾀|꾜|꾸|꿔|꿰|뀌|뀨|끄|끠|끼|나|내|냐|냬|너|네|녀|녜|노|놔|뇌|뇨|누|눠|뉘|느|늬|니|다|대|댜|댸|더|데|뎌|뎨|도|돠|되|됴|두|둬|뒤|드|듸|디|따|때|땨|떠|떼|뗴|뗘|또|똬|뙤|뚀|뚜|뚸|뛔|뛰|뜌|뜨|띄|띠|라|래|랴|럐|러|레|려|례|로|롸|뢰|료|루|뤄|뤼|르|릐|리|마|매|먀|먜|머|메|며|몌|모|뫄|뫼|묘|무|뭐|뮈|므|믜|미|바|배|뱌|뱨|버|베|벼|볘|보|봐|뵈|뵤|부|붜|뷔|브|븨|비|빠|빼|뺘|뻐|뻬|뼤|뼈|뽀|뽜|뾔|뾰|뿌|뿨|쀄|쀠|쀼|쁘|쁴|삐|사|새|샤|섀|서|세|셔|셰|소|솨|쇠|쇼|수|숴|쉬|스|싀|시|싸|쌔|쌰|써|쎄|쎼|쎠|쏘|쏴|쐬|쑈|쑤|쒀|쒜|쒸|쓔|쓰|씌|씨|아|애|야|얘|어|에|여|예|오|와|외|요|우|워|위|으|의|이|자|재|쟈|쟤|저|제|져|졔|조|좌|죄|죠|주|줘|쥐|즈|즤|지|짜|째|쨔|쩌|쩨|쪠|쪄|쪼|쫘|쬐|쬬|쭈|쭤|쮀|쮜|쮸|쯔|쯰|찌|차|채|챠|챼|처|체|쳐|쳬|초|촤|최|쵸|추|춰|취|츠|츼|치|카|캐|캬|컈|커|케|켜|켸|코|콰|쾨|쿄|쿠|쿼|퀴|크|킈|키|타|태|탸|턔|터|테|텨|톄|토|톼|퇴|툐|투|퉈|튀|트|틔|티|파|패|퍄|퍠|퍼|페|펴|폐|포|퐈|푀|표|푸|풔|퓌|프|픠|피|하|해|햐|햬|허|헤|혀|혜|호|화|회|효|후|훠|휘|흐|희|히]/)){
			return "은";	//한글자음
		} else {
			return "는";	//한글모음
		}
	} else {
		hanChr = val.charAt(i-1);
		return false;		//한글 아님.
	}
}

function f_getDate( separator ) {

	separator = separator || "";
	var dt = new Date();
	var arrDate = new Array();

	var date = dt.getDate();
	var month = dt.getMonth()+1;

	arrDate[0] = dt.getFullYear();
	arrDate[1] = month.toString().length < 2 ? month = "0"+month : month;
	arrDate[2] = date.toString().length < 2 ? date = "0"+date : date;

	return arrDate.join( separator );
}

function f_getDateAdd(Yy,Mm,Dd, addDays, separator ) {

	separator = separator || "";
	var dt = new Date(Yy,Mm-1,Dd);
	var arrDate = new Array();

	var day = dt.getDate() + addDays;
	var month = dt.getMonth()+1;

	var newDt = new Date(dt.getFullYear(), month, day );
	day = newDt.getDate();
	month = newDt.getMonth();

	arrDate[0] = newDt.getFullYear();
	arrDate[1] = month.toString().length < 2 ? month = "0"+month : month;
	arrDate[2] = day.toString().length < 2 ? day = "0"+day : day;

	return arrDate.join( separator );
}


// 20120625 or 2001.10.10  --> 2001-10-10
function addbar(befor) {

	var ret ;
	if(befor.length==8){
		ret = befor.substring(0,4) + "-" + befor.substring(4,6) + "-" + befor.substring(6,8);
	}else if(befor.length==10){
		ret = befor.substring(0,4) + "-" + befor.substring(5,7) + "-" + befor.substring(8,10);
	}else {
		ret = false;
	}
	return ret;
}
function removebar(value)
{
	var want_val = '';
	var resultVal = value;	//입력한 값

	//값이 존재하여야만 연산을 수행함
	if (resultVal.length != 0)
	{
		for(i=0; i < resultVal.length; i++)    //<,>단위의 표기법을 연산 형식으로 변환
		{
			var digit = resultVal.charAt(i);   //i 이전의 문자를 반영한다
			if(digit != "-")                   //<.>가 아닌 문자는 누적
				want_val = want_val + digit;
		}
	}
	return want_val;
}
function ClipBoardClear(){     if(window.clipboardData) clipboardData.clearData();    }    //[CSR ID:2389767] [정보보안] e-HR MSS시스템 수정


//@2014 연말정산 소수점 체크 ###.## 으로 입력
function checkMaxNum(obj) {

	var _pattern = /^(\d{1,3}([.]\d{0,2})?)?$/;

	var _value = obj.value;
	var _rslt = "";

	if (!_pattern.test(_value)&&_value!="") {

		alert("1000 이하의 숫자만 입력가능하며,\n소수점 둘째자리까지만 허용됩니다.");
		//event.srcElement 이벤트를 발생한 변수
		obj.value = obj.value.substring(0,obj.value.length - 1);
		obj.select();
		_rslt= "1";
	}
	return _rslt;

}

//@2015 연말정산 소수점 체크 #.## 으로 입력 (주택자금 이자율)
function checkMaxNum2(obj) {

	var _pattern = /^(\d{1,1}([.]\d{0,2})?)?$/;

	var _value = obj.value;
	var _rslt = "";

	if (!_pattern.test(_value)&&_value!="") {

		alert("10 미만의 숫자만 입력가능하며,\n소수점 둘째자리까지만 허용됩니다.");
		//event.srcElement 이벤트를 발생한 변수
		obj.value = obj.value.substring(0,obj.value.length - 1);
		obj.select();
		_rslt= "1";
	}
	return _rslt;

}

//@2014 연말정산 특수문자 입력 불가
function fn_checkSpText(obj){
	if ((event.keyCode > 32 && event.keyCode < 48) || (event.keyCode > 57 && event.keyCode < 65) || (event.keyCode > 90 && event.keyCode < 97) || (event.keyCode>122 && event.keyCode<127))
		event.returnValue = false;
}

//[CSR ID:2849215] G-Portal 내 신주소 시스템 구축 요청
function execDaumPostcode() {
	new daum.Postcode({
		oncomplete: function(data) {
			// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

			// 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
			// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
			var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
			var extraRoadAddr = ''; // 도로명 조합형 주소 변수

			// 법정동명이 있을 경우 추가한다. (법정리는 제외)
			// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
			if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
				extraRoadAddr += data.bname;
			}
			// 건물명이 있고, 공동주택일 경우 추가한다.
			if(data.buildingName !== '' && data.apartment === 'Y'){
				extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
			}
			// 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
			if(extraRoadAddr !== ''){
				extraRoadAddr = ' (' + extraRoadAddr + ')';
			}
			// 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
			if(fullRoadAddr !== ''){
				fullRoadAddr += extraRoadAddr;
			}

			// 우편번호와 주소 정보를 해당 필드에 넣는다.
			document.getElementById('PSTLZ').value = data.zonecode; //5자리 기초구역번호 사용
			//var testArr = fullRoadAddr.split('(');
			//alert(testArr[0]);
			//alert(testArr[1]);

			document.getElementById('STRAS').value = fullRoadAddr;
			document.getElementById('LOCAT').value = '';//지번 주소는 받지 않음.

			// 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
			if(data.autoRoadAddress) {
				//예상되는 도로명 주소에 조합형 주소를 추가한다.
				var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
				document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';

			} else if(data.autoJibunAddress) {
				var expJibunAddr = data.autoJibunAddress;
				document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';

			} else {
				document.getElementById('guide').innerHTML = '';
			}
		}
	}).open();
}