<%--/*
 * 		Name: D1213common.jsp
		Desc: 부서근태,일일근무일정변경 공용 js
		 <jsp:include page="${g.jsp }D/D13ScheduleChange/D1213common.jsp"/>
*/
 --%>
 
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
/**	사번으로 조직명가죠오기	*/

var _ajax_isreturned = true;

function on_change_pernr(obj) {
	var i_pernr = ltrim(rtrim(obj.value));
   if( i_pernr == ""  ) return;
	/** 권한검사 */
   var url = '${g.servlet}hris.D.D12Rotation.D12RotationBuildDetailCnSV';
   var pars = 'jobid=searchPerson&PERNR=' + i_pernr;
   _ajax_isreturned = false;
	  $.ajax({type:'GET', url: url, data: pars, dataType: 'html', success: function(data){
		  if( data == "S"){
			  getOrgeh(i_pernr);
		  }else if( data == "E" ){
			  alert("<spring:message code='MSG.F.F46.0002'/>");
			  obj.value="";
		  }
		  _ajax_isreturned = true;
		  }
  	}); 
}
function getOrgeh(i_pernr) {
	  /* 조직코드검사 */
    var url = '${g.servlet}hris.D.D13ScheduleChange.D13ScheduleChangeDetailSV_CN';
    var pars = 'jobid=findORGEH&i_PERNR='+i_pernr ;
	     $.ajax({type:'GET', url: url, data: pars, dataType: 'html', success: function(data){
	    if(data == "N" ){
	       alert("<spring:message code='LABEL.APPROVAL.0010'/>");//인사정보 조회대상이 아니거나 사원마스터가 없습니다.
   	   obj.value="";  
	  		}else{
  	  		arr = data.split('|');
  	  		document.form1.txt_deptNm.value = arr[0];
  	  		document.form1.hdn_deptNm.value = arr[0];
  	  		document.form1.hdn_deptId.value = arr[1];
	   	    dept_search();
	  		}
	     }
	  });
}


</script>
