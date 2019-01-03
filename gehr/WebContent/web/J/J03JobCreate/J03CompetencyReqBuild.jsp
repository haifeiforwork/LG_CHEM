<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/popupPorcess.jsp" %> 

<%@ page import="hris.J.J01JobMatrix.*" %>   
<%@ page import="hris.J.J03JobCreate.*" %>
<%@ page import="hris.J.J03JobCreate.rfc.*" %>         
<%@ page import="com.sns.jdf.util.*" %>  
<%@ page import="java.util.*" %>
<%   
//  Competency Requirements
    String i_jobid     =  (String)request.getAttribute("jobid");
    String T_Spec      =  (String)request.getAttribute("spec_size");
    String T_Comm      =  (String)request.getAttribute("comm_size");    
    int  min_spec_size =  Integer.parseInt(T_Spec);
    int  min_comm_size =  Integer.parseInt(T_Comm);    
    String T_QKID      =  "" ;
    int    T_rows      =  0;

//  requirement 그룹핑     
    Vector    J03QK_vt         = (Vector)request.getAttribute("J03QK_vt");

    J03QKData data_QK_t0       = (J03QKData)J03QK_vt.get(0);            
    J03QKData data_QK_t1       = (J03QKData)J03QK_vt.get(1);                
    String    comm_objid       = data_QK_t0.OBJID;
    String    spec_objid       = data_QK_t1.OBJID;   
        
//  requirement level    
    Vector    J03RequireLevel_vt = (Vector)request.getAttribute("J03RequireLevel_vt");
    
// 이전에 선택한 requirement 내용     
    Vector    J03Q_vt            = (Vector)request.getAttribute("J03Q_vt");
    Vector    J03D_vt            = (Vector)request.getAttribute("J03D_vt");  
%> 

<html>  
<head>
<title>ESS</title> 
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/jms_style.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

</head>

<%@ include file="J03JobMatrixMenu.jsp" %>

<script language="JavaScript"> 
<!-- 

// Competency 지정
function setCompetency(QK_id, i_rows){

  document.form1.QKID.value = QK_id;
  document.form1.rows.value = i_rows;  
  small_window=window.open("","setCompetency","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=789,height=600,left=100,top=100");
  small_window.focus();

  document.form1.action = "<%= WebUtil.JspURL %>J/J03JobCreate/J03FramePage.jsp";
  document.form1.target = "setCompetency";
  document.form1.submit();
}

// 요구수준 레벨변경
function changeContents(t_rows){   
   var t, key_text, t_line; 
   t =  eval("document.form1.LEVEL_D"+ t_rows + ".selectedIndex");
   
   t = t - 1 ;
   if ( t < 0 ) {
     key_text = "";
     t_line   = "";
     t        = 9; 
     eval("document.form1.SELECTED" + t_rows + ".value = '"+t+"';");      
   } else {
     key_text = eval("document.form1.STEXT_KEY_S" + t_rows + t + ".value");
     t_line   = eval("document.form1.TLINE_S" + t_rows + t + ".value");
     eval("document.form1.SELECTED" + t_rows + ".value = '"+t+"';");   
   }   
   
   eval("STEXT_KEY_T" + t_rows + ".innerHTML = '"+key_text+"';");
   eval("TLINE_T" + t_rows + ".innerHTML = '"+t_line+"';");
}
 
// 요구수준 삭제
function delCompetency(t_QKid, t_rows){
//삭제하시겠습니까? 라는 메시지 추가
  if( confirm("삭제하시겠습니까?") ){
    var htmlBUTTON_S = "", t_temp = "<table hight=45><tr><td>&nbsp;</td></tr></table>", t_exit = "N";   
  
//  삭제된 경우에도 중복 Competency 지정을 check하기위해서 SOBID를 넣어준다.
    var del_STEXT_Q_S = "<input type=hidden name=SOBID"+t_rows+">";

    eval("STEXT_Q_S"   + t_rows + ".innerHTML = '"+ del_STEXT_Q_S +"';");
    eval("ZLEVEL_S"    + t_rows + ".innerHTML = '"+ t_temp +"';");
    eval("STEXT_KEY_S" + t_rows + ".innerHTML = '"+ t_temp +"';"); 
    eval("TLINE_S"     + t_rows + ".innerHTML = '"+ t_temp +"';");   
    eval("document.form1.D_EXIT" + t_rows + ".value = '"+ t_exit + "';");      
  
    if ( t_rows == 0 ) {
      BUTTON_S0.innerHTML  =  "<a href='javascript:setCompetency(\"" + t_QKid + "\",\"" + t_rows + "\");" + "'><img src='<%= WebUtil.ImageURL %>jms/btn_points.gif' border=0 hspace=3 alt='지정'></a>";   
    } else if ( t_rows == 0 ) {  
      BUTTON_S0.innerHTML  =  "<a href='javascript:setCompetency(\"" + t_QKid + "\",\"" + t_rows + "\");" + "'><img src='<%= WebUtil.ImageURL %>jms/btn_points.gif' border=0 hspace=3 alt='지정'></a>";   
    } else if ( t_rows == 1 ) {  
      BUTTON_S1.innerHTML  =  "<a href='javascript:setCompetency(\"" + t_QKid + "\",\"" + t_rows + "\");" + "'><img src='<%= WebUtil.ImageURL %>jms/btn_points.gif' border=0 hspace=3 alt='지정'></a>";   
    } else if ( t_rows == 2 ) {  
      BUTTON_S2.innerHTML  =  "<a href='javascript:setCompetency(\"" + t_QKid + "\",\"" + t_rows + "\");" + "'><img src='<%= WebUtil.ImageURL %>jms/btn_points.gif' border=0 hspace=3 alt='지정'></a>";   
    } else if ( t_rows == 3 ) {  
      BUTTON_S3.innerHTML  =  "<a href='javascript:setCompetency(\"" + t_QKid + "\",\"" + t_rows + "\");" + "'><img src='<%= WebUtil.ImageURL %>jms/btn_points.gif' border=0 hspace=3 alt='지정'></a>";   
    } else if ( t_rows == 4 ) {  
      BUTTON_S4.innerHTML  =  "<a href='javascript:setCompetency(\"" + t_QKid + "\",\"" + t_rows + "\");" + "'><img src='<%= WebUtil.ImageURL %>jms/btn_points.gif' border=0 hspace=3 alt='지정'></a>";   
    } else if ( t_rows == 5 ) {  
      BUTTON_S5.innerHTML  =  "<a href='javascript:setCompetency(\"" + t_QKid + "\",\"" + t_rows + "\");" + "'><img src='<%= WebUtil.ImageURL %>jms/btn_points.gif' border=0 hspace=3 alt='지정'></a>";   
    } else if ( t_rows == 6 ) {  
      BUTTON_S6.innerHTML  =  "<a href='javascript:setCompetency(\"" + t_QKid + "\",\"" + t_rows + "\");" + "'><img src='<%= WebUtil.ImageURL %>jms/btn_points.gif' border=0 hspace=3 alt='지정'></a>";   
    } else if ( t_rows == 7 ) {  
      BUTTON_S7.innerHTML  =  "<a href='javascript:setCompetency(\"" + t_QKid + "\",\"" + t_rows + "\");" + "'><img src='<%= WebUtil.ImageURL %>jms/btn_points.gif' border=0 hspace=3 alt='지정'></a>";   
    } else if ( t_rows == 8 ) {  
      BUTTON_S8.innerHTML  =  "<a href='javascript:setCompetency(\"" + t_QKid + "\",\"" + t_rows + "\");" + "'><img src='<%= WebUtil.ImageURL %>jms/btn_points.gif' border=0 hspace=3 alt='지정'></a>";   
    } else if ( t_rows == 9 ) {  
      BUTTON_S9.innerHTML  =  "<a href='javascript:setCompetency(\"" + t_QKid + "\",\"" + t_rows + "\");" + "'><img src='<%= WebUtil.ImageURL %>jms/btn_points.gif' border=0 hspace=3 alt='지정'></a>";   
    } else if ( t_rows == 10 ) {  
      BUTTON_S10.innerHTML  =  "<a href='javascript:setCompetency(\"" + t_QKid + "\",\"" + t_rows + "\");" + "'><img src='<%= WebUtil.ImageURL %>jms/btn_points.gif' border=0 hspace=3 alt='지정'></a>";   
    } else if ( t_rows == 11 ) {  
      BUTTON_S11.innerHTML  =  "<a href='javascript:setCompetency(\"" + t_QKid + "\",\"" + t_rows + "\");" + "'><img src='<%= WebUtil.ImageURL %>jms/btn_points.gif' border=0 hspace=3 alt='지정'></a>";   
    }
  }
}

// Common Competency line 추가 
function changeLine(type){

   var count = 0;
 
    if ( type == "1" ) {
       count = <%= min_comm_size %>;
       count = count  + 1;
       document.form1.comm_size.value = count;
    } else if  ( type == "2" ) {
       count = <%= min_spec_size %>;
       count = count  + 1;
       document.form1.spec_size.value = count;
    }
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03CompetencyReqBuildSV";
    document.form1.method      = "post";
    document.form1.target      = "J_right";
    document.form1.submit();
}

// Competency Requirement 저장  
function saveObject(){

    var count = 0, k = 0;
    var contents = "" , selected = ""; 
//  지정후 삭제한 데이터의 경우     
    
    count = <%= min_comm_size %> + <%= min_spec_size %> ;
    
//  요구수준이 선택 안된 데이터 존재하는지 체크 
    for ( var i = 0; i < count ; i++ ) {
      contents = eval("document.form1.D_EXIT" + i + ".value");       
      if ( contents == "Y" ) {
        k++;
        selected = eval("document.form1.SELECTED" + i + ".value");               
        if ( selected == "9" ) {
          alert("요구수준이 선택되지 않은 데이터가 존재합니다.");        
          return;
        }
      }
    }
    
//  데이터 입력건수가 존재하는지 체크    
    if ( k == 0 ) {
        alert("데이터가 입력되지 않았습니다.");    
        return;        
    }
    
    document.form1.jobid.value = "create";
    document.form1.action      = "<%= WebUtil.ServletURL %>hris.J.J03JobCreate.J03CompetencyReqBuildSV";
    document.form1.method      = "post";
    document.form1.target      = "J_right";
    document.form1.submit();
}
 
-->
</script>

<form name="form1" method="post" action="">
  <input type="hidden" name="jobid"      value="<%= i_jobid %>">                      <!-- Servlet 작업 구분 -->
  <input type="hidden" name="QKID"       value="">                       <!-- QK  ID-->
  <input type="hidden" name="rows"       value="">                       <!-- 선택 라인-->
  <input type="hidden" name="comm_size"  value="<%= min_comm_size %>">     <!-- common size-->
  <input type="hidden" name="spec_size"  value="<%= min_spec_size %>">     <!-- special size-->    
  <input type="hidden" name="OBJID"      value="<%= i_objid %>">               <!-- Objective id-->
  <input type="hidden" name="SOBID"      value="<%= i_sobid %>">               <!-- Job id-->    
  <input type="hidden" name="IMGIDX"     value="<%= i_imgidx %>">             <!-- Image Index-->
  <input type="hidden" name="i_link_chk" value="<%= i_link_chk %>">       <!-- Link Check-->    
  <input type="hidden" name="i_Create"   value="<%= i_Create %>">           <!-- Create yn-->
  <input type="hidden" name="BEGDA"      value="<%= i_begda %>">               <!-- Create yn-->  

  
  
 <table cellspacing=0 cellpadding=0 border=0 width=760>
   <tr>
     <td width=14><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=14 height=15></td>
     <td width=746 valign=top align=center>
       <table cellpadding=0 cellspacing=0 border=0 width=746>
         <tr height=26>
           <td colspan=11 class=subt01><img src="<%= WebUtil.ImageURL %>jms/bullet_Dround.gif" align=absmiddle>Competency Requirements 생성</td>
         </tr>
         <!-- 표의 맨 위에는 #999999를 넣어주세요. 여기서 td에 width를 모두 설정하셔야 아래쪽의 가이드라인이 잡힙니다. -->
         <tr bgcolor=#999999 height=2>
           <td width=29></td>
           <td width=1></td>
           <td width=69></td>
           <td width=1></td>
           <td width=49></td>
           <td width=1></td>
           <td width=77></td>
           <td width=1></td>
           <td width=452></td>
           <td width=1></td>
           <td width=65></td>
         </tr>
         <tr>
           <td colspan=11 bgcolor=#999999></td>
         </tr>
         <tr>
           <td class=ct colspan=3 align=center>Job Name</td>
           <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
           <td class=cc colspan=7> <%= dStext.STEXT_JOB %> </td>
         </tr>
         <tr>
           <td colspan=11 bgcolor=#999999></td>
         </tr>
        <!-- 이 tr이 들어가면 테이블 사이가 벌어집니다. 늘 같은 간격으로 벌어지게 하기 위해 height를 교정하지 마세요 -->	  
          <tr>
            <td colspan=11 height=5><img src="<%= WebUtil.ImageURL %>jms/space.gif" width=2 height=5></td>
          </tr>
        <!-- 아래의 tr과 같이 다시 height를 2를 적용해 주시면 보기에 새로 테이블이 시작한 것과 같은 효과를 줍니다. -->	  
          <tr height=2>
            <td colspan=11 bgcolor=#999999></td>
          </tr>
         <tr align=center>
           <td class=ct colspan=3 align=center>요구역량</td>
           <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
           <td class=ct>요구수준</td>
           <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
           <td class=ct>Key Words</td>
           <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
           <td class=ct colspan=3>행동지표</td>
         </tr>
         <tr>
           <td colspan=11 bgcolor=#999999></td>
         </tr>
<%
    int  base, base2,count = 0;
    int  comm_cur_size  = 0;
    int  spec_cur_size  = 0;
    int  temp_min_size  = 0;            
    int  temp_cur_size  = 0;
    
// 각 컨피턴시별로(common, spectial) 이미존재하는것 갯수구함 
    for( int j = 0 ; j < J03Q_vt.size() ; j++ ) {
        J01CompetencyReqData data_Q = (J01CompetencyReqData)J03Q_vt.get(j);        

        if( data_Q.OBJID_G.equals(comm_objid) ) {
            comm_cur_size += 1;
        }else if( data_Q.OBJID_G.equals(spec_objid) ) {
            spec_cur_size += 1;
         }
    }            

//  각 컨피턴시 그룹 수만큼 루핑 돎.    
    for ( int l = 0; l < J03QK_vt.size() ; l++ ){
         J03QKData data_QK = (J03QKData)J03QK_vt.get(l);            

        if ( l == 0 ){
           temp_min_size = min_comm_size;
           temp_cur_size = comm_cur_size;
           base = 0;
           base2 = 0 ;
        } else {
           temp_min_size = min_spec_size;
           temp_cur_size = spec_cur_size;           
           base = comm_cur_size;
           base2 = min_comm_size;
        } 
//  1차 루핑은 0 -> 이미존재하는 common competency 갯수까지 실데이터로 채움 
//            존재하는 common competency 갯수 -> 늘린갯수까지 공데이터로 채움
//  2차 루핑은 common 갯수부터 존재하는 specil 갯수까지 실데이터 
//            존재하는 special 갯수부터 -> 늘린 갯수까지 공데이터           
      count = 0 ;
      for( int i = base ; i < base + temp_cur_size ; i ++ ) {
      
         J01CompetencyReqData data_Q = (J01CompetencyReqData)J03Q_vt.get(i); 

// 각 컨피턴시 별로 처음이면..        
            if( i == 0 || i == comm_cur_size ) { 
%>
        <tr>
          <td rowspan="<%= (temp_min_size * 2) - 1 %>" class=ct style="writing-mode:tb-rl" align="center"><%= data_QK.STEXT %></td>
          <td rowspan="<%= (temp_min_size * 2) - 1 %>" width=1 bgcolor=#999999></td>
<%
            }else {
%>            
        <tr>                
<%
            }   
//  요구역량                 
%>                
          <td class=ct1 id="STEXT_Q_S<%= base2 + count %>">
              <%= data_Q.STEXT_Q %>
              <input type=hidden name='SOBID<%= base2 + count %>' value='<%= data_Q.SOBID %>'>
              <input type=hidden name='STEXT_Q<%= base2 + count %>' value='<%= data_Q.STEXT_Q %>'>  
          </td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
<%
//  현재 작업대상을 템프 벡터에 담아 작업함.
           Vector  J03D_vt_t    = new Vector();            
           for( int j = 0 ; j < J03D_vt.size() ; j ++ ) {
               J01CompetencyReqData data_D = (J01CompetencyReqData)J03D_vt.get(j);
               if ( data_D.SOBID.equals(data_Q.SOBID) ) {
                  J03D_vt_t.addElement(data_D);
               }
           }
//  요구수준
           int  t_selected =  Integer.parseInt(data_Q.SUBTY);
%>        

          <td class=cc align=center  id="ZLEVEL_S<%= base2 + count %>">
             <select onChange='javascript:changeContents(<%= base2 + count %>);' name='LEVEL_D<%= base2 + count %>'>          
<%

           if ( t_selected >= 0 ) {
%>
              <option value='' >--</option>       
<%
           }else {
%>             
              <option value='' selected>--</option>
<%              
           }       
           for( int j = 0 ; j < J03D_vt_t.size() ; j ++ ) {
               J01CompetencyReqData data_D = (J01CompetencyReqData)J03D_vt.get(j);
               J03RequireLevelData  data_L = (J03RequireLevelData)J03RequireLevel_vt.get(j);

%>                   
              <option value='<%= j %>' <%if ( t_selected == j ){ %> selected <%}%>><%= data_L.PSTEXT %></option> 
<%            
          }
%>                        
             </select>
             <input type=hidden name='SELECTED<%= base2 + count %>' value='<%= t_selected %>'>             
          </td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>   
          <td class=cc id="STEXT_KEY_S<%= base2 + count %>">
<%
//  키 워드 
           for( int j = 0 ; j < J03D_vt_t.size() ; j ++ ) {
               J01CompetencyReqData data_D = (J01CompetencyReqData)J03D_vt_t.get(j);

              if ( t_selected == j ){
%>             
             <table cellspacing=0 cellpadding=0 border=0 width=75>
               <tr>
                  <td id="STEXT_KEY_T<%= base2 + count %>"><%= data_D.STEXT_KEY%></td>
               </tr>
             </table> 
<%
              }           
%>                   
              <input type=hidden name='STEXT_KEY_S<%= base2 + count %><%=j%>' value='<%= data_D.STEXT_KEY %>'>
<%              
           }
           if ( t_selected == 9 ) {   // 9 이면 선택이 안된것
%>              
             <table cellspacing=0 cellpadding=0 border=0 width=75>
               <tr>
                  <td id="STEXT_KEY_T<%= base2 + count %>"></td>
               </tr>
             </table> 
<%            
           }
//  행동지표                             
%>          
          </td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>                          
          <td class=cc id="TLINE_S<%= base2 + count %>">
<% 
           for( int j = 0 ; j < J03D_vt_t.size() ; j ++ ) {
               J01CompetencyReqData data_D = (J01CompetencyReqData)J03D_vt_t.get(j);
              if ( t_selected == j ){
%>            
            <table cellspacing=0 cellpadding=0 border=0 width=450>
              <tr>
                <td id="TLINE_T<%=base2 + count %>"><%= data_D.TLINE%></td>
              </tr>
            </table>  
<%
              } 
%>               
              <input type=hidden name='TLINE_S<%= base2 + count %><%=j%>' value='<%= data_D.TLINE %>'>
<%              
           }
           if ( t_selected == 9 ){
%>
            <table cellspacing=0 cellpadding=0 border=0 width=450>
              <tr>
                <td id="TLINE_T<%=base2 + count %>"></td>
              </tr>
            </table>  
<%            
              }
%>          
          </td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>                          
          <td align=center class=cc id="BUTTON_S<%= base2 + count %>"> 
             <a href='javascript:setCompetency(<%= data_Q.OBJID_G %>,<%= base2 + count%>);'><img src='<%= WebUtil.ImageURL %>jms/btn_points.gif' border=0 hspace=3 alt='지정'></a><br><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=10 height=3><br>
             <a href='javascript:delCompetency(<%= data_Q.OBJID_G %>,<%= base2 + count%>);'><img src='<%= WebUtil.ImageURL %>jms/btn_deletes.gif' border=0 hspace=3 alt='삭제'></a>
          </td>  
        </tr>
        <tr>
          <td colspan=11 bgcolor=#999999>
             <input type=hidden name='QKID<%=   base2 + count %>' value='<%= data_QK.OBJID %>'>
             <input type=hidden name='STEXT<%=  base2 + count %>' value='<%= data_QK.STEXT %>'> 
             <input type=hidden name='D_EXIT<%= base2 + count %>' value='Y'>                           
          </td>
        </tr>
<%
        count++;
        }
       for( int i = temp_cur_size ; i < temp_min_size ; i ++ ) { 
         if( i == 0 ) { 
%>
        <tr>
          <td rowspan="<%= (temp_min_size * 2) - 1 %>" class=ct style="writing-mode:tb-rl" align="center"><%= data_QK.STEXT %></td>
          <td rowspan="<%= (temp_min_size * 2) - 1 %>" width=1 bgcolor=#999999></td>
<%
         }else {
%>            
        <tr>                
<%
         }        
%>                                        
          <td class=ct1 id="STEXT_Q_S<%= base2 + i %>">
              <input type=hidden name='SOBID<%= base2 + i %>' value=''>
          </td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc align=center id="ZLEVEL_S<%= base2 + i %>"></td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc id="STEXT_KEY_S<%= base2 + i %>"></td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td class=cc id="TLINE_S<%= base2 + i %>"></td>
          <td width=1 bgcolor=#999999><img src="<%= WebUtil.ImageURL %>jms/spacer.gif" width=1 height=1></td>
          <td align=center class=cc id="BUTTON_S<%= base2 + i %>"> 
             <a href="javascript:setCompetency('<%= data_QK.OBJID %>', '<%= base2 + i %>');"><img src="<%= WebUtil.ImageURL %>jms/btn_points.gif" border=0 hspace=3 alt="지정"></a>
          </td>          
        </tr>
        <tr>
          <td colspan=11 bgcolor=#999999>
             <input type=hidden name='QKID<%= base2 + i %>' value='<%= data_QK.OBJID %>'>
             <input type=hidden name='STEXT<%= base2 + i %>' value='<%= data_QK.STEXT %>'> 
             <input type=hidden name='D_EXIT<%= base2 + i %>' value='N'>              
          </td>
        </tr>            
<%
       }
//  common 의 경우       
    if ( l == 0 ){
%>    
        <tr height=30>
          <td colspan=11><a href="javascript:changeLine('1')"><img src="<%= WebUtil.ImageURL %>jms/btn_addCompetency01.gif" border=0 alt="Common Competency행 추가"></a></td>
        </tr>
        <tr height=2>
          <td colspan=11 bgcolor=#999999></td>
        </tr>	  
<%                
//  special 의 경우       
    } else {
%>    
        <tr height=30>
          <td colspan=11><a href="javascript:changeLine('2')"><img src="<%= WebUtil.ImageURL %>jms/btn_addCompetency02.gif" border=0 alt="Special Competency행 추가"></a></td>
        </tr>
<%                
     }
  }   
%>
        <tr height=30 valign=bottom>
           <td colspan=11 align=center>
             <a href="javascript:saveObject()"><img src="/web/images/jms/btn_save.gif" border=0 hspace=5 alt="저 장"></a>
           </td>
       </tr>
       
       </table>
     </td>
   </tr>       
</table>

</form>
<%@ include file="/web/common/commonEnd.jsp" %>
 