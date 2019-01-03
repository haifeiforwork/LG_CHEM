<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 조직도 조회                                                 */
/*   Program ID   : OrganListPopIF.jsp                                          */
/*   Description  : 조직도 조회 PopUp의 iFrame                                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-20  유용원                                          */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
 
<%@ page contentType="text/html; charset=utf-8" %> 
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/common" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<tags:layout >
    <common:mss-tree-layout url="${g.servlet}hris.common.OrganListSV"/>
    <tags:script>
        <script>
            //폴더 선택시.
            function fol(deptId, deptNm, uporgid) {
                var frm = document.form1;
                parent.setDeptID(deptId, deptNm, uporgid);
            }

            function node(deptId) {
                $("#tree").fancytree("getTree").activateKey(deptId);
                parent.blockFrame();
            }


            /*function selectIMG(docID){
                var obj2 = document.all.length;

                var textid = eval("document.all.mn" + docID);

                var spantag =  document.getElementById("mn"+docID);
                //alert("span : "+spantag);
                //alert("text : "+textid);

                if(spantag != null){
                    textid = eval("document.all.mn" + docID);
                    //alert("ok");


                    for(i = 0; i < obj2; i++){
                        var aa;
                        aa = eval("document.all["+i+"]");
                        if(aa.id.substring(0,2)=="mn"){
                            aa.className = "";
                        }
                    }
                    spantag.className="treeMenu_on";
                }else{
                    //var spandouble =  document.getElementsByName("mn"+docID);
                    //alert("error");
                    //alert("span : "+textid[0]);
                }

            }*/



        </script>
    </tags:script>
</tags:layout>




