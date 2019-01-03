<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<div class="Lnodisplay">
<table>
<tbody id="cTypeCloneTemplate">
<tr>
    <th>휴게시간 1</th>
    <td>
        <input type="text" name="PBEG1STDT" eid="PBEG1STDT" class="w20 span-look align-right" readonly="readonly" placeholder="--" /> :
        <input type="text" name="PBEG1EDDT" eid="PBEG1EDDT" class="w20 span-look align-left" readonly="readonly" placeholder="--" />
    </td>
    <td>
        <input type="text" name="PEND1STDT" eid="PEND1STDT" class="w20 span-look align-right" readonly="readonly" placeholder="--" /> :
        <input type="text" name="PEND1EDDT" eid="PEND1EDDT" class="w20 span-look align-left" readonly="readonly" placeholder="--" />
    </td>
    <td><input type="text" name="PUNB1" eid="PUNB1" class="span-look align-center" readonly="readonly" /></td>
    <td class="tdBorder"><input type="text" name="PBEZ1" eid="PBEZ1" class="span-look align-center" readonly="readonly" /></td>
</tr>
<tr>
    <th>휴게시간 2</th>
    <td>
        <input type="text" name="PBEG2STDT" eid="PBEG2STDT" class="w20 span-look align-right" readonly="readonly" placeholder="--" /> :
        <input type="text" name="PBEG2EDDT" eid="PBEG2EDDT" class="w20 span-look align-left" readonly="readonly" placeholder="--" />
    </td>
    <td>
        <input type="text" name="PEND2STDT" eid="PEND2STDT" class="w20 span-look align-right" readonly="readonly" placeholder="--" /> :
        <input type="text" name="PEND2EDDT" eid="PEND2EDDT" class="w20 span-look align-left" readonly="readonly" placeholder="--" />
    </td>
    <td><input type="text" name="PUNB2" eid="PUNB2" class="span-look align-center" readonly="readonly" /></td>
    <td class="tdBorder"><input type="text" name="PBEZ2" eid="PBEZ2" class="span-look align-center" readonly="readonly" /></td>
</tr>
</tbody>
</table>
<table>
<tbody id="oTypeCloneTemplate">
<tr>
    <th>휴게시간 1</th>
    <td>
        <select class="w50" name="PBEG1STDT" oid="PBEG1STDT">
            <option value="">--</option>
            <c:forEach begin="0" end="23" step="1" var="hour"><fmt:formatNumber var="hour" pattern="00" value="${hour}" />
            <option value="${hour}">${hour}</option>
            </c:forEach>
        </select>
        :
        <select class="w50" name="PBEG1EDDT" oid="PBEG1EDDT">
            <option value="">--</option>
            <c:forEach begin="0" end="50" step="10" var="minute"><fmt:formatNumber var="minute" pattern="00" value="${minute}" />
            <option value="${minute}">${minute}</option>
            </c:forEach>
        </select>
    </td>
    <td>
        <select class="w50" name="PEND1STDT" oid="PEND1STDT">
            <option value="">--</option>
            <c:forEach begin="0" end="23" step="1" var="hour"><fmt:formatNumber var="hour" pattern="00" value="${hour}" />
            <option value="${hour}">${hour}</option>
            </c:forEach>
        </select>
        :
        <select class="w50" name="PEND1EDDT" oid="PEND1EDDT">
            <option value="">--</option>
            <c:forEach begin="0" end="50" step="10" var="minute"><fmt:formatNumber var="minute" pattern="00" value="${minute}" />
            <option value="${minute}">${minute}</option>
            </c:forEach>
        </select>
    </td>
    <td><input type="text" name="PUNB1" oid="PUNB1" /></td>
    <td class="tdBorder"><input type="text" name="PBEZ1" oid="PBEZ1" /></td>
</tr>
<tr>
    <th>휴게시간 2</th>
    <td>
        <select class="w50" name="PBEG2STDT" oid="PBEG2STDT">
            <option value="">--</option>
            <c:forEach begin="0" end="23" step="1" var="hour"><fmt:formatNumber var="hour" pattern="00" value="${hour}" />
            <option value="${hour}">${hour}</option>
            </c:forEach>
        </select>
        :
        <select class="w50" name="PBEG2EDDT" oid="PBEG2EDDT">
            <option value="">--</option>
            <c:forEach begin="0" end="50" step="10" var="minute"><fmt:formatNumber var="minute" pattern="00" value="${minute}" />
            <option value="${minute}">${minute}</option>
            </c:forEach>
        </select>
    </td>
    <td>
        <select class="w50" name="PEND2STDT" oid="PEND2STDT">
            <option value="">--</option>
            <c:forEach begin="0" end="23" step="1" var="hour"><fmt:formatNumber var="hour" pattern="00" value="${hour}" />
            <option value="${hour}">${hour}</option>
            </c:forEach>
        </select>
        :
        <select class="w50" name="PEND2EDDT" oid="PEND2EDDT">
            <option value="">--</option>
            <c:forEach begin="0" end="50" step="10" var="minute"><fmt:formatNumber var="minute" pattern="00" value="${minute}" />
            <option value="${minute}">${minute}</option>
            </c:forEach>
        </select>
    </td>
    <td><input type="text" name="PUNB2" oid="PUNB2" /></td>
    <td class="tdBorder"><input type="text" name="PBEZ2" oid="PBEZ2" /></td>
</tr>
</tbody>
</table>
</div>