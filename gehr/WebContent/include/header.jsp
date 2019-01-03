<%--
/*                      2017-09-28 이지은 [CSR ID:3497450] 주소 검색 창 오픈 안됨   */
--%>
<%--<%@elvariable id="g" type="com.common.Global" %> --%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="com.common.Global" %>
<%@ page import="com.common.Utils" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="org.apache.commons.lang.BooleanUtils" %>
<%@ page import="org.apache.commons.lang.ObjectUtils" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%
    String modal = request.getParameter("modal");
    String viewSource = ObjectUtils.toString(request.getAttribute("viewSource"));

    if(WebUtil.isLocal(request)) viewSource = "true";

    boolean isUpdate = false;
    try {
        isUpdate = BooleanUtils.toBoolean(ObjectUtils.toString(request.getAttribute("isUpdate")));
    } catch(Exception e) {}
%>
<html>
<head>
    <%  if("true".equals(modal)) { %>
    <BASE target="_self">
    <%  } %>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type"     content="text/html; charset=UTF-8">
    <meta http-equiv="Pragma"           content="no-cache"/>
    <meta http-equiv="Cache-Control"    content="no-cache"/>
    <meta http-equiv="Expires"          content="-1"/>
    <meta http-equiv="p3p"              content="CP='CAO DSP AND SO'" policyref="/w3c/p3p.xml" />
    <meta http-equiv="X-XSS-Protection" content="0; mode=block;" />
    <meta name="robots"                 content="none,noindex,nofollow"/>
    <meta http-equiv="X-UA-Compatible"  content="IE=${param.EdgeMode eq 'Y' or EdgeMode eq 'Y' ? 'Edge' : '8'}">
    <title>${!empty param.title ? param.title : (!empty title ? title : 'ESS')}</title>

<%
    String unblock = request.getParameter("unblock");
    Global g = Utils.getBean("global");

%>
    <link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
    <link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
    <link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">
    <link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ui_jquery.css?v1" type="text/css">
<%
    String noCache = StringUtils.defaultString(request.getParameter("noCache"), ObjectUtils.toString(request.getAttribute("noCache")));

    String [] cssNames = request.getParameterValues("css");
    if (cssNames != null) {
        for (String cssName : cssNames) {
            if (StringUtils.isEmpty(cssName)) continue;
            if (StringUtils.contains(cssName, ",")) {
                for (String splitCssName : cssName.split(",")) {

%>
    <link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/<%= splitCssName.trim() %><%= splitCssName.indexOf("?") > -1 ? noCache.replaceAll("^\\?", "&") : noCache %>" type="text/css"><%
                }
            } else {
%>
    <link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/<%= cssName %><%= cssName.indexOf("?") > -1 ? noCache.replaceAll("^\\?", "&") : noCache %>" type="text/css"><%
            }
        }
    }
%>

    <script language="javascript">
//     	var console = window.console || {log:function(){}};
//     	try {
//         	console = ((top || {}).window || {}).console || window.console || {log: function() {}};
//     	} catch (e) {
//         	console = {log: function() {}};
//     	}
        window.currency = "${g.sapType.local ? 'KRW' : 'USD'}";

        <%-- 2018.04.26 [WorkTime52] 주52시간 근무제 대응 --%>
        var LOCALE = '${g.locale}';
        <%-- js 파일 내에서 java 변수 WebUtil.ServletURL, WebUtil.JspURL, WebUtil.ImageURL을 사용할 수 있도록 javascript 변수로 셋팅하고
             이 파일 하단에 정의되어있는 getServletURL, getJspURL, getImageURL function을 호출하여 사용한다. --%>
    	var URL_PREFIX = {
    	    servlet: '${g.servlet}',
    	    jsp: '${g.jsp}',
    	    image: '${g.image}'
    	};
    </script>

    <script language="javascript" src="<%= WebUtil.ImageURL %>js/jquery-1.12.4.min.js?v1"></script>
    <script language="javascript" src="<%= WebUtil.ImageURL %>js/jquery.blockUI.js?v1"></script>
    <script language="javascript" src="<%= WebUtil.ImageURL %>js/promise-7.0.4.min.js?v1"></script>
    <script language="javascript" src="<%= WebUtil.ImageURL %>js/underscore.js?v1"></script>
    <script language="javascript" src="<%= WebUtil.ImageURL %>js/json2.js?v1"></script>

    <script language="javascript" src="<%= WebUtil.ImageURL %>js/jquery-ui-1.10.0.js?v1"></script>
    <script language="javascript" src="<%= WebUtil.ImageURL %>js/i18n/jquery.ui.datepicker-<%= g.getLocale() %>.js?v1"></script>
    <script language="javascript" src="<%= WebUtil.ImageURL %>js/jquery.validate.min.js?v1"></script>
    <script language="javascript" src="<%= WebUtil.ImageURL %>js/jquery.maskedinput.min.js?v1"></script>
    <script language="javascript" src="<%= WebUtil.ImageURL %>js/jquery.keyfilter.js?v1"></script>
    <script language="javascript" src="<%= WebUtil.ImageURL %>js/autoNumeric.min.js?v1"></script>

    <script language="javascript" src="<%= WebUtil.ImageURL %>js/common.js"></script>
    <script language="javascript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
    <script language="javascript" src="<%= WebUtil.ImageURL %>js/postcode.v2.js"></script><!-- [CSR ID:3497450] -->
<%
        String [] scripts = request.getParameterValues("script");
        if (scripts != null) {
            for (String script : scripts) {
                if (StringUtils.isEmpty(script)) continue;
                if (StringUtils.contains(script, ",")) {
                    for (String splitScript : script.split(",")) {
%>
    <script language="javascript" src="<%= WebUtil.ImageURL %>js/<%= splitScript.trim() %><%= splitScript.indexOf("?") > -1 ? noCache.replaceAll("^\\?", "&") : noCache %>"></script><%
                    }
                } else {
%>
    <script language="javascript" src="<%= WebUtil.ImageURL %>js/<%= script %><%= script.indexOf("?") > -1 ? noCache.replaceAll("^\\?", "&") : noCache %>"></script><%
                }
            }
        }
%>
    <script language="javascript">
        function isValid(_formID) {
            return _validator[_formID].form();
        }

        var _validator = new Object();

        $(function () {
        <%  if (!"true".equals(viewSource) && !isUpdate) { %>
            try {
                document.oncontextmenu = function () {
                    return false;
                };<% if (!"Y".equals(request.getAttribute("Draggable"))) { /* 근무시간입력 화면 layer popup draggable 처리를 위해 */ %>
                document.ondragstart = function () {
                    return false;
                };<% } %>
                document.onselectstart = function () {
                    return false;
                };
            } catch(e) {}
        <%  } %>

        <%  if(!StringUtils.equals(unblock, "false")) { %>
            $.unblockUI();
            try {
                if (window.parent && window.parent.$) window.parent.$.unblockUI();
            } catch(e) {}
        <%  } %>

            $(".listTable tbody").children("tr").addClass("listTableHover");


        <%  if(!"true".equals(request.getParameter("external"))) { %>
            /* iframe 내부일 경우 css 적용  확인중 */
            try {
            if(window != parent && parent && parent.frames["framesets"] == undefined) {
                $(".title:not(.always)").hide();
                $(".subWrapper:not(.always)").addClass("iframeWrap");
            }
            } catch(e) {}
        <%  } %>

            //달력
            addDatePicker($('.date'));


            jQuery.validator.addClassRules("money", ({number: true}));
            jQuery.validator.addMethod("date", function(value, element) {
                return this.optional(element) || checkDate(value, true);
            });

//            jQuery.validator.addClassRules("fromDate", ({fromDate: true}));
            jQuery.validator.addMethod("fromDate", function(value, element) {
                if(this.optional(element)) return true;

                var _$target = $(element);
                var _toDateId = _$target.data("toDate");
                if (!_.isEmpty(_toDateId)) {
                    if(_$target.stripVal() > $("#" + _toDateId).stripVal()) return false;
                }

                return true
            });

            jQuery.validator.addClassRules("toDate", ({toDate: true}));
            jQuery.validator.addMethod("toDate", function(value, element) {
                if(this.optional(element)) return true;

                var _$target = $(element);
                var _fromDateId = _$target.data("fromDate");
                if (!_.isEmpty(_fromDateId)) {
                    if(_$target.stripVal() < $("#" + _fromDateId).stripVal()) return false;
                }

                return true
            });

            /**
             * validateRow, masking 및 keyevent 처리
             */
            setValidate($("form"));
        });

        $.extend($.validator.messages, {
            required: '<spring:message code="script.validate.required" />',
            email: '<spring:message code="script.validate.email" />',
            date: '<spring:message code="script.validate.date" />',
            dateISO: '<spring:message code="script.validate.dateISO" />',
            number: '<spring:message code="script.validate.number" />',
            digits: '<spring:message code="script.validate.digits" />',
            equalTo: '<spring:message code="script.validate.equalTo" />',
            accept: '<spring:message code="script.validate.accept" />',
            maxlength: $.validator.format('<spring:message code="script.validate.maxlength" />'),
            minlength: $.validator.format('<spring:message code="script.validate.minlength" />'),
            rangelength: $.validator.format('<spring:message code="script.validate.rangelength" />'),
            range: $.validator.format('<spring:message code="script.validate.range" />'),
            max: $.validator.format('<spring:message code="script.validate.max" />'),
            min: $.validator.format('<spring:message code="script.validate.min" />'),
            blankItem : '<spring:message code="script.validate.blankItem" />',
            fromDate : '<spring:message code="script.validate.term" />',
            toDate : '<spring:message code="script.validate.term" />'
        });




        var _showLoading = function(p, count) {
            if(count == 0) return;
            p = p || window.parent;
            count = count || 5;
            try {
            if(p && p["showLoading"]) window.onbeforeunload = p["showLoading"];
            else if(p && p.parent && p !== p.parent) _showLoading(p.parent, --count);
            else return ;
            } catch(e) {}
        };

        function setBeforeUnload() {
            _showLoading();
            /*window.onbeforeunload = _showLoading();*/
        };

        function blockFrame() {
            $.blockUI({ message : '<spring:message code="MSG.COMMON.WAIT" />' });
        }

	/**************************************************************************************************
			snsscript.js에서 옮겨옴 (메시지 다국어 처리를위해)
	***************************************************************************************************/
        function checkNull(obj, title)
        {
        	var t = obj.value;
        	var ValidFlag = true;
        	var msg = "<spring:message code='script.validate.required2' arguments='"+title+"' />"; // title+" 입력하세요."
        	t = rtrim(ltrim(t));
        	if (t.length <= 0)
        	{
        		alert( msg );
        		obj.focus();
        		ValidFlag = false;
        	}
        	return ValidFlag;
        }

		////////////반올림, 올림, 내림///////////////
		function banolim(num, pos) {
		if( !isNaN(Number(num)) ){
			var posV = Math.pow(10, (pos ? pos : 0));
			return Math.round(num*posV)/posV;
		} else {
			alert("<spring:message code='MSG.COMMON.0026' />"); // 숫자가 아닙니다
		}
		return num;
		}

		function olim(num, pos) {
			if( !isNaN(Number(num)) ){
				var posV = Math.pow( 10, (pos ? pos : 0) );
				return Math.ceil(num*posV)/posV;
			} else {
				alert("<spring:message code='MSG.COMMON.0026' />"); // 숫자가 아닙니다
			}
			return num;
		}



		///////////// 숫자 포맷 ////////////////
		function addComma(obj)
		{
		var want_val = '';
		var want_val2 = '';
		var resultVal = obj.value;
		var imsi = '';
		var dotcnt = 0;
		var reVal = 0;
		var dot = ',';
		var num="0123456789.,";   //숫자만 들어갈때
		if (resultVal.length != 0)
		{

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
					alert("<spring:message code='MSG.COMMON.0027' />");//정확한 데이타를 넣어주세요
					obj.value = end_val.substring(0,end_val.length-1);
				}
			} else {   // end if 2
				alert("<spring:message code='MSG.COMMON.0027' />");//정확한 데이타를 넣어주세요
				obj.value = '';
			}
		}//end if 3
		obj.focus();
		return;
		//수량을 입력되지 않을 경우
		if (resultVal.length == 0)
		{
			obj.focus();//입력 필드로 이동
			return false;
		}
		}

		<%-- 2018.04.26 [WorkTime52] 주52시간 근무제 대응 --%>
		function getWaitURL(target) {
		    return URL_PREFIX.jsp + 'common/wait.jsp?url=' + (target || '');
		}
		function getServletURL(target) {
		    return URL_PREFIX.servlet + (target || '');
		}
		function getJspURL(target) {
		    return URL_PREFIX.jsp + (target || '');
		}
		function getImageURL(target) {
		    return URL_PREFIX.image + (target || '');
		}
    </script>
</head>