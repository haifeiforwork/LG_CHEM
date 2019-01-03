<%--
/********************************************************************************/
/*   System Name  : MSS															*/
/*   1Depth Name  : 조직관리														*/
/*   2Depth Name  : 조직/인원현황													*/
/*   Program Name : 실근무 실적현황												*/
/*   Program ID   : D25WorkTimeLeaderReportFrame.jsp							*/
/*   Description  : 실근무시간 관리 frame											*/
/*   Note         : 															*/
/*   Creation     : 2018-05-28 [WorkTime52] 성환희								*/
/*   Update       : 															*/
/********************************************************************************/
--%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- html 시작 선언 및 head 선언 --%>
<%-- * 참고 *
     아래 noCache 변수는 css와 js 파일이 browser에서 caching 되는 것을 방지하기위한 변수이다.
     운영모드에서 css와 js 파일이 안정화되어 수정될 일이 없다고 판단되는 경우 browser에서 caching 되도록 하여 server 부하를 줄이고자한다면 noCache 변수를 삭제한다.

     noCache 변수 삭제 후 운영중에 css나 js 파일이 변경되면 browser의 cache를 사용자가 직접 삭제해줘야하는데 이런 번거로움을 없애려면 noCache 변수를 다시 넣으면된다.

     주의할 점은 jsp:include tag 내부에서는 주석이 오류를 발생시키므로
     주석으로 남기고 싶은 경우 noCache 변수 line을 jsp:include tag 외부로 빼서 주석처리하거나
     변수명을 noCache에서 noCacheX 등으로 변경한다. --%>
<jsp:include page="/include/header.jsp">
    <jsp:param name="noCache" value="?${timestamp}" />
    <jsp:param name="css" value="bootstrap-3.3.2.min.css" />
    <jsp:param name="css" value="D/D25WorkTime.css" />
    <jsp:param name="script" value="moment-with-locales.min.js" />
    <jsp:param name="script" value="primitive-ext-string.js" />
    <jsp:param name="script" value="D/D-common-var.jsp" />
    <jsp:param name="script" value="D/D-common.js" />
    <jsp:param name="script" value="D/D25WorkTimeLeaderFrame-var.jsp" />
</jsp:include>

<script type="text/javascript">

	$(function() {
		
		$.bindButtonSearchHandler();
		$.bindEmpGubunRadioChangeHandler();
		$.bindSearchOptionRadioHandler();
		$.bindIncludeSubOrgCheckboxHandler();
		$.bindDeptNameKeydownHandler();
		$.bindEmpNameKeydownHandler();
		$.bindButtonSearchDeptHandler();
		$.bindSearchOrgInTreeHandler();
		$.bindSearchEmpHandler();
		
		$.changeIgbnRadioHandler();
		$.changeJobidRadioHandler();
		
		$.bindTabClickHandler();
		
		$('#SEARCH_DATE').datepicker("setDate", new Date());
		$('.tab').find('a:first').addClass('selected');
		
		setDeptID();
		
	});
	
	$.bindEmpGubunRadioChangeHandler = function() {
		$('#SEARCH_EMPGUBUN').change(function() {
			if($(this).val() == 'S') {
				$('#labelSInfo').show();
				$('#labelHInfo').hide();
			} else {
				$('#labelSInfo').hide();
//				$('#labelHInfo').show();
				$('#labelHInfo').hide();
			}
		});
	}
	
	$.bindButtonSearchHandler = function() {
		$('#searchButton').click(function(e) {
			e.preventDefault();
			
			$.tabMove($('.tab a.selected').eq(0));
		});
	}

	$.bindTabClickHandler = function() {
		$('.tabArea').find('a').each(function() {
			$(this).click(function(e) {
				e.preventDefault();
				$.tabMove($(this));
			});
		});
	}
	
	$.tabMove = function(tabObj) {
		setTimeout(blockFrame);

	    $('.tab .selected').removeClass('selected');
	    tabObj.addClass('selected');

	    var gubun = tabObj.data('gubun');
	    var searchOption = $('[name=searchOption]:checked').val();
	    
		$('[name=SEARCH_GUBUN]').val(gubun);
		$('[name=SEARCH_EMPGUBUN]').val($('#SEARCH_EMPGUBUN').val());
		$('[name=SEARCH_DATE]').val($('#SEARCH_DATE').val());
		if(searchOption == 'Org') {
			$('[name=SEARCH_DEPTID]').val($('[name=DEPTID]').val());
			$('[name=SEARCH_PERNR]').val('');
			if($('[name=includeSubOrg]').is(':checked')) {
				$('[name=SEARCH_INCLUDE_SUBDEPT]').val($('[name=includeSubOrg]').val());
			} else {
				$('[name=SEARCH_INCLUDE_SUBDEPT]').val('');
			}
		} else {
			$('[name=SEARCH_DEPTID]').val('');
			$('[name=SEARCH_INCLUDE_SUBDEPT]').val('');
			$('[name=SEARCH_PERNR]').val($('[name=PERNR]').val());
		}
		
		if($('#SEARCH_EMPGUBUN').val() == 'S') {
			$('.noTabArea').hide();
			$('.tabArea').show();
			
			$('#labelSInfo').show();
			$('#labelHInfo').hide();
		} else {
			$('.tabArea').hide();
			$('.noTabArea').show();
			
			$('#labelSInfo').hide();
//			$('#labelHInfo').show();
			$('#labelHInfo').hide();
		}
		
		$('#urlForm')
			.attr('target', 'listFrame')
			.attr('action', '<%= WebUtil.ServletURL %>hris.D.D25WorkTime.D25WorkTimeLeaderReportSV')
			.submit();
	}
	
	$.bindSearchOptionRadioHandler = function() {
	    $('input[type="radio"][name="searchOption"]').click(function() {
	
	        var v = $(this).val();
	        $('div[data-name="search#Wrapper"]'.replace(/#/, v)).show().siblings().hide();
	        $('div.searchOrg_ment').css('visibility', v === 'Org' ? 'visible' : 'hidden');
	        
	        /* $('[name=I_GBN] > option').eq(0).prop('selected', true);
	        $('[name=DEPTID]').val('');
	        $('[name=I_VALUE1]').val('');
	        $('[name=txt_deptNm]').val(''); */
	    });
	}

    $.bindIncludeSubOrgCheckboxHandler = function() {
	    $('form[name="searchOrg"] input[type="checkbox"][name="includeSubOrg"]').click(function() {
	
	        var form = $('form[name="searchOrg"]');
	        if (!form.find('input[type="hidden"][name="DEPTID"]').val()) return;
	
	        // 체크박스 선택시 자동검색
	        setDeptID(form.find('input[type="hidden"][name="DEPTID"]').val(), form.find('input[type="text"][name="txt_deptNm"]').val());
	    });
    }

    $.bindDeptNameKeydownHandler = function() {
	    $('form[name="searchOrg"] input[type="text"][name="txt_deptNm"],form[name="searchOrg"] input[type="text"][name="I_VALUE1"]').keydown(function(e) {
	
	        if (e.keyCode !== 13) return;
	
	        $('a[data-name="searchOrg"]').click();
	
	        return false;
	    });
    }

    $.bindEmpNameKeydownHandler = function() {
	    $('form[name="searchEmp"] input[type="text"][name="I_VALUE1"]').keydown(function(e) {
	
	        if (e.keyCode !== 13) return;
	
	        $('a[data-name="searchEmp"]').click();
	
	        return false;
	    });
    }

    $.changeIgbnRadioHandler = function() {
	    $('form[name="searchOrg"] select[name="I_GBN"]').change(function() {
	        $('form[name="searchOrg"] input[type="text"][data-follow="' + $(this).val() + '"]').val('').show().focus().siblings('[data-follow]').hide();
	    });
    }

    $.changeJobidRadioHandler = function() {
	    $('form[name="searchEmp"] select[name="jobid"]').change(function() {
	        $('form[name="searchEmp"] input[type="text"][name="I_VALUE1"]').val('').focus();
	    });
    }

    $.bindButtonSearchDeptHandler = function() {
	    $('a[data-name="searchOrg"]').click(function() {
	    	
	        var form = $('form[name="searchOrg"]'),
	        I_GBN = form.find('select[name="I_GBN"] option:selected').val();
	        if (I_GBN === 'ORGEH') {
	            var t = form.find('input[type="text"][name="txt_deptNm"]');
	            if (!t.val().trim()) {
	                alert(i18n.MSG.COMMON.SEARCH.DEPT.REQUIR); // 검색할 부서명을 입력하세요.
	                t.focus();
	                return false;
	            }
	
	            openPopup({
	                url: getJspURL('common/SearchDeptNamePop.jsp'),
	                data: form.jsonize(),
	                width: 500,
	                height: 500
	            });
	
	        } else if (I_GBN === 'PERNR') {
	            var t = form.find('input[type="text"][name="I_VALUE1"]'), v = t.val().trim();
	            if (!v) {
	                alert(i18n.MSG.APPROVAL.SEARCH.NAME.REQUIRED); // 검색할 부서원 성명을 입력하세요.
	                t.focus();
	                return false;
	            }
	            if (v.length < 2) {
	                alert(i18n.MSG.APPROVAL.SEARCH.NAME.MIN); // 검색할 성명을 한 글자 이상 입력하세요.
	                t.focus();
	                return false;
	            }
	
	            openPopup({
	                url: getJspURL('D/D12Rotation/SearchDeptPersonsWait_Rot.jsp'),
	                data: form.jsonize(),
	                width: 550,
	                height: 550
	            });
	
	        }
	
	        return false;
	    });
    }

    $.bindSearchOrgInTreeHandler = function() {
	    $('a[data-name="searchOrgInTree"]').click(function() {
			
	        openPopup({
	            url: getServletURL('hris.common.OrganListPopSV'),
	            data: $('form[name="searchOrg"]').jsonize(),
	            width: 400,
	            height: 550
	        });
	
	        return false;
	    });
    }

    $.bindSearchEmpHandler = function() {
	    $('a[data-name="searchEmp"]').click(function() {
	
	        var form = $('form[name="searchEmp"]'),
	        t = form.find('input[type="text"][name="I_VALUE1"]'), v = t.val().trim();
	
	        if ($('select[name="jobid"] option:selected').val() === 'ename') {
	            if (!v) {
	                alert(i18n.MSG.APPROVAL.SEARCH.NAME.REQUIRED); // 검색할 부서원 성명을 입력하세요.
	                t.focus();
	                return false;
	            }
	            if (v.length < 2) {
	                alert(i18n.MSG.APPROVAL.SEARCH.NAME.MIN); // 검색할 성명을 한 글자 이상 입력하세요.
	                t.focus();
	                return false;
	            }
	        } else {
	            if (!v) {
	                alert(i18n.MSG.APPROVAL.SEARCH.PERNR.REQUIRED); // 검색할 부서원 사번을 입력하세요.
	                t.focus();
	                return false;
	            }
	        }
	
	        openPopup({
	            url: getJspURL('common/SearchDeptPersonsWait_T.jsp'),
	            data: form.jsonize(),
	            width: 800,
	            height: 530
	        });
	
	        return false;
	    });
    }
    
    /**
     * 기준년월, 부서 또는 사원 정보 반환
     * 
     * @returns
     */
    function getData() {

        var YYMON = $('select[name="year"] option:selected').val() + $('select[name="month"] option:selected').val(),
        method = $('input[type="radio"][name="searchOption"]:checked').val();
        if ($('input[type="radio"][name="searchOption"]:checked').val() === 'Org') {
            var form = $('form[name="searchOrg"]'), DEPTID = form.find('input[type="hidden"][name="DEPTID"]'), ORGEH = DEPTID.val().trim();
            return {
                METHOD: method,
                I_ORGEH: ORGEH ? ORGEH : DEPTID.data('init'),
                I_LOWERYN: form.find('input[type="checkbox"][name="includeSubOrg"]').prop('checked') ? 'Y' : '',
                I_YYMON: YYMON
            };

        } else {
            var form = $('form[name="searchEmp"]');
            return {
                METHOD: method,
                I_PERNR: form.find('input[type="hidden"][name="PERNR"]').val(),
                I_RETIR: form.find('input[type="checkbox"][name="retir_chk"]').prop('checked') ? 'X' : '',
                I_YYMON: YYMON
            };

        }
        return null;
    }

    /**
     * Popup에서 선택된 부서 정보 적용 및 해당 data 조회
     * 
     * @param deptId
     * @param deptNm
     */
    function setDeptID(deptId, deptNm) {

        var form = $('form[name="searchOrg"]');
        form.find('input[type="hidden"][name="DEPTID"]').val(function() {
            return deptId ? deptId : $(this).data('init');
        });
        form.find('input[type="text"][name="txt_deptNm"]').val(function() {
            return deptNm ? deptNm : $(this).data('init');
        });

        $.tabMove($('.tab a.selected').eq(0));
    }

    /**
     * @param o 
     *     부서검색 = {
     *         SPERNR: 로그인 사번
     *         EPERNR: 대상자 사번
     *         ENAME : 대상자 성명
     *         STEXT : 부서명
     *         OBJID : 부서 ID
     *         OBJTXT: 
     *     }
     *     사원검색 = {
     *         PERNR: 사번
     *         ENAME: 성명
     *         ORGTX: 부서
     *         JIKWT: 직위/직급 호칭
     *         JIKKT: 직책
     *         STLTX: 직무
     *         BTEXT: 근무지
     *         STAT2: 구분
     *     }
     */
    function setPersInfo(o) {
        if ($('input[type="radio"][name="searchOption"]:checked').val() === 'Org') {
            var form = $('form[name="searchOrg"]');
            form.find('input[type="hidden"][name="DEPTID"]').val(o.OBJID);
            if (form.find('select[name="I_GBN"] option:selected').val() === 'ORGEH') {
                form.find('input[type="text"][name="txt_deptNm"]').val(o.STEXT);
            } else {
                form.find('input[type="text"][name="I_VALUE1"]').val(o.ENAME);
            }

        } else {
            var form = $('form[name="searchEmp"]');
            form.find('input[type="hidden"][name="PERNR"]').val(o.PERNR);
            form.find('input[type="text"][name="I_VALUE1"]').val(o.ENAME);

        }

        $.tabMove($('.tab a.selected').eq(0));
    }
    
</script>

<%-- body 시작 선언 및 body title --%>
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D25.N1010" />
</jsp:include>

<div class="contentBody" style="min-width:1205px">

<form id="urlForm" name="urlForm" target="listFrame" method="POST">
   <input type="hidden" name="unblock" value="true" />
   <input type="hidden" name="subView" value="Y" />
   <input type="hidden" name="SEARCH_GUBUN" value="M" />
   <input type="hidden" name="SEARCH_EMPGUBUN" value="${E_AUTH eq 'N' ? 'H' : 'S'}" />
   <input type="hidden" name="SEARCH_DEPTID" value="" />
   <input type="hidden" name="SEARCH_INCLUDE_SUBDEPT" value="" />
   <input type="hidden" name="SEARCH_PERNR" value="" />
   <input type="hidden" name="SEARCH_DATE" value="" />
</form>    

    <div class="tableInquiry">
        <table style="min-width:1185px;">
            <colgroup>
                <col style="width:70px" />
                <col style="width:200px" />
                <col style="width:90px" />
                <col style="width:110px" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th rowspan="2">
                        <img class="searchTitle" src="${g.image}sshr/top_box_search.gif" />
                    </th>
                    <th>
                        <label class="bold">신분</label>
                        &nbsp;
                        <select id="SEARCH_EMPGUBUN" style="margin-left:-1px;">
                        	<c:if test="${E_AUTH ne 'N'}">
                        	<option value="S">사무직</option>
                        	</c:if>	
                        	<option value="H">현장직</option>	
                        </select>
                    </th>
                   	<th rowspan="2">
                        <div class="tableBtnSearch tableBtnSearch2">
	                        <a href="#" class="search" id="searchButton">
	                        	<span>조회</span>
	                        </a>
	                    </div>
                    </th>
                    <th rowspan="2" class="divider">
                        <div class="vertical-radio"><label class="for-radio"><input type="radio" name="searchOption" value="Org" checked="checked" /> 부서검색</label></div>
                        <div class="vertical-radio"><label class="for-radio"><input type="radio" name="searchOption" value="Emp" /> 사원검색</label></div>
                    </th>
                    <th rowspan="2" class="align-left" style="padding-left:10px">
                        <div data-name="searchOrgWrapper">
                            <form name="searchOrg" method="POST">
                                <div>
                                    <select name="I_GBN">
                                        <option value="ORGEH">부서명</option>
                                        <option value="PERNR">사원명</option>
                                    </select>
                                    <input type="hidden" name="DEPTID" data-init="${user.e_objid}" />
                                    <input type="text" name="I_VALUE1"   maxlength="10" onfocus="this.select()" data-follow="PERNR" style="width:200px; ime-mode:active; display:none" />
                                    <input type="text" name="txt_deptNm" maxlength="10" onfocus="this.select()" data-follow="ORGEH" style="width:200px; ime-mode:active" data-init="${user.e_obtxt}" />
                                    <div class="tableBtnSearch"><a class="search" href="javascript:;" data-name="searchOrg"><span>부서검색</span></a></div>
                                </div>
                                <div class="divider" style="margin-left:10px; padding-left:10px">
                                    <img class="searchIcon" src="${g.image}sshr/icon_map_g.gif" />
                                    <label>하위조직포함 <input type="checkbox" name="includeSubOrg" value="Y" /></label>
                                    <div class="tableBtnSearch"><a class="search" href="javascript:;" data-name="searchOrgInTree"><span>조직도로 부서찾기</span></a></div>
                                </div>
                            </form>
                        </div>
                        <div data-name="searchEmpWrapper" style="display:none">
                            <form name="searchEmp" method="POST">
                                <div>
                                    <label>퇴직자조회 <input type="checkbox" name="retir_chk" value="X" /></label>
                                </div>
                                <div style="margin-left:15px">
                                    <select name="jobid">
                                        <option value="ename">성명별</option>
                                        <option value="pernr">사번별</option>
                                    </select>
                                    <input type="hidden" name="PERNR" />
                                    <input type="text" name="I_VALUE1" maxlength="10" onfocus="this.select()" style="width:103px; ime-mode:active" />
                                    <div class="tableBtnSearch"><a class="search" href="javascript:;" data-name="searchEmp"><span>사원검색</span></a></div>
                                </div>
                            </form>
                        </div>
                    </th>
                </tr>
                <tr>
                	<th>
                        <label class="bold">조회기준일</label>
                        &nbsp;
                		<input type="text" id="SEARCH_DATE" class="date required" size="10" value="<c:out value='${SEARCH_DATE}' />" />
                    </th>
                </tr>
            </tbody>
        </table>
    </div>

   	<table style="min-width:1185px;">
		<colgroup>
			<col style="width:360px" />
			<col />
		</colgroup>
		<tr>
			<td>
				<div id="labelSInfo" class="align-right">* 조회기준일의 1일~말일 데이터를 조회합니다.</div>
				<div id="labelHInfo" class="align-right">* 조회기준일이 속한 탄력근무 기간 데이터를 조회합니다.
			</td>
			<td style="text-align:right;">
				<div class="searchOrg_ment align-right">* 하위조직포함을 선택하면 하위조직까지 조회됩니다.</div>
			</td>
		</tr>
	</table>
	
    <!-- Tab 시작 -->
    <div class="tabArea">
        <ul class="tab">
           	<li id="tab_month"><a href="#" data-gubun="M">월별</a></li>
           	<li id="tab_week"><a href="#" data-gubun="W">주별</a></li>
        </ul>
    </div>
    
    <div class="noTabArea" style="display:none;padding:0;height:31px;"></div>

    <div class="frameWrapper">
        <!-- Tab 프레임 -->
        <iframe id="listFrame" name="listFrame" onload="autoResize();" frameborder="0" scrolling="no"></iframe>
    </div>
</div>

<jsp:include page="/include/body-footer.jsp" /><!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>      <!-- html footer 부분 -->