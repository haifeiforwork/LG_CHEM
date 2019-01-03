<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<!--// Page Title start -->
<div class="title">
	<h1>파일업로드</h1>
	<div class="titleRight">
		<ul class="pageLocation">
			<li><span><a href="#">Home</a></span></li>
			<li><span><a href="#">급여</a></span></li>
			<li><span><a href="#">연말정산</a></span></li>
			<li class="lastLocation"><span><a href="#">파일업로드</a></span></li>
		</ul>						
	</div>
</div>
<!--// Page Title end -->
<form name="form1" id="form1" enctype="multipart/form-data">
<script language="javascript">
	makeSwfMultiUpload(
		movie_id='smu03', //파일폼 고유ID
		flash_width='420', //파일폼 너비 (기본값 400, 권장최소 300)
		list_rows='10', // 파일목록 행 (기본값:3)
		limit_size='30', // 업로드 제한용량 (기본값 10)
		file_type_name='PDF 파일', // 파일선택창 파일형식명 (예: 그림파일, 엑셀파일, 모든파일 등)
		allow_filetype='*.pdf', // 파일선택창 파일형식 (예: *.jpg *.jpeg *.gif *.png)
		deny_filetype='*.cgi *.pl', // 업로드 불가형식
		upload_exe='/sample/tempFileUpload.json', // 업로드 담당프로그램
		browser_id='<%=session.getId()%>'
	);
</script>

<div class="buttonArea" >
	<ul class="btn_crud">
		<li><a class="darken" href="#" id="saveBtn"><span>SAVE</span></a></li>
		<li><a class="darken" href="#" id="resetBtn"><span>RESET</span></a></li>
	</ul>
</div>			
</form>
<script type="text/javascript">
$(document).ready(function(){

	$("#saveBtn").click(function(){
		SAVE();
	});
	
	$("#resetBtn").click(function(){
		RESET();
	});
	
});

	var SAVE = function() {
		
		var movie = document.getElementById('multi_upload');
		if(movie.GetVariable("totalSize")==0){
			alert("[파일선택] 버튼을 클릭하시고 업로드할 파일을 선택하세요.");
			return;
		}
		callSwfUpload('form1');

		
		

	};
	
	var RESET = function() {

	};

</script>

