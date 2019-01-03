
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS ?                                                         */
/*   1Depth Name  : 공통  ?                                                    */
/*   2Depth Name  :                                                             */
/*   Program Name : 주택자금신청 담당자 조회                                                 */
/*   Program ID   : ContactListPop.jsp                                            */
/*   Description  : 주택자금신청 담당자 조회 PopUp                                           */
/*   Note         : 담당자 버튼 클릭 시 나오는 화면                                        */
/*   Creation     : 2016-05-27 김불휘S [CSR ID:C20160526_74869]                                         */
/*   Update       : 2017-05-12  eunha  [CSR ID:3377485] 담당자 변경 수정 건                                                          */
/*   Update       : 2017-07-12  eunha  [CSR ID:3430087] 담당자 변경 수정 건                                                          */
/*                   : 2018-03-28   cykim  [CSR ID:3613143] 주택자금 담당자 변경요청의 건                                         */
/*                                                                              */
/********************************************************************************/%>
 <%@page import="java.util.ArrayList"%>
<%@page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@include file="popupPorcess.jsp" %>

 <%
 //2017-07-12  eunha  [CSR ID:3430087] 담당자 변경 수정 건 start
 /*	String[] oChang = new String[3];
 oChang[0] = "오창"; oChang[1] = "이혜지 사원"; oChang[2] = "043) 219-7117";

 	String[] chungJu = new String[3];
 	chungJu[0] = "청주"; chungJu[1] = "이다미 사원"; chungJu[2] = "043) 261-7032";

 	String[] yeoSu = new String[3];
 	yeoSu[0] = "여수"; yeoSu[1] = "박명순 사원"; yeoSu[2] = "061) 680-1889";

 	String[] daeJeon = new String[3];
 	daeJeon[0] = "대전"; daeJeon[1] = "나현성 사원"; daeJeon[2] = "042) 866-5928";

 	String[] naJu = new String[3];
 	naJu[0] = "나주"; naJu[1] = "박성희 사원"; naJu[2] = "061) 330-1017";

 	String[] ickSan = new String[3];
 	ickSan[0] = "익산"; ickSan[1] = "유경심 사원"; ickSan[2] = "063) 830-4023";

 	String[] kimCheon = new String[3];
 	kimCheon[0] = "김천"; kimCheon[1] = "김민정 사원"; kimCheon[2] = "054) 420-1819";

 	String[] paJu = new String[3];
 	paJu[0] = "파주"; paJu[1] = "윤미라 사원"; paJu[2] = "031) 937-3068";

 	String[] kwaCheon = new String[3];
 	kwaCheon[0] = "과천"; kwaCheon[1] = "김선주 사원"; kwaCheon[2] = "02) 2206-0521";

 	String[] yeoYiDo = new String[3];
 	//[CSR ID:3377485] 담당자 변경 수정 건 start
 	//yeoYiDo[0] = "본사"; yeoYiDo[1] = "정은지 사원"; yeoYiDo[2] = "02) 3773-6728";
 	yeoYiDo[0] = "본사"; yeoYiDo[1] = "박난이 대리"; yeoYiDo[2] = "02) 3773-7814";
 	//[CSR ID:3377485] 담당자 변경 수정 건 end
*/


	String[] sList0 = new String[3];
 	//[CSR ID:3613143] 주택자금 담당자 변경요청의 건
	sList0[0] = "본사"; sList0[1] = "황지윤 사원"; sList0[2] = "02) 3773-6808";

	//[CSR ID:3613143] 주택자금 담당자 변경요청의 건  start
	/* String[] sList1 = new String[3];
	sList1[0] = "광화문"; sList1[1] = "임하경 사원"; sList1[2] = "02) 6924-3344"; */

	String[] sList1 = new String[3];
	sList1[0] = "여수공장"; sList1[1] = "박명순 사원"; sList1[2] = "061) 680-1889";

	String[] sList2 = new String[3];
	sList2[0] = "오창공장"; sList2[1] = "이혜지 사원"; sList2[2] = "043) 219-7117";

	String[] sList3 = new String[3];
	sList3[0] = "청주공장"; sList3[1] = "홍정희 사원"; sList3[2] = "043) 261-7034";

	String[] sList4 = new String[3];
	sList4[0] = "나주공장"; sList4[1] = "박성희 사원"; sList4[2] = "061) 330-1017";

	String[] sList5 = new String[3];
	sList5[0] = "익산공장"; sList5[1] = "유경심 사원"; sList5[2] = "063) 830-4023";

	String[] sList6 = new String[3];
	sList6[0] = "익산(전지재료)"; sList6[1] = "최수빈 사원"; sList6[2] = "063) 720-6610";

	String[] sList7 = new String[3];
	sList7[0] = "익산공장(생명)"; sList7[1] = "김인화 사원"; sList7[2] = "063) 830-4206";

	String[] sList8 = new String[3];
	sList8[0] = "김천공장"; sList8[1] = "김민정 사원"; sList8[2] = "054) 420-1819";

	String[] sList9 = new String[3];
	sList9[0] = "파주공장"; sList9[1] = "최지연 사원"; sList9[2] = "031) 937-3068";

	String[] sList10 = new String[3];
	sList10[0] = "오송공장"; sList10[1] = "장하나 사원"; sList10[2] = "043) 710-6003";

	String[] sList11 = new String[3];
	sList11[0] = "온산공장(생명)"; sList11[1] = "박동인 책임"; sList11[2] = "052) 231-5324";

	String[] sList12 = new String[3];
	sList12[0] = "기술원(대전)"; sList12[1] = "나현성 사원"; sList12[2] = "042) 866-5928";

	//[CSR ID:3613143] 주택자금 담당자 변경요청의 건
    String[] sList13 = new String[3];
	sList13[0] = "마곡"; sList13[1] = "이혜나 사원"; sList13[2] = "02) 6987-4510";

	String[] sList14 = new String[3];
	sList14[0] = "기술원(과천)"; sList14[1] = "김선주 사원"; sList14[2] = "02) 2206-0521";
	//[CSR ID:3613143] 주택자금 담당자 변경요청의 건  end

 	ArrayList<String[]> contactList = new ArrayList<String[]>();

 	contactList.add(0, sList0 );
 	contactList.add(1, sList1 );
 	contactList.add(2, sList2);
 	contactList.add(3, sList3 );
 	contactList.add(4, sList4);
 	contactList.add(5, sList5);
 	contactList.add(6, sList6 );
 	contactList.add(7, sList7 );
 	contactList.add(8, sList8);
 	contactList.add(9, sList9 );
 	contactList.add(10, sList10);
 	contactList.add(11, sList11);
 	contactList.add(12, sList12);
 	contactList.add(13, sList13);
 	contactList.add(14, sList14);
 	 //2017-07-12  eunha  [CSR ID:3430087] 담당자 변경 수정 건 end
 %>

<html>
<head>
<title>담당자 안내</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr1.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_style.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

</head>
<body>
<div class="winPop">
	<div class="header">
    	<span><spring:message code='LABEL.COMMON.0019' /><!-- 담당자 연락처 --></span>
		<a href="javascript:self.close()"><img src="<%= WebUtil.ImageURL %>sshr/btn_popup_close.png" /></a>
    </div>
    <div class="body">
    	<div class="listArea">
    		<div class="table">
      			<table class="listTable">
      			   <thead>
			        <tr>
			          <th width="300"><spring:message code='LABEL.COMMON.0017' /><!-- 사업장 --></td>
			           <th width="300"><spring:message code='LABEL.COMMON.0016' /><!-- 담당자 --></td>
			          <th width="300" class="lastCol"><spring:message code='LABEL.COMMON.0018' /><!-- 연락처 --></td>
			        </tr>
			        </thead>

<%
	for( String[] contact : contactList) {
%>
					<tr>
			      		<td><%=contact[0] %></td>
			      		<td><%=contact[1]%></td>
			     		<td class="lastCol"><%=contact[2]%></td>
			     	</tr>
<%
	}
%>
      			</table>
      		</div>
      	</div>
    	<ul class="btn_crud close">
    		<li><a href="javascript:self.close()"><span><spring:message code="BUTTON.COMMON.CLOSE"/><%--닫기--%></span></a>
    	</ul>
    </div>




</div>

</body>
</html>

