<?xml version="1.0" encoding="utf-8" ?>
<%/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  :
/*   2Depth Name  :
/*   Program Name : EP My Menu
/*   Program ID   : epxmlmymenu.jsp
/*   Description  : EP My Menu를 위한 e-HR 메뉴 표시
/*   Note         : 없음
/*   Creation     : 2005-09-13  배민규
/*   Update       : 2005-10-31  1.LSA 포틀릿메뉴추가
                                2.사원인사정보의권한을조직장에서 조직장또는인사담당으로 변경함
/*
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ page import ="java.util.*" %>
<%@ page import ="java.lang.*" %>
<%@ page import = "com.sns.jdf.util.*"%>
<%@ page import = "hris.common.*"%>
<%!
    // 레벨 
    int depth = 0;
    // 문서 갯수
    int docCount = 0;
    // 메뉴 갯수
    int menuCount = 0;
    String strGubun = "";
    String strGubun2 = "";
    StringBuffer sb_authM = new StringBuffer();
    StringBuffer sb_authMH = new StringBuffer();

    public String writeMenu(Vector vc ,Vector va, String topCode ,String parentID) 
    {
        depth ++;
        StringBuffer sb = new StringBuffer();
        int order = 0;
        int leve1 = 0;
        int leve2 = 0;
        int txtLeng = 0;
        String prePERNR = "";
        for (int i = 0; i < vc.size(); i++) {
          hris.sys.MenuCodeData mncd   =   (hris.sys.MenuCodeData) vc.get(i);
          if (mncd.upMenuCode.equals(topCode)) {
            // 구분
            if ( mncd.etc == null ) { mncd.etc="N";}  
            if(mncd.etc.equals("Y")){
	            if (mncd.isDisplay) {
  	              String selfID = parentID;
                if(i==0){
                  //sb.append("<MyMenuResponse SystemCode=\"027\" xmlns=\"http://ehr.lgchem.com/images/ep/xml/MyMenu.xsd\">");
                  sb.append("<MyMenuResponse SystemCode=\"027\" xmlns=\"http://temp.openuri.org/com/lgchem/ep/cbs/p13n/entitlement/data/entitlement.xsd\">");
             
                  ////10.31 포틀릿메뉴추가START
                  //sb.append("<MenuGroupInfo Title=\""+"Portlet"+"\">");
                  //  sb.append("<MenuInfo Title=\""+"부서휴가사용율"+"\" Url=\""+"/ep/leaveResult.jsp"+"\" Desc=\"e-HR "+"부서휴가사용율"+"\">");
                  //  for(int k=0; k<va.size(); k++){
                  //      EpMyMenuData data = (EpMyMenuData)va.get(k);
                  //      if(data.ZAUTH.equals("M")){
                  //        sb_authM.append("<UserInfo>");
                  //        sb_authM.append("<UserSabn>"+data.PERNR+"</UserSabn>");
                  //        sb_authM.append("</UserInfo>");
                  //      }
                  //  }
                  //  sb.append(sb_authM);
                  //  sb.append("</MenuInfo>");                     
                  //  sb.append("<MenuInfo Title=\""+"사원인사정보검색"+"\" Url=\""+"/ep/memberSearch.jsp"+"\" Desc=\"e-HR "+"사원인사정보검색"+"\">");
                  //  prePERNR = "";
                  //  for(int k=0; k<va.size(); k++){
                  //      EpMyMenuData data = (EpMyMenuData)va.get(k);
                  //      if((!data.PERNR.equals(prePERNR)) && (data.ZAUTH.equals("M")||data.ZAUTH.equals("H")) ){ //M:조직장,H:인사담당
                  //        sb_authMH.append("<UserInfo>");
                  //        sb_authMH.append("<UserSabn>"+data.PERNR+"</UserSabn>");
                  //        sb_authMH.append("</UserInfo>");
                  //        prePERNR = data.PERNR;
                  //      }
                  //  }
                  //  sb.append(sb_authMH);
                  //  sb.append("</MenuInfo>");                    
                  //  sb.append("<MenuInfo Title=\""+"신청/결재진행현황"+"\" Url=\""+"/ep/AStsADoc.jsp"+"\" Desc=\"e-HR "+"신청/결재진행현황"+"\">");
                  //    sb.append("<RoleInfo>");
                  //      sb.append("<DeptCode>all</DeptCode>");
                  //      sb.append("<JobCode>all</JobCode>");
                  //      sb.append("<DutyCode>all</DutyCode>");
                  //    sb.append("</RoleInfo>");
                  //  sb.append("</MenuInfo>");
                  //sb.append("</MenuGroupInfo>");
                  ////10.31 포틀릿메뉴추가END

                  
                }

               //sb.append(topCode+"*"+strGubun+"*"+strGubun2+"*"+parentID+"*"+mncd.menuCode);
	              if(depth==1&&mncd.menuClsf.equals("01")){
	                leve2++;
	                if(leve2>1 ){
                    strGubun = mncd.menuCode;
                  }
                  sb.append("<MenuGroupInfo Title=\""+mncd.prnMenu.substring(mncd.prnMenu.indexOf("'>")+2,mncd.prnMenu.indexOf("</"))+"\">");
	              }else if(depth==2&&mncd.menuClsf.equals("01")){
                  sb.append("<MenuGroupInfo Title=\""+mncd.prnMenu+"\">");
	              }else if(mncd.menuClsf.equals("01")){
                  sb.append("<MenuGroupInfo Title=\""+mncd.prnMenu+"\">");
	              }
	              sb.append(writeMenu(vc ,va, mncd.menuCode ,selfID));
                if(mncd.menuClsf.equals("02")) {
                  sb.append("<MenuInfo Title=\""+mncd.prnMenu+"\" Url=\""+mncd.pgDetail.realPath+"\" Desc=\"e-HR "+mncd.prnMenu+"\">");

                  if(strGubun.equals("")){
                    sb.append("<RoleInfo>");
                    sb.append("<DeptCode>all</DeptCode>");
                    sb.append("<JobCode>all</JobCode>");
                    sb.append("<DutyCode>all</DutyCode>");
                    sb.append("</RoleInfo>");
                  } else if(strGubun.equals("1002")){ //부서인사정보
                    //조직통계1093-권한M:조직장
                    if (topCode.equals("1094")||topCode.equals("1137")||topCode.equals("1138")||topCode.equals("1139")||topCode.equals("1140")||topCode.equals("1141")) { 
                       for(int k=0; k<va.size(); k++){
                         EpMyMenuData data = (EpMyMenuData)va.get(k);
                         if(data.ZAUTH.equals("M")){
                           sb.append("<UserInfo>");
                           sb.append("<UserSabn>"+data.PERNR+"</UserSabn>");
                           sb.append("</UserInfo>");
                         }
                       }  
                       //sb.append(sb_authM);
                    }   
                    else { //사원인사정보1008-권한M:조직장또는H:인사담당 
                       sb.append(sb_authMH);
                    }
                  }

                  sb.append("</MenuInfo>");
                }

                if(depth==1&&mncd.menuClsf.equals("01")){
                  sb.append("</MenuGroupInfo>");
                  if(i==1&&mncd.menuClsf.equals("01")) {
                    sb.append("</MyMenuResponse>");
                  }
                }else if(depth==2&&mncd.menuClsf.equals("01")){
                   sb.append("</MenuGroupInfo>");
                }else if(mncd.menuClsf.equals("01")){
                   sb.append("</MenuGroupInfo>");
                }
//                   sb.append(mncd.etc);
	            } // end if
            }
         } // end if
      } // end for
      
      depth --;
      return sb.toString();
    }
%>
<%
    Vector vcOMenuCodeData = (Vector)request.getAttribute("vcMeneCodeData");
    Vector epMyMenu_vt = (Vector)request.getAttribute("epMyMenu_vt");
%>
<%=writeMenu(vcOMenuCodeData ,epMyMenu_vt, "1000" ,"")%>
