<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 초과근무                                                    */
/*   Program Name : 초과근무 조회                                               */
/*   Program ID   : D01OTDetail.jsp                                             */
/*   Description  : 초과근무 조회 및 삭제를 할 수 있도록 하는 화면              */
/*   Note         :                                                             */
/*   Creation     : 2002-01-15  박영락                                          */
/*   Update       : 2005-03-03  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<tags:layout css="ui_library_approval.css" script="dialog.js" >
<%-- form1, AINF_SEQN, jobid 선언되어 잇음 --%>
<tags-approval:detail-layout titlePrefix="TAB.COMMON.0037" updateUrl="${g.servlet}hris.D.D19Duty.D19DutyChangeSV">
	<tags:script>
		<script>
		<!--

		var tmp = "<c:out value='${resultData.DUTY_REQ}'/>";
		var ss = [];

		jQuery(function(){
			alert("1111");
			on_Load();
		});

		function on_Load(){

			var PERNR = "<c:out value='${resultData.PERNR}'/>";
			var jobid = "check";
			var DUTY_DATE = removePoint(document.form1.DUTY_DATE.value) ;

		    jQuery.ajax({
		        type:"post",
		        //dataType: "json",
		        url:'${g.servlet}hris.D.D19Duty.D19DutyCheckSV',
		        data: {jobid : jobid, PERNR : PERNR, DUTY_DATE : DUTY_DATE },
		        success:function(data){
		            showResponse(data);
		        },
		        error:function(e){
		            alert("error="+e.responseText);
		        }
		    });
	    }

		function showResponse(originalRequest){
		    var resText = originalRequest;
		    //var resText = originalRequest.split(",")[0];
		    resText = unescape(resText);
		    var t = eval('(' + resText + ')');

		    $("#TPROG1").val( t.TPROG1 );
			$("#TTEXT1").html( t.TTEXT1 );
			$("#BEGUZ1").val( t.BEGUZ1 );
			$("#ENDUZ1").val( t.ENDUZ1 );
			$("#TPROG2").val( t.TPROG2 );
			$("#TTEXT2").html( t.TTEXT2 );
			$("#BEGUZ2").val( t.BEGUZ2 );
			$("#ENDUZ2").val( t.ENDUZ2 );
			$("#TTOUT").val( t.TTOUT );

		    /*for(i in t){
		          if(typeof(i) != 'Function' && i != 'toJSONString'){
		              try{
		                    if(eval("t." + i) != ''){
		                        if(eval("$('"+i+"')").type == 'text')
		                            eval("$('"+i+"')").value = eval("t." + i) == '|' ? "" : eval("t." + i);
		                        else(eval("$('"+i+"')").tagName == 'span')
		                            eval("$('"+i+"')").innerText = eval("t." + i) == '|' ? "" : eval("t." + i);
		                    }
		              }catch(e){
		              }
		          }
		    }*/

		    $('#ZJIKCH1').html( t.ZJIKCH ); //$('#ZJIKCH1').innerText = t.ZJIKCH;
			//$('#HOLIDAY').html( t.ZHOLIDAY == 'X'?'Holiday':'Non Holiday' );

			$('#ZJIKCH').val( t.ZJIKCH ); //$('ZJIKCH').innerText = t.ZJIKCH;

		    ss = t.sels;
		    for(i = 0 ; i < ss.length ; i ++){
		        if(ss[i].DUTY == tmp){
		        	$('#DUTY_REQ').val( ss[i].DUTY_TXT ); // $('DUTY_REQ').value = ss[i].DUTY_TXT;
		            $('#UPMU').val(ss[i].UPMU); // $('UPMU').value = ss[i].UPMU;
		        }
		    }
		}

		//-->

		</script>
	</tags:script>

	<%--@elvariable id="resultData" type="hris.A.A17Licence.A17LicenceData"--%>
	<div class="tableArea">
          <div class="table">
              <table class="tableGeneral">
               <colgroup>
	           		<col width="20%" />
            		<col width="25%" />
            		<col width="15%" />
            		<col width="" />
	           	</colgroup>

	           	<tr>
                    <th><span class="textPink">*</span> <!--Duty Date--><spring:message code="LABEL.D.D19D.0001" /></th>
                    <td colspan="3">
                    	<input type="hidden" id="BEGDA" name="BEGDA" value="${f:printDate(approvalHeader.RQDAT)}" />
                        <input type="text" name="DUTY_DATE" id="DUTY_DATE" size="15" value="${f:printDate(resultData.DUTY_DATE)}" readonly />
                    </td>
                </tr>
                <tr>
					<th><span class="textPink">*</span><!-- Duty Type--><spring:message code="LABEL.D.D19D.0002" /></th>
					<td colspan="3">
						<input type="text" name="DUTY_REQ" id="DUTY_REQ" value="<c:out value='${resultData.DUTY_REQ}'/>"  size="15" readonly="readonly">
						<input type="hidden" name="UPMU" id="UPMU" value="<c:out value='${resultData.UPMU}'/>" />
					</td>
                </tr>

                <tr>
					<th><span class="textPink">*</span><!-- Duty Time--><spring:message code="LABEL.D.D19D.0003" /></th>
					<td colspan="3">
						<input type="text" name="BEGUZ" id="BEGUZ" size="7" value="${ f:printTime( resultData.BEGUZ ) }" readonly />
						~
						<input type="text" name="ENDUZ" id="ENDUZ" size="7" value="${ f:printTime( resultData.ENDUZ ) }" readonly />&nbsp;
						<input type="text" name="ANZHL" id="ANZHL" size="3" value="<c:out value='${ resultData.ANZHL}'/>" class="noBorder"  readonly style="text-align:right;">
						<!--hour(s)--><spring:message code="LABEL.D.D19D.0004" />
					</td>
          	    </tr>

          	    <tr>
			        <th><span class="textPink">*</span> <!--Application Reason--><spring:message code="LABEL.D.D19D.0005" /></th>
					<td colspan="3">
					<input type="text" name="ZREASON" id="ZREASON" size="105" value="<c:out value='${ resultData.ZREASON }'/>" maxlength="100" readonly/>
					</td>
                </tr>

                <tr>
					<th><!--Date Character--><spring:message code="LABEL.D.D19D.0006" /></th>
					<td>
					    <input type="hidden" name="HOLIDAY1" id="HOLIDAY1" value="">
					    <span id="HOLIDAY" style="width:103px">${resultData.ZHOLIDAY eq 'X'? "Holiday" : "Non Holiday" }</span>
					</td>
	                <th class="th02"><!--Level--><spring:message code="LABEL.D.D19D.0007" /></th>
	                <td >
	                 	 <input type="text" name="TTOUT" id="TTOUT" size="7" class="noBorder" value="<c:out value='${ resultData.ZJIKCH }'/>" readonly />
						 &nbsp;&nbsp;&nbsp;&nbsp;
						 <span id="ZJIKCH1" style="width:120;visibility: hidden"></span>
		                 <input type="hidden" name="ZJIKCH" id="ZJIKCH" value="">
					</td>
                </tr>

                <tr>
					<th><!--Daily Work Schedule(On day)--><spring:message code="LABEL.D.D19D.0008" /></th>
					<td>
						<input type="text" name="TPROG1" id="TPROG1" size="10" value="<c:out value='${ resultData.TPROG1 }'/>" readonly />
						<span id="TTEXT1" style="width:80"></span>
					</td>
					<td colspan="2">
						<input type="text" name="BEGUZ1" id="BEGUZ1" size="7" value="${ f:printTime( resultData.BEGUZ1 ) }" readonly />
						~
						<input type="text" name="ENDUZ1" id="ENDUZ1" size="7" value="${ f:printTime( resultData.ENDUZ1 ) }" readonly />&nbsp;
					</td>
               </tr>

               <tr>
					<th><!--Daily Work Schedule(Next day)--><spring:message code="LABEL.D.D19D.0009" /></th>
					<td>
						<input type="text" name="TPROG2" id="TPROG2" size="10"  value="<c:out value='${ resultData.TPROG2 }'/>" readonly />
						<span id="TTEXT2" style="width:80"></span>
					</td>
					<td colspan="2">
						<input type="text" name="BEGUZ2" id="BEGUZ2" size="7" value="${ f:printTime( resultData.BEGUZ2 ) }" readonly />
						~
						<input type="text" name="ENDUZ2" id="ENDUZ2" size="7" value="${ f:printTime( resultData.ENDUZ2 ) }" readonly />&nbsp;
					</td>
                </tr>



	           	</table>
          </div><!--  end table -->

		<!-----   hidden field ---------->

		<!-----   hidden field ---------->

        <!-- 상단 입력 테이블 끝-->
      </div> <!--  end tableArea -->


</tags-approval:detail-layout>

</tags:layout>