<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%


    HashMap qlHM = (HashMap)request.getAttribute("resultVT");
    int TOTCNT =  0;

    int listSize = 0;
    PageUtil pu = null;
    String paging =   WebUtil.nvl((String)request.getParameter("page"));
    int fagNo = 1;

    Vector listVT = (Vector)qlHM.get("T_EXPORT");
    listSize = listVT.size();

    if(listSize > 0 ){
        TOTCNT =Integer.parseInt((String)qlHM.get("TOTCNT"));
    }

    if(!paging.equals("") && !paging.equals("1") ){
        int mpaging = Integer.parseInt(paging) -1;
        int pagNo  = mpaging * 10;
        fagNo =  pagNo+1;
    }else{
        paging = "1";
    }

    try {
        pu = new PageUtil(TOTCNT, paging , 10, 10 );//Page 관련사항
    } catch (Exception ex) {

    }


%>

<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <title>LG화학 e-HR 시스템</title>
    <meta name="description" content="LG화학 e-HR 시스템" />
    <link rel="stylesheet" type="text/css" href="<%=WebUtil.ImageURL %>css/ehr_style.css" />
    <link rel="stylesheet" type="text/css" href="<%=WebUtil.ImageURL %>css/ehr_wsg.css" />
    <script type="text/javascript">

    function dataDetail(objid){
            frm = document.form1;
            frm.mode.value="DETL";
            frm.I_OBJID.value=objid;
            var returnUrl = "<%=WebUtil.JspURL%>N/EAP/mental/greenLetter_view.jsp";
            frm.action = "<%= WebUtil.ServletURL%>hris.N.common.CommonFAQListSV?I_CODE=0002&I_PFLAG=&returnUrl="+returnUrl;
            frm.submit();
    }

    function pageChange(page){
            document.form1.page.value = page;
            get_Page();
    }

    function get_Page(){
            frm = document.form1;
            var returnUrl ="<%=WebUtil.JspURL%>N/EAP/mental/greenLetter_list.jsp";
            frm.action = "<%= WebUtil.ServletURL %>hris.N.common.CommonFAQListSV?I_CODE=0002&I_PFLAG=X&returnUrl="+returnUrl;
            frm.submit();
    }

    </script>
</head>

<body id="subBody">
<form name="form1" method="post">
<input type="hidden" name="page" value="<%= paging %>">
<input type="hidden" name="mode" value="">
<input type="hidden" name="I_OBJID" value="">
<div class="winPop">
    <div class="header">
        <span>Green Letter </span>
        <a href=""><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" /></a>
    </div>

    <div class="body">

        <!-- 테이블 시작 -->
        <div class="listArea">
            <div class="listTop">
                <span class="listCnt"><%= pu == null ?  "" : pu.pageInfo() %></span>
            </div>
            <div class="table">
                <table class="listTable">
                    <colgroup>
                        <col width="50" />
                        <col />
                        <col width="110" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>제목</th>
                            <th class="lastCol">게시일자</th>
                        </tr>
                    </thead>
                    <tbody>
<%


if(listSize > 0 ){
     HashMap<String, String> sphm = new HashMap<String, String>();

     for(int k = 0 ; k < listSize ; k++){

        String tr_class = "";

        if(k%2 == 0){
            tr_class="oddRow";
        }else{
            tr_class="";
        }

         sphm = (HashMap)listVT.get(k);
         String CODTX = sphm.get("CODTX");
         String SUBTX = sphm.get("SUBTX");
         String TITLE = sphm.get("TITLE");
         String REGDT = sphm.get("BEGDA");
         String OBJID = sphm.get("OBJID");


%>
                        <tr class="<%=tr_class%>">
                            <td><%=fagNo+k %></td>
                            <td class="align_left"><a href="javascript:dataDetail('<%= OBJID%>')"><%=TITLE %></a></td>
                            <td class="lastCol"><%=REGDT %></td>
                        </tr>
<%}
 }
     %>

                    </tbody>
                </table>
                <div class="align_center">
                    <%= pu == null ? "" : pu.pageControl() %>
                </div>
            </div>
        </div>
        <!-- 테이블 끝 -->

        <!--페이징 시작 -->
<!--         <style type="text/css">
            a:link {  color: #666666; text-decoration: none}
            a:visited {  color: #666666; text-decoration: none}
            a:hover {  color: #666666; text-decoration: underline}
            .pagingTd {vertical-align:middle;text-align:center;height:25px;}
            .pagingTd img {vertical-align:middle;}
        </style>

        <div class="paging">
         <table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="pagingTd">

            </td>
          </tr>
        </table>
        </div> -->
        <!--페이징 끝 -->

        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a href="javascript:window.close();"><span>닫기</span></a></li>
            </ul>
        </div>

    </div>


</div>

</form>
</body>
</html>