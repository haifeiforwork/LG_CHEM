<%@ tag import="com.sns.jdf.util.WebUtil" %>
<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>

<%@ attribute name="url" type="java.lang.String" required="true" %>

<link rel="stylesheet" href="${g.image}css/dynatree/skin-win7/ui.fancytree.min.css" type="text/css">

<script language="JavaScript" src="${g.image}js/jquery.dynatree.min.js"></script>

<tags:script>
    <script>

        $(function() {
            $("#tree").fancytree({
                /*selectMode: 3,*/
                checkbox: true,
                clickFolderMode : 2,
                autoFocus : false,
                activate: function(event, data){
                    <%-- 노드 선택시 부분 행위 ex)조직 상세조회, 조직정보 조회 등 작업 --%>
                    //fol(data.node.key, data.node.title);
                },
				select: function(event, data){

					var selectKey = data.tree.getSelectedNodes();
					var selKeys = $.map(selectKey, function(node){
						return node.key;
			        });
					var selValues = $.map(selectKey, function(node){
						return node.title;
			        });
					parent.$("#deptNo").val(selKeys.join(","));
					parent.$("#deptNm").val(selValues.join(","));
				},
                postProcess: function(event, data) {
                    var row = data.response;
                    data.result =  {title: row.OBJTXT, id: row.OBJID, isFolder: 'X' == row.LOWERYN, isLazy: 'X' == row.LOWERYN};
                },
                lazyLoad: function(event, data) {
                    <%-- 하위 노드 조회 부분 ajax 로 요청 함 --%>
                    var node = data.node;

                    data.result = [];

                    var _param = {OBJID : data.node.key, jobid:'node'};

                    ajaxPost("${url}", _param,  function(resultData) {
						<%-- 선택노드에 하위 노드 결과 값을 등록한다 --%>
						$.each(resultData.resultList, function(idx, row) {
							node.addChildren({title: row.OBJTXT, id: row.OBJID, key: row.OBJID, folder: 'X' == row.LOWERYN, lazy: 'X' == row.LOWERYN});
						});
					}, function(resultData){
							alert(resultData.message);
					});
                }
            });
        });

        $(function() {
            $(".subWrapper").removeClass("subWrapper");
            if('${I_SELTAB}' == "C"){	//사원검색 팝업 근태그룹 텝일때
	            chkbox();
            }
        });

        function chkbox(){
        	var iSeqno = "00000"+'${iSeqno}';
            if('${orgOrTm}' == 2 ){	//근태그룹 라디오 선택
	            if(iSeqno == "00000"){	//전체
	            	$("#tree").fancytree("getTree").visit(function(node){
	            		node.setSelected(true);
	    			});
	            }else{
	            	$("#tree").fancytree("getTree").visit(function(node){
	    				if(iSeqno == node.key){
	    					node.setSelected(true);
	    				}
	    			});
	            }

	            parent.do_searchEmp();
            }


        }

    </script>
</tags:script>
<style type="text/css">
	body { margin-bottom: 0px }
    .iframeWrap {margin:0px;}
    ul.fancytree-container{ border: 0px; height: 100%; margin: 0px; padding: 0px; }
</style>

<div class="ui-widget">
    <div id="tree" style="text-align: left;" >
        <ul id="treeData" style="border: 0px;" >
            <%--@elvariable id="resultList" type="java.util.Vector<hris.common.OrganInfoData>"--%>
            <c:forEach items="${resultList}" var="row" varStatus="status">
                <li id="${row.OBJID}"
                    class="folder ${'X' == row.LOWERYN ? 'lazy' : ''}">${row.OBJTXT}</li>
            </c:forEach>
        </ul>
    </div>
</div>