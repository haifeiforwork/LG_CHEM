<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 조직도 조회                                                 */
/*   Program ID   : ViewOrganListLeftIF.jsp                                     */
/*   Description  : 초기화면 조직도 조회 iFrame                                 */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-20  유용원                                          */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
  
<%@ page contentType="text/html; charset=utf-8" %> 
<%@ include file="/web/common/popupPorcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
 
<%  
    int    clickSize    = 0;
    Vector CallDept_vt  = (Vector)request.getAttribute("CallDept_vt");
    Vector OrganList_vt = (Vector)request.getAttribute("OrganList_vt");
    
    if( CallDept_vt != null && CallDept_vt.size()>0 ) {
        
        for( int i = 0; i < CallDept_vt.size(); i++ ){
            OrganInsertData tempData = (OrganInsertData)CallDept_vt.get(i);
            String tempDept = WebUtil.nvl(tempData.OBJID);
            
            if( !tempDept.equals("") ){
                clickSize++;
            }
        }
    }
%>
       
<%! 
    // 갯수
    int deptCount = 0;
    int depth = 0;
   
    //마지막 존재 여부.
    public boolean isLastNode(Vector vc ,String topCode ,int startIndex )
    {
        for(int i = startIndex; i < vc.size(); i ++ ) {
            OrganInfoData dataOpen1 = (OrganInfoData)vc.get(i);
            if(topCode.equals(dataOpen1.UPOBJID)){
                return false;
            }// end 
        } // end for
    
        return true;
    } 

    public String writeOrganTree(Vector vc ,String topCode ,String parentID) 
    {
        depth ++;
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < vc.size(); i++) {
            OrganInfoData data = (OrganInfoData)vc.get(i);
            
            if (data.UPOBJID.equals(topCode)) {
                //하위에 조직이 있을경우.
                if ("X".equals(data.LOWERYN)){
                    String selfID = "subDept" + deptCount;
                    
                    sb.append("<tr height=22>");
                    sb.append(data.STOPHERE); 
                    sb.append("<td valing=middle>");
                    if(isLastNode(vc, topCode, i + 1)) {                        
                        if(data.isOpen) {
	                        sb.append("<a href=\"#\" onClick=\"node('" + data.OBJID + "','" + data.OBJTXT + "');\" ><img src='/web/images/OrganTree/ftv2mlastnode.gif'  border=0></a>");	                        
	                    } else {
	                        sb.append("<a href=\"#\" onClick=\"node('" + data.OBJID + "','" + data.OBJTXT + "');\" ><img src='/web/images/OrganTree/ftv2plastnode.gif'  border=0></a>");	                        
	                    } // end if
                        
                    } else {
                        if(data.isOpen) {
                            sb.append("<a href=\"#\" onClick=\"node('" + data.OBJID + "','" + data.OBJTXT + "');\" ><img src='/web/images/OrganTree/ftv2mnode.gif'  border=0></a>");                            
                        } else {
                            sb.append("<a href=\"#\" onClick=\"node('" + data.OBJID + "','" + data.OBJTXT + "');\" ><img src='/web/images/OrganTree/ftv2pnode.gif'  border=0></a>");                            
                        } // end if
                    } // end if
                                        
                    sb.append("</td><td valing=middle>");  
                    if(data.isOpen) {
                        sb.append("<img src='/web/images/OrganTree/folderOpen.gif' height=18 border=0 >");                        
                    } else {
                        sb.append("<img src='/web/images/OrganTree/folderClosed.gif' height=18 border=0 >");                        
                    } // end if 
                    
                    sb.append("<a href=\"#\"  onClick=\"fol('" + data.OBJID + "','" + data.OBJTXT + "');\" >" + data.OBJTXT + "</a>" );                    
                    sb.append("</td></tr><tr>");
                    if(isLastNode(vc, topCode, i + 1)){
                        sb.append("<td background='/web/images/OrganTree/ftv2blank.gif' width=16>");
                    }else{
                        sb.append("<td background='/web/images/OrganTree/ftv2vertline.gif' width=16>");
                    }//end if
                    
                    sb.append("</td><td >");                          
                    sb.append("<table  cellspacing=\"0\" cellpadding=\"0\" border=0 >");
                    sb.append(writeOrganTree(vc ,data.OBJID ,selfID));
                    sb.append("</table>" );
                    sb.append("</td></tr>");
                    deptCount ++;
                //하위에 조직이 없을경우.    
                } else {  
                    sb.append("<tr height=22><td valing=middle>");
                    if(isLastNode(vc, topCode, i + 1)){
                        sb.append("<img src='/web/images/OrganTree/ftv2lastnode.gif' border=0>"); 
                    }else{
                        sb.append("<img src='/web/images/OrganTree/ftv2node.gif' border=0>");  
                    }//end if                    
                    
                    sb.append("</td><td valign=middle>");  
                    if(data.isOpen) {
                        sb.append("<img src='/web/images/OrganTree/folderOpen.gif' height=18 border=0 >");                        
                    } else {
                        sb.append("<img src='/web/images/OrganTree/folderClosed.gif' height=18 border=0 >");                        
                    } // end if 
                    
                    sb.append("<a href=\"#\" onClick=\"fol('" + data.OBJID + "','" + data.OBJTXT + "');\" >" + data.OBJTXT + "</a>");   
                    sb.append("</td></tr>");
                } // end if
            } // end if
        } // end for
        depth --;
        return sb.toString();
    }
%> 
  
<html> 
<head>
<title></title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<script LANGUAGE="JavaScript">
<!--        
    //노드 선택시.        
    function node(deptId, deptNm)  {




        var frm   = document.form1;    
        var tFlag = "N";
        
        if( deptId != "" ){  
            for(var x=0; x<<%=clickSize%>; x++){
                //중복되는 값이 있으면 ''으로 할당.
                if(frm.hdn_clickDeptCode[x].value == deptId){
                    frm.hdn_clickDeptCode[x].value = "";
                    tFlag = "Y";
                    break;
                }
            }//end for
            
            //선택된 값중 중복되는 값이 없을 경우만 값 할당.
            if(tFlag=="N"){
                frm.hdn_clickDeptCode[<%=clickSize%>].value = deptId;
            }//end if   
            
            frm.hdn_deptId.value = deptId;  //stopHere를 위한 값. 
            frm.action = "<%= WebUtil.ServletURL %>hris.common.OrganListSV#Stop_Here";
            frm.target = "iFrame1";
            frm.submit();
        }
    }           

    //폴더 선택시.
    function fol(deptId, deptNm) 
    {      
        var frm = document.form1;    
        
        frm.action = "<%=WebUtil.JspURL%>"+"common/ViewOrganListRightIF.jsp";
        frm.hdn_deptId.value = deptId;
        frm.hdn_deptNm.value = deptNm;
        frm.target = "iFrame2";
        frm.submit(); 
    }               
    
//-->
</script>

</head>
<body bgcolor="#FFFFFF" topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" >
<form name="form1" method="post" action="">
<input type="hidden" name="deptCount" value="<%=deptCount%>">
<input type="hidden" name="hdn_popCode" value="V">
<input type="hidden" name="hdn_deptId" value="">
<input type="hidden" name="hdn_deptNm" value="">

<%
    if( CallDept_vt != null && CallDept_vt.size()>0 ) {
        for( int i = 0; i < CallDept_vt.size(); i++ ){
            OrganInsertData organInsertData = (OrganInsertData)CallDept_vt.get(i);
            String selectedDept = WebUtil.nvl(organInsertData.OBJID);
            
            if( !selectedDept.equals("") ){
%>
<input type="hidden" name="hdn_clickDeptCode" value="<%=selectedDept%>">
<%
            } 
        }
    }
%>
<input type="hidden" name="hdn_clickDeptCode" value="">
<input type="hidden" name="hdn_clickDeptCode" value="">

<table border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td align="right" valign="top" aling="left" >
        <table border="0" cellspacing="0" cellpadding="0" >
          <tr>
            <td colspan="2" height="5"></td>
          </tr>
          <tr>
            <td colspan="2" >LG CHEM</td>
          </tr>
           <%=writeOrganTree(OrganList_vt ,"00000000" ,"")%> 
        </table>
    </td>
  </tr>
  <tr>
  </tr>
</table>

</form>
</body>
</html> 
<%
    deptCount = 0;
%>

