<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import = "com.sns.jdf.util.*"%>
<%

    String totalSum =  request.getParameter("totalSum");
    int srange =0;
    srange = Integer.parseInt(totalSum);
    String groupIdx = "0";
    if(srange >= 10 && srange <= 15){
        groupIdx = "1";
    }else if(srange >= 16 && srange <= 20){
        groupIdx = "2";
    }else if(srange >= 21 && srange <= 25){
        groupIdx = "3";
    }else if(srange >= 26 && srange <= 30){
        groupIdx = "4";
    }else if(srange >= 31){
        groupIdx = "5";
    }


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <!--[if lt IE 9]>
    <script src="http://getbootstrap.com/2.3.2/assets/js/html5shiv.js"></script>
    <script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE9.js">IE7_PNG_SUFFIX=".png";</script>
    <![endif]-->
    <title>LG화학 e-HR 시스템</title>
    <meta name="description" content="LG화학 e-HR 시스템" />
    <link rel="stylesheet" type="text/css" href="<%=WebUtil.ImageURL  %>/css/ehr_style.css" />
    <link rel="stylesheet" type="text/css" href="<%=WebUtil.ImageURL  %>/css/ehr_wsg.css" />

    <script type="text/javascript">

        function popup(theURL,winName,features) {
          window.open(theURL,winName,features);
        }
    </script>
</head>

<body id="subBody" oncontextmenu="return true" ondragstart="return false" onselectstart="return false">
<div class="winPop">
    <div class="header"  style="background-image:url(../../../images/sshr/bg_winPopHeader.gif);">
        <span>심리검사 채점 및 결과</span>
        <a href=""><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" /></a>
    </div>

    <div class="body">


        <!-- 테이블 시작 -->
        <div class="table">
        <table class="listTable">
            <colgroup>
                <col width="150" />
                <col  />
            </colgroup>
            <thead>
                <tr>
                    <th>총점</th>
                    <th class="lastCol">설명</th>
                </tr>
            </thead>
            <tbody>
                <tr class="oddRow">
                    <td <%if(groupIdx.equals("1")){ %> style="background-color:#fcf2f5;color:#d4326f;"  <%} %>>10점 ~15점</td>
                    <td class="lastCol align_left" <%if(groupIdx.equals("1")){ %> style="background-color:#fcf2f5;color:#d4326f;"  <%} %>>
                        거의 스트레스를 받고 있지 않은 것으로 보입니다.
                    </td>
                </tr>
                <tr>
                    <td <%if(groupIdx.equals("2")){ %> style="background-color:#fcf2f5;color:#d4326f;"  <%} %>>16점 ~20점</td>
                    <td class="lastCol align_left" <%if(groupIdx.equals("2")){ %> style="background-color:#fcf2f5;color:#d4326f;"  <%} %>>
                         약간 스트레스를 받고 있는 것으로 보입니다.
                    </td>
                </tr>
                <tr class="oddRow">
                    <td <%if(groupIdx.equals("3")){ %> style="background-color:#fcf2f5;color:#d4326f;"  <%} %>>21점 ~25점</td>
                    <td class="lastCol align_left" <%if(groupIdx.equals("3")){ %> style="background-color:#fcf2f5;color:#d4326f;"  <%} %>>
                         비교적 스트레스가 심한 편이므로 스트레스를 줄이기 위한 대책이 필요합니다.
                    </td>
                </tr>
                <tr>
                    <td <%if(groupIdx.equals("4")){ %> style="background-color:#fcf2f5;color:#d4326f;"  <%} %>>26점 ~30점</td>
                    <td class="lastCol align_left" <%if(groupIdx.equals("4")){ %> style="background-color:#fcf2f5;color:#d4326f;"  <%} %>>
                         심한 스트레스를 받고 있으므로 신체상태에 대한 정기적인 검진과 더불어 스트레스를 줄이기 위한 방법을 생각해 보아야 합니다.
                    </td>
                </tr>
                <tr class="oddRow">
                    <td <%if(groupIdx.equals("5")){ %> style="background-color:#fcf2f5;color:#d4326f;"  <%} %>>31점 이상</td>
                    <td class="lastCol align_left" <%if(groupIdx.equals("5")){ %> style="background-color:#fcf2f5;color:#d4326f;"  <%} %>>
                         매우 심한 스트레스를 받고 있으므로 바로 전문가를 찾아야 합니다.
                    </td>
                </tr>
            </tbody>
        </table>
        <!-- 테이블 끝 -->

        <span class="commentOne" style="background-image:url(../../../images/sshr/ico_instruct.gif);">보다 자세한 검사 및 문의는 심리 상담실로 연락하여 주시기 바랍니다.</span>

        <div class="buttonArea">
            <ul class="btn_crud">
                <li><a href="javascript:window.close();" style="background-image:url(../../../images/btn_crud_normal.gif);"><span  style="background-image:url(../../../images/btn_crud_normal.gif);">닫기</span></a></li>
            </ul>
        </div>
    </div>
</div>
</body>
</html>