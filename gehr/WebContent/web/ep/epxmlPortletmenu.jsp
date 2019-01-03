<?xml version="1.0" encoding="utf-8" ?>
<%/******************************************************************************/
/*
/*   System Name  : e-HR
/*   1Depth Name  :
/*   2Depth Name  :
/*   Program Name : EP My Menu
/*   Program ID   : epxmlPortletmenu.jsp
/*   Description  : EP portlet menu 의 사번정보 
/*   Note         : 없음
/*   Creation     : 2005-11-17  lsa
/*   Update       :  
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
        //int order = 0;
        //int leve1 = 0;
        //int leve2 = 0;
        //int txtLeng = 0;
        String prePERNR = "";
        sb.append("<entitlementInfo xmlns=\"http://temp.openuri.org/com/lgchem/ep/cbs/p13n/entitlement/data/entitlement.xsd\">\n");
        sb.append("<GroupInfo GroupName=\"TL\">");
        sb.append("<UserInfo>");
        prePERNR = "";
        for(int k=0; k<va.size(); k++){
             EpMyMenuData data = (EpMyMenuData)va.get(k);
             if((!data.PERNR.equals(prePERNR)) && (data.ZAUTH.equals("M")||data.ZAUTH.equals("H")||data.ZAUTH.equals("G")) ){ //M:조직장,H:인사담당,G:Global인재육성
                sb.append("<UserSabn>"+data.PERNR+"</UserSabn>");
                prePERNR = data.PERNR;
            }
        }
        ////sb.append(sb_authMH);                  
        sb.append("</UserInfo>");
        sb.append("<PortletInfo>");
        sb.append("<Portlet>");
        sb.append("<PortletLabel>"+"Portlet_emplsearch"+"</PortletLabel>");
        sb.append("<PortletTitle>"+"사원인사정보검색"+"</PortletTitle>");
        sb.append("</Portlet>");                  
        sb.append("</PortletInfo>"); 
        sb.append("</GroupInfo>"); 
        sb.append("</entitlementInfo>"); 

      //depth --;
      return sb.toString();
    }
%>
<%
    Vector vcOMenuCodeData = (Vector)request.getAttribute("vcMeneCodeData");
    Vector epMyMenu_vt = (Vector)request.getAttribute("epPortletMenu_vt");
%>
<%=writeMenu(vcOMenuCodeData ,epMyMenu_vt, "1000" ,"")%>