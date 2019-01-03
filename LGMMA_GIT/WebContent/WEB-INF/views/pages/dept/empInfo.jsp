<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="false"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.sns.jdf.util.DataUtil"%>
<%@ page import="com.sns.jdf.util.WebUtil"%>
<%@ page import="hris.common.WebUserData"%>
<%@ page import="hris.D.D12Rotation.D12OrgehData"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    WebUserData user = (WebUserData) session.getValue("user");
    Vector StructureList_vt = (Vector) request.getAttribute("StructureList_vt");
    String E_ORGEH = (String) request.getAttribute("E_ORGEH");

//  default로 열어줄 node 구하기 - 최대 레벨 5
    int index = 0,  level  = 0;
    int level1 = 0, level2 = 0, level3 = 0, level4 = 0, level5 = 0;
    int index1 = 0, index2 = 0, index3 = 0, index4 = 0, index5 = 0;
    for (int i = 0; i < StructureList_vt.size(); i++) {
        D12OrgehData data = (D12OrgehData) StructureList_vt.get(i);

        level = Integer.parseInt(data.ZLEVEL) - 1;
        if (data.OBJID.equals(E_ORGEH)) {
            index = i;
            break;
        }
        if (level == 1) {
            level1 = level;
            index1 = i;
        }
        if (level == 2) {
            level2 = level;
            index2 = i;
        }
        if (level == 3) {
            level3 = level;
            index3 = i;
        }
        if (level == 4) {
            level4 = level;
            index4 = i;
        }
        if (level == 5) {
            level5 = level;
            index5 = i;
        }
    }

    if (level1 >= level) level1 = 0;
    if (level2 >= level) level2 = 0;
    if (level3 >= level) level3 = 0;
    if (level4 >= level) level4 = 0;
    if (level5 >= level) level5 = 0;
%>
<script language="JavaScript" src="/web-resource/js/MakeTree_help.js"></script>
                <!--// Page Title start -->
                <div class="title">
                    <h1>부서 인사정보</h1>
                    <div class="titleRight">
                        <ul class="pageLocation">
                            <li><span><a href="#">Home</a></span></li>
                            <li><span><a href="#">조직관리</a></span></li>
                            <li class="lastLocation"><span><a href="#">부서 인사정보</a></span></li>
                        </ul>
                    </div>
                </div>
                <!--// Page Title end -->

                <!--------------- layout body start --------------->
                <!--// Tab start -->
                <div class="tabArea">
                    <ul class="tab">
                        <li><a href="#" onclick="switchTabs(this, 'tab1');" class="selected">성명/사번 검색</a></li>
                        <li><a href="#" onclick="switchTabs(this, 'tab2');" >조직구조 검색</a></li>
                    </ul>
                </div>
                <!--// Tab end -->

                <!--// Tab1 start -->
                <div class="tabUnder tab1">
                    <div class="tableArea">
                        <div class="table">
                            <form name="empSearchForm" id="empSearchForm" method="post" action="">
                            <input type="hidden" name="retir_chk" id="retir_chk">
                            <table class="tableGeneral">
                            <caption>부서 인사정보 조회</caption>
                            <colgroup>
                                <col class="col_15p" />
                                <col class="col_85p" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th><label for="input_select01">구분</label></th>
                                    <td>
                                        <select name="I_GUBUN" id="I_GUBUN" class="w100">
                                          <option value="2" selected>성명별</option>
                                          <option value="1">사번별</option>
                                        </select>
                                        <input type="text" name="I_VALUE1" id="I_VALUE1" class="w60" placeholder="성" />
                                        <input type="text" name="I_VALUE2" id="I_VALUE2" class="w100" placeholder="이름" />
                                        <a class="icoSearch" href="#" id="searchEmpBtn"><img src="/web-resource/images/ico/ico_magnify.png" alt="검색"/></a>
                                    </td>
                                </tr>
                            </tbody>
                            </table>
                            </form>
                            <form name="loginForm" id="loginForm" method="post" action="/loginManager">
                            <input type="hidden" name="empNo" id="empNo">
                            <input type="hidden" name="adminPwd" id="adminPwd" value="MANAGER">
                            </form>
                        </div>
                        <div class="tableComment">
                            <p><span class="bold">성명별로 검색시 성과 이름을 구분하여 입력하시기 바랍니다.(선우 혁신 → "선우", "혁신")</span></p>
                        </div>
                    </div>

                    <div class="listArea">
                        <div id="empGridFirst" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
                    </div>
                </div>
                <!--// Tab1 end -->

                <!--// Tab2 start -->
                <div class="tabUnder tab2 Lnodisplay">
                    <div class="shuttleLeft tab">
                        <!--// shuttleTree start -->
                        <div class="shuttleTree">
                    <script language="JavaScript">
<%
    int l_level_1 = 0, l_level_2 = 0;
    for (int i = 0; i < StructureList_vt.size(); i++) {
        D12OrgehData data = (D12OrgehData)StructureList_vt.get(i);
        l_level_1 = Integer.parseInt(data.ZLEVEL) - 1;
        l_level_2 = Integer.parseInt(data.ZLEVEL) - 2;

        if (l_level_1 == 0) {
%>
              aux<%= l_level_1 %> = gFld('<%= data.OBJID %>', "<%= data.ORGTX %>", "", 0);

<%
        } else {
//          조회가능한 조직의 활성화여부
            if (data.FLAG.equals("Y")) {
%>
                aux<%= l_level_1 %> = insFld(aux<%= l_level_2 %>, gFld('<%= data.OBJID %>', "<%= data.ORGTX %>", "javascript:searchDeptEmp('<%= data.OBJID %>');", 1));
<%
            } else {
%>
                aux<%= l_level_1 %> = insFld(aux<%= l_level_2 %>, gFld('<%= data.OBJID %>', "<%= data.ORGTX %>", "javascript:searchDeptEmp('<%= data.OBJID %>');", 1));
              //aux<%= l_level_1 %> = insFld(aux<%= l_level_2 %>, gFld("<%= data.ORGTX %>", "", 0));
<%
            }
        }
    }
%>
                initializeDocument();
                  </script>
                        </div>
                        <!--// shuttleTree end -->
                    </div>

                    <div class="shuttleRight">
                        <!--// List inside Shuttle start -->
                        <div class="listArea">
                            <div id="empGridSecond" class="jsGridPaging"><!-- 페이징이 필요할 경우 class="jsGridPaging" 추가 --></div>
                        </div>
                        <!--// List inside Shuttle end -->
                    </div>
                </div>
                <!--// Tab2 end -->
                <!--------------- layout body end --------------->
<script>
$(function() {
    on_Load();

    searchDeptEmp('<c:out value="${E_ORGEH}"/>');

    function on_Load() {

        if ("<%= level1 %>" != "0") clickOnNode(<%= index1 %>);
        if ("<%= level2 %>" != "0") clickOnNode(<%= index2 %>);
        if ("<%= level3 %>" != "0") clickOnNode(<%= index3 %>);
        if ("<%= level4 %>" != "0") clickOnNode(<%= index4 %>);
        if ("<%= level5 %>" != "0") clickOnNode(<%= index5 %>);

        document.all.folderIcon<%= index %>.src="/web-resource/images/tree/ftv2folderopen1.gif";
    }

    $("#empSearchForm #I_GUBUN").change(function() {
        if ($("#empSearchForm #I_GUBUN").prop("selectedIndex") == 0) { //성명
            fncSetReadOnly(new Array($("#empSearchForm #I_VALUE1")), false);
            $("#empSearchForm #I_VALUE1").attr("placeholder", "성");
            $("#empSearchForm #I_VALUE2").attr("placeholder", "이름");
        } else {
            $("#empSearchForm #I_VALUE1").val("");
            fncSetReadOnly(new Array($("#empSearchForm #I_VALUE1")), true);
            $("#empSearchForm #I_VALUE1").removeAttr("placeholder");
            $("#empSearchForm #I_VALUE2").attr("placeholder", "사번");
        }
    });

    var searchEmp = function() {
        if (checkEmpSearchFormValid()) $("#empGridFirst").jsGrid("search");
    }
    // 엔터 입력시 조회
    $("#empSearchForm #I_VALUE1, #empSearchForm #I_VALUE2").keyup(function(event){
        if (event.keyCode == 13) searchEmp();
    });

    //empSearchForm search start
    $("#searchEmpBtn").click(searchEmp);

    var checkEmpSearchFormValid = function() {
        if ($("#empSearchForm #I_GUBUN").prop("selectedIndex") == 0) { // 성명검색
            var val1 = $.trim($("#empSearchForm #I_VALUE1").val());
            var val2 = $.trim($("#empSearchForm #I_VALUE2").val());

            if (val1 == "" && val2 == "") {
                alert("검색할 부서원 성명을 입력하세요!")
                $("#empSearchForm #I_VALUE1").focus();
                return false;
            } else {
                if (val1.length < 1 ) {
                    alert("검색할 성명의 성을 입력하세요!")
                    $("#empSearchForm #I_VALUE1").focus();
                    return false;
                } else if (val2.length < 1) {
                    alert("검색할 성명의 이름을 한 글자 이상 입력하세요!")
                    $("#empSearchForm #I_VALUE2").focus();
                    return false;
                }
            }
        } else { // 사번검색
            var val = $.trim($("#empSearchForm #I_VALUE2").val());

            if (val == "") {
                alert("검색할 부서원 사번을 입력하세요!")
                $("#empSearchForm #I_VALUE2").focus();
                return false;
            }
        }
        return true;
    }

    $("#empGridFirst").jsGrid({
        height: "auto",
        width: "100%",
        sorting: true,
        paging: true,
        autoload: false,
        pageSize: 10,
        pageButtonCount: 10,
        controller : {
            loadData : function() {
                var d = $.Deferred();
                $.ajax({
                    type : "GET",
                    url : "/dept/getEmpList.json",
                    dataType : "json",
                    data: $("#empSearchForm").serializeArray()
                }).done(function(response) {
                    if (response.success) {
                        d.resolve(response.storeData);
                    } else {
                        alert("조회시 오류가 발생하였습니다. " + response.message);
                    }
                });
                return d.promise();
            }
        },
        fields: [
            { title: "선택", name: "PERNR", sorting: false, align: "center", width: "8%",
                itemTemplate: function(value, item) {
                    return $("<input type='radio' name='FIRSE_PERNR'>")
                        .on("click", function(e) {
                            goManagerLogin(item);
                        });
                }
            },
            { title: "사번", name: "PERNR", type: "text", align: "center", width: "12%" },
            { title: "성명", name: "ENAME", type: "text", align: "center", width: "12%" },
            { title: "부서", name: "ORGTX", type: "text", align: "center", width: "20%" },
            { title: "직위", name: "TITEL", type: "text", align: "center", width: "12%" },
            { title: "직책", name: "TITL2", type: "text", align: "center", width: "12%" },
            { title: "직무", name: "STLTX", type: "text", align: "center", width: "12%" },
            { title: "근무지", name: "BTEXT", type: "text", align: "center", width: "12%" }
        ]
    });

    $("#empGridSecond").jsGrid({
        height: "auto",
        width: "100%",
        sorting: true,
        paging: true,
        autoload: false,
        pageSize: 10,
        pageButtonCount: 10,
        fields: [
            { title: "선택", name: "PERNR", sorting: false, align: "center", width: "6%",
                itemTemplate: function(value, item) {
                    return $("<input type='radio' name='FIRSE_PERNR'>")
                        .on("click",function(e) {
                            goManagerLogin(item);
                        });
                }
            },
            { title: "사번", name: "PERNR", type: "text", align: "center", width: "12%" },
            { title: "성명", name: "ENAME", type: "text", align: "center", width: "12%" },
            { title: "부서", name: "ORGTX", type: "text", align: "center", width: "20%" },
            { title: "직위", name: "TITEL", type: "text", align: "center", width: "12%" },
            { title: "직책", name: "TITL2", type: "text", align: "center", width: "12%" },
            { title: "직무", name: "STLTX", type: "text", align: "center", width: "13%" },
            { title: "근무지", name: "BTEXT", type: "text", align: "center", width: "13%" }
        ]
    });
    var exist = false;
    var goManagerLogin = function(item) {
        isCanLogin(item);
        if (exist) {
            window.open('','menagedUser','toolbar=1,directories=1,menubar=1,status=1,resizable=1,location=0,scrollbars=1,width=800,height=500');
            //window.open('',item.PERNR,'toolbar=1,directories=1,menubar=1,status=1,resizable=1,location=1,scrollbars=1,width=800,height=500');
            $("#loginForm #empNo").val(item.PERNR);
            $("#loginForm").attr("target", 'menagedUser');
            $("#loginForm").submit();
        } else {
            alert("조회 권한이 없습니다.");
        }
    }
    var isCanLogin = function(item) {
        var orgeh = '<c:out value="${E_ORGEH}"/>';
        if ('<%=user.empNo%>' == '07196' || '<%=user.empNo%>' == '07152' || '<%=user.empNo%>' == '01014' || '<%=user.empNo%>' == '07082' || '<%=user.empNo%>' == '07158')
            orgeh = '50000003';
        else if ('<%=user.empNo%>' == '07206' || '<%=user.empNo%>' == '04103')
            orgeh = '50000017';

        var folder = getFolderWithKey(orgeh);
        exist = false;
        scanChildren(folder, item);
    }
    var scanChildren = function(folder, item) {
        if (folder.children != null && folder.children.length > 0) {
            for (var i = 0; i < folder.children.length; i ++)
                scanChildren(folder.children[i], item);
        }
        if (folder.key == item.ORGEH) {
            exist = true;
        }
    }
});

function searchDeptEmp(orgeh) {
    $("#empGridSecond").jsGrid({
        controller : {
            loadData : function() {
                var d = $.Deferred();
                $.ajax({
                    type : "GET",
                    url : "/dept/getDeptEmpList.json",
                    dataType : "json",
                    data: {"i_objid" : orgeh}
                }).done(function(response) {
                    if (response.success) {
                        d.resolve(response.storeData);
                    }
                    else
                        alert("조회시 오류가 발생하였습니다. " + response.message);
                });
                return d.promise();
            }
        }
    });
    $("#empGridSecond").jsGrid("search");
}
</script>