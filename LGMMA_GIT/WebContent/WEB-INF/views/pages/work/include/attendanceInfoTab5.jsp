<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%-- 근태실적조회 --%>
    <form id="attListForm" name="attListForm" method="post" action="">
    <div class="tableInquiry">
        <table>
            <caption>1행조회</caption>
            <colgroup>
                <col class="col_11p" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th>조회년월</th>
                    <td class="td04">
                        <select class="w70" id="year" name="year">
                            <%= WebUtil.printOption(years, String.valueOf(year)) %>
                        </select>
                        <select class="w50" id="month" name="month"><c:forEach begin="1" end="12" step="1" var="i">
                            <option value="${i}"${i eq month ? ' selected' : ''}>${i}</option></c:forEach>
                        </select>
                        <a class="icoSearch" href="#"><img src="/web-resource/images/ico/ico_magnify.png" alt="검색" /></a>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <!--// list start -->
    <div class="listArea">
        <h3 class="subsubtitle">
            <span class="colorPoint" id="yearMonth"></span> 근태실적 조회
        </h3>
        <!-- slide content -->
        <div class="contentDetail">
            <div id="addListGrid" class="thSpan"></div>
            <div id="attendanceList" class="listTotal"></div>
            <table class="listTable tHead">
                <colgroup>
                    <col class="col_9p"/>
                    <col class="col_7p"/>
                    <col class="col_7p"/>
                    <col class="col_7p"/>
                    <col class="col_7p"/>
                    <col class="col_7p"/>
                    <col class="col_7p"/>
                    <col class="col_7p"/>
                    <col class="col_7p"/>
                    <col class="col_7p"/>
                    <col class="col_7p"/>
                    <col class="col_7p"/>
                    <col class="col_7p"/>
                    <col class="col_7p"/>
                </colgroup>
                <thead>
                    <tr class="totalMonth">
                        <td><strong>월계</strong></td>
                        <td id="TOTAL"></td>
                        <td id="TOTAL1"></td>
                        <td id="TOTAL2"></td>
                        <td id="TOTAL3"></td>
                        <td id="TOTAL4"></td>
                        <td id="TOTAL5"></td>
                        <td id="TOTAL6"></td>
                        <td id="TOTAL7"></td>
                        <td id="TOTAL8"></td>
                        <td id="TOTAL9"></td>
                        <td id="TOTAL10"></td>
                        <td id="TOTAL11"></td>
                        <td id="TOTAL12"></td>
                    </tr>
                </thead>
            </table>
        </div>
    </div>
    </form>