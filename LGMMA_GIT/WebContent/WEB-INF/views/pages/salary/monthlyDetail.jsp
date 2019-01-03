<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.D.D05Mpay.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %>
<%@ page import="hris.D.D08RetroDetailData" %>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.CodeEntity"%>
<%@ page import="com.sns.jdf.util.DateTime"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.SortUtil"%>
<%
	WebUserData user   = (WebUserData)session.getValue("user");

	Vector d05MpayDetailData1_vt = ( Vector ) request.getAttribute( "d05MpayDetailData1_vt" ) ; // 해외급여 반영내역(항목) 내역
      
    Vector d05MpayDetailData2_vt = ( Vector ) request.getAttribute( "d05MpayDetailData2_vt" ) ; // 지급내역/공제내역
    Vector d05ZocrsnTextData_vt  = ( Vector ) request.getAttribute( "d05ZocrsnTextData_vt" ) ;   // 급여사유 코드와 TEXT
    
    Vector d05MpayDetailData3_vt = ( Vector ) request.getAttribute( "d05MpayDetailData3_vt" ) ; // 과세추가내역
    Vector d05MpayDetailData4_vt = ( Vector ) request.getAttribute( "d05MpayDetailData4_vt" ) ; // 변형 과세추가내역
    
    Vector d05MpayDetailData5_vt = ( Vector ) request.getAttribute( "d05MpayDetailData5_vt" ) ; // 지급내역text
    Vector d05MpayDetailData6_vt = ( Vector ) request.getAttribute( "d05MpayDetailData6_vt" ) ; // 해외지급내역수정
      
    D05MpayDetailData4 d05MpayDetailData4 = (D05MpayDetailData4) request.getAttribute( "d05MpayDetailData4"  ) ; // 급여명세표 - 개인정보/환율 내역 
    D05MpayDetailData5 d05MpayDetailData5 = (D05MpayDetailData5) request.getAttribute( "d05MpayDetailData5"  ) ; // 지급내역/공제내역의 합

    String year      = ( String ) request.getAttribute("year");
    String month     = ( String ) request.getAttribute("month");
    String ocrsn     = ( String ) request.getAttribute("ocrsn");
    String seqnr     = ( String ) request.getAttribute("seqnr");  // 5월 21일 순번 추가 
    String k_yn      = "";
    String ocrsn_t   = ocrsn.substring(0,2);
    String dis_play  = "";

    int    startYear = Integer.parseInt( (user.e_dat03).substring(0,4) );
    int    endYear   = Integer.parseInt( DataUtil.getCurrentYear() );

    if( startYear < 2002 ){
        startYear = 2002;
    }

    Vector CodeEntity_vt = new Vector();
    for( int i = startYear ; i <= endYear ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }

    for ( int i = 0 ; i < d05MpayDetailData4_vt.size() ; i++ ) {
       D05MpayDetailData3 data4 = (D05MpayDetailData3)d05MpayDetailData4_vt.get(i);

       if(!data4.BET01.equals("0") ) {
          dis_play = "Y";
       }
    }

	//소급분
    Vector D08RetroDetailData_vt  = (Vector)request.getAttribute("D08RetroDetailData_vt"); //전체데이터를 담은 백터
    D08RetroDetailData_vt = SortUtil.sort( D08RetroDetailData_vt, "1", "asc" );
        
    Vector D08RetroDetailData1_vt = (Vector)request.getAttribute("D08RetroDetailData1_vt"); // 공제내역을 담은 백터
    D08RetroDetailData1_vt = SortUtil.sort( D08RetroDetailData1_vt, "1", "asc" );
    
    Vector D08RetroDetailData2_vt = (Vector)request.getAttribute("D08RetroDetailData2_vt"); // 지급내역을 담은 백터
    D08RetroDetailData2_vt = SortUtil.sort( D08RetroDetailData2_vt, "1", "asc" );
    
    Vector D08RetroDetailData3_vt = (Vector)request.getAttribute("D08RetroDetailData3_vt"); // 해당월을 1개씩만 담은 백터(단 지급유형이 다른것은 제외)
    D08RetroDetailData3_vt = SortUtil.sort( D08RetroDetailData3_vt, "1", "asc" );
    
    String total1                 = ( String ) request.getAttribute( "total1" ) ; // 공제내역의 소급액합
    String total2                 = ( String ) request.getAttribute( "total2" ) ; // 지급내역의 소급액합
   
    int total = Integer.parseInt(total2)-Integer.parseInt(total1); // 전체소급액
    String yno = "" ;
    String choi = "";
    String minwoo = "";

%>
				<!--// Page Title start -->
				<div class="title">
					<h1>월급여</h1>
					<div class="titleRight">
						<ul class="pageLocation">
							<li><span><a href="#">Home</a></span></li>
							<li><span><a href="#">My Info</a></span></li>
							<li><span><a href="#">급여</a></span></li>
							<li class="lastLocation"><span><a href="#">월급여</a></span></li>
						</ul>						
					</div>
				</div>
				<!--// Page Title end -->	
				
				<!--------------- layout body start --------------->				
				<div class="tableArea">
					<form id="searchForm">
					<input type="hidden" name="ocrsn" id="ocrsn" value="">
					<h2 class="subsubtitle">월급여 조회</h2>
					<div class="table">
						<table class="tableGeneral">
						<caption>월급여조회정보</caption>
						<colgroup>
							<col class="col_15p" />
							<col class="col_37p" />
							<col class="col_10p" />
							<col class="col_14p" />
							<col class="col_10p" />
							<col class="col_14p" />
						</colgroup>
						<tbody>
							<tr>
								<th><label for="input_select01">해당년월</label></th>
								<td colspan="6">
									<select id="year" name="year" class="w80"> 
<% 
    for( int i = DateTime.getYear() ; i > 2002 ; i-- ) {
        int year1 = Integer.parseInt(year);
%>
										<option value="<%= i %>"<%= year1 == i ? " selected " : "" %>><%= i %></option>
<%
    }
%>                  
									</select>
									<select id="month" name="month" class="w60">
<% 
    for( int i = 1 ; i < 13 ; i++ ) {
        String temp = Integer.toString(i);
        int mon = Integer.parseInt(month);
%>
										<option value="<%= i %>"<%= mon == i ? " selected " : "" %>><%= temp.length() == 1 ? '0' + temp : temp %></option>
<% 
    }
%>   
									</select>
									<select id="ZOCRSN" name="ZOCRSN" class="w100">
<%
    for ( int i = 0 ; i < d05ZocrsnTextData_vt.size() ; i++ ) {
        D05ZocrsnTextData data4 = (D05ZocrsnTextData)d05ZocrsnTextData_vt.get(i);
        if(data4.ZOCRTX.equals("급여+정산")) {                      
            continue;
        } else {   
%>
										<option value="<%= data4.ZOCRSN + data4.SEQNR %>" <%= ocrsn.equals(data4.ZOCRSN + data4.SEQNR) ? "selected" : ""%>><%= data4.ZOCRTX %></option>
<%
        }
    }
%>  
									</select>
									<a class="icoSearch" href="#"><img src="/web-resource/images/ico/ico_magnify.png" alt="검색"/></a>
									<div class="floatRight"><a class="inlineBtn" href="#" id="showSalBtn"><span>급여명세표</span></a></div>
								</td>
							</tr>
							<tr>
								<th>부서명</th>
								<td><%= user.e_orgtx %></td>
								<th>사번</th>
								<td><%= user.empNo %></td>
								<th>성명</th>
								<td><%= user.ename %></td>
							</tr>
						</tbody>
						</table>
					</div>
					</form>
<%  
    if(user.e_trfar.equals("02") || user.e_trfar.equals("03") || user.e_trfar.equals("04")) {   
%>
					<div class="tableComment">
						<p><span class="bold">개인 평가결과, 연봉 및 성과급 등 개인 처우 관련 사항을 社內外 제3자에게 절대로 공개하지 마시기 바라며, <br/>이를 위반시에는
    취업규칙상의 규정과 절차에 따라 징계조치 됨을 알려드립니다.</span></p>
					</div>
<%  
    }   
%>
				</div>
				<!--// Tab start -->
				<div class="tabArea">
					<ul class="tab">
						<li><a href="#" onclick="switchTabs(this, 'tab1');" class="selected">상세내역</a></li>
						<li><a href="#" onclick="switchTabs(this, 'tab2');" class="tab2">소급내역</a></li>
					</ul>
				</div>
				<!--// Tab end -->	
				<!--// Tab1 start -->
				<div class="tabUnder tab1">
					<div class="tableArea pb10" id="printArea01">
						<h3 class="subsubtitle">월급여 상세내역</h3>
						<div class="table">
							<table class="tableGeneral">
								<caption>월급여명세표</caption>
								<colgroup>
									<col class="col_15p" />
									<col class="col_18p" />
									<col class="col_15p" />
									<col class="col_18p" />
									<col class="col_15p" />
									<col class="col_19p" />
								</colgroup>
								<tbody>
								<tr>
									<th>총지급액</th>
									<td class=""><%= WebUtil.printNumFormat(d05MpayDetailData4.BET01) %></td>
									<th>공제총액</th>
									<td><%= WebUtil.printNumFormat(d05MpayDetailData5.BET02) %></td>
									<th>차감지급액</th>
									<td><%= WebUtil.printNumFormat(d05MpayDetailData4.BET03) %></td>
								</tr>
								</tbody>
							</table>
						</div>
					</div>
				
					<!--// List start -->	
					<div class="listArea" id="printArea02">
						<div class="table">
							<table class="listTable">
							<caption>연급여 내역 테이블</caption>
							<colgroup>
								<col class="col_20p"/>
								<col class="col_10p"/>
								<col class="col_20p"/>
								<col class="col_30p"/>
								<col class="col_20p"/>
							</colgroup>
							<thead>
								<tr>
									<th class="thAlignCenter">지급내역</th>						
									<th class="thAlignCenter">시간,%</th>
									<th class="thAlignCenter thRightLine">금액</th>
									<th class="thAlignCenter">공제내역</th>
									<th class="thAlignCenter tdBorder">금액</th>									
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="tdAlignLeft tdAlignTop">
										<ul class="tdList">
<%
        for( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
            D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
            if( !data5.LGTXT.equals("소급분총액") ) {  
%>                
       <li><%= data5.LGTXT.equals("") ? "　" : data5.LGTXT %></li>
<%
            }
        }
    
        for( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
            D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
            String kibon_text = "";
            if( data5.LGTXT.length() > 3 ) {
                kibon_text = data5.LGTXT.substring(0,3);
            } else {
                kibon_text = data5.LGTXT;
    	      }
    
            if( kibon_text.equals("기본급") || kibon_text.equals("급여소") || kibon_text.equals("청구") ) {
                k_yn = "Y";
            }
        }
    
        for( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
            D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
            if(data5.BET01.equals("0")){  
%>
        <li></li>
<%
            } else {
                if( k_yn.equals("Y") && data5.LGTXT.equals("소급분총액") ) {  
%>
        <li class="total"><a href="#" onclick="switchTabs('.tabArea ul.tab li a.tab2', 'tab2');" ><%= data5.LGTXT.equals("") ? "" : data5.LGTXT%></a></li>
<%
                }
            }
        }
%>
										</ul>
									</td>
									<td class="tdAlignRight tdAlignTop">
										<ul class="tdList">
<% 
        for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
            D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
            if(!data5.LGTXT.equals("소급분총액")) {  
%>
                <li><%= data5.ANZHL.equals("0") ? "　" : data5.ANZHL %></li>
<%
            }
        }
    
        for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
            D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
            if(data5.LGTXT.equals("소급분총액")) {  
%>
               <li><%= data5.ANZHL.equals("0") ? "　" : data5.ANZHL %></li>
<%
            }
        }
%>
										</ul>
									</td>
									<td class="tdAlignRight tdRightLine tdAlignTop">
										<ul class="tdList">
<% 
        for( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
            D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
            if(!data5.LGTXT.equals("소급분총액")) {  
%>
                <li><%= data5.BET01.equals("0") ? "　" : WebUtil.printNumFormat(data5.BET01) %></li>
<%
            }
        }
    
        for ( int i = 0 ; i < d05MpayDetailData5_vt.size() ; i++ ) {
            D05MpayDetailData2 data5 = (D05MpayDetailData2)d05MpayDetailData5_vt.get(i);
            if(data5.LGTXT.equals("소급분총액")) {
%>
               <li><%= data5.BET01.equals("0") ? "　" : WebUtil.printNumFormat(data5.BET01) %></li>
<%
            }
        }
%>
										</ul>
									</td>
									<td class="tdAlignLeft tdAlignTop">
										<ul class="tdList">
<% 
        for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
            D05MpayDetailData2 data2 = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
    		    if( data2.LGTX1.equals("") && data2.BET02.equals("0") ) {   
            		continue;
            } else { 
                if( data2.BET02.equals("0") ){
%>
          <li><%= data2.LGTX1 %></li>
<%
                } else {
                    if( data2.LGTX1.equals("소급분공제총액") ) { 
%>
                <li class="total"><a href="#" onclick="switchTabs('.tabArea ul.tab li a.tab2', 'tab2');" ><%= data2.LGTX1.equals("") ? "　" :  data2.LGTX1%></a></li>
<%
                    } else {
%>
                <li><%= data2.LGTX1.equals("") ? "　" : data2.LGTX1 %></li>
<% 
                    }
                }
            }
        }
%>
										</ul>
									</td>
									<td class="tdAlignRight tdAlignTop tdBorder">									
										<ul class="tdList">
	<% 
        for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
            D05MpayDetailData2 data2 = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
    
            if( data2.LGTX1.equals("") && data2.BET02.equals("0") ) {   
            		continue;
            } else { 
%>
                <li><%= data2.BET02.equals("0") ? "　" :WebUtil.printNumFormat(data2.BET02) %></li>

<%
            }
        }
%>
										</ul>
									</td>
								</tr>
								<tr class="total">
									<td class="tdAlignLeft"><strong>지급계</strong></td>
									<td class="tdAlignRight"><%= d05MpayDetailData5.ANZHL.equals("0") ? "" : d05MpayDetailData5.ANZHL %></td>
									<td class="tdAlignRight tdRightLine"><%= WebUtil.printNumFormat(d05MpayDetailData5.BET01) %></td>
									<td class="tdAlignLeft"><strong>공제계</strong></td>
									<td class="tdAlignRight tdBorder"><%= WebUtil.printNumFormat(d05MpayDetailData5.BET02) %></td>
								</tr>									
							</tbody>
							</table>
						</div>									
					</div>
					<!--// List end -->
<%
        if( ocrsn_t.equals("01") || ocrsn_t.equals("ZZ") ) {
            if(d05MpayDetailData4_vt.size() != 0 && dis_play.equals("Y") && d05MpayDetailData5_vt.size() != 0){
%>
					<!--// List start -->	
					<div class="listArea" id="printArea03">
						<h3 class="subsubtitle">과세추가 내역</h3>
						<div class="table">
							<table class="listTable">
							<caption>과세추가 내역</caption>
							<colgroup>
								<col class="col_25p"/>
								<col class="col_25p"/>
								<col class="col_25p"/>
								<col class="col_25p"/>
							</colgroup>
							<thead>
								<tr>
									<th class="thAlignCenter">과세반영 </th>		
									<th class="thAlignCenter thRightLine">금액</th>
									<th class="thAlignCenter">소급분과세반영</th>
									<th class="thAlignCenter tdBorder">금액</th>									
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="tdAlignLeft tdAlignTop">
										<ul class="tdList">
<% 
                for ( int i = 0 ; i < d05MpayDetailData4_vt.size() ; i++ ) {
                    D05MpayDetailData3 data4 = (D05MpayDetailData3)d05MpayDetailData4_vt.get(i);
                    String kase_text = "";
                    if( data4.LGTX1.length() > 4 ) {
                        kase_text = data4.LGTX1.substring(0,4);
                    } else {
                        kase_text = data4.LGTX1 ;
    	              }
                    if ( kase_text.equals("과세반영")) {   
%>
          <li><%= data4.LGTX1.equals("") ? "" : data4.LGTX1 %></li>
<%          
                    } else { 
                        continue; 
                    }
                }
%>
										</ul>
									</td>
									<td class="tdAlignRight tdAlignTop thRightLine">
										<ul class="tdList">
<% 
                for ( int i = 0 ; i < d05MpayDetailData4_vt.size() ; i++ ) {
                    D05MpayDetailData3 data4 = (D05MpayDetailData3)d05MpayDetailData4_vt.get(i);
                    String kase_text = "";
                    if( data4.LGTX1.length() > 4 ) {
                        kase_text = data4.LGTX1.substring(0,4);
                    } else {
                        kase_text = data4.LGTX1 ;
    	              }
                    if ( kase_text.equals("과세반영")) {   
%>
          <li><%= data4.BET01.equals("0") ? "" : WebUtil.printNumFormat(data4.BET01) %></li>
<%          
                    } else { 
                        continue; 
                    }
                }
%>
										</ul>
									</td>
									<td class="tdAlignLeft tdAlignTop">
										<ul class="tdList">
<% 
                for ( int i = 0 ; i < d05MpayDetailData4_vt.size() ; i++ ) {
                    D05MpayDetailData3 data4 = (D05MpayDetailData3)d05MpayDetailData4_vt.get(i);
                    String kase_text = "";
                    if( data4.LGTX1.length() > 4 ) {
                        kase_text = data4.LGTX1.substring(0,3);
                    } else {
                        kase_text = data4.LGTX1 ;
    	              }
                    if ( kase_text.equals("소급분")) {   
                        if(!data4.BET01.equals("0")) { 
%> 
          <li><%= data4.LGTX1.equals("") ? "" : data4.LGTX1 %></li>
<%
                        }
                    } else { 
                        continue; 
                    }
                }
%>
										</ul>
									</td>
									<td class="tdAlignRight tdAlignTop">
										<ul class="tdList">
<% 
                for ( int i = 0 ; i < d05MpayDetailData4_vt.size() ; i++ ) {
                    D05MpayDetailData3 data4 = (D05MpayDetailData3)d05MpayDetailData4_vt.get(i);
                    String kase_text = "";
                    if( data4.LGTX1.length() > 4 ) {
                        kase_text = data4.LGTX1.substring(0,3);
                    } else {
                        kase_text = data4.LGTX1 ;
    	              }
                    if ( kase_text.equals("소급분")) {
                        if(!data4.BET01.equals("0")) { 
%> 
          <li><%= data4.BET01.equals("0") ? "" : WebUtil.printNumFormat(data4.BET01) %></li>
<%
                        }
                    } else { 
                        continue; 
                    }
                }
%>
										</ul>
									</td>
								</tr>							
							</tbody>
							</table>
						</div>									
					</div>
<%
            }
        }   
%>
<%
        if( ocrsn_t.equals("01") || ocrsn_t.equals("ZZ") ) {  
%>
					<div class="tableArea" id="printArea04">
						<h3 class="subsubtitle">근태현황</h3>
						<div class="table">
							<table class="tableGeneral">
								<caption>근태현황</caption>
								<colgroup>
									<col class="col_15p" />
									<col class="col_18p" />
									<col class="col_15p" />
									<col class="col_18p" />
									<col class="col_15p" />
									<col class="col_19p" />
								</colgroup>
								<tbody>
								<tr>
									<th>근태일수</th>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat(Double.parseDouble(d05MpayDetailData4.WRK01),0) %>&nbsp;</td>
									<th>사용휴가일수</th>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat(Double.parseDouble(d05MpayDetailData4.WRK02),1) %>&nbsp;</td>
									<th>잔여휴가일수</th>
<%
            if (month.equals("12")) {           // 보상완료되는 시점
%>
                <td class="tdAlignRight">0.0&nbsp;</td>
<%
            } else {
%>
                <td class="tdAlignRight"><%= WebUtil.printNumFormat(Double.parseDouble(d05MpayDetailData4.WRK03),1) %>&nbsp;</td>
<%
            }
%>
								</tr>
								</tbody>
							</table>
						</div>
					</div>
<%
	}
%>
				</div>
				<!--// Tab1 end -->
				<!--// Tab2 start -->
				<div class="tabUnder tab2 Lnodisplay">	
					<div class="tableArea pb10">
						<h3 class="subsubtitle">월급여 소급내역</h3>
						<div class="table">
							<table class="tableGeneral">
								<caption>월급여명세표</caption>
								<colgroup>
									<col class="col_15p" />
									<col class="col_18p" />
									<col class="col_15p" />
									<col class="col_18p" />
									<col class="col_15p" />
									<col class="col_19p" />
								</colgroup>
								<tbody>
<%  // 해당월을 for문으로 돌림
	double sum7 = 0;
	int sum8 = 0;

	for ( int i = 0 ; i < D08RetroDetailData3_vt.size() ; i++ ) {
		D08RetroDetailData data4 = (D08RetroDetailData)D08RetroDetailData3_vt.get(i);
%>
<%    // 지급총액 
		for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
			D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j); 
			String kase_text ;
			String imgi_text = data3.LGTXT;
			if( data3.LGTXT.length() > 4 )
			{
				kase_text = data3.LGTXT.substring(0,4);
			}
			else
			{
				kase_text = data3.LGTXT ;
			}
%>
              <% if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){ %> 
<%                 if(kase_text.equals("과세반영")){   
 //                    choi = data3.PAYDT;
                     continue;
                   }else{   
%>                   
<%                  if(imgi_text.equals("임지생계비(현지화)") || imgi_text.equals("임지주택비차액(현지화)") || imgi_text.equals("국외일정액(현지화)") || imgi_text.equals("해외휴가비(현지화)") || imgi_text.equals("해외학자금(현지화)")) {                       
                      continue;
                    }else{
%>                   
                     <% sum7 += Double.parseDouble(data3.SOGUP_AMNT); %>
<%                  }                    %>
<%                 }                  %>            
              <% }  %>
<% 
           }  
%>

<%   // 공제총액
	       for ( int k = 0 ; k < D08RetroDetailData1_vt.size() ; k++ ) {
               D08RetroDetailData data2 = (D08RetroDetailData)D08RetroDetailData1_vt.get(k); 
%>
               <% if( data2.FPPER.equals( data4.FPPER ) && data2.OCRSN.equals( data4.OCRSN ) && data2.PAYDT.equals( data4.PAYDT )){ %>
                 <% sum8 += Double.parseDouble(data2.SOGUP_AMNT); %>
               <% } %>
<% 
           }
     }
%> 
								<tr>
									<th>지급계</th>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat(sum7) %></td>
									<th>공제계</th>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat(sum8) %></td>
									<th>차액계</th>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat(sum7 - sum8) %>
									</td>
								</tr>
								</tbody>
							</table>
						</div>
					</div>
					
					<!--// List start -->	
					<div class="listArea">
						<div class="table">
							<table class="listTable sty2">
							<caption>소급내역 테이블</caption>
							<colgroup>
								<col class="col_10p"/>
								<col class="col_8p"/>
								<col class="col_18p"/>
								<col class="col_9p"/>
								<col class="col_16p"/>
								<col class="col_9p"/>
								<col class="col_16p"/>
								<col class="col_14p"/>
							</colgroup>
							<thead>
								<tr>
								    <th rowspan="2" class="thAlignCenter">대상월</th>
								    <th rowspan="2" class="thAlignCenter">구분</th>
								    <th rowspan="2" class="thAlignCenter">항목</th>
								    <th colspan="2" class="thAlignCenter">소급전</th>
								    <th colspan="2" class="thAlignCenter">소급후</th>
								    <th rowspan="2" class="thAlignCenter tdBorder">소급액</th>
								  </tr>
								  <tr>
								    <th class="thAlignCenter">시간</th>
								    <th class="thAlignCenter">금액</th>
								    <th class="thAlignCenter">시간</th>
								    <th class="thAlignCenter">금액</th>
								  </tr>
							</thead>
							<tbody>
<%
	if(D08RetroDetailData3_vt.size() > 0 ) {
%>                
								<tr>
<%  // 해당월을 for문으로 돌림
	 for ( int i = 0 ; i < D08RetroDetailData3_vt.size() ; i++ ) {
      D08RetroDetailData data4 = (D08RetroDetailData)D08RetroDetailData3_vt.get(i);
      int intMonth = Integer.parseInt(data4.FPPER.substring(4));
      double sum1 = 0;
      double sum2 = 0;
      double sum3 = 0;
      double sum4 = 0;
      double sum5 = 0;
      double sum6 = 0;
      double sum10 = 0;
      double sum11 = 0;
 
 // 10월 28일 추가내용 -------------------------------------------------**     
        for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
              D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j); 
              String kase_text ;
              String imgi_text = data3.LGTXT;
              if( data3.LGTXT.length() > 4 )
              {
                 kase_text = data3.LGTXT.substring(0,4);
              }
              else
              {
                 kase_text = data3.LGTXT ;
			  }

               if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){  
                 if(kase_text.equals("과세반영")){   
                     choi = data3.PAYDT;
                     minwoo = data3.OCRTX;
                 }else{
                     continue;
                 }
               }
        }     
//------------------------------------------------------------------------**
%>
<%       if(choi.equals(data4.PAYDT) && minwoo.equals(data4.OCRTX)) {          %>
            <th rowspan="6"><%= intMonth %>월<br>
               (<%= data4.OCRTX %>)
            </th>
<%       }else{      %> 
            <th rowspan="5"><%= intMonth %>월<br>
               (<%= data4.OCRTX %>)
            </th>
<%       }      %>
									<td>지급내역</td>
									<td class="tdAlignLeft tdAlignTop">
             <% 
	          for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
               D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j); 
               String kase_text ;
              if( data3.LGTXT.length() > 4 )
              {
                 kase_text = data3.LGTXT.substring(0,4);
              }
              else
              {
                 kase_text = data3.LGTXT ;
			  }
             %> 
										<ul class="tdList">
              <% if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){ %>
<%                 if(kase_text.equals("과세반영")){ 
                     yno = data3.PAYDT;  
                     continue;
                   }else{   
// 소급분 Data 중에서 2004년 8월에 상여로 포함된 성과급인 생산성향상금 text에 대한 처리 (2004.09.24)
                        if( data3.FPPER.equals("200408") && data3.OCRSN.equals("0002") && data3.LGART.equals("3001") ) { 
%>
                     <li>생산성향상금</li>
<%
                        } else {
%>
                     <li><%= data3.LGTXT %></li>
<%
                        } 
%>
<%                 }                     %> 
              <% }  %>
              
            <% }  %>
										</ul>
									</td>
									<td class="tdAlignRight tdAlignTop">
            <% 
	          for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
               D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j); 
              String kase_text ;
              if( data3.LGTXT.length() > 4 )
              {
                 kase_text = data3.LGTXT.substring(0,4);
              }
              else
              {
                 kase_text = data3.LGTXT ;
			  }
             %> 
										<ul class="tdList">
              <% if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){ %>
<%                 if(kase_text.equals("과세반영")){  
                     yno = data3.PAYDT; 
                     continue;
                   }else{   
%>   
                     <li><%= data3.ANZHL.equals("0") ? "" : data3.ANZHL %></li>
                     <% sum11 += Double.parseDouble(data3.ANZHL); %>
<%                 }                     %> 
              <% }  %>
              
            <% }  %>
										</ul>
									</td>
									<td class="tdAlignRight tdAlignTop">
            <% 
	          for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
              String kase_text ;
              D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j); 
              String imgi_text = data3.LGTXT;
              double SOGUP_BEFORE = Double.parseDouble(data3.SOGUP_BEFORE) / 100;
              String SOGUP_BEFORE1 = Double.toString(SOGUP_BEFORE);
              if( data3.LGTXT.length() > 4 )
              {
                 kase_text = data3.LGTXT.substring(0,4);
              }
              else
              {
                 kase_text = data3.LGTXT ;
			  }
            %>
										<ul class="tdList">
              <% if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){ %> 
<%                 if(kase_text.equals("과세반영")){   
                     continue;
                   }else{   
%>  
<%                  if(imgi_text.equals("임지생계비(현지화)") || imgi_text.equals("임지주택비차액(현지화)") || imgi_text.equals("국외일정액(현지화)") || imgi_text.equals("해외휴가비(현지화)") || imgi_text.equals("해외학자금(현지화)")) {                       %>                                                  
                     <li><%= SOGUP_BEFORE1.equals("0.0") ? "" : WebUtil.printNumFormat(SOGUP_BEFORE1,2) %></li>
<%                  }else{             %>
                     <li><%= data3.SOGUP_BEFORE.equals("0.0") ? "" : WebUtil.printNumFormat(data3.SOGUP_BEFORE) %></li>
<%                  }              %>
<%                   if(!imgi_text.equals("임지생계비(현지화)") && !imgi_text.equals("임지주택비차액(현지화)") && !imgi_text.equals("국외일정액(현지화)") && !imgi_text.equals("해외휴가비(현지화)") && !imgi_text.equals("해외학자금(현지화)")) { %>                     
                        <% sum4 += Double.parseDouble(data3.SOGUP_BEFORE); %>
<%                   }                     %>
<%                 }                     %> 
              <% }  %>
            
            <% }  %>
										</ul>
									</td>
									<td class="tdAlignRight tdAlignTop">
            <% 
	          for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
               D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j); 
              String kase_text ;
              if( data3.LGTXT.length() > 4 )
              {
                 kase_text = data3.LGTXT.substring(0,4);
              }
              else
              {
                 kase_text = data3.LGTXT ;
			  }
             %> 
										<ul class="tdList">
              <% if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){ %>
<%                 if(kase_text.equals("과세반영")){   
                     continue;
                   }else{   
%>  
                     <li><%= data3.ANZHL1.equals("0") ? "" : data3.ANZHL1 %></li>
                     <% sum10 += Double.parseDouble(data3.ANZHL1); %>
<%                 }                     %>  
              <% }  %>
              
            <% }  %>
										</ul>
									</td>
									<td class="tdAlignRight tdAlignTop">
            <% 
	          for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
              D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j); 
              String kase_text ;
              String imgi_text = data3.LGTXT;
              double SOGUP_AFTER = Double.parseDouble(data3.SOGUP_AFTER) / 100;
              String SOGUP_AFTER1 = Double.toString(SOGUP_AFTER);
              if( data3.LGTXT.length() > 4 )
              {
                 kase_text = data3.LGTXT.substring(0,4);
              }
              else
              {
                 kase_text = data3.LGTXT ;
			  }
            %>
										<ul class="tdList">
               <% if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){ %> 
<%                 if(kase_text.equals("과세반영")){   
                     continue;
                   }else{   
%>                    
<%                  if(imgi_text.equals("임지생계비(현지화)") || imgi_text.equals("임지주택비차액(현지화)") || imgi_text.equals("국외일정액(현지화)") || imgi_text.equals("해외휴가비(현지화)") || imgi_text.equals("해외학자금(현지화)")) {                       %>                                                 
                     <li><%= SOGUP_AFTER1.equals("0.0") ? "" : WebUtil.printNumFormat(SOGUP_AFTER1,2) %></li>
<%                  }else{               %>       
                     <li><%= data3.SOGUP_AFTER.equals("0.0") ? "" : WebUtil.printNumFormat(data3.SOGUP_AFTER) %></li>
<%                  }      %>
<%                   if(!imgi_text.equals("임지생계비(현지화)") && !imgi_text.equals("임지주택비차액(현지화)") && !imgi_text.equals("국외일정액(현지화)") && !imgi_text.equals("해외휴가비(현지화)") && !imgi_text.equals("해외학자금(현지화)")) { %>                     
                        <% sum5 += Double.parseDouble(data3.SOGUP_AFTER); %>
<%                   }                     %>
<%                 }                  %>               
               <% }  %>
            <% }  %>
										</ul>
									</td>
									<td class="tdAlignRight tdAlignTop">
            <% 
	          for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
              D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j); 
              String kase_text ;
              String imgi_text = data3.LGTXT;
              double SOGUP_AMNT = Double.parseDouble(data3.SOGUP_AMNT) / 100;
              String SOGUP_AMNT1 = Double.toString(SOGUP_AMNT);
              if( data3.LGTXT.length() > 4 )
              {
                 kase_text = data3.LGTXT.substring(0,4);
              }
              else
              {
                 kase_text = data3.LGTXT ;
			   }
            %>
										<ul class="tdList">
              <% if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){ %> 
<%                 if(kase_text.equals("과세반영")){   
                     continue;
                   }else{   
%>                    
<%                  if(imgi_text.equals("임지생계비(현지화)") || imgi_text.equals("임지주택비차액(현지화)") || imgi_text.equals("국외일정액(현지화)") || imgi_text.equals("해외휴가비(현지화)") || imgi_text.equals("해외학자금(현지화)")) {                       %>                                                 
                      <li><%= SOGUP_AMNT1.equals("0.0") ? "" : WebUtil.printNumFormat(SOGUP_AMNT1,2) %></li>
<%                  }else{             %>        
                      <li><%= data3.SOGUP_AMNT.equals("0.0") ? "" : WebUtil.printNumFormat(data3.SOGUP_AMNT) %></li>
<%                  }      %>
<%                   if(!imgi_text.equals("임지생계비(현지화)") && !imgi_text.equals("임지주택비차액(현지화)") && !imgi_text.equals("국외일정액(현지화)") && !imgi_text.equals("해외휴가비(현지화)") && !imgi_text.equals("해외학자금(현지화)")) { %>                     
                      <% sum6 += Double.parseDouble(data3.SOGUP_AMNT); %>
<%                   }                     %>
<%                 }                  %>  
              <% }  %>
            
            <% }  %>  
										</ul>
									</td>
								</tr>
								<tr>
									<td colspan="2">소계</td>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat(sum11).equals("0") ? "" : WebUtil.printNumFormat(sum11,2) %></td>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat(sum4).equals("0") ? "" : WebUtil.printNumFormat(sum4) %></td>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat(sum10).equals("0") ? "" : WebUtil.printNumFormat(sum10,2) %></td>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat(sum5).equals("0") ? "" : WebUtil.printNumFormat(sum5) %></td>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat(sum6).equals("0") ? "" : WebUtil.printNumFormat(sum6) %></td>
								</tr>
<%     if(yno.equals(data4.PAYDT) && minwoo.equals(data4.OCRTX)) {     %>                
								<tr class="trTotal">
            						<td colspan="2">
            <% 
	          for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
                String kase_text ;
                D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j); 
                if( data3.LGTXT.length() > 4 )
                {
                   kase_text = data3.LGTXT.substring(0,4);
                }
                else
                {
                   kase_text = data3.LGTXT ;
			    }
              %>
              <% if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){ %> 
<%                 if(!kase_text.equals("과세반영")){   
                     continue;
                   }else{   
%>                
                      <%= data3.LGTXT %><br>              
<%                 }            %>
<%               }               %>
<%            }         %>
									</td>
									<td></td>
									<td class="tdAlignRight">
            <% 
	          for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
              String kase_text ;
              D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j); 
              if( data3.LGTXT.length() > 4 )
              {
                 kase_text = data3.LGTXT.substring(0,4);
              }
              else
              {
                 kase_text = data3.LGTXT ;
			  }
            %>
              <% if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){ %> 
<%                 if(!kase_text.equals("과세반영")){   
                     continue;
                   }else{   
%>                
                     <%= data3.SOGUP_BEFORE.equals("0.0") ? "" : WebUtil.printNumFormat(data3.SOGUP_BEFORE) %><br>  
                     <%-- sum4 += Double.parseDouble(data3.SOGUP_BEFORE); --%>
<%                 }                     %> 
              <% }  %>
            
            <% }  %>
									</td>
									<td></td>
									<td class="tdAlignRight">
            <% 
	          for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
              D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j); 
              String kase_text ;
              if( data3.LGTXT.length() > 4 )
              {
                 kase_text = data3.LGTXT.substring(0,4);
              }
              else
              {
                 kase_text = data3.LGTXT ;
			  }
            %>
               <% if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){ %> 
<%                 if(!kase_text.equals("과세반영")){   
                     continue;
                   }else{   
%>                    <%= data3.SOGUP_AFTER.equals("0.0") ? "" : WebUtil.printNumFormat(data3.SOGUP_AFTER) %><br>
                      <%-- sum5 += Double.parseDouble(data3.SOGUP_AFTER); --%>
<%                 }                  %>               
               <% }  %>
            
            <% }  %>
									</td>
									<td class="tdAlignRight">
            <% 
	          for ( int j = 0 ; j < D08RetroDetailData2_vt.size() ; j++ ) {
              D08RetroDetailData data3 = (D08RetroDetailData)D08RetroDetailData2_vt.get(j); 
              String kase_text ;
              if( data3.LGTXT.length() > 4 )
              {
                 kase_text = data3.LGTXT.substring(0,4);
              }
              else
              {
                 kase_text = data3.LGTXT ;
			   }
            %>
              <% if(data3.FPPER.equals(data4.FPPER) && data3.OCRSN.equals( data4.OCRSN ) && data3.PAYDT.equals( data4.PAYDT )){ %> 
<%                 if(!kase_text.equals("과세반영")){   
                     continue;
                   }else{   
%>                    <%= data3.SOGUP_AMNT.equals("0.0") ? "" : WebUtil.printNumFormat(data3.SOGUP_AMNT) %><br>
                      <%-- sum6 += Double.parseDouble(data3.SOGUP_AMNT); --%>
<%                 }                  %>  
              <% }  %>
            
            <% }  %> 
									</td>
								</tr>
<%      }       %>          
								<tr>
									<td>공제내역</td>
									<td class="tdAlignLeft tdAlignTop">
										<ul class="tdList">
            <% 
	          for ( int k = 0 ; k < D08RetroDetailData1_vt.size() ; k++ ) {
               D08RetroDetailData data2 = (D08RetroDetailData)D08RetroDetailData1_vt.get(k); 
            %> 
              <% if( data2.FPPER.equals( data4.FPPER ) && data2.OCRSN.equals( data4.OCRSN ) && data2.PAYDT.equals( data4.PAYDT )){ %>
               <li><%= data2.LGTXT %></li>
              <% } %>
               
            <% }  %>
										</ul>
									</td>
									<td class="tdAlignRight tdAlignTop"></td>
									<td class="tdAlignRight tdAlignTop">
										<ul class="tdList">
            <% 
	          for ( int k = 0 ; k < D08RetroDetailData1_vt.size() ; k++ ) {
               D08RetroDetailData data2 = (D08RetroDetailData)D08RetroDetailData1_vt.get(k); 
            %> 
              <% if( data2.FPPER.equals( data4.FPPER ) && data2.OCRSN.equals( data4.OCRSN ) && data2.PAYDT.equals( data4.PAYDT )){ %>
                <li><%= data2.SOGUP_BEFORE.equals("0.0") ? "" : WebUtil.printNumFormat(data2.SOGUP_BEFORE) %></li>
                <% sum1 += Double.parseDouble(data2.SOGUP_BEFORE); %>
              <% } %>
             
            <% }  %>
										</ul>
									</td>
									<td class="tdAlignRight tdAlignTop"></td>
									<td class="tdAlignRight tdAlignTop">
										<ul class="tdList">
            <% 
	          for ( int k = 0 ; k < D08RetroDetailData1_vt.size() ; k++ ) {
              D08RetroDetailData data2 = (D08RetroDetailData)D08RetroDetailData1_vt.get(k); 
            %> 
              <% if( data2.FPPER.equals( data4.FPPER ) && data2.OCRSN.equals( data4.OCRSN ) && data2.PAYDT.equals( data4.PAYDT )){ %>
                <li><%= data2.SOGUP_AFTER.equals("0.0") ? "" : WebUtil.printNumFormat(data2.SOGUP_AFTER) %></li>
                <% sum2 += Double.parseDouble(data2.SOGUP_AFTER); %>
              <% } %>
                
             
            <% }  %>  
										</ul>
									</td>
									<td class="tdAlignRight tdAlignTop">
										<ul class="tdList">
            <% 
	          for ( int k = 0 ; k < D08RetroDetailData1_vt.size() ; k++ ) {
               D08RetroDetailData data2 = (D08RetroDetailData)D08RetroDetailData1_vt.get(k); 
            %>
               <% if( data2.FPPER.equals( data4.FPPER ) && data2.OCRSN.equals( data4.OCRSN ) && data2.PAYDT.equals( data4.PAYDT )){ %>
                 <li><%= data2.SOGUP_AMNT.equals("0.0") ? "" : WebUtil.printNumFormat(data2.SOGUP_AMNT) %></li>
                 <% sum3 += Double.parseDouble(data2.SOGUP_AMNT); %>
               <% } %>
                 
            <% }  %>
										</ul>
									</td>
								</tr>
								<tr>
									<td colspan="2">소계</td>
									<td class="tdAlignRight"></td>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat(sum1).equals("0") ? "" : WebUtil.printNumFormat(sum1) %></td>
									<td class="tdAlignRight"></td>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat(sum2).equals("0") ? "" : WebUtil.printNumFormat(sum2) %></td>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat(sum3).equals("0") ? "" : WebUtil.printNumFormat(sum3) %></td>
								</tr>
								<tr class="trTotal">
									<td colspan="2">차액</td>
									<td></td>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat(sum4-sum1).equals("0") ? "" :  WebUtil.printNumFormat(sum4-sum1) %></td>
									<td></td>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat(sum5-sum2).equals("0") ? "" :  WebUtil.printNumFormat(sum5-sum2) %></td>
									<td class="tdAlignRight"><%= WebUtil.printNumFormat(sum6-sum3).equals("0") ? "" :  WebUtil.printNumFormat(sum6-sum3) %></td>
								</tr>						
<%  } %>     
<%  } else { %>     
								<tr>
									<td colspan="8">해당 데이터가 없습니다.</td>
								</tr>						
<%  } %>     
							</tbody>
							</table>
						</div>									
					</div>
					<!--// List end -->
					
				</div>
				<!--// Tab2 end -->
<!-- //print start -->
<div class="layerWrapper layerSizeP" id="popLayerPrint">
	<div class="layerHeader">
		<a href="#" class="btnClose popLayerPrint_close">창닫기</a>
	</div>
	<div class="printScroll">
		<div id="printContentsArea" class="layerContainer">
			<div class="printTitle">급여명세표</div>
			<div id="printHeader" class="printHeader">
				<div class="tableArea">
					<div class="table">
						<table class="tableGeneral">
						<caption>월급여조회정보</caption>
						<colgroup>
							<col class="col_25p" />
							<col class="col_25p" />
							<col class="col_25p" />
							<col class="col_25p" />
						</colgroup>
						<tbody>
							<tr>
								<td><%= year %>년 <%= month %>월</td>
								<td>부서명 : <%= user.e_orgtx %></td>
								<td>사번 : <%= user.empNo %></td>
								<td>성명 : <%= user.ename %></td>
							</tr>
						</tbody>
						</table>
					</div>
				</div>
				<div id="printBody">
				</div>
				<div id="printFooter" class="printFooter">
				귀하의 노고에 진심으로 감사드립니다. <image src="/web-resource/images/sub/img_logo_mma.png" class="floatRight" style="width:100px;">
				</div>
			</div>
			<!-- 프린트 영역 -->		
		</div>	
	</div>
	<div class="buttonArea buttonPrint">
			<ul class="btn_crud">
				<li><a class="darken" href="#" id="printSalBtn"><span>프린트</span></a></li>								
			</ul>
		</div>	
		<div class="clear"> </div>	
</div>
<!-- // popup script -->
<script type="text/javascript">
	$(document).ready(function(){
		$('#year').change(function(){
			getSalReasonCode();
		});
		$('#month').change(function(){
			getSalReasonCode();
		});

		var getSalReasonCode = function() {
	    	jQuery.ajax({
	    		type : 'POST',
	    		url : '/salary/getSalReasonCode.json',
	    		cache : false,
	    		dataType : 'json',
	    		data : {
	    		    "year" : $("#year option:selected").text(),
	    		    "month" : $("#month option:selected").text()
				},
	    		async :false,
	    		success : function(response) {
	    			if(response.success)
	    				setZOCRSNOption(response.storeData);
	    			else
	    				alert("급여사유 조회시 오류가 발생하였습니다. " + response.message);
	    		}
	    	});
	    };

		var setZOCRSNOption = function(jsonData) {
			$('#ZOCRSN').empty();
	        $.each(jsonData, function (key, value) {
	            if(value.ZOCRTX != "급여+정산") {                      
	            	$('#ZOCRSN').append('<option value=' + value.ZOCRSN + value.SEQNR + '>' + value.ZOCRTX + '</option>');
	            }
	        });
		}

		//search
		$(".icoSearch").click(function(){
			if(checkValid()) {
				$("#ocrsn").val($("#ZOCRSN option:selected").val());
				$("#searchForm").attr("method", "POST");
				$("#searchForm").attr("action", "/salary/monthlyDetail");
				$("#searchForm").submit();
			}
		});
		var checkValid = function (){
		    date = new Date();
		    c_year = date.getFullYear();
		    c_month = date.getMonth()+1;
		    year1 = $("#year option:selected").text();
		    month1 = $("#month option:selected").val();
		      
		    if(year1 > c_year){
		        alert("현재 년도보다 큽니다." + year1+"::"+c_year); 
		        $("#year").focus();
		        return false;    
		    } else if(year1 == c_year && month1 > c_month){
		        alert("현재 월보다 큽니다.");
		        $("#month").focus();
		        return false;
		    }
		    return true;
		}  

		//팝업 띄우기
		$(function(){
			if($(".layerWrapper").length){
				//팝업 : 월급여 프린트
				$('#popLayerPrint').popup();
			}
		});
		
		//프린트 팝업 영역 설정
		$("#popLayerPrint").dialog({
		    autoOpen: false,
		    close: function() {
		    }
		});

		$("#showSalBtn").click(function() {
//			var printDivs = $("#printArea01").wrap('<p/>').parent().html().find(".subsubtitle").hide();
			var printBody = $("#printArea01").wrap('<p/>').parent().clone().html();
			$("#printArea01").unwrap();
			printBody = printBody + $("#printArea02").wrap('<p/>').parent().clone().html();
			$("#printArea02").unwrap();
			if($("#printArea03").length){
				printBody = printBody + $("#printArea03").wrap('<p/>').parent().clone().html();
				$("#printArea03").unwrap();
			}
			if($("#printArea04").length){
				printBody = printBody + $("#printArea04").wrap('<p/>').parent().clone().html();
				$("#printArea04").unwrap();
			}
			$("#printBody").html(printBody);
			$('#popLayerPrint').popup("show");
			//$("#popLayerPrint").contents().find(".subsubtitle").hide();
			//$("#printContentsArea").print();
		});
		$("#printSalBtn").click(function() {
			$("#printContentsArea").print();
		});
	});

</script>

<!-- //print end -->
