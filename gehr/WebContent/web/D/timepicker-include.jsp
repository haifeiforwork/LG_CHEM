<%--
		timepicker 사용공통모듈; 휴가, 초과근무신청에서 호출
		; D03VocationBuild.jsp, D03VocationBuild_Global.jsp, D03VocationBuild_DE.jsp, D03VocationBuild_US.jsp , D03VocationBuild_PL.jsp
		; D01OTBuild_KR.jsp, D01OTBuild_Global.jsp

		아이콘보이기/숨기기          $('.timeStart').timepicker('hide/show');
		시간범위지정;     	$('.timeStart').timepicker('option','hourMin',9);
						    	$('.timeStart').timepicker('option','hourMax',14);

 --%>

<%@ page import="com.common.Global" %>
<%@ page import="com.common.Utils" %>

<%     Global g = Utils.getBean("global"); %>

<%--CSS --%>
<link href="/web/images/css/jquery-ui-timepicker-addon.css" rel="stylesheet" type="text/css"/>
<!-- <link rel="stylesheet" media="all" type="text/css" href="http://code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css" /> -->

<script src="/web/images/js/jquery-ui-timepicker-addon.js" type="text/javascript" ></script>
<script type="text/javascript" src="/web/images/js/jquery-ui-timepicker-addon-i18n.min.js"></script>
<%--Globalization --%>
<script language="JavaScript" src="/web/images/js/i18n/jquery-ui-timepicker-<%=g.getLocale()%>.js"></script>

<script>
$(function(){

	// 2달치달력보이기
// 	$('.date').datepicker('option','numberOfMonths',2);


    //시계  // 속성개별수정시 : $(timeobj).timepiker('option','hourMin', 9);..
    // 보이기속성제어; $(timeobj).show(), hide()
	$('.time').timepicker({
		currentText:"", showButtonPanel:false,
		controlType: 'select',oneLine: true,
 		defaultValue:'00:00',
		buttonImage:"/web/images/icon_time.gif",
		timeFormat: 'HH:mm',
		onSelect: function(){
			check_Time();
		}
	});
	$('.timeRoBe').timepicker({
		currentText:"", showButtonPanel:false,
		oneLine: true,
		controlType: 'select',
		hourMin:0, hourMax:23,
		buttonImage:"/web/images/icon_time.gif",
		timeFormat: 'HH:mm:ss',
		onClose:function(){
            var element = $(this);
            if(element.val() == "" || element.val() == "__:__:__"){
            	element.val("00:00:00");
            }
		}
	});
	$('.timeRoEn').timepicker({
		currentText:"", showButtonPanel:false,
		oneLine: true,
		controlType: 'select',
		hourMin:0, hourMax:24,
		buttonImage:"/web/images/icon_time.gif",
		timeFormat: 'HH:mm:ss',
		onClose:function(){
            var element = $(this);
            if(element.val() == "" || element.val() == "__:__:__"){
            	element.val("00:00:00");
            }
		}
	});

	$('.timeStart').timepicker({controlType: 'select',oneLine: true,
		timeFormat: 'HH:mm', showButtonPanel:false,
		hourMin:9, hourMax:18,
		buttonImage:"/web/images/icon_time.gif",
		onSelect: function(){
			check_Time('BEGUZ');
		}
	});

	$('.timeEnd').timepicker({controlType: 'select',oneLine: true,
		timeFormat: 'HH:mm',showButtonPanel:false,
		hourMin:9, hourMax:18,
		buttonImage:"/web/images/icon_time.gif",
		onSelect: function(){
			check_Time('ENDUZ');
		}

	});
})
</script>