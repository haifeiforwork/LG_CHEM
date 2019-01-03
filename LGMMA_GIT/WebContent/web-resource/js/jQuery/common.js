/**
 * @author LG CNS
 */

/*
var w_width = 0;
var w_height = 0;
*/

// 레이어팝업
$(function() {
	if ($('.layerWrapper').length) {
		$('#popLayerAddress').popup(); // 주소
		$('#popLayerTel').popup(); // 연락처
		$('#popLayerFamily').popup(); // 가족사항
		$('#popLayerUniform').popup(); // 근무복 신청
		$('#popLayerUniformStock').popup(); // 근무복 재고
		$('#popLayerUniformImg').popup(); // 근무복 이미지
		$('#popLayerMedical').popup(); //의료비 등록
		$('#popLayerBill').popup(); //진료비 계산서 조회
		$('#popLayerBillWrite').popup(); //진료비 계산서 입력
		$('#popLayerRoommate').popup(); //동거인 신청
		$('#popLayerInformal').popup(); //인포멀 신청정보
		$('#popLayerHometax').popup(); //연말정산 신청안내
		$('#popLayerTaxPrint').popup(); //소득공제신고서발행
		$('#popLayerMedicalInfo').popup(); //의료비 지원/제외 기준
		$('#popLayerMedicalAlert').popup();
	}
	tblHEAD_Fixed(); // 틀고정 테이블
});

//left 영역 열고 닫기
function clsopnleftMenu() {

	if ($('.leftTop').hasClass('close')) {
		$('.leftMenu').css('width', '20px');
		$('.leftBg').addClass('closed');
		$('.leftTop').removeClass('close');
		$('.contents').css('width', (1370 - 116) + 'px');
		$('.closeOpen').hide();
		$('.leftUnderBanner').hide();
	} else {
		$('.leftMenu').css('width', '189px');
		$('.leftTop').addClass('close');
		$('.leftBg').removeClass('closed');
		$('.contents').css('width', (1370 - 285) + 'px');
		$('.closeOpen').show();
		$('.leftUnderBanner').show();
	}
}

//헤더영역의 메뉴 클릭 시 호버 영역 및 메가드롭 나타내기
function globalNavigate(target) {
	var item = '.' + target + ' a';
	var mega = '.' + target + ' .megaDrop';

	$('.hMenu').mouseleave();

	$('.hMenu a').removeClass('on');
	$(item).toggleClass('on');

	$('.megaDrop').removeClass('Lnodisplay');
	$('.megaDrop').removeClass('on');
	$(mega).addClass('on');
}


function ltrim(parm_str) {
	str_temp = parm_str ;
	while (str_temp.length != 0) {
		if (str_temp.substring(0, 1) == ' ') {
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
		int_last_blnk_pos = str_temp.lastIndexOf(' ');
		if ((str_temp.length - 1) == int_last_blnk_pos) {
			str_temp = str_temp.substring(0, str_temp.length - 1);
		} else {
			return str_temp;
		}
	}
	return str_temp;
}

/////////////////////////null Check///////////////////////

function checkNull(obj, title) {
	var t = obj.value;
	var ValidFlag = true;
	var msg = title+' 입력하세요.'
	t = rtrim(ltrim(t));
	if (t.length <= 0) {
		alert(msg);
		obj.focus();
		ValidFlag = false;
	}
	return ValidFlag;
}

// Loading Layer
(function($) {
	/*!
	 * Center-Loader PACKAGED v1.0.0
	 * http://plugins.rohitkhatri.com/center-loader/
	 * MIT License
	 * by Rohit Khatri
	 */
	$.fn.loader = function(action,spinner) {
		var action = action || 'show';
		if (action === 'show') {
			if (this.find('.loader').length == 0) {
				parent_position = this.css('position');
				this.css('position','relative');
				paddingTop = parseInt(this.css('padding-top'));
				paddingRight = parseInt(this.css('padding-right'));
				paddingBottom = parseInt(this.css('padding-bottom'));
				paddingLeft = parseInt(this.css('padding-left'));
				width = this.innerWidth();
				height = this.innerHeight();

				$loader = $('<div class="loader"></div>').css({
					'position': 'fixed',
					'top': 0,
					'left': 0,
					'width': '100%',
					'height': '100%',
					'z-index':1000,
					'background-color': 'rgba(0,0,0,0.1)',
					'border-radius': ''
				});

				$loader.attr('parent_position',parent_position);

				$spinner = $(spinner).css({
					'position': 'absolute',
					'top': '50%',
					'left': '50%',
					'color': '#000',
					'margin-top': '-'+paddingTop+'px',
					'margin-right': '-'+paddingRight+'px',
					'margin-bottom': '-'+paddingBottom+'px',
					'margin-left': '-'+paddingLeft+'px'
				});

				$loader.html($spinner);
				this.prepend($loader);
				marginTop = $spinner.height()/2;
				marginLeft = +$spinner.width()/2;
				$spinner.css({
					'margin-top': '-'+marginTop+'px',
					'margin-left': '-'+marginLeft+'px'
				});
			}
		} else if (action === 'hide') {
			this.css('position',this.find('.loader').attr('parent_position'));
			this.find('.loader').remove();
		}
	};

})(jQuery);

// 숫자 타입에서 쓸 수 있도록 format() 함수 추가
Number.prototype.format = function() {
    if (this==0) return 0;

    var reg = /(^[+-]?\d+)(\d{3})/;
    var n = (this + '');

    while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');

    return n;
};

// 문자열 타입에서 쓸 수 있도록 format() 함수 추가
String.prototype.format = function() {
    var num = parseFloat(this);
    if (isNaN(num)) return '0';

    return num.format();
};
//즐겨찾기 버튼 클릭시  아이콘 바뀌기
function toggleTitleIcon(target) {
	$('.titleButton li a').removeClass('on');
	$(target).addClass('on');
}

//탭영역 클릭시 선택탭 나타내기
function switchTabs(target, item) {
	$('.tabArea ul.tab li a').removeClass('selected');

	var anchor = $(target).addClass('selected');
	item = item || anchor.attr('id');

	$('.tabUnder').addClass('Lnodisplay');
	if ($('.tabUnder').hasClass(item)) {
		$('.' + item).removeClass('Lnodisplay');
	}
}

//셔틀 영역의 탭(혹은 탭 안의 탭) 클릭시 선택탭 나타내기
function switchShuttle(target, item) {
	$(target).parent().parent().children('li').removeClass('on');
	$(target).parent().addClass('on');
	var changeTab = '.' + item;

	$('.tabInsideUnder').addClass('Lnodisplay');
	if ($('.tabInsideUnder').hasClass(item)) {
		$(changeTab).removeClass('Lnodisplay');
	}

}

//레이어 팝업 영역의 탭
function popupTabs(target, item) {
	$('.poptabArea ul.tab li a').removeClass('selected');
	$(target).addClass('selected');
	var changeTab = '.' + item;

	$('.poptabUnder').addClass('Lnodisplay');
	if ($('.poptabUnder').hasClass(item)) {
		$(changeTab).removeClass('Lnodisplay');
	}
}

//레이어팝업에서 X버튼 클릭시 닫기
function closelayerpopup() {
	$('.qLayerpop').addClass('Lnodisplay');
	$('.qBanners a').removeClass('on');
}

//플래너의 탭 클릭시 선택탭 나타내기
function switchCalendar(target) {
	$('.plTop ul li').removeClass('on');
	$(target).parent().addClass('on');
}

//조회조건이 4행 이상인 경우 버튼 클릭시 모두 나타내기
function spreadInquiry() {

	var chImage = $('.btnSpread a img');
	var hiddenConds = $('.tableInquiry table tr.hideNshow');

	if (hiddenConds.hasClass('Lnodisplay')) {
		$(chImage).attr('src', '../images/btn_search_fold.gif');
		$(hiddenConds).removeClass('Lnodisplay');

		} else {
		$(chImage).attr('src', '../images/btn_search_spread.gif');
		$(hiddenConds).addClass('Lnodisplay');
	}
}

//트리영역 구현
function shuttleTree() {
	var shuttleTree = $('.shuttleTree');
	var icon_open = '../web-resource/images/ico/ico_tree_open.gif';
	var icon_close = '../web-resource/images/ico/ico_tree_close.gif';
	shuttleTree.find('li:has("ul")').prepend('<a href="#" class="control"><img src="' + icon_open + '" /></a> ');
	shuttleTree.find('li:last-child').addClass('end');

	$('.control').click(function() {
		var temp_el = $(this).parent().find('>ul');
		if (temp_el.css('display') == 'none') {
			temp_el.slideDown(50);
			$(this).find('img').attr('src', icon_close);
			$(this).next('a').find('span').addClass('on');
			return;
		}
		else {
			temp_el.slideUp(50);
			$(this).find('img').attr('src', icon_open);
			$(this).next('a').find('span').removeClass('on');
			return;
		}
	});
}

//슬라이드 메뉴 혹은 트리 메뉴 아이콘 및 영역 바꾸기
function toggleListType(target) {
	var item = '.' + target;

	$('.leftType li a').removeClass('on');
	$(item).addClass('on');
	if (target == 'list') {
		$('#leftMenuBlock').removeClass('treeMenu');
		$('#leftMenuBlock').addClass('slideMenu');
		$('.control').remove();
		$('.treeConArea').addClass('Lnodisplay');
		menuActive();
	} else
	if (target == 'tree') {
		$('#leftMenuBlock').removeClass('slideMenu');
		$('#leftMenuBlock').addClass('treeMenu');
		$('#leftMenuBlock').css('min-height', '145px');
		$('.treeConArea').removeClass('Lnodisplay');
        treemenuActive();
	}
}

//트리메뉴 구현
function treemenuActive() {
	var tree_menu = $('.treeMenu');
	var icon_open = '../images/ico/ico_tree_open.gif';
	var icon_close = '../images/ico/ico_tree_close.gif';
	//$.each(tree_menu.find('li:has("ul")'),function(index,item) {
	//    if (item.children[0].children[0].attributes[0].value == 'on') {
	//        item.prepend('<a href="#" class="control"><img src="' + icon_close + '" /></a> ');
	//    } else {
	//        item.prepend('<a href="#" class="control"><img src="' + icon_open + '" /></a> ');
	//    }
	//});
	tree_menu.find('li:has("ul")').prepend('<a href="#" class="control"><img src="' + icon_open + '" /></a> ');
	tree_menu.find('li:last-child').addClass('end');

	$('.dashAdded').remove();

	$('.treeConArea').removeClass('Lnodisplay');
	$('#all').css('display', 'block');

	$('.control').click(function() {
		var temp_el = $(this).parent().find('>ul');
		if (temp_el.css('display') == 'none') {
			temp_el.slideDown(50);
			$(this).find('img').attr('src', icon_close);
			$(this).next('a').addClass('on');
			$(this).next('a').children('span').addClass('on');
			return false;
		}
		else {
			temp_el.slideUp(50);
			$(this).find('img').attr('src', icon_open);
			$(this).next('a').removeClass('on');
			$(this).next('a').children('span').removeClass('on');
			return false;
		}
	});
}

//트리메뉴 모두 열거나 모두 닫기
function tree_init(status) {
	var tree_menu = $('.treeMenu');
	var icon_open = '../images/ico/ico_tree_open.gif';
	var icon_close = '../images/ico/ico_tree_close.gif';
	if (status == 'close') {
		tree_menu.find('ul').hide();
		$('.control').find('img').attr('src', icon_open);
		$('.treeMenu .leftDepth1 span').removeClass('on');
		$('.treeMenu .leftDepth1').removeClass('on');
		$('.treeMenu .leftDepth2 span').removeClass('on');
		$('.treeMenu .leftDepth2').removeClass('on');
	}
	else
		if (status == 'open') {
			tree_menu.find('ul').show();
			$('.control').find('img').attr('src', icon_close);
			$('.treeMenu .leftDepth1 span').addClass('on');
			$('.treeMenu .leftDepth1').addClass('on');
			$('.treeMenu .leftDepth2 span').addClass('on');
			$('.treeMenu .leftDepth2').addClass('on');
	}
}
//트리메뉴 모두 열거나 모두 닫을 때 텍스트 바꾸기
function clickTreeCon() {
	if ($('.treeCon span').text() == 'ALL OPEN') {
		tree_init('open');
		$('.treeCon span').text('ALL CLOSE');
	}else {
		tree_init('close');
		$('.treeCon span').text('ALL OPEN');
	}
}

//슬라이드 메뉴 구현
function menuActive() {

	var appendDash = '<span class="dashAdded">- </span>';
	$('.slideMenu .leftDepth2 span').before(appendDash);

	$('.slideMenu .leftDepth1').unbind('click');
	$('.slideMenu .leftDepth2').unbind('click');


	$('.slideMenu .leftDepth1').click(function() { //leftDepth1 클릭을 하면
		/*
		$('.slideMenu .2depthArea').addClass('Lnodisplay').css('display', 'none'); // 2depthArea
		$('.slideMenu .leftDepth1 span').removeClass('on');
		$('.slideMenu .leftDepth1').removeClass('on');

		$('.slideMenu .3depthArea').addClass('Lnodisplay').css('display', 'none');
		$('.slideMenu .leftDepth2 span').removeClass('on');
		$('.slideMenu .leftDepth2').removeClass('on');
		*/
		//if ($('#leftMenuBlock').hasClass('slideMenu')) {
			var slide_el = $(this).parent().find('>ul');
			if (slide_el.hasClass('Lnodisplay')) {
				slide_el.slideDown(100);
				$(slide_el).removeClass('Lnodisplay');
				$(this).addClass('on');
				$(this).children('span').addClass('on');
				return;
			}
			else {
				slide_el.slideUp(100);
				$(this).children('span').removeClass('on');
				$(slide_el).addClass('Lnodisplay');
				return;
			}
		//}
	});

	$('.slideMenu .leftDepth2').click(function() {
		var depth2_el = $(this).parent().find('>ul');
		if (depth2_el.hasClass('Lnodisplay')) {
			depth2_el.slideDown(50);
			$(this).children('span').addClass('on');
			$(this).addClass('on');
			$(depth2_el).removeClass('Lnodisplay');
			return;
		}
		else {
			depth2_el.slideUp(50);
			$(this).children('span').removeClass('on');
			$(depth2_el).addClass('Lnodisplay');
			return;
		}
	});
}

//DatePicker;
$(function() {
	//날짜 datepicker
	$('.datepicker').datepicker();

	//날짜 기간 datepicker
	$('#inputDateFrom').datepicker({
		defaultDate: '+1w',
		onClose: function(selectedDate) {
			$('#inputDateTo').datepicker('option', 'minDate', selectedDate);
		}
	});
	$('#inputDateTo').datepicker({
		defaultDate: '+1w',
		onClose: function(selectedDate) {
			$('#inputDateFrom').datepicker('option', 'maxDate', selectedDate);
		}
	});
	// 소액대출 달력추가
	$('#inputDateDay').datepicker();

	var periodpicker = $('.periodpicker');

	for(var i=0;i<periodpicker.length;i++) {
		//date 찾아오기
		var dateInput = $(periodpicker[i]).find('input');
		$.each(dateInput, function(i, data) {
			var fid = dateInput[0].id;
			var tid = dateInput[1].id;
			$(data).datepicker({
				defaultDate: '+1w',
	            onClose: function (selectedDate) {
	            	if (i==0) {
	            		$('#'+tid).datepicker('option', 'minDate', selectedDate);
	            	} else {
	            		$('#'+fid).datepicker('option', 'maxDate', selectedDate);
	            	}
	            }
	        });
		});
	}

});

//period 동적 생성
function setPeriodpicker(formid) {
	$.each($('#'+formid).find('.periodpicker'), function(i, periodpicker) {
		var dateInput = $(periodpicker).find('input');
		$.each(dateInput, function(i, data) {
			var fid = dateInput[0].id;
			var tid = dateInput[1].id;
			$(data).datepicker({
				defaultDate: '+1w',
	            onClose: function (selectedDate) {
	            	if (i==0) {
	            		$('#'+tid).datepicker('option', 'minDate', selectedDate);
	            	} else {
	            		$('#'+fid).datepicker('option', 'maxDate', selectedDate);
	            	}
	            }
	        });
		});
	});
}

function destroydatepicker(formid) {
	//datepicker 삭제
	$.each($('#'+formid).find('.datepicker'), function(i, daypicker) {
		$(daypicker).datepicker('destroy');
	});

	//periodpicker 삭제
	$.each($('#'+formid).find('.periodpicker'), function(i, periodpicker) {
		var dateInput = $(periodpicker).find('input');
		$.each(dateInput, function(data) {
			$(data).datepicker('destroy');
		});
	});
}

//주민등록번호에 '-' 추가
function addResBar(resno) {
	var tempStr = '';
	if (resno!=null) {
		tempStr=resno;
	}
	if (tempStr.length == 13) {
		tempStr = resno.substring(0,6) + '-' + resno.substring(6,13);
	}
	return tempStr;
}

// 주민등록번호에 '-' 삭제
function removeResBar(resno) {
	if (resno.length != 14) {
		return resno;
	}
	return resno.substring(0,6) + resno.substring(7,14);
}

function chkResno(resno) {
	fmt = /^\d{6}-[9012345678]\d{6}$/;
	if (!fmt.test(resno)) {
		return false;
	}

	// 재외국인 번호 체크 로직 추가 (2005.03.07) [5:남자(외국), 6:여자(외국) ==> 1900년대 출생, 7:남자(외국), 8:여자(외국) ==> 2000년대 출생]
	if (resno.charAt(7) == '5' || resno.charAt(7) == '6' || resno.charAt(7) == '7' || resno.charAt(7) == '8') {
		return check_fgnno(removeResBar(resno));             // 하이픈 삭제
	// 1:남자(국내), 2:여자(국내)
	} else if (resno.charAt(7) == '1' || resno.charAt(7) == '2') {
		birthYear = '19';
	// 3:남자(국내), 4:여자(국내)
	} else if (resno.charAt(7) == '3' || resno.charAt(7) == '4') {
		birthYear = '20';
	}

	birthYear += resno.substr(0, 2);
	birthMonth = resno.substr(2, 2) - 1;
	birthDate  = resno.substr(4, 2);
	birth = new Date(birthYear, birthMonth, birthDate);

	if (birth.getFullYear() % 100 != resno.substr(0, 2) || birth.getMonth() != birthMonth || birth.getDate() != birthDate) {
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

//만나이 계산..
function getAge(resno) {
	if (chkResno(resno)==true) {
		birthYear  = resno.substr(0, 2);
		birthMonth = resno.substr(2, 2);
		birthDate  = resno.substr(4, 2);
		if (resno.charAt(7) == '1' || resno.charAt(7) == '2') {
			birthYear = '19' + birthYear;
		} else {
			birthYear = '20' + birthYear;
		}

		ageYear  = 0;
		ageMonth = 0;
		ageDate  = 0;

		d = new Date();
		ageYear  = d.getFullYear() - birthYear;

		ageMonth = (d.getMonth() + 1) - birthMonth;

		if (ageMonth < 0) {          // 아직 생일이 지나지 않은 경우..
			ageYear = ageYear - 1;
			} else if (ageMonth == 0) {
				ageDate = d.getDate() - birthDate;
				if (ageDate <= 0) {          // 아직 생일이 지나지 않은 경우..
					ageYear = ageYear - 1;
				}
		}

		return ageYear;
	}
}

// 금액 자동 콤마 입력
function cmaComma(obj) {
    var firstNum = '';
    var strNum = /^[/,/,0,1,2,3,4,5,6,7,8,9,/]/; // 숫자와 , 만 가능
    var str = '' + obj.value.replace(/,/gi,''); // 콤마 제거
    var regx = new RegExp(/(-?\d+)(\d{3})/);
    var bExists = str.indexOf('.',0);
    var strArr = str.split('.');
    if (obj.value=='') return;

    if (!strNum.test(obj.value)) {
        alert('숫자만 입력하십시오.\n\n특수문자와 한글/영문은 사용할수 없습니다.');
        obj.value = '';
        obj.focus();
        return false;
    }

    if (str.length>11) {
		alert('입력 가능한 자릿수를 초과했습니다.');
		obj.value = '';
        obj.focus();
        return false;
	}

	for(var i =0 ; i < str.length ; i ++) {
		firstNum = str.charAt(i);
	    if ((firstNum < '0' || '9' < firstNum)) {
	        alert('숫자만 입력하십시오.');
	        obj.value = '';
	        obj.focus();
	        return false;
	    }
	}


    while(regx.test(strArr[0])) {
        strArr[0] = strArr[0].replace(regx,'$1,$2');
    }
    if (bExists > -1)  {
        obj.value = strArr[0] + '.' + strArr[1];
    } else  {
        obj.value = strArr[0];
    }
}

// 우편번호 팝업
function sample4_execDaumPostcode(zipcode,address,detail) {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
            var extraRoadAddr = ''; // 도로명 조합형 주소 변수

            // 법정동명이 있을 경우 추가한다. (법정리는 제외)
            // 법정동의 경우 마지막 문자가 '동/로/가'로 끝난다.
            if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                extraRoadAddr += data.bname;
            }
            // 건물명이 있고, 공동주택일 경우 추가한다.
            if (data.buildingName !== '' && data.apartment === 'Y') {
               extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
            }
            // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
            if (extraRoadAddr !== '') {
                extraRoadAddr = ' (' + extraRoadAddr + ')';
            }
            // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
            if (fullRoadAddr !== '') {
                fullRoadAddr += extraRoadAddr;
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            //document.getElementById('sample4_postcode').value = data.postcode; //6자리 우편번호 사용
            document.getElementById(zipcode).value = data.zonecode; //5자리 기초구역번호 사용
            document.getElementById(address).value = fullRoadAddr;
            document.getElementById(detail).value = '';
            //document.getElementById('LOCAT').value = fullRoadAddr2;

            //document.getElementById('sample4_jibunAddress').value = data.jibunAddress;

            // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
//            if (data.autoRoadAddress) {
//                //예상되는 도로명 주소에 조합형 주소를 추가한다.
//                var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
//                document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
//
//            } else if (data.autoJibunAddress) {
//                var expJibunAddr = data.autoJibunAddress;
//                document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
//
//            } else {
//                document.getElementById('guide').innerHTML = '';
//            }
        }
    }).open();
}

// 주민등록 번호 체크  사용 예  javascript: resno_chk('id')
var resno_chk = function(id) {
	resno = $('#'+id).val();

	if (resno.length == 13) {
		tempStr = resno.substring(0,6) + '-' + resno.substring(6,13);
	} else if (resno.length == 14) {
		tempStr = resno;
	} else if (resno.length == 10) {  //@2014 연말정산 사업자번호도 등록가능하도록 수정
		tempStr = resno.substring(0,3) + '-' + resno.substring(3,5) + '-' + resno.substring(5,10);
	} else if (resno.length == 12) {
		tempStr = resno;
	} else if (resno.length == 0) {
		return true;
	} else {
		alert('형식이 적당하지 않습니다.');
		$('#'+id).focus();
		$('#'+id).select();

		return false;
	}

	if (check_fgnno(tempStr)) {
		$('#'+id).val(tempStr);
		alert('외국인등록번호입니다.');
		return true;
	} else if (chkResno(tempStr)) {
		$('#'+id).val(tempStr);
		return true;
	} else if (businoFormat01(id)) {
		$('#'+id).val(tempStr);
		return true;
	} else {
		alert('주민등록번호가 유효하지 않습니다.');
		$('#'+id).focus();
		$('#'+id).select();
		return false;
	}
}

var formatResno = function(id) {
	resno = $('#'+id).val();

	if (resno.length == 13) {
		tempStr = resno.substring(0,6) + '-' + resno.substring(6,13);
		$('#'+id).val(tempStr);
	}
}

// 재외국인 번호 체크 로직 추가 (2005.03.07)
var check_fgnno = function(fgnno) {
	var sum=0;
	var odd=0;
	buf = new Array(13);
	for(i=0; i<13; i++) { buf[i]=parseInt(fgnno.charAt(i)); }
	odd = buf[7]*10 + buf[8];
	if (odd%2 != 0) { return false; }
	if ((buf[11]!=6) && (buf[11]!=7) && (buf[11]!=8) && (buf[11]!=9)) {
		return false;
	}
	multipliers = [2,3,4,5,6,7,8,9,2,3,4,5];
	for(i=0, sum=0; i<12; i++) { sum += (buf[i] *= multipliers[i]); }
	sum = 11 - (sum%11);
	if (sum >= 10) { sum -= 10; }
	sum += 2;
	if (sum >= 10) { sum -= 10; }
	if (sum != buf[12]) { return false }
	return true;
}

// 주민등록번호 유효성 체크
var chkResno = function(resno) {
	fmt = /^\d{6}-[9012345678]\d{6}$/;
	if (!fmt.test(resno)) {
		return false;
	}

	// 재외국인 번호 체크 로직 추가 (2005.03.07) [5:남자(외국), 6:여자(외국) ==> 1900년대 출생, 7:남자(외국), 8:여자(외국) ==> 2000년대 출생]
	if (resno.charAt(7) == '5' || resno.charAt(7) == '6' || resno.charAt(7) == '7' || resno.charAt(7) == '8') {
		return check_fgnno(removeResBar(resno));             // 하이픈 삭제
	// 1:남자(국내), 2:여자(국내)
	} else if (resno.charAt(7) == '1' || resno.charAt(7) == '2') {
		birthYear = '19';
	// 3:남자(국내), 4:여자(국내)
	} else if (resno.charAt(7) == '3' || resno.charAt(7) == '4') {
		birthYear = '20';
	}

	birthYear += resno.substr(0, 2);
	birthMonth = resno.substr(2, 2) - 1;
	birthDate  = resno.substr(4, 2);
	birth = new Date(birthYear, birthMonth, birthDate);

	if (birth.getFullYear() % 100 != resno.substr(0, 2) || birth.getMonth() != birthMonth || birth.getDate() != birthDate) {
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

// 사업자등록번호 포맷 (2005.05.06)
var businoFormat01 = function(id) {
	valid_chk = true;

	t = $('#'+id).val();
	if (t.length == 10) {
		tempStr = t.substring(0,3) + t.substring(3,5) + t.substring(5,10);
	} else if (t.length == 12) {
		if (t.substring(3,4) != '-' || t.substring(6,7) != '-') {
			valid_chk = false;
		}
		tempStr = t.substring(0,3) + t.substring(4,6) + t.substring(7,12);
	} else {
		tempStr = t;

		if (tempStr.length != 0) {
			valid_chk = false;
		}
	}

	if ((!check_busino(tempStr) && tempStr.length != 0) || (valid_chk == false)) {
		//alert('사업자등록번호가 유효하지 않거나 형식이 틀립니다.\n숫자 10자리 형식으로 입력하세요.');
		$('#'+id).focus();
		$('#'+id).select();
		return false;
	// 사업자등록번호 '-'으로 구분 3자리-2자리-5자리
	} else {
		if (tempStr.length != 0) {
			tempStr = tempStr.substring(0,3) + '-' + tempStr.substring(3,5) + '-' + tempStr.substring(5,10);
		}
	}
	$('#'+id).val(tempStr);
	return true;
}

//근로소득,갑근세원청징수 영수증 신청 > 구분 selcet > 갑근세 원천징수 증명서(during001)/근로소득 원천징수 영수증(during002)
function duringSelectChange() {
	if (document.all.duringChange .value=='during001') {
		document.all.duringLayer1.style.display='';
	} else {
		document.all.duringLayer1.style.display='none';
	}
	if (document.all.duringChange.value=='during002') {
		document.all.duringLayer2.style.display='';
	} else {
		document.all.duringLayer2.style.display='none';
	}
}

// Null Check
function checkNull(obj, title) {
	var t = obj.val();
	var ValidFlag = true;
	var msg = title+' 입력하세요.'
	t = rtrim(ltrim(t));
	if (t.length <= 0) {
		alert(msg);
		obj.focus();
		ValidFlag = false;
	}
	return ValidFlag;
}

// 문자의 길이를 구한다
function limitKoText(text, maxlength) {
	val = '';
	var limit = 0;

	for(i = 0; i < text.length; i++) {
		codeChr = text.charCodeAt(i);

		if (codeChr > 255) {
			limit = limit + 2;
		} else {
			limit = limit + 1;
		}

		if (limit > maxlength) {
			return val;
		} else {
			val = val + text.charAt(i);
		}
	}
	return val;
}

function check_length(obj,leng) {
    val = obj.value;
    nam = obj.name;
    len = checkLength(obj.value);
    if (len > leng) {
        vala = limitKoText(val,leng);
        obj.blur();
        obj.value = vala;
        obj.focus();
    }
}
// 전화번호 Check
function phone_check(tel) {
	var m = document.getElementById(tel);
	var phonestr = /0\d{1,2}-\d{3,4}-\d{4}/; // 전화번호 관련 체크 변수 정의
	if (m.value != '') {
		if (!m.value.match(phonestr)) {
			alert('전화번호를 정확하게 입력하세요.\n\n(입력형식 : 02-123-4567)');
			m.focus();
			return false;
		}
		var str = m.value.substr(1,2);
		if (!(str == '2-' || str == '31' || str == '32' || str == '33' || str == '41' || str == '42' || str == '43' ||
			  str == '51' || str == '52' || str == '53' || str == '54' || str == '55' || str == '61' || str == '62' ||
			  str == '63' || str == '64' || str == '70')) {
			alert('지역 번호를 정확하게 입력하세요.');
			m.focus();
			return false;
		}
	}
	return true;
}

//전화번호 Check without alert
function phoneCheck(telno) {
	var phonestr = /0\d{1,2}-\d{3,4}-\d{4}/; // 전화번호 관련 체크 변수 정의
	if (telno != '') {
		if (!telno.match(phonestr)) {
			return false;
		}
		var str = telno.substr(1,2);
		if (!(str == '2-' || str == '31' || str == '32' || str == '33' || str == '41' || str == '42' || str == '43' ||
				str == '51' || str == '52' || str == '53' || str == '54' || str == '55' || str == '61' || str == '62' ||
				str == '63' || str == '64' || str == '70')) {
			return false;
		}
	}
	return true;
}

//진료비 영수증 서식 목록
function showList() {
	var oList = document.all.userList;
	oList.style.visibility = 'visible';

	if (document.onmousedown != null) {
		document.onmousedown();
	}
	document.onmousedown = pageClick;
}
function hideList() {
	listOn = false;
	document.all.userList.style.visibility = 'hidden';
	document.onmousedown = null;
}
function listOver() {
	listOn = true;
	overList = true;
}
function listOut() {
	if (event.srcElement.contains(event.toElement))	return;
	overList = false;
}
function pageClick() {
	if (listOn == true && overList == false) {
		hideList();
	}
}

// 날자형식 Check
function checkdate(input) {
	var validformat = /[0-9]{4}[.][0-9]{2}[.][0-9]{2}/; //Basic check for format validity
	var returnval = false;
	if (!validformat.test(input.val())) {
		alert('날짜 형식이 올바르지 않습니다. YYYY.MM.DD');
		return false;
	}else{
		return true;
	}
}

// 숫자입력 Check
function checkNum(tocheck) {
	var isnum = true;
	var numbers='0123456789';
	if (tocheck == null || tocheck == '') {
		isnum = false;
		return isnum;
	}
	for (var i = 0 ; i < tocheck.length; i++) {
		if (numbers.indexOf(tocheck.substring(i,i+1)) < 0) {
			isnum = false;
			break;
		}
	}
	return isnum;
}

//콤보옵션을 설정함
function setSelectOption(sid, arr, code, name, isEmpty) {

    $('#' + sid).html($.map(arr, function(data, i) {
        return '<option value="' + data[code] + '">' + data[name] + '</option>';
    }));
}

function setObjReadOnly(obj, stat) {

    var o = $(obj).toggleClass('readOnly', stat);
    o.prop(o.is('select,input:radio,input:checkbox') ? 'disabled' : 'readonly', stat);
}

//input의 readonly 상태와 style 변경
//1.arr : input obj 배열 (jquery obj 형태로 넘김)
//2.stat : readonly 상태(true/false)
//예시 : fncSetReadOnly(new Array($('#CONG_WONX')), false);
function fncSetReadOnly(arr, stat) {
	for (var i = 0; i < arr.length; i++) {
		setObjReadOnly(arr[i], stat);
	}
}

//form의 input, textarea, select의 readonly 상태와 style 변경
//1.form : form jquery obj 형태로 넘김
//2.stat : readonly 상태(true/false)
//3.except : readonly 상태변경에서 제외시킬 항목의 id array (생략가능)
//select 는 disable 도 시킨다.
//예시 : fncSetFormReadOnly($('#detailForm'), true, new Array('SPEC_ENTRY'))
function fncSetFormReadOnly(form, stat, except) {
	var x = typeof except != 'undefined' && except.length > 0;
	$(form).find('input,textarea,select').each(function() {
		if (!x || $.inArray($(this).prop('id'), except) == -1) {
		    setObjReadOnly(this, stat);
		}
	});
	form.find('.textPink')[stat ? 'hide' : 'show']();
}

function setReadOnlyTextForm(form, stat, except) {
	var arr = new Array;
	$(form).find('input, textarea, select').each(function() {
			if (typeof except != 'undefined' && except.length>0) {
				if ($.inArray($(this).prop('id'), except) == -1) {
					arr.push($(this));
				}
			}
			else
				arr.push($(this));
		});
	$(form).find('select').each(function() {
			if ($.inArray($(this).prop('id'), except) == -1)
				$(this).attr('disabled', stat);
		});
	setReadOnlyText(arr, stat);
}



function setReadOnlyText(arr, stat) {
	for(var i=0;i<arr.length;i++) {

		var obj = arr[i];

		var type = $(obj).prop('type');
		switch(type) {
			case 'checkbox': $(obj).prop('disabled', stat);
							break;
			default: $(obj).attr('readonly', stat);
		}

		if (stat) {
			$(obj).addClass('inputTR');  // 새로운 클래스를 적용한다.
		} else {
			$(obj).removeClass('inputTR');  // 기존 클래스를 지운다.
		}

	}
}

function removeComma(input) {
	if (input != undefined)
		return input.replace(/,/g, '');
	else
		return input;
}

function banolim(num, pos) {
	if (!isNaN(Number(num))) {
		var posV = Math.pow(10, (pos ? pos : 0));
		return Math.round(num*posV)/posV;
	} else {
		alert('숫자가 아닙니다');
	}
	return num;
}

function olim(num, pos) {
	if (!isNaN(Number(num))) {
		var posV = Math.pow(10, (pos ? pos : 0));
		return Math.ceil(num*posV)/posV;
	} else {
		alert('숫자가 아닙니다');
	}
	return num;
}

function nelim(num, pos) {
	if (!isNaN(Number(num))) {
		var posV = Math.pow(10, (pos ? pos : 0));
		return Math.floor(num*posV)/posV;
	} else {
		alert('숫자가 아닙니다');
	}
	return num;
}

function numberOnly(val) {
	if (val!='' || val!=null) {
		return val.replace(/[^0-9]/gi,'');
	} else {
		return '';
	}
}

var checkNullField = function(obj) {
	var taget = $('#'+obj).children().find('input, select');

	for (var i = 0; i < taget.length; i++) {
		var field = taget[i];

		if (!field.required) continue;
		var fieldname = field.getAttribute('vname');
		if (field.getAttribute('type') === null) {
			if ($('#'+field.getAttribute('id') +' option:selected').val() === '') {
				alert(fieldname + '을(를) 선택하십시오.');
				field.focus();
				return false;
			}
		}else{
			switch (field.getAttribute('type')) {
			case 'text':
			case 'password':
			case 'textarea':
			case 'select-one':
				var data = field.value;
				if (data.search('\\S') == -1) {
					alert(fieldname + '을(를) 입력하십시오.');
					field.focus();
					return false;
				}
				break;
			case 'checkbox':
			case 'radio':
				var element = eval(field.getAttribute('name'));
				if (!checkElements(element)) {
					alert(fieldname + '을(를) 선택하십시오.');
					return false;
				}
				break;
			}
		}
	}
	return true;
}

var checkElements = function(e) {
  for (var i = 0; i < e.length; i++) {
    if (e[i].checked) return true;
  }
  return false;
}

/* ----- 틀고정 테이블 ----- */
function tblHEAD_Fixed() {
	if (!$('.tblBackground').length) return;
	$('.tBodyScroll').each(function() {
		$(this).scroll(function() {
			var xPoint = $(this).scrollLeft(); //divBodyScroll의 x좌표가 움직인 거리
			$(this).parent().find('.tHeadScroll').scrollLeft(xPoint); //가져온 x좌표를 divHeadScroll에 적용시켜 같이 움직일수 있도록 함
		});
	});
}

/* ----- 과거시스템 snsscript 로 부터 옮김 ----- */
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
			if (digit != '.')                   //<.>가 아닌 문자는 누적
			want_val = want_val + digit;
		}
	}
	return want_val;
}
function dayDiff(d1,d2) {
	if (isDate(d1)==true && isDate(d2)==true) {
	  var date1;
		var date2;

		if (d1.length==8) {
		  date1 = new Date(d1.substring(0,4) + '/' + d1.substring(4,6) + '/' + d1.substring(6,8));
    }else if (d1.length==10) {
      date1 = new Date(d1.substring(0,4) + '/' + d1.substring(5,7) + '/' + d1.substring(8,10));
    }

		if (d2.length==8) {
		  date2 = new Date(d2.substring(0,4) + '/' + d2.substring(4,6) + '/' + d2.substring(6,8));
    }else if (d2.length==10) {
      date2 = new Date(d2.substring(0,4) + '/' + d2.substring(5,7) + '/' + d2.substring(8,10));
    }
//		alert('차이는'+Math.ceil((date2 - date1) / 1000 / 24 / 60 / 60));
		return Math.ceil((date2 - date1) / 1000 / 24 / 60 / 60);
	}
	return false;
}
function addSlash(befor) {
    var ret ;
    if (befor.length==8) {
      ret = befor.substring(0,4) + '/' + befor.substring(4,6) + '/' + befor.substring(6,8);
    }else if (befor.length==10) {
      ret = befor.substring(0,4) + '/' + befor.substring(5,7) + '/' + befor.substring(8,10);
    }else {
      ret = false;
    }
    return ret;
}
function isDate(dateStr) {
	var datePat = /^(\d{1,4})(\/|-|.)(\d{1,2})(\/|-|.)(\d{1,2})$/;
	var matchArray = new Array;
	matchArray = dateStr.match(datePat);
	if (matchArray == null) {
			return false;
	}
	year = matchArray[1];
	month = matchArray[3];
	day = matchArray[5];
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
///////////// 문자가 영문인지 한글인지를 확인하고  영문일경우 true를 리턴한다./////////
function checkEnglish(text) {
  val = text;
   for(i = 0; i<val.length; i++) {
        codeChr = val.charCodeAt(i);
        if (codeChr>255) {
            return false;
		}
   }
   return true;
}

// 카드번호 여부 확인(16자리, 숫자 체크)
function isCardNumber(obj) {
	var str = obj;
	if (str.length != 16)
		return false;
	for (var i=0; i<16;i++) {
		if (!('0'<= str.charAt(i) && str.charAt(i) <= '9'))
			return false;
	}
	return true;
}
//문자의 길이를 구한다.(1 byte 문자 length 1 2byte 문자 length 2);
function checkLength(text) {
	val = text;
	var leng = 0;
	for(i = 0; i<val.length; i++) {
		codeChr = val.charCodeAt(i);
		if (codeChr>255) {
			leng = leng+2;
		} else {
			leng = leng+1;
		}
	}
	return leng;
}

function fnPushArr(arr, code, name) {
	var aaa = 'e';

	var narr = eval('[{' + code + ':"", ' + name + ':""}]');
	for (var i = 0; i < arr.length; i++) {
		narr.push(arr[i]);
	}
	return narr;
}

///////////// 금액 체크 ////////////////////////////////////////////////////////////////////////////////////
/*  화면상에 통화키 select list 가 있는경우 이 메소드를 사용한다. 소숫점, 유효문자 체크 통합 */
/*  onKeyUp="javascript:moneyChkForLGchemR3(this,'WAERS');"  WAERS => select Field의 name  */
function moneyChkForLGchemR3(obj, select_field_name) {
    x_field = eval('document.form1.'+select_field_name);
    x_value = x_field[x_field.selectedIndex].value;
    decimal_size = 2;
//이부분은 RFC에 의해 변형
    if (x_value == 'KRW') {
        decimal_size = 0 ;
    }
    if (x_value == 'USD') {
        decimal_size = 2 ;
    }
//이부분은 RFC에 의해 변형
    moneyChkEvent(obj, x_value);
    moneyChkEventWithDecimal(obj, decimal_size);
}

/*  소수점절사단위                                                                 */
/*  일반적으로 moneyChkForLGchemR3() 내부에서만 호출된다                            */
/*  onBlur="javascript:moneyChkEventWithDecimal(this, 3);" ==> 소수세째자리에서 절삭 */
/*  직접입력시에만 절사한다.                                                        */
/*  이미 moneyChkEvent 등이 onKeyUp() 실행되었다고 가정한다.                        */
/*  그래서 obj.value 는 정상적인 값이다.                                            */
function moneyChkEventWithDecimal(obj, decimal_size) {
    d_value = obj.value;
  	d_index = d_value.indexOf('.');
    if (d_index == 0) { // ex) .1234  ==> 0.12
        d_other = d_value.substring(d_index, d_value.length); //d_other = 1234
        d_other = removeComma(removePoint(d_other));
        d_length = d_other.length; //d_length = 4
        if (d_length > decimal_size) {
            obj.value = '0' + d_other.substring(0, decimal_size);
        }else{
            obj.value = '0' + d_other.substring(0, d_length);
        }
    } else if (d_index > 0) { // ex) 123.4567
        d_other = d_value.substring(d_index+1, d_value.length); //d_other = 4567
        d_other = removeComma(removePoint(d_other));
        d_length = d_other.length; //d_length = 4
        if (d_length > decimal_size) {
            obj.value = d_value.substring(0, d_index+1) + d_other.substring(0, decimal_size);
        }else{
            obj.value = d_value.substring(0, d_index+1) + d_other.substring(0, d_length);
        }
    } else {
        obj.value = d_value;
    }
}

/*  통화키단위                                                                      */
/*  onKeyUp="javascript:moneyChkEvent(this);"  ==>  원화 아닌 것                     */
/*  onKeyUp="javascript:moneyChkEvent(this,'\\');"                                   */
/*  onKeyUp="javascript:moneyChkEvent(this,'KRW');"                                  */
/*  onKeyUp="javascript:moneyChkEvent(this,'WAERS');"  WAERS => select Field의 name  */
/*  주의] select Field의 name을 받을경우는 form의 갯수가 하나여야 한다                */
function moneyChkEvent(obj, key) {
    function_len = moneyChkEvent.arguments.length;
    /*원화가 아닐경우 콤마, 숫자, point 허용*/
    if (function_len == 1) {
        moneyChkEventForWorld(obj);
        return;
    /* 원화인 경우 */
    }else if (key=='\\' || key=='KRW') {
        moneyChkEventForWon(obj);
        return;
    }else{
        for (j = 0 ; j < document.form1.elements.length ; j++) {
            if ((document.form1.elements[j].type=='select-one') && (key == document.form1.elements[j].name) && (document.form1.elements[j].value == 'KRW')) {
                moneyChkEventForWon(obj);
                return;
            }
        }
        moneyChkEventForWorld(obj);
        return;
    }
}

/****** 달러등 일반화폐일때 포멧 체크 : onKeyUp="javascript:moneyChkEventForWorld(this);" *******/
function moneyChkEventForWorld(obj) {
    val = obj.value;
    if (unusableFirstChar(obj,',') && usableChar(obj,'0123456789,.')) { // unusableFirstChar에 0 을 뺐다
        addComma(obj);
    }
    /*  onKeyUp="addComma(this)" onBlur="javascript:unusableChar(this,'.');"  */
}

/****** 원화일때 포멧 체크 : onKeyUp="javascript:moneyChkEventForWon(this);" *******/
function moneyChkEventForWon(obj) {
    val = obj.value;
    if (unusableFirstChar(obj,'0,') && usableChar(obj,'0123456789,')) {
        addComma(obj);
    }
    /*  onKeyUp="addComma(this)" onBlur="javascript:unusableChar(this,'.');"  */
}

//연말정산입력시 음수를 입력받기위해서 추가로 생성(2002.12.24.)
function moneyChkEventForWon_1(obj) {
    val = obj.value;
    if (unusableFirstChar(obj,'0,') && usableChar(obj,'-0123456789,')) {
        addComma_1(obj);
    }
    /*  onKeyUp="addComma(this)" onBlur="javascript:unusableChar(this,'.');"  */
}

//=================== onBlur시 사용 ===========================================================================//
function moneyChkForLGchemR3_onBlur(obj, select_field_name) {
    x_field = eval('document.form1.'+select_field_name);
    x_value = x_field[x_field.selectedIndex].value;

    if (obj.value == '') return;             // 값이 입력되지 않은경우..리턴..

    decimal_size = 2;
//이부분은 RFC에 의해 변형
    if (x_value == 'KRW') {
        decimal_size = 0 ;
    }
    if (x_value == 'USD') {
        decimal_size = 2 ;
    }
//이부분은 RFC에 의해 변형
//    moneyChkEvent(obj, x_value);
    moneyChkEventWithDecimal_onBlur(obj, decimal_size);
}

function moneyChkEventWithDecimal_onBlur(obj, decimal_size) {
    d_value = obj.value;
  	d_index = d_value.indexOf('.');
    if (d_index == 0) { // ex) .1234  ==> 0.12
        d_other = d_value.substring(d_index, d_value.length); //d_other = 1234
        d_other = removeComma(removePoint(d_other));
        d_length = d_other.length; //d_length = 4
        if (d_length > decimal_size) {
            obj.value = '0' + d_other.substring(0, decimal_size);
        }else{
            obj.value = '0' + d_other.substring(0, d_length);
        }
    } else if (d_index > 0) { // ex) 123.4567
        d_other = d_value.substring(d_index+1, d_value.length) + '00000'; //d_other = 456700000
        d_other = removeComma(removePoint(d_other));
        d_length = d_other.length; //d_length = 4
        if (d_length > decimal_size) {
            if (decimal_size == 0) {           // KRW경우
                obj.value = d_value.substring(0, d_index);
            } else {
                obj.value = d_value.substring(0, d_index+1) + d_other.substring(0, decimal_size);
            }
        }else{
            if (decimal_size == 0) {           // KRW경우
                obj.value = d_value.substring(0, d_index);
            } else {
                obj.value = d_value.substring(0, d_index+1) + d_other.substring(0, d_length);
            }
        }
    } else {
        if (decimal_size == 0) {           // KRW경우
            obj.value = d_value;
        } else {
            d_other = '00000'; //d_other = 00000
            d_other = removeComma(removePoint(d_other));
            d_length = d_other.length; //d_length = 5
            if (d_length > decimal_size) {
                obj.value = d_value + '.' + d_other.substring(0, decimal_size);
            }else{
                obj.value = d_value + '.' + d_other.substring(0, d_length);
            }
        }
    }
}
//=================== onBlur시 사용 ===========================================================================//
/* *************************************************************** 문의 :  김성일 *** */
function removeResBar2(busino) {
	if (busino.length != 12) {
		return busino;
	}
	return busino.substring(0,3) + busino.substring(4,6) + busino.substring(7,12);
}

//소숫점 이하 자리수 포맷설정하기..
function pointFormat(str, pointnum) {
    var s = str + '';

    if (str == '') return s;

    num1  = s.indexOf('.')             //소숫점이 위치한 곳의 좌표값을 구함
    s2    = s.length;                  //총길이 구하기

    if (num1 != -1) {                    // 소숫점이 있는 경우
        num2 = s.slice(num1+1, s2);     //소숫점 이후의 값저장
        if (num2.length == pointnum) {
            s = s;
        } else if (num2.length < pointnum) {
            for(i = 0 ; i < pointnum - num2.length ; i++) {
                s = s + '0';
            }
        } else if (num2.length > pointnum) {
            s = s.substr(0, (s2 - (num2.length - pointnum)));
        }
    } else {                           // 소숫점이 없는 경우
        for(i = 0 ; i < pointnum ; i++) {
            if (i == 0) {
                s = s + '.0';
            } else {
                s = s + '0';
            }
        }
    }

    return s;
}

function insertComma(value)
{
	var want_val = '';
	var want_val2 = '';
	var resultVal = value+'';
	var imsi = '';
	var dotcnt = 0;
	var reVal = 0;
	var dot = ',';

	for(i=0; i < resultVal.length; i++)    //<,>단위의 표기법을 연산 형식으로 변환
	{
		var digit = resultVal.charAt(i);   //i 이전의 문자를 반영한다
		if (dot != '.' && digit != '.') {		//<,>가 아닌 문자는 누적
			if (digit != ',') want_val = want_val + digit;
		} else {
			dot = '.';
			want_val2 = want_val2 + digit;   //소수이하 숫자
			if (digit == '.') dotcnt = dotcnt + 1;
		}
	}// end for

	var want_amt = want_val;
	for(j=want_amt.length; j > 3; j-=3)         //금액의 마지막 부터 3자리씩 검색
	{
		if (j != want_amt.length)                  //두번째 자리수 부터의 처리루틴
			imsi = ',' + want_amt.substring(j-3,j) +  imsi;
		else                                      //처음 처리시 사용 (예)10000=>10,000
			imsi = ',' + want_amt.substring(j-3,j);
	}
	//모두 처리된후의 나머지 앞단위의 수치를 처리
	if (j<=3)
	{
		var last_val = want_amt.substring(0,j);  //앞 자리
		var prev_val = imsi;                     //이미 처리된 값들
		var end_val  = '';
		imsi = last_val + prev_val;  //최종 값을 입력
		if (want_val2.length > 0)
		{
			end_val = imsi + want_val2;
		} else {
			end_val = imsi;
		}
	}
	return end_val;
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
		alert('날짜가 아닙니다.');
		return;
	}

	if (time.length == 10) {
		yyyy = time.substring(0,4);
		mm	 = time.substring(5,7);
		dd	 = time.substring(8,10);
	} else if (time.length==8) {
		yyyy = time.substring(0,4);
		mm	 = time.substring(4,6);
		dd	 = time.substring(6,8);
	}

	day = dd;
	yearInterval = Math.floor((Number(mm)+Number(interval)-1)/12) ;
	year = Number(yyyy)+yearInterval;
	monthInterval = (Number(mm)+Number(interval))-Math.floor((Number(mm)+Number(interval))/12)*12;
	if ((Number(year) % 4) == 0 && ((Number(year) % 100) != 0 || (Number(year) % 400) == 0))
	{
		if (monthInterval == 0) {
			month = 12;
		} else {
			month = monthInterval;
		}

		if (day > yMonth[Number(month)-1]) {
			day = yMonth[Number(month)-1];
		} else {
			day = dd;
		}
	} else {
		if (monthInterval == 0) {
			month = 12;
		} else {
			month = monthInterval;
		}
		if (day > nMonth[Number(month)-1]) {
			day = nMonth[Number(month)-1];
		} else {
			day = dd;
		}
	}
	for(i = (year+'').length; i < 4 ; i++) {
		year = '0'+year;
	}
	if ((month+'').length < 2) {
		month = '0'+month;
	}
	if ((day+'').length < 2) {
		day = '0'+day;
	}
	return year+''+month+''+day;
}
//사업자등록번호 체크 로직 추가 (2005.03.07)
function check_busino(businoStr) {
  var sum = 0;
  var getlist =new Array(10);
  var chkvalue =new Array('1','3','7','1','3','7','1','3','5');

  for(var i=0; i<10; i++) { getlist[i] = businoStr.substring(i, i+1); }
  for(var i=0; i<9; i++) { sum += getlist[i]*chkvalue[i]; }
  sum = sum + parseInt((getlist[8]*5)/10);
  sidliy = sum % 10;
  sidchk = 0;
  if (sidliy != 0) { sidchk = 10 - sidliy; }
  else { sidchk = 0; }
  if (sidchk != getlist[9]) {
//    alert('사업자등록번호가 유효하지 않습니다.');
    return false;
  }
  return true;
}
//사업자등록번호 포맷 (2005.03.07)
function businoFormat(obj)
{
  valid_chk = true;

	t = obj.value;
	if (t.length == 10) {
		tempStr = t.substring(0,3) + t.substring(3,5) + t.substring(5,10);
	} else if (t.length == 12) {
	  if (t.substring(3,4) != '-' || t.substring(6,7) != '-') {
	    valid_chk = false;
	  }
		tempStr = t.substring(0,3) + t.substring(4,6) + t.substring(7,12);
	} else {
	  tempStr = t;

	  if (tempStr.length != 0) {
	    valid_chk = false;
		}
	}

  if ((!check_busino(tempStr) && tempStr.length != 0) || (valid_chk == false)) {
    alert('사업자등록번호가 유효하지 않거나 형식이 틀립니다.\n숫자 10자리 형식으로 입력하세요..');
		obj.focus();
		obj.select();
		return false;
// 사업자등록번호 '-'으로 구분 3자리-2자리-5자리
	} else {
	  if (tempStr.length != 0) {
	    tempStr = tempStr.substring(0,3) + '-' + tempStr.substring(3,5) + '-' + tempStr.substring(5,10);
	  }
  }
  obj.value = tempStr;
  return true;
}

function checkBusino(val) {
	valid_chk = true;

	t = val;
	if (t.length == 10) {
		tempStr = t.substring(0,3) + t.substring(3,5) + t.substring(5,10);
	} else if (t.length == 12) {
	  if (t.substring(3,4) != '-' || t.substring(6,7) != '-') {
	    valid_chk = false;
	  }
	  tempStr = t.substring(0,3) + t.substring(4,6) + t.substring(7,12);
	  if (!checkNum(tempStr))valid_chk = false;

	} else {
		  tempStr = t;

		  if (tempStr.length != 0) {
		    valid_chk = false;
			}
	}
	if (!valid_chk) {
		alert('사업자등록번호가 유효하지 않거나 형식이 틀립니다.\n숫자 10자리 형식으로 입력하세요.');
		return false;
	}

	return true;
}

function addBizNo(val)
{
  valid_chk = true;

	t = val;
	if (t.length == 10) {
		tempStr = t.substring(0,3) + t.substring(3,5) + t.substring(5,10);
	} else if (t.length == 12) {
	  if (t.substring(3,4) != '-' || t.substring(6,7) != '-') {
	    valid_chk = false;
	  }
		tempStr = t.substring(0,3) + t.substring(4,6) + t.substring(7,12);


	} else {
	  tempStr = t;

	  if (tempStr.length != 0) {
	    valid_chk = false;
		}
	}
  //if ((!check_busino(tempStr) && tempStr.length != 0) || (valid_chk == false)) {
   // alert('사업자등록번호가 유효하지 않거나 형식이 틀립니다.\n숫자 10자리 형식으로 입력하세요.');

		//return val;
// 사업자등록번호 '-'으로 구분 3자리-2자리-5자리
	//} else {

	if (numberOnly(tempStr).length<10) {
		alert('사업자등록번호가 유효하지 않거나 형식이 틀립니다!\n숫자 10자리 형식으로 입력하세요.');
		return val;
	}

	tempStr = numberOnly(tempStr);

	if (tempStr.length != 0) {
	    tempStr = tempStr.substring(0,3) + '-' + tempStr.substring(3,5) + '-' + tempStr.substring(5,10);
	  }
  //}

  return tempStr;
}

//단순히 숫자와 '-'만을 체크한다.
function phone_1(obj) {
	var resultVal = obj.value;
	var num='0123456789-';

	if (resultVal.length != 0)	{
		for(var i=0; i < resultVal.length ;i++) {
			if (-1 == num.indexOf(resultVal.charAt(i))) {
				alert('잘못된 값을 입력하셨습니다.');
				obj.focus();
				obj.select();
				return false;
			}
		}
	}
	return true;
}

function dateFormat(obj)
{
  valid_chk = true;

	t = obj.value;
	if (t.length == 8)
	{
		tempStr = t.substring(0,4) + '.' + t.substring(4,6) + '.' + t.substring(6,8);
	} else if (t.length == 10) {
	  if (t.substring(4,5) != '.' || t.substring(7,8) != '.') {
	    valid_chk = false;
	  }

		tempStr = t.substring(0,4) + '.' + t.substring(5,7) + '.' + t.substring(8,10);

	} else {
	  tempStr = t;

	  if (tempStr.length != 0) {
	    valid_chk = false;
		}
	}

  if ((!isDate(tempStr) && tempStr.length != 0) || (valid_chk == false)) {
    alert('날짜 형식이 틀립니다.\n\'YYYYMMDD\' 형식으로 입력하세요.');
		obj.focus();
		obj.select();
		return false;
	}
  obj.value = tempStr;
  return true;
}

Date.prototype.format = function(f) {

    if (!this.valueOf()) return ' ';

    var weekName = ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'];
    var d = this;

    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
        switch ($1) {
          case 'yyyy': return d.getFullYear();
          case 'yy': return (d.getFullYear() % 1000).zf(2);
          case 'MM': return (d.getMonth() + 1).zf(2);
          case 'dd': return d.getDate().zf(2);
          case 'E': return weekName[d.getDay()];
          case 'HH': return d.getHours().zf(2);
          case 'hh': return ((h = d.getHours() % 12) ? h : 12).zf(2);
          case 'mm': return d.getMinutes().zf(2);
          case 'ss': return d.getSeconds().zf(2);
          case 'a/p': return d.getHours() < 12 ? '오전' : '오후';
          default: return $1;
        }
    });
};

String.prototype.string = function(len) {var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.zf = function(len) {return '0'.string(len - this.length) + this;};
Number.prototype.zf = function(len) {return this.toString().zf(len);};

//단건, 다건 구분....
function setTableText(arr, formid, type) {
	if (Array.isArray(arr)) {
		$.each(arr, function(i, data) {
			getFormData(data, formid, i, type);
		});
	} else {
		getFormData(arr, formid, 0, type);
	}
};

function getFormData(data, formid, i, arr) {
	for (var key in data) {
	     if (data[key]) {
			 $('#' + formid + ' [name="' + key + '"]').each(function() {
			     setTagValue(this, data[key], data, arr);
			 });
		 }
	}
	//자동숫자
	var numb = $('#' + formid + ' [name="autoNumbering"]');
	$.each(numb, function(i,num) {
		$(num).text(i+1);
	});
}

function setHidden(sh) {
	if (sh) {
		$('#hiddenPrint').hide();
	} else {
		$('#hiddenPrint').show();
	}
}

function setArrTableText(obj, table, idx, arr) {
	var tr = $('#' + table + ' tr').eq(idx);
	if (obj.length==0) {
		var td = $(tr).find('td').length;
		$(tr).html('<td colspan='+td+' style="text-align:center">no data</td>');
		return;
	}
	for(var i=0;i<obj.length-1;i++) {
		//추가
		var target = $('#' + table + ' tr').eq(idx+i);
		target.after(tr.clone());
		//tr.clone().appendTo($('#' + table));
	}
	setTableText(obj, table, arr);
}

function setTagValue(obj, val, addValue, arr) {
	var t = $(obj), tag = t.prop('tagName');
	if (val == '0000.00.00' || val == null) val = '';

	switch (t.attr('format')) {
		case 'currency':
			if (val == '' || val == null) {
			    val = Number('');
			} else {
			    val = val.format();
			}
			break;
		case 'emptyCur':
			if (val == '0' || val == '' || val == null) {
			    val = '';
			} else {
			    val = val.format();
			}
			break;
		case 'resNo':
			if (val == '' || val == null) {
			    val = '';
			} else {
			    val = addResBar(val);
			}
			break;
		case 'curWon':
			if (val == '' || val == null) {
			    val = '';
			} else {
			    val = Math.floor(val).format() + ' 원';
			}
			break;
		case 'bizNo':
			if (val == '' || val == null) {
			    val = '';
			} else {
			    val = addBizNo(val);
			}
			break;
		case 'daysKR':
			if (val == '' || val == null) {
			    val = '';
			} else {
			    val = numberOnly(val) + ' 일';
			}
			break;
		case 'dateKR':
			if (val == '' || val == null) {
			    val = '';
			} else {
				val = numberOnly(val);
				val = val.substring(0,4) + '년 ' + Number(val.substring(4,6)) + '월 ' + Number(val.substring(6,8)) + '일';
			}
			break;
		case 'dateB':
			if (val == '' || val == null) {
			    val = '';
			} else {
				val = numberOnly(val);
				val = val.substring(0,4) + '.' + val.substring(4,6) + '.' + val.substring(6,8);
			}
			break;
		case 'yearMonth':
			if (val == '' || val == null) {
			    val = '';
			} else {
				val = numberOnly(val);
				val = val.substring(0,4) + '.' + val.substring(4,6);
			}
			break;
		case 'year':
			if (val == '' || val == null||val=='0000') {
			    val = '';
			}
			break;
		case 'replace':
			var code = t.attr('code');
			var codeNm = t.attr('codeNm');
			var type = t.attr('name');

			var codeArr;
			//코드 꺼냄
			$.each(arr, function(i, data) {
				for (var key in data) {
					if (key == type) {
						codeArr = data[key];
						return false;
					}
				}
			});

			var chk = true;
			//코드 돌림
			$.each(codeArr, function(j, cdata) {
				for (var key in cdata) {
					if (cdata[code] == val) {
					    val = cdata[codeNm];
						chk = false;
						return false;
					}
				}
			});

			if (chk) val = '';
			break;
		case 'time':
			if (val == '' || val == null) {
			    val = '';
			} else {
				if (val.length < 4) {
				    val = '';
				} else {
					val = numberOnly(val);
					val = val.substring(0,2) + ':' + val.substring(2,4);
				}
			}
			break;
	}

	switch (tag) {
		case 'INPUT':
			var type = t.prop('type');
			if (type == 'checkbox' && val != '') {
				t.prop('checked', true);
				break;
			} else if (type == 'radio') {
				$('input:radio[name="' + t.attr('name') + '"]')
				    .prop('checked', false)
				    .filter('[value="' + val + '"]')
				    .prop('checked', true);
				break;
			}
		case 'SELECT':
			t.val(val);
			break;
		default :
			t.text(val);
			var add = t.attr('addValue');
			if (add != undefined && val != '') {
				$addVal = addValue[add];
				if ($addVal== '0000.00.00') $addVal = '';

				if (t.attr('addformat') == 'period' && $addVal != '') {
					$addVal = t.text()+' ~ '+$addVal;
				} else if (t.attr('addformat') == 'bracket' && $addVal != '') {
					$addVal = t.text()+'('+$addVal+')';
				} else if (t.attr('addformat') == 'blank' && $addVal != '') {
					$addVal = t.text()+' '+$addVal;
				} else if (t.attr('addformat') == 'enter' && $addVal != '') {
					$addVal = t.text()+'\n'+$addVal;
				} else {
					$addVal = t.text()+$addVal;
				}

				t.text($addVal);
			}
	}
}

function getDayInterval(date1,date2) {

    var day = 1000 * 3600 * 24;
	return parseInt((date2 - date1) / day, 10) + 1;
}

function chkResnoObj_1(obj) {
	var resno = obj.value;
	if (resno.length == 13) {
		tempStr = resno.substring(0,6) + '-' + resno.substring(6,13);
	} else if (resno.length == 14) {
		tempStr = resno;
	} else if (resno.length == 0) {
	  return true;
	} else {
		alert('주민등록번호 형식이 적당하지 않습니다.');
		obj.focus();
		obj.select();
		return false;
	}
	if (chkResno(tempStr)) {
		obj.value = tempStr;
		return true;
	} else {
		alert('주민등록번호가 유효하지 않습니다.');
		obj.focus();
		obj.select();
		return false;
	}
}

//GRID HEADER
/******************************************
headerRowRenderer 에서
var arr = new Array(new Array(3, 9,'추가공제'));
return setGridHeader(this, arr);
이런 식으로 사용

colspan이 여러개 일 경우
new Array(new Array(3, 9,'추가공제'), new Array(11, 14,'테스트'))
형식으로 추가하여 사용
**********************************************/
function setGridHeader(grid, arr) {

	$tr = $('<tr>').height('0%');
	grid._eachField(function(field, index) {
		if (field.visible) {
        	var $th = $('<th>').width(field.width).appendTo($tr);
		}
    });

	//rowspan과 colspan
	$tr1 = $('<tr>');
	grid._eachField(function(field, index) {
		//합치는 만큼 돌기
		if (field.visible) {
			var chkIndex = true;
			var title = '';
			var sIndex;
			var eIndex;
			$.each(arr, function(i, data) {
				//index 영역 점검
				if (index>data[0] && index<data[1]) {
					chkIndex = false;
					title = data[2];
					sIndex = data[0];
					eIndex = data[1];
					return;
				}
			});

			if (chkIndex) {
				var $th = $('<th>').html(field.title).attr('rowspan', 2).appendTo($tr1);
			} else {
				if (index == sIndex+1) {
					var $th = $('<th>').html(title).attr('colspan', eIndex-sIndex-1).appendTo($tr1);
				}
			}
		}
	});

	$tr = $tr.add($tr1);

	//마지막
	$tr2 = $('<tr>');
	grid._eachField(function(field, index) {
		if (field.visible) {
			$.each(arr, function(i, data) {
				//index 영역 점검
				if (index>data[0] && index<data[1]) {
					var $th = $('<th>').html(field.title).width(field.width).appendTo($tr2);
				}
			});
		}
	});

	$tr = $tr.add($tr2);

	return $tr;
}

function setVectorOption(id, jsonData) {

    $('#'+id).empty();
	$('#'+id).append('<option value=" ">--</option>');
	$.each(jsonData, function (key, value) {
		$('#'+id).append('<option value=' + value.code + '>' + value.value + '</option>');
	});
}

// LGMMA 1000 미만 단수절상
function money_olim(val_int) {

    return olim(val_int, -3);
};

// 정규표현식을 사용하여 입력한 폰번호를 체크 합니다.
function mobileCheck(phoneNumber) {

    var regExp = /(01[0|1|6|9|7])[-](\d{3}|\d{4})[-](\d{4}$)/g; // ^01[01679]\-\d{3,4}\-\d{4}$

    // exec 는 정규표현식 대입하여 부합하는 값을 반환 합니다. 값이 없으면 null 입니다.
	return regExp.exec(phoneNumber) ? true : flase;
}

// 신청/결재 기한 button 설정
function setRequestOrApprovalDeadlineProperty(p) {

    var wrapper = p.wrapper ? p.wrapper + ' ' : '', TPGUB_CD = p.TPGUB === 'C' || p.TPGUB === 'D';

    $(wrapper + 'a[name="RADL-button"]')
        [TPGUB_CD ? 'show' : 'hide']()
        [TPGUB_CD ? 'data' : 'removeData']('datum', p.DATUM || '');
}

function popupRequestOrApprovalDeadline(e) {

    $('body').loader('show', '<img style="width:50px;height:50px" src="/web-resource/images/img_loading.gif">');

    var target = $(e.currentTarget), TPGUB = target.data('tpgub'), DATUM = target.data('datum');

    $('<div class="layerWrapper layerSizeM" id="popLayerRequestOrApprovalDealine">').append([
        '<div class="layerHeader"><strong>신청/결재 기한</strong> <a href="#" class="btnClose popLayerRequestOrApprovalDealine_close">창닫기</a></div>',
        '<div class="layerContainer">',
            '<div class="layerContent">',
                '<div class="listArea" style="padding:0 0 14px 0">',
                    '<h2 class="subtitle align-right" style="width:100%">D : 근태일</h2>',
                    '<div class="table" style="margin-bottom:20px"><!-- content table --></div>',
                    '<div class="tableComment">',
                        '<p><span class="bold">조위, 승중상, 출산을 사유로 하는 경조공가는 기한 적용 제외</span></p>',
                        '<p>- 단, 반드시 복귀시 해당 월의 평일 초과근무 발생전 경조공가 신청/승인 필요</p>',
                    '</div>',
                '</div>',
            '</div>',
        '</div>'
    ].join(''))
    .draggable()
    .popup({
        autoopen: true,
        transition: null,
        beforeopen: function() {
            $(this).find('.table').load('/popup/requestOrApprovalDeadline table', {
                DATUM: (DATUM || '').replace(/[^\d]/g, ''), // 일자를 선택하는 화면에서 선택된 일자 기준으로 조회해야할 때 사용
                TPGUB: TPGUB || '' // 로그인한 사원의 사원구분이 아닌 강제로 사원구분을 넣을 때 사용
            });
            $('body').loader('hide');
        },
        closetransitionend: function() {
            $(this).parents('.popup_wrapper').remove();
        }
    });
}

function downloadPdfReader() {

    alert('가이드 및 FAQ 가 보이지 않는 경우,\n기존 PDF 뷰어 프로그램을 삭제하시고\n다운로드한 파일을 압축해제 후 재설치 바랍니다.');

    var src = 'https://open.lgmma.com:444/template/Download/AdbeRdr1000_ko_KR.zip',
    iframe = $('iframe#pdfDownloader');
    if (iframe.length) {
        iframe.attr('src', src);
    } else {
        $('<iframe id="pdfDownloader" style="display:none" src="' + src + '">').appendTo('body');
    }
}

$(function() {
    menuActive();
    shuttleTree();
    $(document).on('click', 'a[name="RADL-button"]', popupRequestOrApprovalDeadline); // 신청/결재 기한 button
});