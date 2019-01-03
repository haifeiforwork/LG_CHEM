/********************************************************************************/
/* 
/*   System Name  : e-HR
/*   1Depth Name  :
/*   2Depth Name  :
/*   Program Name : EP 교육 안내 Portlet
/*   Program ID   : C02EpCurriInfoListSV
/*   Description  : EP로부터의 교육 안내 portlet 처리 Servlet
/*   Note         : 없음
/*   Creation     : 2005-08-31  배민규
/*   Update       : 2005-11-03  lsa ehr로그인하지 않은 경우에 에러 발생으로 인해 L84수정,L109-128추가
/*                  2005-11-29  @v1.2 lsa page error 처리
/********************************************************************************/
package servlet.hris.C.C02Curri;

import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.SortUtil;
import com.sns.jdf.util.WebUtil;
import hris.C.C02Curri.C02CurriCheckData;
import hris.C.C02Curri.C02CurriData;
import hris.C.C02Curri.C02CurriInfoData;
import hris.C.C02Curri.rfc.*;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;
public class C02EpCurriInfoListSV extends EHRBaseServlet {
    
    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            performTask(req, res);
        }catch(GeneralException e){
            throw new GeneralException (e);
        }
    }

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            
            
            
            HttpSession session = req.getSession(false);
            Config conf           = new Configuration();
			      Box box = WebUtil.getBox(req);
			      //String SSNO				= box.get("SSNO");
			      WebUserData user = new WebUserData() ;
			      String dest = "";
            
            if(session != null){
            	 user = ( WebUserData ) session.getAttribute( "user" ) ;
			      	 if( user == null ) user = new WebUserData() ;
			      
			      }
            String jobid = "";    
			      jobid = box.get("jobid");
			      
			      if( jobid.equals("") ){
			      	 jobid = "first";
			      }
			      String page  = "";  //paging 처리
			      //String originEmpNo = DataUtil.convertEmpNo(DataUtil.decodeEmpNo(SSNO));
			      String SSNO = "";
			      SSNO = DataUtil.convertEmpNo(DataUtil.decodeEmpNo(SSNO));
			      String originEmpNo = (String)session.getAttribute("SYSTEM_ID"); 
                  
            //처리 후 돌아 갈 페이지
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            
            //최초로그인 인증없는경우         
            
            Logger.debug.println(this, "@@@@@originEmpNo : " + originEmpNo);
            Logger.debug.println(this, "@@@@@SSNO : " + SSNO);
            
            if((session == null || originEmpNo == null || user == null  || user.empNo == null) && !jobid.equals("build")) {
			      //if((session == null || originEmpNo == null || user == null || user.empNo.equals("00000000") || !user.empNo.equals(originEmpNo)) && !jobid.equals("build")) {
			                      
			      	  PersonInfoRFC numfunc        = new PersonInfoRFC();
			      	  PersonData phonenumdata;
			      	  phonenumdata = (PersonData)numfunc.getPersonInfo(originEmpNo);
			      	  if( phonenumdata.E_BUKRS==null|| phonenumdata.E_BUKRS.equals("") ) {
			      	  	  throw new GeneralException("재접속하여 주세요.");
			      	  } else {
			      	  
			      	      if( session.getAttribute("user") != null )  user = ( WebUserData ) session.getAttribute( "user" ) ;

			      	      user.empNo			      = originEmpNo;
			              user.login_stat       = "Y";
			      	  	  user.e_dat03          = phonenumdata.E_DAT02 ;
			      	  	  user.loginPlace       = "EP";
			      	  	  user.SSNO			   = originEmpNo;
			      	  	  DataUtil.fixNull(user);
			      	  	  session = req.getSession(true);
			      	  	  //Config conf           = new Configuration();
			      	  	  int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
			      	  	  session.setMaxInactiveInterval(maxSessionTime);
			      	  	  session.setAttribute("user",user);
			      	  	  dest = WebUtil.ServletURL+"hris.C.C02Curri.C02EpCurriInfoListSV";
			      	  }
			      }else if((user.empNo.equals("00000000") || !user.empNo.equals(originEmpNo)) && !jobid.equals("build")) {
			      	  PersonInfoRFC numfunc        = new PersonInfoRFC();
			      	  PersonData phonenumdata;
			      	  phonenumdata = (PersonData)numfunc.getPersonInfo(originEmpNo);
			      	  if( phonenumdata.E_BUKRS==null|| phonenumdata.E_BUKRS.equals("") ) {
			      	  	  throw new GeneralException("사원번호를 확인하여 주십시오.");
			      	  } else {
			      	      user.empNo			   = originEmpNo;
			      	      user.login_stat       = "Y";
			      	  	  user.e_dat03          = phonenumdata.E_DAT02 ;
			      	  	  user.loginPlace       = "EP";
			      	  	  user.SSNO			   = originEmpNo;
			      	  	  DataUtil.fixNull(user);
			      	  	  session = req.getSession(true);
			      	  	  //Config conf           = new Configuration();
			      	  	  int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
			      	  	  session.setMaxInactiveInterval(maxSessionTime);
			      	  	  session.setAttribute("user",user);
			      	  	  dest = WebUtil.ServletURL+"hris.C.C02Curri.C02EpCurriInfoListSV";
			      	  }
			      } else {
			      
			      	  page  = box.get("page");
			      	  Logger.debug.println(this, "servlet Page : " + page);
			      	  if( page.equals("") || page == null ){
			      	  	  page = "1";
			      	  }
			      	  
			      	  C02CurriInfoData key = new C02CurriInfoData();
			      	  Vector C02CurriInfoData_vt = new Vector();
			      	  
			      	  box.copyToEntity(key);
                
			      	  if ( jobid.equals("first" ) ){
			      	  	  req.setAttribute("C02CurriInfoData", key);
			      	  	  req.setAttribute("jobid", jobid);
			      	  	  //Logger.debug.println(this, "##1##KEY = " + key);
			      	  	  //Logger.debug.println(this, "##1##C02CurriInfoData_vt = " + C02CurriInfoData_vt);
			      	  	  dest = WebUtil.JspURL+"C/C02Curri/C02EpCurriSearchTop.jsp";
			      	  } else if( jobid.equals("search") ){    
			      	  	
					          String I_FDATE       = box.get("I_FDATE");         //@v1.2 paging add
					          String I_GROUP       = box.get("I_GROUP");         //@v1.2 paging add
					          String I_LOCATE      = box.get("I_LOCATE");        //@v1.2 paging add
					          String I_BUSEO       = box.get("I_BUSEO");         //@v1.2 paging add
					          String I_DESCRIPTION = box.get("I_DESCRIPTION");   //@v1.2 paging add
								      	  	
			      	  	  C02CurriInfoListRFC func = new C02CurriInfoListRFC();
			      	  	  C02CurriInfoData_vt = func.getCurriInfoList(key);
			      	  	  C02CurriInfoData_vt = SortUtil.sort( C02CurriInfoData_vt , "GWAID,BEGDA", "desc,asc");
			      	  	  req.setAttribute("C02CurriInfoData", key);
			      	  	  req.setAttribute("C02CurriInfoData_vt", C02CurriInfoData_vt);
			      	  	  req.setAttribute("jobid"        , jobid);
			      	  	  req.setAttribute("page"         , page);             //@v1.2 paging add 
			      	  	  req.setAttribute("I_FDATE"      , I_FDATE      );    //@v1.2 paging add 
			      	  	  req.setAttribute("I_GROUP"      , I_GROUP      );    //@v1.2 paging add 
			      	  	  req.setAttribute("I_LOCATE"     , I_LOCATE     );    //@v1.2 paging add 
			      	  	  req.setAttribute("I_BUSEO"      , I_BUSEO      );    //@v1.2 paging add 
			      	  	  req.setAttribute("I_DESCRIPTION", I_DESCRIPTION);    //@v1.2 paging add 
			      	  	  req.setAttribute("jobid", jobid);
			      	  	  //Logger.debug.println(this, "##2##KEY = " + key);
			      	  	  //Logger.debug.println(this, "##2##C02CurriInfoData_vt = " + C02CurriInfoData_vt);
			      	  	  dest = WebUtil.JspURL+"C/C02Curri/C02EpCurriSearchTop.jsp";
			      	  } else if( jobid.equals("detail")){
			      	  	  req.setAttribute("C02CurriInfoKey", key);
                    
			      	  	  C02CurriInfoData data = new C02CurriInfoData();
			      	  	  box.copyToEntity(data);
                    
			      	  	  C02CurriInfoRFC   func1 = new C02CurriInfoRFC();
			      	  	  Vector            ret   = func1.getCurriInfo( data.GWAID, data.CHAID );
			      	  	  
			      	  	  Vector C02CurriEventInfoData_vt = (Vector)ret.get(0);
			      	  	  Vector C02CurriEventData_vt     = (Vector)ret.get(1);
			      	  	  Vector C02CurriData_Course_vt   = (Vector)ret.get(2);//선이수과정
			      	  	  Vector C02CurriData_Get_vt      = (Vector)ret.get(3);
			      	  	  Vector C02CurriData_Grint_vt    = (Vector)ret.get(4);//선수자격요건
			      	  	  Vector checkPre_vt              = new Vector();
			      	  	  Vector checkPreChk_vt           = new Vector();
			      	  	  
			      	  	  for( int i = 0; i < C02CurriData_Course_vt.size(); i++ ){
			      	  	  	C02CurriCheckData chkData = new C02CurriCheckData();
			      	  	  	C02CurriData  infoData    = (C02CurriData)C02CurriData_Course_vt.get(i);
			      	  	  	chkData.OBJID             = infoData.PREID;
			      	  	  	checkPre_vt.addElement( chkData );
			      	  	  }
			      	  	  
			      	  	  C02CurriPreRFC    func2         = new C02CurriPreRFC();//선이수과정CHECK
			      	  	  Vector C02CurriCheck_Pre_vt     = func2.getCurriPreviouse( user.empNo, checkPre_vt );
			      	  	  
			      	  	  for( int i = 0; i < C02CurriData_Grint_vt.size(); i++ ){
			      	  	  	C02CurriCheckData chkData = new C02CurriCheckData();
			      	  	  	C02CurriData  infoData    = (C02CurriData)C02CurriData_Grint_vt.get(i);
			      	  	  	chkData.OBJID             = infoData.PREID;
			      	  	  	chkData.CHARA             = infoData.CHARA;
			      	  	  	checkPreChk_vt.addElement( chkData );
			      	  	  }
			      	  	  C02CurriPreChkRFC func3         = new C02CurriPreChkRFC();//선수자격요건CHECK
			      	  	  Vector C02CurriCheck_PreChk_vt  = func3.getCurriPreCheck( user.empNo, checkPreChk_vt );
                    
			      	  	  req.setAttribute("C02CurriInfoData", data);
			      	  	  req.setAttribute("C02CurriEventInfoData_vt", C02CurriEventInfoData_vt);
			      	  	  req.setAttribute("C02CurriEventData_vt", C02CurriEventData_vt);
			      	  	  req.setAttribute("C02CurriData_Course_vt", C02CurriData_Course_vt);
			      	  	  req.setAttribute("C02CurriData_Grint_vt", C02CurriData_Grint_vt);
			      	  	  req.setAttribute("C02CurriData_Get_vt", C02CurriData_Get_vt);
			      	  	  
			      	  	  req.setAttribute("C02CurriCheck_Pre_vt", C02CurriCheck_Pre_vt);
			      	  	  req.setAttribute("C02CurriCheck_PreChk_vt", C02CurriCheck_PreChk_vt);   
			      	  	  req.setAttribute("jobid", jobid);
			      	  	  //Logger.debug.println(this, "##3##KEY = " + key);
			      	  	  //Logger.debug.println(this, "##3##data = " + data);
			      	  	  //Logger.debug.println(this, "##3##C02CurriEventInfoData_vt = " + C02CurriEventInfoData_vt);
			      	  	  //Logger.debug.println(this, "##3##C02CurriEventData_vt = " + C02CurriEventData_vt);
			      	  	  //Logger.debug.println(this, "##3##C02CurriData_Course_vt = " + C02CurriData_Course_vt);
			      	  	  //Logger.debug.println(this, "##3##C02CurriData_Grint_vt = " + C02CurriData_Grint_vt);
			      	  	  //Logger.debug.println(this, "##3##C02CurriData_Get_vt = " + C02CurriData_Get_vt);
			      	  	  //Logger.debug.println(this, "##3##C02CurriCheck_Pre_vt = " + C02CurriCheck_Pre_vt);
			      	  	  //Logger.debug.println(this, "##3##C02CurriCheck_PreChk_vt = " + C02CurriCheck_PreChk_vt);
			      	  	  dest = WebUtil.JspURL+"C/C02Curri/C02EpCurriNotice.jsp";
			      	  } else if( jobid.equals("build")){
			      	  		//Connection conn = null;
			      	  		session = req.getSession(false);
                
			      	  		boolean isCommit = false;
			      	  		PersonInfoRFC personInfoRFC        = new PersonInfoRFC();
			      	  		PersonData personData;

						  personData = personInfoRFC.getPersonInfo(originEmpNo, "X");
                
			      	  		if( personData.E_BUKRS==null|| personData.E_BUKRS.equals("") ) {
			      	  			  throw new GeneralException("사원번호를 확인하여 주십시오.");
			      	  		} else {
			      	  			  user.empNo            = originEmpNo;
			      	  			  //Config conf           = new Configuration();
			      	  			  user.clientNo         = conf.get("com.sns.jdf.sap.SAP_CLIENT");
			      	  			  user.login_stat       = "Y";

								personInfoRFC.setSessionUserData(personData, user);
                                WebUtil.setLang(WebUtil.getLangFromCookie(req), req, user);
			      	  			  user.loginPlace       = "EPortlet";
			      	  			  

			      	  			  // Logger.debug.println(this ,user);
			      	  			  // 사용자 권한 그룹 설정
			      	  			  // user.e_authorization = "ALL";
			      	  			  //conn = DBUtil.getTransaction("HRIS");
			      	  			  //user.user_group =   (new CommonCodeDB(conn)).getAuthGroup(user.e_authorization);
			      	  			  
                                                          //@v1.0 메뉴관련 db를 oracle에서 sap로 이관
                                                          /*SysAuthGroupRFC rfc_Auth         = new SysAuthGroupRFC();
                                                          user.user_group = rfc_Auth.getAuthGroup(user.e_authorization);*/
                                                          			      	  			  
			      	  			  isCommit = true;
                        
			      	  			  DataUtil.fixNull(user);
			      	  			  session = req.getSession(true);
                        
			      	  			  int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
			      	  			  session.setMaxInactiveInterval(maxSessionTime);
			      	  			  session.setAttribute("user",user);
			      	  		}
			      	  	
			      	  	  req.setAttribute("C02CurriInfoKey", key);
		                req.setAttribute("PERNR" , user.empNo );
			      	  	
			      	  	  C02CurriInfoData data = new C02CurriInfoData();
			      	  	  C02CurriInfoData_vt = new Vector();
			      	  	  box.copyToEntity(data);
                    
			      	  	  C02CurriPersonRFC func = new C02CurriPersonRFC();
			      	  	  Vector C02CurriPersonData_vt = func.getCurriPerson( user.empNo );
			      	  	  //Logger.debug.println(this, data.toString() );
			      	  	  //Logger.debug.println(this, C02CurriPersonData_vt.toString() );
			      	  	  
			      	  	  // 신청하려는 교육과 기간이 중복되는 교육이 있는지를 체크한다.
			      	  	  C02CurriGetFlagRFC func_check = new C02CurriGetFlagRFC();
			      	  	  String checkFlag  = func_check.check( user.empNo, data.BEGDA, data.ENDDA, data.CHAID );
			      	  	  
			      	  	  //Logger.debug.println(this, "checkFlag = " + checkFlag );
			      	  	  
			      	  	  req.setAttribute("checkFlag", checkFlag);
			      	  	  // 신청하려는 교육과 기간이 중복되는 교육이 있는지를 체크한다.
			      	  	  
			      	  	  req.setAttribute("C02CurriInfoData", data);
			      	  	  req.setAttribute("C02CurriPersonData_vt", C02CurriPersonData_vt);
			      	  	  //Logger.debug.println(this, "##4##KEY = " + key);
			      	  	  //Logger.debug.println(this, "##4##data = " + data);
			      	  	  
			      	  	  //String detailPage = WebUtil.ServletURL+"hris.C.C02Curri.C02CurriBuildSV";
			      	  	  //req.setAttribute("detailPage",detailPage);
			      	  	  //Logger.debug.println(this, "##4##detailPage = " + detailPage);
			      	  	  req.setAttribute("jobid", "");
			      	  	  dest = WebUtil.JspURL+"C/C02Curri/C02CurriBuild.jsp";
			      	  }
			      	  //req.setAttribute("page", page);
			      	  //Logger.debug.println(this, "####jobid = " + jobid);
			      	  //Logger.debug.println(this, "####page = " + page);
			      }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
        } catch(Exception e) {
            throw new GeneralException(e);
            //String dest = "http://portal.lgchem.com";
            //req.setAttribute("page", "1");
            //printJspPage(req, res, dest);
            
        } finally {
            //DBUtil.close(con);
        }
    }
}