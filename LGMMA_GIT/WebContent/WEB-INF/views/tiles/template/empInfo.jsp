<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

	<div class="tableArea">
		<h2 class="subtitle">신청자 정보</h2>
		<div class="table">
			<table class="tableGeneral">
			<caption>신청자 정보</caption>
			<colgroup>
				<col class="col_15p"/>
				<col class="col_35p"/>
				<col class="col_15p"/>
				<col class="col_35p"/>
			</colgroup>
			<tbody>
			<tr>
				<th><label for="inputText01-1">사번</label></th>
				<td>${empNo}</td>
				<th><label for="a1">이름</label></th>
				<td>${ename}</td>
			</tr>
			<tr>
				<th><label for="inputText01-2">자사입사일</label></th>
				<td>${dat03}</td>
				<th><label for="inputText01-2">그룹입사일</label></th>
				<td>${dat02}</td>
			</tr>
			</tbody>
		</table>
		</div>
	</div>