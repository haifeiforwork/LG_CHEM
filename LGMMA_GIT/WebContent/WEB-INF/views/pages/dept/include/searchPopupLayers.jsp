<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<!-- 부서검색 영역 팝업 -->
<div class="layerWrapper layerSizeL" id="popLayerSearchDept" style="width:500px;height:530px;">
    <div class="layerHeader">
        <strong>부서 검색</strong>
        <a href="#" class="btnClose popLayerSearchDept_close">창닫기</a>
    </div>
    <div class="layerContainer">        
        <div class="layerContent">          
            <!--// Content start  -->
            <div class="listArea" style="margin-bottom:0px;">
                <div class="table scroll-table scroll-head">
                    <table class="listTable">
                        <caption>부서 검색 목록</caption>
                        <colgroup>
                            <col width="15%"/>
                            <col />
                        </colgroup>
                        <thead>
                            <tr>
                                <th class="th02">선택</th>
                                <th class="th02">부서명</th>
                            </tr>
                        </thead>
                    </table>
                </div>
                <div class="scroll-table scroll-body">
                    <table class="listTable">
                        <colgroup>
                            <col width="15%"/>
                            <col />
                        </colgroup>
                        <tbody id="bodySearchDept">
                        </tbody>
                    </table>
                </div>
            </div>
            <!--// Content end  -->                         
        </div>      
    </div>      
</div>
<!-- END 부서검색 영역 팝업 -->

<!-- 조직도 영역 팝업 -->
<div class="layerWrapper layerSizeL" id="popLayerSearchOrgInTree" style="width:400px;height:550px;">
    <div class="layerHeader">
        <strong>조직도로 부서찾기</strong>
        <a href="#" class="btnClose popLayerSearchOrgInTree_close">창닫기</a>
    </div>
    <div class="layerContainer">        
        <div class="layerContent" style="overflow:auto;height:450px;">      
            <!--// Content start  -->
            <div id="tree" style="text-align: left;" >
                <ul id="treeData" style="border: 0px;" >
                </ul>
            </div>
            <!--// Content end  -->                         
        </div>      
    </div>      
</div>
<!-- END 부서검색 영역 팝업 -->

<!-- 사원검색 영역 팝업 -->
<div class="layerWrapper layerSizeL" id="popLayerSearchEmp" style="width:800px;height:530px;">
    <div class="layerHeader">
        <strong>사원 검색</strong>
        <a href="#" class="btnClose popLayerSearchEmp_close">창닫기</a>
    </div>
    <div class="layerContainer">        
        <div class="layerContent">          
            <!--// Content start  -->
            <div class="listArea" style="margin-bottom:0px;">
                <div class="table scroll-table scroll-head">
                    <table class="listTable">
                        <caption>사원 검색 목록</caption>
                        <colgroup>
                            <col width="5%"/>
                            <col width="10%"/>
                            <col width="10%"/>
                            <col />
                            <col width="12%"/>
                            <col width="10%"/>
                            <col width="10%"/>
                            <col width="15%"/>
                            <col width="10%"/>
                        </colgroup>
                        <thead>
                            <tr>
                                <th class="th02">선택</th>
                                <th class="th02">사번</th>
                                <th class="th02">성명</th>
                                <th class="th02">부서</th>
                                <th class="th02">직위/직급호칭</th>
                                <th class="th02">직책</th>
                                <th class="th02">직무</th>
                                <th class="th02">근무지</th>
                                <th class="th02">구분</th>
                            </tr>
                        </thead>
                    </table>
                </div>
                <div class="scroll-table scroll-body">
                    <table class="listTable">
                        <colgroup>
                            <col width="5%"/>
                            <col width="10%"/>
                            <col width="10%"/>
                            <col />
                            <col width="12%"/>
                            <col width="10%"/>
                            <col width="10%"/>
                            <col width="15%"/>
                            <col width="10%"/>
                        </colgroup>
                        <tbody id="bodySearchEmp">
                        </tbody>
                    </table>
                </div>
            </div>
            <!--// Content end  -->                         
        </div>      
    </div>      
</div>
<!-- END 사원검색 영역 팝업 -->

<script id="searchDeptTmpl" type="text/x-jquery-tmpl">
<tr>
    <td class="align-center"><input type="radio" name="radiobutton" value="radiobutton" onclick="setDeptID('\${OBJID}', '\${OBJTXT}');"></td>
    <td>\${OBJTXT}</td>
</tr>
</script>

<script id="searchEmpTmpl" type="text/x-jquery-tmpl">
<tr>
    <td class="align-center"><input type="radio" name="radiobutton" value="radiobutton2" onclick="setPersInfo('\${PERNR}', '\${ENAME}');"></td>
    <td>\${PERNR}</td>
    <td>\${ENAME}</td>
    <td>\${ORGTX}</td>
    <td>\${JIKWT}</td>
    <td>\${JIKKT}</td>
    <td>\${STLTX}</td>
    <td>\${BTEXT}</td>
    <td>
        {{if STAT2 == "0"}}
            퇴직자
        {{else}}
            재직자
        {{/if}}
    </td>
</tr>
</script>