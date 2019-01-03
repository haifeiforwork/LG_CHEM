<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
				<!--// Page Title start -->
				<div class="title">
					<h1>에러 페이지</h1>
					<div class="titleRight">
						<ul class="pageLocation">
							<li><span><a href="#">Home</a></span></li>
							<li class="lastLocation"><span><a href="#">Error</a></span></li>
						</ul>						
					</div>
				</div>
				<!--// Page Title end -->		
		
				<!--------------- layout body start --------------->	
				<div class="errorArea">
					<div class="errorMsg">	
						<div class="errorImg"><!-- 에러이미지 --></div>					
						<div class="alertContent">
							<p>${exception}</p>
						</div>
					</div>
				</div>
				<!--------------- layout body end --------------->						
