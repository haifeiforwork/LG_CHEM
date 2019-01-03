<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                          */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 연말정산                                                    */
/*   Program Name : 연말정산                                                    */
/*   Program ID   : D11TaxAdjustMedicalChange.jsp                               */
/*   Description  : 특별공제 의료비 입력 및 조회                                */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-02-01  윤정현                                          */
/*                  2005-11-23  @v1.1 lsa C2005111701000000551 및 버튼 분리작업 */
/*                                        사업자번호추가                        */
/*                  2005-11-23  @v1.2 lsa 성명선택시 주민번호,관계에 자동셋팅   */
/*                  2005-11-28  @v1.2 lsa 성명너비조정                          */
/*                  2005-11-30  @v1.3 lsa 인적공제장애인 공제를 받을 경우 장애자 check버튼 default로 처리 및 비활성화 처리*/
/*                  2006-11-21  @v1.4 lsa 1.금액 -> 의료비총액/신용카드분/현금영수증분/현금으로 나누어 입력 */
/*                                        2.자동반영분 확인 플래그 추가         */
/*                  2008-11-20  CSR ID:1361257 2008년말정산반영                 */
/*                  2009-12-20  CSR ID:1361257 2009년말정산반영                 */
/*                  2012-12-13  C20121213_34842 2012 년말정산 국세청자료인경우 내용,건수 입력불가처리 */
/*                  2013-12-23  CSR ID:2013_9999 화면SIZE 조정                 */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.A.A12Family.rfc.*" %>
<%@ page import="hris.D.*" %>
<%@ page import="hris.D.rfc.*" %>
<%@ page import="hris.D.D11TaxAdjust.*" %>
<%@ page import="com.sns.jdf.util.*" %>

<%
    WebUserData  user = (WebUserData)session.getAttribute("user");
    D00TaxAdjustPeriodRFC  periodRFC           = new D00TaxAdjustPeriodRFC();
    D00TaxAdjustPeriodData taxAdjustPeriodData = new D00TaxAdjustPeriodData();
    taxAdjustPeriodData = (D00TaxAdjustPeriodData)periodRFC.getPeriod(((WebUserData)session.getAttribute("user")).companyCode,((WebUserData)session.getAttribute("user")).empNo);

    String targetYear = (String)request.getAttribute("targetYear" );
    Vector medi_vt    = (Vector)request.getAttribute("medi_vt" );
    String rowCount   = (String)request.getAttribute("rowCount" );
 //out.println("medi_:"+medi_vt.toString() +" reow:"+rowCount);
//  2002.12.03 내역조회가 가능한지 날짜를 체크한다.
    String currentDate = DataUtil.getCurrentDate();
    int appl_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
    int appl_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
    int disp_from = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
    int disp_toxx = DataUtil.getBetween(currentDate, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));
    int medi_count = 8;

    if( medi_vt.size() > medi_count ) {
        medi_count = medi_vt.size();
    }
    if ( Integer.parseInt(rowCount) != 8  ) {
        medi_count = Integer.parseInt(rowCount);
    }

    String Gubn = "Tax05";   //@v1.1

    //@v1.3
    D11TaxAdjustPePersonRFC   rfcPeP   = new D11TaxAdjustPePersonRFC();
    Vector MediPeP_vt = new Vector();
    MediPeP_vt      = rfcPeP.getPePerson( "2",user.empNo, targetYear  ); //I_GUBUN :1 - 보험료 2- 의료비  3-교육비 4-신용카드

%>

<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
<!--
	//enable 처리
	function setEnable(){
		var tbody = $('#table tbody');
		tbody.find(':input').each(function(){
			this.disabled = false;
		});
	}

function check_data() {
    for( var i = 0 ; i < "<%= medi_count %>" ; i++ ) {

        subty    = eval("document.form1.SUBTY"+i+".value");
        f_ename  = eval("document.form1.F_ENAME"+i+".value");
        f_regno  = eval("document.form1.F_REGNO"+i+".value");
        content  = eval("document.form1.CONTENT"+i+".value");
        bizno    = eval("document.form1.BIZNO"+i+".value");
        biz_name = eval("document.form1.BIZ_NAME"+i+".value");
        ca_cnt   = eval("document.form1.CA_CNT"+i+".value");
        ca_betrg = eval("document.form1.CA_BETRG"+i+".value");
        metyp    = eval("document.form1.METYP"+i+".value");


        if ( subty != "" ) {
            if( eval("document.form1.GUBUN"+i+".value") == "1" ) {
                if (  metyp=="" ) {
                    alert("<spring:message code='MSG.D.D11.0064' />"); // \"의료증빙유형은 필수 항목입니다.
                    eval("document.form1.METYP"+i+".focus()")
                    return;
                }
            }else{
                if (eval("document.form1.CHNTS"+i+".checked") == true) { //국세청자료인 경우 사업자번호 입력안해도 됨
                   if ( f_regno == ""  ) {
                       alert("<spring:message code='MSG.D.D11.0065' />"); // \"관계는 필수 항목입니다.
                       eval("document.form1.SUBTY"+i+".focus()");
                       return;
                   }
                   if (  f_ename == ""   ) {
                       alert( "<spring:message code='MSG.D.D11.0066' />"); //성명은 필수 항목입니다.
                       eval("document.form1.F_ENAME"+i+".focus()");
                       return;
                   }
                   if (  f_regno == ""   ) {
                       alert( "<spring:message code='MSG.D.D11.0040' />"); //주민번호는 필수 항목입니다.
                       eval("document.form1.F_REGNO"+i+".focus()");
                       return;
                   }
                   if (  metyp=="" ) {
                       alert( "<spring:message code='MSG.D.D11.0067' />"); //의료증빙유형은 필수 항목입니다.
                       eval("document.form1.METYP"+i+".focus()");
                       return;
                   }
                }else {
                   if ( metyp =="1") { //1.국세청장이 제공하는 의료비 은 사업자번호/상호 입력안함
                        if ( f_regno == ""  ) {
                            alert("<spring:message code='MSG.D.D11.0065' />"); // \"관계는 필수 항목입니다.
                            eval("document.form1.SUBTY"+i+".focus()");
                            return;
                        }
                        if (  f_ename == ""   ) {
                            alert( "<spring:message code='MSG.D.D11.0066' />"); //성명은 필수 항목입니다.
                            eval("document.form1.F_ENAME"+i+".focus()");
                            return;
                        }
                        if (  f_regno == ""   ) {
                            alert( "<spring:message code='MSG.D.D11.0040' />"); //주민번호는 필수 항목입니다.
                            eval("document.form1.F_REGNO"+i+".focus()");
                            return;
                        }

                        if (  metyp=="" ) {
                            alert( "<spring:message code='MSG.D.D11.0067' />"); //의료증빙유형은 필수 항목입니다.
                            eval("document.form1.METYP"+i+".focus()");
                            return;
                        }
                   }else {
                        if ( f_regno == ""  ) {
                            alert("<spring:message code='MSG.D.D11.0065' />"); //\"관계는 필수 항목입니다.
                            eval("document.form1.SUBTY"+i+".focus()");
                            return;
                        }
                        if (  f_ename == ""   ) {
                            alert( "<spring:message code='MSG.D.D11.0066' />"); //성명은 필수 항목입니다.
                            eval("document.form1.F_ENAME"+i+".focus()");
                            return;
                        }
                        if (  f_regno == ""   ) {
                            alert( "<spring:message code='MSG.D.D11.0040' />"); //주민번호는 필수 항목입니다.
                            eval("document.form1.F_REGNO"+i+".focus()");
                            return;
                        }
                        if ( bizno == ""  ) {
                            alert( "<spring:message code='MSG.D.D11.0046' />"); //사업자번호는 필수 항목입니다.
                            eval("document.form1.BIZNO"+i+".focus()");
                            return;
                        }
                        if ( biz_name == ""  ) {
                            alert( "<spring:message code='MSG.D.D11.0045' />"); //상호는 필수 항목입니다.
                            eval("document.form1.BIZ_NAME"+i+".focus()");
                            return;
                        }
                        if (  metyp=="" ) {
                            alert( "<spring:message code='MSG.D.D11.0067' />"); //의료증빙유형은 필수 항목입니다.
                            eval("document.form1.METYP"+i+".focus()");
                            return;
                        }
                        if ( content == ""  ) {
                            alert( "<spring:message code='MSG.D.D11.0068' />"); //의료비내용은 필수 항목입니다.
                            eval("document.form1.CONTENT"+i+".focus()");
                            return;
                        }
                   }
                }
            }
            //C20121213_34842
            if ( metyp !="1") { //1.국세청장이 제공하는 의료비 은 건수 입력안함

                 if ( (ca_cnt == ""  )) {
                     alert("<spring:message code='MSG.D.D11.0069' />"); //건수는 필수 항목입니다.
                     eval("document.form1.CA_CNT"+i+".focus()")
                     return;
                 }
            }
            if ( (ca_betrg == ""  )) {
                alert("<spring:message code='MSG.D.D11.0044' />"); //금액은 필수 항목입니다.
                eval("document.form1.CA_BETRG"+i+".focus()")
                return;
            }
            if (  eval("document.form1.CA_BETRG"+i+".value.length") > 11 ) {
                alert("<spring:message code='MSG.D.D11.0070' />"); //금액을 확인하세요!
                eval("document.form1.CA_BETRG"+i+".focus()")
                return;
            }
            //C20121213_34842
            if ( metyp !="1") { //1.국세청장이 제공하는 의료비 은 건수 입력안함

                if ( ( (ca_cnt != "" && ca_cnt != "0") && (ca_betrg == "" || ca_betrg == "0") ) || ( (ca_cnt == "" ||  ca_cnt == "0") &&( ca_betrg != ""&&ca_betrg != "0") )) {
                    alert("<spring:message code='MSG.D.D11.0071' />"); // \"건수\", \"금액\"은 함께 입력하셔야 합니다.
                    return;
                }
            }
        } else {
        	if(eval("document.form1.PDF"+ i + ".checked == false")){//@2015 연말정산 오류수정
	            if ( f_ename != "" || f_regno != "" || bizno != "" || biz_name != ""   ) {
	                alert("<spring:message code='MSG.D.D11.0017' />"); //\"관계\"는 필수 항목입니다. 선택해 주세요
	                return;
	            }
        	}
        }
    }

    return true;
}

// 65세 이상일때 경로우대 대상자 자동클릭
function checkAgeField(cnt) {
    var l_regno = "";

    l_regno = eval("document.form1.F_REGNO"+cnt+".value");
    if ( l_regno == "" ) {
        eval("document.form1.OLDD"+cnt+".checked = false");
        return;
    }

    birthYear  = l_regno.substr(0, 2);
    birthMonth = l_regno.substr(2, 2);
    birthDate  = l_regno.substr(4, 2);

    if( l_regno.charAt(7) == '1' || l_regno.charAt(7) == '2' ||
        l_regno.charAt(7) == '5' || l_regno.charAt(7) == '6' ){
        birthYear = "19" + birthYear;
    } else {
        birthYear = "20" + birthYear;
    }

    ageYear  = 0;
    ageMonth = 0;
    ageDate  = 0;

    d = new Date();
    ageYear  = <%=targetYear%> - birthYear;

    if( ageYear >= 65 ){
        eval("document.form1.OLDD"+cnt+".checked = true");
    } else {
        eval("document.form1.OLDD"+cnt+".checked = false");
    }
}

// 특별공제 의료비 - 수정
function do_change() {
    if ( check_data() ) {
        for( var i = 0 ; i < "<%= medi_count %>" ; i++ ) {

            eval("document.form1.CA_BETRG"+i+".value   = removeComma(document.form1.CA_BETRG"+i+".value);");
            eval("document.form1.F_REGNO"+i+".value = removeResBar(document.form1.F_REGNO"+i+".value);");
            eval("document.form1.BIZNO"+i+".value   = removeResBar2(document.form1.BIZNO"+i+".value);");
            eval("document.form1.METYP_NAME"+i+".value = document.form1.METYP"+i+"[document.form1.METYP"+i+".selectedIndex].text;");
            if( eval("document.form1.CA_BETRG"+ i + ".value == ''") )
                eval("document.form1.CA_BETRG"+ i + ".value ='0';");

            if( eval("document.form1.OLDD"+ i + ".checked == true") ) {
                eval("document.form1.OLDD"+ i + ".value ='X';");
            } else {
                eval("document.form1.OLDD"+ i + ".value ='';");
            }
            if( eval("document.form1.OBST"+ i + ".checked == true") ) {
                eval("document.form1.OBST"+ i + ".value ='X';");
            } else {
                eval("document.form1.OBST"+ i + ".value ='';");
            }
            if( eval("document.form1.GLASS_CHK"+ i + ".checked == true") ) {
                eval("document.form1.GLASS_CHK"+ i + ".value ='X';");
                eval("document.form1.DIFPG_CHK"+ i + ".value ='';");
            } else {
                eval("document.form1.GLASS_CHK"+ i + ".value ='';");
            }

            //@2015 연말정산 난임시술비 추가
            if( eval("document.form1.DIFPG_CHK"+ i + ".checked == true") ) {
                eval("document.form1.DIFPG_CHK"+ i + ".value ='X';");
                eval("document.form1.GLASS_CHK"+ i + ".value ='';");
            } else {
                eval("document.form1.DIFPG_CHK"+ i + ".value ='';");
            }

            if( eval("document.form1.GUBUN"+ i + ".checked == true") ) {
            	eval("document.form1.GUBUN"+ i + ".value ='1';");
	        } else {
                eval("document.form1.GUBUN"+ i + ".value ='2';");
            }

	        if(eval("document.form1.PDF"+ i + ".checked == true")) {
	           	eval("document.form1.PDF"+ i + ".value ='X';");
	       	} else {
                eval("document.form1.PDF"+ i + ".value ='';");
            }

            if( eval("document.form1.CHNTS"+ i + ".checked == true") ) {
                eval("document.form1.CHNTS"+ i + ".value ='X';");
            } else {
                eval("document.form1.CHNTS"+ i + ".value ='';");
            }

            if( eval("document.form1.OMIT_FLAG"+ i + ".checked == true") ) {
                eval("document.form1.OMIT_FLAG"+ i + ".value ='X';");
            } else {
                eval("document.form1.OMIT_FLAG"+ i + ".value ='';");
            }
        }
        //세대주여부
        eval("document.form1.FSTID.disabled = false;") ; //세대주여부
        if( eval("document.form1.FSTID.checked == true") )
           eval("document.form1.FSTID.value ='X';");

       //필드 enable처리
        setEnable();
        document.form1.jobid.value = "change";
        document.form1.action      = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustMedicalSV";
        document.form1.method      = "post";
        document.form1.target      = "menuContentIframe";
        document.form1.submit();
    }
}

/* 의료비 입력항목 1개 추가 */
function add_field(){
    document.form1.rowCount.value = document.form1.medi_count.value = parseInt(document.form1.medi_count.value) + 1; //@v1.4
    for( var i = 0 ; i < "<%= medi_count %>" ; i++ ) {
        eval("document.form1.F_REGNO"+i+".value = removeResBar(document.form1.F_REGNO"+i+".value);");
        eval("document.form1.BIZNO"+i+".value   = removeResBar2(document.form1.BIZNO"+i+".value);");
        eval("document.form1.CA_BETRG"+i+".value   = removeComma(document.form1.CA_BETRG"+i+".value);");

        if( eval("document.form1.OLDD"+ i + ".checked == true") ) {
            eval("document.form1.OLDD"+ i + ".value ='X';");
        } else {
            eval("document.form1.OLDD"+ i + ".value ='';");
        }

        if( eval("document.form1.OBST"+ i + ".checked == true") ) {
            eval("document.form1.OBST"+ i + ".value ='X';");
        } else {
            eval("document.form1.OBST"+ i + ".value ='';");
        }
        eval("document.form1.GUBUN"+ i + ".disabled = false;") ;
        //@v1.4
        if( eval("document.form1.GUBUN"+ i + ".checked == true") ) {
           	eval("document.form1.GUBUN"+ i + ".value ='1';");
        } else {
               eval("document.form1.GUBUN"+ i + ".value ='2';");
           }

        if(eval("document.form1.PDF"+ i + ".checked == true")) {
           	eval("document.form1.PDF"+ i + ".value ='X';");
       	} else {
               eval("document.form1.PDF"+ i + ".value ='';");
        }

        if( eval("document.form1.CHNTS"+ i + ".checked == true") ) {
            eval("document.form1.CHNTS"+ i + ".value ='X';");
        } else {
            eval("document.form1.CHNTS"+ i + ".value ='';");
        }

        if( eval("document.form1.OMIT_FLAG"+ i + ".checked == true") ) {
            eval("document.form1.OMIT_FLAG"+ i + ".value ='X';");
        } else {
            eval("document.form1.OMIT_FLAG"+ i + ".value ='';");
        }

        if( eval("document.form1.GLASS_CHK"+ i + ".checked == true") ) {
            eval("document.form1.GLASS_CHK"+ i + ".value ='X';");
            eval("document.form1.DIFPG_CHK"+ i + ".value ='';");
        } else {
            eval("document.form1.GLASS_CHK"+ i + ".value ='';");
        }

        //@2015 연말정산 난임시술비 추가
        if( eval("document.form1.DIFPG_CHK"+ i + ".checked == true") ) {
            eval("document.form1.DIFPG_CHK"+ i + ".value ='X';");
            eval("document.form1.GLASS_CHK"+ i + ".value ='';");
        } else {
            eval("document.form1.DIFPG_CHK"+ i + ".value ='';");
        }
    }

	//필드 enable처리
    setEnable();
	document.form1.jobid.value = "AddorDel";
	document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustMedicalSV";
	document.form1.method = "post";
    document.form1.target = "menuContentIframe";
	document.form1.submit();
}

/* 의료비 입력항목 아래항목 지우기 */
function remove_field(){
	var delchk = false;
    //@v1.4 start 선택 삭제 추가
    document.form1.rowCount.value = parseInt(document.form1.medi_count.value) - 1;

    for( var i = 0 ; i < "<%= medi_count %>" ; i++ ) {
        if (document.form1.radiobutton[i].checked == true &&  eval("document.form1.GUBUN"+i+".value") == "1"     )  {
            alert("<spring:message code='MSG.D.D11.0027' />"); //자동반영분은 삭제할 수 없습니다.
            return;
        }
        if( isNaN( document.form1.radiobutton.length ) ){
            eval("document.form1.use_flag0.value = 'N'");
        } else {
            if ( document.form1.radiobutton[i].checked == true ) {
                eval("document.form1.use_flag"+ i +".value = 'N'");
                if(!delchk){
                	delchk = true;
                }
            }
        }

    }
    //@v1.4 end

    if ( document.form1.medi_count.value == 0 ) {
        alert("<spring:message code='MSG.D.D11.0072' />"); //의료비 입력항목을 더이상 줄일수 없습니다.
        return;
    }

    if(!delchk) {
    	alert("<spring:message code='MSG.D.D11.0021' />"); //삭제할 건을 선택하세요.
    	return;
    }

    var row=0;
    row = "<%= medi_count - 1 %>";
    if (eval("document.form1.GUBUN"+row+".value") == "1")  {
        alert("<spring:message code='MSG.D.D11.0073' />"); //이미 급여처리 된 건은 삭제할 수 없습니다.
        return;
    }

    //document.form1.medi_count.value = parseInt(document.form1.medi_count.value) - 1;

    for( var i = 0 ; i < "<%= medi_count %>" ; i++ ) {
        eval("document.form1.F_REGNO"+i+".value = removeResBar(document.form1.F_REGNO"+i+".value);");
        eval("document.form1.BIZNO"+i+".value   = removeResBar2(document.form1.BIZNO"+i+".value);");
        eval("document.form1.CA_BETRG"+i+".value   = removeComma(document.form1.CA_BETRG"+i+".value);");

        if( eval("document.form1.OLDD"+ i + ".checked == true") ) {
            eval("document.form1.OLDD"+ i + ".value ='X';");
        } else {
            eval("document.form1.OLDD"+ i + ".value ='';");
        }

        if( eval("document.form1.OBST"+ i + ".checked == true") ) {
            eval("document.form1.OBST"+ i + ".value ='X';");
        } else {
            eval("document.form1.OBST"+ i + ".value ='';");
        }

        //@v1.4
        if( eval("document.form1.GUBUN"+ i + ".checked == true") ) {
           	eval("document.form1.GUBUN"+ i + ".value ='1';");
        } else {
               eval("document.form1.GUBUN"+ i + ".value ='2';");
        }

        if(eval("document.form1.PDF"+ i + ".checked == true")) {
           	eval("document.form1.PDF"+ i + ".value ='X';");
       	} else {
               eval("document.form1.PDF"+ i + ".value ='';");
        }

        //@v1.4
        if( eval("document.form1.CHNTS"+ i + ".checked == true") ) {
            eval("document.form1.CHNTS"+ i + ".value ='X';");
        } else {
            eval("document.form1.CHNTS"+ i + ".value ='';");
        }

        //@v1.4
        if( eval("document.form1.GLASS_CHK"+ i + ".checked == true") ) {
            eval("document.form1.GLASS_CHK"+ i + ".value ='X';");
            eval("document.form1.DIFPG_CHK"+ i + ".value ='';");
        } else {
            eval("document.form1.GLASS_CHK"+ i + ".value ='';");
        }

        //@2015 연말정산 난임 시술비 추가
        if( eval("document.form1.DIFPG_CHK"+ i + ".checked == true") ) {
            eval("document.form1.DIFPG_CHK"+ i + ".value ='X';");
            eval("document.form1.GLASS_CHK"+ i + ".value ='';");
        } else {
            eval("document.form1.DIFPG_CHK"+ i + ".value ='';");
        }

        if( eval("document.form1.OMIT_FLAG"+ i + ".checked == true") ) {
            eval("document.form1.OMIT_FLAG"+ i + ".value ='X';");
        } else {
            eval("document.form1.OMIT_FLAG"+ i + ".value ='';");
        }

    }
    //필드 enable처리
    setEnable();
	document.form1.jobid.value = "AddorDel";
	document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustMedicalSV";
 	document.form1.method = "post";
    document.form1.target = "menuContentIframe";
	document.form1.submit();
}

function resno_chk(obj){
    if( chkResnoObj_1(obj) == false ) {
        return false;
    }
}


// 값이 변경되었는지 체크한다
function chk_change() {
    flag = false;
}

// onLoad시 호출됨.
function first(){
    var l_check = "";
    for( var i = 0 ; i < "<%= medi_count %>" ; i++ ) {
        eval("document.form1.OLDD"+ i + ".disabled = true;") ;
        eval("document.form1.OBST"+ i + ".disabled = true;");
        l_check = "";
<%
    String old_Name = "";
    for( int j = 0 ; j < MediPeP_vt.size() ; j++ ){
        D11TaxAdjustPrePersonData fdata = (D11TaxAdjustPrePersonData)MediPeP_vt.get(j);
        if (!fdata.ENAME.equals(old_Name)&& !fdata.ENAME.equals("")&& !fdata.REGNO.equals("")) {
%>
            if( "<%= fdata.REGNO.equals("") ? "" : DataUtil.addSeparate(fdata.REGNO) %>" == eval("document.form1.F_REGNO"+ i + ".value") )
                if( <%= fdata.DPTID.equals("X") %> )
                    l_check = "Y";
<%
        }
        old_Name = fdata.ENAME;
    }
%>
    }
}

function businoFormat1(i,obj) {
    if ( eval("document.form1.GUBUN"+i+".value") == "1" )
        return false;
    else
        businoFormat(obj);
}

//@v1.2 성명변경시 관계 값 선택
function subty_change(row, obj) {
 	  var val = obj[obj.selectedIndex].value;//DREL_CODE
    var inx = obj.selectedIndex;
    if( inx > 0 ) {
        var fami_rlat =  eval( "document.form1.FAMI_RLAT"+(inx-1)+".value"); //선택된 성명의 관계코드
        var fami_regn =  eval( "document.form1.FAMI_REGN"+(inx-1)+".value"); //선택된 성명의 주민번호
        var fami_b001 =  eval( "document.form1.FAMI_B001"+(inx-1)+".value"); //선택된 성명의 인적공제 기본공제
        var fami_b002 =  eval( "document.form1.FAMI_B002"+(inx-1)+".value"); //선택된 성명의 인적공제 장애인여부

        var subI =  eval( "document.form1.SUBTY0.length");     //화면의관계코드index
        //화면의성명에 해당하는 관계코드setting
        for ( i=0; i< subI ; i++ ) {
           if ( eval( "document.form1.SUBTY"+row+"["+i+"].value") == fami_rlat )
               eval( "document.form1.SUBTY"+row+"["+i+"].selected = true;");
        }
        //화면의성명에 해당하는 주민번호setting
        eval( "document.form1.F_REGNO"+row+".value = \""+addResBar(fami_regn)+"\";");
        //화면의성명에 해당하는 장애인여부setting
        if (fami_b002 == "X" ) {
            eval( "document.form1.OBST"+row+".checked = true;");
        } else {
            eval( "document.form1.OBST"+row+".checked = false;");
        }
    } else {
        eval( "document.form1.SUBTY"+row+"["+inx+"].selected = true;");
        eval( "document.form1.F_REGNO"+row+".value = \"\";");
        eval( "document.form1.OBST"+row+".checked = false;");
        eval( "document.form1.OBST"+row+".disabled = true;");
        eval( "document.form1.CONTENT"+row+".value = \"\";");
        eval( "document.form1.METYP"+row+"[0].selected = true;");
        eval( "document.form1.BIZNO"+row+".value = \"\";");
        eval( "document.form1.BIZ_NAME"+row+".value = \"\";");
        eval( "document.form1.CA_CNT"+row+".value = \"\";");
        eval( "document.form1.CA_BETRG"+row+".value = \"\";");
        eval( "document.form1.OLDD"+row+".value = \"\";");
        eval( "document.form1.GUBUN"+row+".value = \"\";");
        eval( "document.form1.CHNTS"+row+".value = \"\";");
        eval( "document.form1.GLASS_CHK"+row+".value = \"\";");
        eval( "document.form1.DIFPG_CHK"+row+".value = \"\";"); //@2015 연말정산 난임시술비 추가
        eval( "document.form1.OMIT_FLAG"+row+".value = \"\";");

    }
}
//@v1.4 금액 합계계산
function checkMoney(obj, cnt) {
    var hap = 0;
    val3 = eval("removeComma(document.form1.CA_BETRG"+cnt+".value)");
    hap = Number(val3);
    if( hap > 0 ) {
        hap = pointFormat(hap, 0);

        eval("document.form1.BETRG"+cnt+".value = insertComma(hap);") ;
    }else if( hap == 0 ){
        eval("document.form1.BETRG"+cnt+".value = '';");
    }

}
//@v1.1 사업자번호 명칭검색
function name_search(obj,i)
{
    val1 = obj.value;
    val1 = rtrim(ltrim(val1));

    if ( val1 == "" ) {
        return;
    }
    document.form1.BUS01.value = removeResBar2(val1);
    document.form1.INX.value = i;
    document.form1.target = "ifHidden";
    document.form1.action = "<%=WebUtil.JspURL%>D/D11TaxAdjust/D11TaxAdjustMediHiddenbusiName.jsp";
    document.form1.submit();
} // @v1.1 end function

//@2015연말정산 안경콘택트, 난임시술비 중복 불가
function noDup(code , i ){//code 1 = 안경, 2 = 난임
	var glassVal = "";
	if(code== "1" && eval("document.form1.GLASS_CHK"+i+".checked")){
		eval("document.form1.DIFPG_CHK"+i+".checked = false");
	}else if (code == "2" && eval("document.form1.DIFPG_CHK"+i+".checked")){
		eval("document.form1.GLASS_CHK"+i+".checked = false");
	}
}
//입력취소
function cancel(){
    if(confirm("<spring:message code='MSG.D.D11.0038' />")){ //입력작업을 취소하시겠습니까?
        document.form1.jobid.value = "first";
        document.form1.action = "<%= WebUtil.ServletURL %>hris.D.D11TaxAdjust.D11TaxAdjustMedicalSV";
        document.form1.method = "post";
        document.form1.target = "menuContentIframe";
        document.form1.submit();
    }
}
//-->
</SCRIPT>

 <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
 </jsp:include>
<form name="form1" method="post">

		<%@ include file="D11TaxAdjustButton.jsp" %>
        <!--특별공제 테이블 시작-->
     <div class="listArea">
        <div class="listTop">
            <div class="buttonArea">
                <ul class="btn_mdl">
                    <li><a href="javascript:add_field();""><span><spring:message code="BUTTON.COMMON.LINE.ADD" /><!-- 추가 --></span></a></li>
                    <li><a href="javascript:remove_field();"><span><spring:message code="BUTTON.COMMON.LINE.DELETE" /><!-- 삭제 --></span></a></li>
                </ul>
            </div>
        </div>
        <div class="table">
            <table class="listTable"  id="table">
              <thead>
              <tr>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0047" /><!-- 선택 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0009" /><!-- 관계 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0005" /><!-- 성명 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0010" /><!-- 주민번호 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0171" /><!-- 의료비 내용 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0172" /><!-- 의료증빙유형 --></th><!--CSR ID:1361257-->
                <th rowspan="2"><spring:message code="LABEL.D.D11.0173" /><!-- 안경<br>콘택트 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0174" /><!-- 난임<br>시술비 --></th><!-- @2015연말정산 -->
                <th colspan="2"><spring:message code="LABEL.D.D11.0175" /><!-- 요양기관 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0176" /><!-- 건수 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0069" /><!-- 금액 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0177" /><!-- 만65세<br>이상자 --></th>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0178" /><!-- 장애<br>자 --></th>
                <!--  회사지원분삭제 2017.1.6 김지수k요청 -->
                <%--<th rowspan="2"><spring:message code="LABEL.D.D11.0121" /><!-- 회사<br>지원분 --></th> --%>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0076" /><!-- 국세청<br>자료 --></th>
                <% if("Y".equals(pdfYn)) {%>
                <th rowspan="2"><spring:message code="LABEL.D.D11.0054" /><!-- PDF --></th>
                <%} %>
                <th class="lastCol" rowspan="2"><spring:message code="LABEL.D.D11.0055" /><!-- 연말정산삭제 --></th>
              </tr>
              <tr>
                <th><spring:message code="LABEL.D.D11.0139" /><!-- 사업자번호 --></th>
                <th><spring:message code="LABEL.D.D11.0179" /><!-- 상호 --></th>
              </tr>
              </thead>
<%
    old_Name = "";
    int index = 0;
    // @v1.3
    for( int j = 0 ; j < MediPeP_vt.size() ; j++ ){
        D11TaxAdjustPrePersonData fdata = (D11TaxAdjustPrePersonData)MediPeP_vt.get(j);
        if (!fdata.ENAME.equals(old_Name)&& !fdata.ENAME.equals("")&& !fdata.REGNO.equals("")) {

%>
           <input type=hidden name="FAMI_RLAT<%= index %>" value="<%=fdata.KDSVH%>">
           <input type=hidden name="FAMI_REGN<%= index %>" value="<%=fdata.REGNO%>">
           <input type=hidden name="FAMI_B001<%= index %>" value="<%=fdata.DPTID%>">
           <input type=hidden name="FAMI_B002<%= index %>" value="<%=fdata.HNDID%>">

<%
        index = index + 1;

        }
        old_Name = fdata.ENAME;
    }
%>


<%
    for( int i = 0 ; i < medi_vt.size() ; i++ ){
        D11TaxAdjustMedicalData data = (D11TaxAdjustMedicalData)medi_vt.get(i);
%>
          <tr class="<%=WebUtil.printOddRow(i) %>">
         <input type=hidden name="BETRG<%=i%>" value="0">
         <input type=hidden name="CNT<%=i%>" value="0">
            <input type="hidden" name="use_flag<%=i%>"  value="Y"><!--@v1.4-->
            <td><!--@v1.4-->
              <input type="radio" name="radiobutton" value="<%=i%>" <%= data.GUBUN.equals("9")||data.GUBUN.equals("1") ? "disabled" : "" %>>
            </td>
            <td>
              <select name="SUBTY<%=i%>" style="width=70px" auto class="input04" disabled>
                <option value="">-------------</option>
<%= WebUtil.printOption((new D11FamilyRelationRFC()).getFamilyRelation(""), data.SUBTY) %>
              </select>
            </td>
            <td>
              <select name="F_ENAME<%=i%>"  style="width=60px" auto class="<%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "input04" : "input03" %>" onChange="javascript:subty_change(<%=i%>,this);checkAgeField(<%=i%>);" <%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "disabled" : "" %>>
                <option value="">--------</option>
<%
    //@v1.3
    old_Name = "";
    for( int j = 0 ; j < MediPeP_vt.size() ; j++ ){
        D11TaxAdjustPrePersonData fdata = (D11TaxAdjustPrePersonData)MediPeP_vt.get(j);
        if (!fdata.ENAME.equals(old_Name)&& !fdata.ENAME.equals("")&& !fdata.REGNO.equals("")) {
             if (data.F_ENAME.equals(fdata.ENAME)) {
%>
                     <option value="<%=fdata.ENAME%>" selected><%=fdata.ENAME%></option>
<%
             } else  {
%>
                     <option value="<%=fdata.ENAME%>"><%=fdata.ENAME%></option>
<%
             }
         }
         old_Name = fdata.ENAME;

    }
%>

              </select>
            </td>
            <td>
              <input type="text" name="F_REGNO<%=i%>" value="<%= data.F_REGNO.equals("") ? "" : DataUtil.addSeparate(data.F_REGNO) %>" size="13" class="input04" maxlength="14" onBlur="javascript:<%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "return;" : "" %>resno_chk(this);" readonly>
            </td>
            <td>
              <input type="text" name="CONTENT<%=i%>" value="<%= data.CONTENT.equals("") ? "" : data.CONTENT %>" size="13" class="<%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "input04" : "input03" %>" maxlength="20"  <%= data.GUBUN.equals("1")||data.METYP.equals("1")||data.GUBUN.equals("9") ? "disabled" : "" %>>
            </td>
            <td nowrap>
            <select style="width=70px" auto   name="METYP<%= i %>" class="input03"  id="d_METYP<%=i%>"  onChange="javascript:metyp_change(<%=i%>,this);"  <%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "disabled" : "" %>>
                    <option value="">-------------</option>
    <%= WebUtil.printOption((new D11TaxAdjustMedicalTypeRFC()).getMedicalType(), data.METYP) %>
            </select></td><!--코드 CSR ID:1361257-->
            <td>
              <input type="checkbox" name="GLASS_CHK<%=i%>" value="<%=  data.GLASS_CHK.equals("") ? "" : data.GLASS_CHK %>" <%= data.GLASS_CHK.equals("X")  ? "checked" : "" %> class="input03" <%=data.GUBUN.equals("9") ? "disabled" : "" %> onclick="noDup('1','<%=i%>');">
            </td><!--안경콘택트-->
            <td>
              <input type="checkbox" name="DIFPG_CHK<%=i%>" value="<%=  data.DIFPG_CHK.equals("") ? "" : data.DIFPG_CHK %>" <%= data.DIFPG_CHK.equals("X")  ? "checked" : "" %> class="input03" <%=data.GUBUN.equals("9") ? "disabled" : "" %> onclick="noDup('2','<%=i%>');">
            </td><!--@2015연말정산 난임시술비 추가-->
            <input type=hidden name="METYP_NAME<%=i%>" value="">
            <td>
              <input type="text" name="BIZNO<%=i%>" value="<%= data.BIZNO.equals("") ? "" : DataUtil.addSeparate2(data.BIZNO) %>" size="12" class="<%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "input04" : "input03" %>" maxlength="12" onBlur="javascript:<%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "return;" : "" %>name_search(this,<%=i%>);businoFormat1(<%=i%>,this);return;usableChar(this, '0123456789');" <%= data.GUBUN.equals("1")||data.METYP.equals("1")||data.GUBUN.equals("9") ? "disabled" : "" %>>
            </td>
            <td>
              <input type="text" name="BIZ_NAME<%=i%>" value="<%= data.BIZ_NAME.equals("") ? "" : data.BIZ_NAME %>" size="13" class="<%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "input04" : "input03" %>" maxlength="20" <%= data.GUBUN.equals("1")||data.METYP.equals("1")||data.GUBUN.equals("9") ? "disabled" : "" %>>
            </td>

            <td>
              <input type="text" name="CA_CNT<%=i%>" value="<%= data.CA_CNT.equals("") ? "" : Integer.toString(Integer.parseInt(data.CA_CNT)) %>" size="3" class="<%= data.GUBUN.equals("1")||data.METYP.equals("1")||data.GUBUN.equals("9") ? "input04" : "input03" %>" style="text-align:right" maxlength="5" onBlur="javascript:<%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "return;" : "" %>usableChar(this, '0123456789');" <%= data.GUBUN.equals("1")||data.METYP.equals("1")||data.GUBUN.equals("9") ? "disabled" : "" %>>
            </td>
            <td>
              <input type="text" name="CA_BETRG<%=i%>" value="<%= data.CA_BETRG.equals("")  ? "" : WebUtil.printNumFormat(data.CA_BETRG) %>" size="10" maxlength="11" class="<%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "input04" : "input03" %>" onKeyUp="javascript:<%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "return;" : "" %>moneyChkEventForWon(this);" style="text-align:right" <%= data.GUBUN.equals("1")||data.GUBUN.equals("9") ? "readonly" : "" %>>
            </td>
            <td>
              <input type="checkbox" name="OLDD<%=i%>" value="<%=  data.OLDD.equals("") ? "" : data.OLDD %>" <%= data.OLDD.equals("X")  ? "checked" : "" %> class="input03" <%= data.GUBUN.equals("9")  ? "disabled" : "" %>>
            </td>
            <td>
              <input type="checkbox" name="OBST<%=i%>" value="<%=  data.OBST.equals("") ? "" : data.OBST %>" <%= data.OBST.equals("X")  ? "checked" : "" %> class="input03" <%= data.GUBUN.equals("9")  ? "disabled" : "" %>>
            </td>
            <!--  회사지원분삭제 2017.1.6 김지수k요청 -->
            <td style="display:none"><!--@v1.4-->
              <input type="checkbox" name="GUBUN<%=i%>" value="<%=  data.GUBUN.equals("") ? "" : data.GUBUN %>" <%= data.GUBUN.equals("1")  ? "checked" : "" %> class="input03" disabled>
            </td>
            <td>
              <input type="checkbox" name="CHNTS<%=i%>" value="<%=  data.CHNTS.equals("") ? "" : data.CHNTS %>" <%= data.CHNTS.equals("X")  ? "checked" : "" %> class="input03"  disabled>
            </td>
            <% if("Y".equals(pdfYn)) {%>
            <td>
             <input type="checkbox" name="PDF<%=i%>" value="<%=  data.GUBUN.equals("9") ? "X" : "" %>" <%= data.GUBUN.equals("9")  ? "checked" : "" %> class="input03" disabled>
            </td>
            <%} else {%>
            	<div style="display:none">
            	<input type="checkbox" name="PDF<%=i%>">
            	</div>
            <%} %>
            <td class="lastCol">
              <input type="checkbox" name="OMIT_FLAG<%=i%>" value="<%=  data.OMIT_FLAG.equals("") ? "" : data.OMIT_FLAG %>" <%= data.OMIT_FLAG.equals("X")  ? "checked" : "" %> class="input03"   <%= data.GUBUN.equals("1")||data.GUBUN.equals("9")  ? "" : "disabled" %> >
            </td>
          </tr>
<%
    }
%>
<%
    for( int i = medi_vt.size() ; i < medi_count ; i++ ){
%>
          <tr class="<%=WebUtil.printOddRow(i) %>">
            <input type="hidden" name="use_flag<%=i%>" value="Y"><!--@v1.4-->
            <td><!--@v1.4-->
              <input type="radio" name="radiobutton" value="<%=i%>" <%=(i==0) ? "checked" : "" %>>
            </td>

            <td>
              <select name="SUBTY<%=i%>"  style="width=70px" auto class="input04" disabled>
                <option value="">-------------</option>
<%= WebUtil.printOption((new D11FamilyRelationRFC()).getFamilyRelation(""), "") %>
              </select>
            </td>
            <td>
              <select name="F_ENAME<%=i%>"  style="width=60px" auto class="input03" onChange="javascript:subty_change(<%=i%>,this);checkAgeField(<%=i%>);">
                <option value="">--------</option>
<%
    // @v1.3
    old_Name = "";
    for( int j = 0 ; j < MediPeP_vt.size() ; j++ ){

        D11TaxAdjustPrePersonData fdata = (D11TaxAdjustPrePersonData)MediPeP_vt.get(j);
        if (!fdata.ENAME.equals(old_Name)&& !fdata.ENAME.equals("")&& !fdata.REGNO.equals("")) {
%>
                <option value="<%=fdata.ENAME%>"><%=fdata.ENAME%></option>
<%
        }
        old_Name = fdata.ENAME;

    }
%>

              </select>
            </td>
            <td>
              <input type="text" name="F_REGNO<%=i%>" value="" size="13" class="input04" readonly maxlength="14" onBlur="javascript:return;resno_chk(this);">
            </td>
            <td>
              <input type="text" name="CONTENT<%=i%>" value="" size="13" class="input03" maxlength="20">
            </td>
            <td>
            <select style="width=70px" auto  name="METYP<%= i %>"   id="d_METYP<%=i%>"  class="input03" onChange="javascript:metyp_change(<%=i%>,this);">
                    <option value="">-------------</option>
    <%= WebUtil.printOption((new D11TaxAdjustMedicalTypeRFC()).getMedicalType(), "") %>
            </select></td><!--코드 CSR ID:1361257-->
            <td>
              <input type="checkbox" name="GLASS_CHK<%=i%>" value="" class="input03" onclick="noDup('1','<%=i%>');">
            </td>
            <td>
              <input type="checkbox" name="DIFPG_CHK<%=i%>" value="" class="input03" onclick="noDup('2','<%=i%>');">
            </td><!-- @2015 연말정산 난임시술비 추가 -->
            <input type="hidden" name="METYP_NAME<%=i%>" value="">
            <td>
              <input type="text" name="BIZNO<%=i%>" value="" size="12" class="input03"  maxlength="12" onBlur="javascript:name_search(this,<%=i%>);businoFormat1(<%=i%>,this);return;usableChar(this, '0123456789');">
            </td>
            <td>
              <input type="text" name="BIZ_NAME<%=i%>" value="" size="13" class="input03" maxlength="20">
            </td>
            <td>
              <input type="text" name="CA_CNT<%=i%>" value="" size="3" class="input03"  style="text-align:right" maxlength="5" onBlur="javascript:usableChar(this, '0123456789');">
            </td>
            <td>
              <input type="text" name="CA_BETRG<%=i%>" value="" size="10" class="input03" maxlength="11"  onKeyUp="javascript:moneyChkEventForWon(this);" style="text-align:right">
            </td>
            <td>
              <input type="checkbox" name="OLDD<%=i%>" value="" class="input03" >
            </td>
            <td>
              <input type="checkbox" name="OBST<%=i%>" value="" class="input03">
            </td>
            <!--  회사지원분삭제 2017.1.6 김지수k요청 -->
            <td style="display:none">
              <input type="checkbox" name="GUBUN<%=i%>" value="" class="input03" disabled>
            </td>
            <td>
              <input type="checkbox" name="CHNTS<%=i%>" value="" class="input03" disabled>
            </td>
            <% if("Y".equals(pdfYn)) {%>
            <td>
             <input type="checkbox" name="PDF<%=i%>" value="" class="input03" disabled>
            </td>
            <%} else {%>
            	<div style="display:none">
            	<input type="checkbox" name="PDF<%=i%>">
            	</div>
            <%} %>
            <td  class="lastCol">
              <input type="checkbox" name="OMIT_FLAG<%=i%>" value="" class="input03" disabled>
            </td>
          </tr>
<%
    }
%>
            </table>
            <span class="commentOne"><spring:message code="LABEL.D.D11.0058" /><!-- PDF를 통하여 업로드 된 경우에는 “PDF”열에 표시되며, 반영을 취소할 경우에는 “연말정산 삭제”열에 체크 --></span>
        </div>
    </div>
    <!--특별공제 테이블 끝-->
    <div class="buttonArea underList">
        <ul class="btn_crud">
            <li><a class="darken" href="javascript:do_change();"><span><spring:message code="BUTTON.COMMON.INSERT" /><!-- 입력 --></span></a></li>
            <li><a href="javascript:cancel();"><span><spring:message code="BUTTON.COMMON.CANCEL" /><!-- 취소 --></span></a></li>
        </ul>
    </div>
    <div class="commentImportant" style="width:740px;">
        <p><span class="bold"><spring:message code="LABEL.D.D11.0059" /><!-- 주의사항 --></span></p>
        <p><spring:message code="LABEL.D.D11.0180" /><!-- 1. 연말정산 간소화 서비스를 통한 증빙 제출시에는 요양기관(사업자번호 및 상호) 입력없이 건수와 금액만 입력 --></p>
        <!--  회사지원분삭제 2017.1.6 김지수k요청 -->
        <%--<p><spring:message code="LABEL.D.D11.0181" /><!-- 2. 회사에서 지원 받은 의료비 내역이 보여지며, 연말정산 공제 적용하기 위해서는 "연말정산삭제"열 체크 된 부분을 해지해야 함 --></p> --%>
        <p><spring:message code="LABEL.D.D11.0182" /><!-- 2. 시력보정용 안경 또는 콘택트렌즈 구입시 발생한 비용은 “안경콘택트”에 반드시 체크해야 함 --></p>
        <p><spring:message code="LABEL.D.D11.0183" /><!-- 3. 난임시술비 의료비의 경우 난임시술비용만 별도로 입력후 "난임시술비"에 반드시 체크해야 함 --></p>
        <p class="small">  - <spring:message code="LABEL.D.D11.0184" /><!--  국세청 PDF로 올릴 경우 난임시술비로 자동으로 체크가 안되므로 난임시술비용이 있는 경우에는 PDF로 입력하지 마시고 직접 입력하여 주시기 바랍니다. --></p>
   </div>

<!-- 숨겨진 필드 -->
  <input type="hidden" name="jobid"      value="">
  <input type="hidden" name="targetYear" value="<%= targetYear %>">
  <input type="hidden" name="rowCount"   value="<%= rowCount %>">
  <input type="hidden" name="medi_count" value="<%= medi_count %>">
  <input type="hidden" name="curr_job" value="change">
  <input type="hidden" name="test" value="<%= medi_vt.toString() %>">

  <input type="hidden" name="BUS01"         value="">
  <input type="hidden" name="INX"           value="">

<iframe name="ifHidden" width="0" height="0" /></iframe>
<!-- 숨겨진 필드 -->
</form>



<script>

//@v1.2 성명변경시 관계 값 선택
function  metyp_change(row, obj) {
    var val = obj[obj.selectedIndex].value;//DREL_CODE
    var inx = obj.selectedIndex;
    if( val == "1" ) {
       eval("document.form1.CHNTS"+ row + ".checked = true") ;
       eval("document.form1.CHNTS"+ row + ".value ='X';");
    } else {
       eval("document.form1.CHNTS"+ row + ".checked = false") ;
       eval("document.form1.CHNTS"+ row + ".value ='';");
    }
    if (obj.value=="1"){ //1.국세청장이 제공하는 의료비
       eval("document.form1.BIZNO"+ row + ".disabled = true") ;
       eval("document.form1.BIZ_NAME"+ row + ".disabled = true") ;

       eval("document.form1.BIZNO"+ row + ".value = ''") ;
       eval("document.form1.BIZ_NAME"+ row + ".value = ''") ;
       eval("document.form1.CONTENT"+ row + ".disabled = true") ;  //C20121213_34842
       eval("document.form1.CA_CNT"+ row + ".disabled = true") ;   //C20121213_34842
       eval("document.form1.CONTENT"+ row + ".value = ''") ;       //C20121213_34842
       eval("document.form1.CA_CNT"+ row + ".value = ''") ;        //C20121213_34842
    }else{
       eval("document.form1.BIZNO"+ row + ".disabled = false") ;
       eval("document.form1.BIZ_NAME"+ row + ".disabled = false") ;
       eval("document.form1.CONTENT"+ row + ".disabled = false") ;  //C20121213_34842
       eval("document.form1.CA_CNT"+ row + ".disabled = false") ;   //C20121213_34842
    }

    <%

     Vector D11TaxAdjustMedicalType_vt  = (new D11TaxAdjustMedicalTypeRFC()).getMedicalType();

    for( int i = 0 ; i < D11TaxAdjustMedicalType_vt.size() ; i++ ) {
        CodeEntity codeEnt = (CodeEntity)D11TaxAdjustMedicalType_vt.get(i);
   %>
	document.getElementById( 'd_METYP'+row ).options[<%=i+1%>].text='<%=codeEnt.value%>';
   <%
    }
   %>
 	refresh_selectbox(document.getElementById('d_METYP'+row ));
	document.getElementById('d_METYP'+row ).focus();

}
/***********************************************************
* 자동으로 사이즈가 변하는 select box Ver20070423박규선
* 사용법: <select style="width=100px" auto></select>
* 제약조건  onmouseover onclick onmouseout onblur 를 정의하지 말것
* 구현은   onchange 이벤트에 구현하세요
************************************************************/
function autoselectboxsize(){
 var _obj ;
 var arr = document.getElementsByTagName('select');
 var w,h;
 for(var i=0;i<arr.length;i++){
   _obj = arr[i];
   if(_obj.getAttribute("auto")!=null){
    w=_obj.offsetWidth-1;
    h=_obj.offsetHeight;
    _obj.onmouseover="if(this.ow==undefined){this.ow=this.offsetWidth}if(this.n==undefined||this.n==false){this.style.width='';if(this.offsetWidth<=this.ow){this.n=true;this.style.width=this.ow+'px';}}";
    _obj.onclick="this.b=true;if(this.n==true){return;}if(this.n==undefined||this.n==false){this.style.width='';if(this.offsetWidth<=this.ow){this.n=true;this.style.width=this.ow+'px';this.onclick=null;}}";
    _obj.onmouseout="if(this.b==true){return;}if(this.n==undefined||this.n==false){this.style.width=this.ow+'px';}";
    _obj.onblur="this.b=false;if(this.ow!=undefined){this.style.width=this.ow+'px';}";
    _obj.outerHTML="<div  nowrap style='width:" + w + ";height:" + h + "px;overflow:hidden;text-overflow:ellipsis;padding-top:0px;'>" +_obj.outerHTML+"</div>";
    _obj.removeAttribute("auto");
   }
 }
}
/***********************************************************
* 사이즈 내용이 변경된 경우 호출 select box Ver20070423박규선
* 사용법: refresh_selectbox(selectbox_objects_instance)

************************************************************/
function refresh_selectbox(obj){
 obj.ow=undefined;
 obj.n=undefined;
}
autoselectboxsize(); //맨 아래에서 호출하세요.

</script>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
