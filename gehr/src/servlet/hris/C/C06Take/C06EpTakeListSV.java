/********************************************************************************/
/* 
/*   System Name  : e-HR
/*   1Depth Name  :
/*   2Depth Name  :
/*   Program Name : EP 교육 Portlet
/*   Program ID   : C06EpTakeListSV
/*   Description  : EP로부터의 교육관련 portlet 처리 Servlet
/*   Note         : 없음
/*   Creation     : 2005-08-30  배민규
/*   Update       : 2005-11-03  lsa ehr로그인하지 않은 경우에 에러 발생으로 인해 L80수정,L101-121추가
/*                              1.SSNO의GETPARAMETER방식에서 세션의 SYSTEM_ID GET방식으로변경
/*                              2.로그인하지 않은 경우 에러처리
/********************************************************************************/
package servlet.hris.C.C06Take;

import com.sns.jdf.*;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.SortUtil;
import com.sns.jdf.util.WebUtil;
import hris.C.C02Curri.C02CurriInfoData;
import hris.C.C02Curri.rfc.C02CurriInfoRFC;
import hris.C.C06Take.rfc.C06TakeRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

public class C06EpTakeListSV extends EHRBaseServlet {

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
            HttpSession session = req.getSession(true);
            
			      Box box = WebUtil.getBox(req);
			      //String SSNO				= box.get("SSNO");
			      WebUserData user = new WebUserData() ;
			      String dest = "";
            
			      if(session != null){
			      	user = ( WebUserData ) session.getAttribute( "user" ) ;
			      }
			      //String originEmpNo = DataUtil.convertEmpNo(DataUtil.decodeEmpNo(SSNO));
			      String originEmpNo = (String)session.getAttribute("SYSTEM_ID"); 
            Logger.info.println(this , "@@@originEmpNo = " + box);
			      //Logger.info.println(this , "user = " + user);
			      //Logger.info.println(this , "session = " + session);
			      
			      //if(session == null || user == null || user.empNo.equals("00000000") || !user.empNo.equals(originEmpNo)) {
			      if(session == null || user == null || user.empNo==null) {
			      	  Logger.info.println(this , "######## 1 ####### ");
			      	  PersonInfoRFC numfunc        = new PersonInfoRFC();
			      	  PersonData phonenumdata;
			      	  phonenumdata = (PersonData)numfunc.getPersonInfo(originEmpNo);
			      	  if( phonenumdata.E_BUKRS==null|| phonenumdata.E_BUKRS.equals("") ) {
			      	  	  throw new GeneralException("재 접속하여 주세요.");
			      	  } else {
			      	  	  user.empNo			   = originEmpNo;
			      	      user.login_stat       = "Y";
			      	      user.e_dat03          = phonenumdata.E_DAT02 ;
			      	  	  user.loginPlace       = "EP";
			      	  	  user.SSNO			   = originEmpNo;
			      	  	  DataUtil.fixNull(user);
			      	  	  session = req.getSession(true);
			      	  	  Config conf           = new Configuration();
			      	  	  int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
			      	  	  session.setMaxInactiveInterval(maxSessionTime);
			      	  	  session.setAttribute("user",user);
			      	  	  dest = WebUtil.ServletURL+"hris.C.C06Take.C06EpTakeListSV";
			      	  }
			      }else if(user.empNo.equals("00000000") || !user.empNo.equals(originEmpNo)) {
			      	  Logger.info.println(this , "######## 2 ####### ");
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
			      	  	  Config conf           = new Configuration();
			      	  	  int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
			      	  	  session.setMaxInactiveInterval(maxSessionTime);
			      	  	  session.setAttribute("user",user);
			      	  	  dest = WebUtil.ServletURL+"hris.C.C06Take.C06EpTakeListSV";
			      	  }
			      } else {
			      	  Logger.info.println(this , "######## 2 ####### ");
                
			      	  String jobid = "";
			      	  String page  = "";
                
			      	  jobid = box.get("jobid");
                
			      	  if( jobid.equals("") ){
			      	    	jobid = "first";
			      	  }
			      	  Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
                
			      	  C06TakeRFC  func1  = new C06TakeRFC(); 
			      	  				
			      	  if(jobid.equals("first")) { 
			      	  	  String year       = DataUtil.getCurrentYear();
			      	  	  Vector total_vt   = func1.getTakeList(user.empNo, year);
			      	  	  
			      	  	  Vector c06Take_vt = (Vector)total_vt.get(0);
			      	  	  Vector p_edu_vt   = (Vector)total_vt.get(1);
			      	  	  						   
			      	  	  c06Take_vt = SortUtil.sort( c06Take_vt, "GBEGDA", "desc");
			      	  	  p_edu_vt   = SortUtil.sort( p_edu_vt,   "BEGDA",  "desc");
			      	  	  
			      	  	  Logger.debug.println(this,"c06Take_vt"+c06Take_vt.toString());
			      	  	  Logger.debug.println(this,"p_edu_vt"+p_edu_vt.toString());
			      	  	  Logger.debug.println(this,"jobid"+jobid);
			      	  	  Logger.debug.println(this,"year"+year);
			      	  	  Logger.debug.println(this,"page"+page);
			      	  	  
			      	  	  req.setAttribute("jobid", jobid);
			      	  	  req.setAttribute("year", year);
			      	  	  req.setAttribute("page", page);
			      	  	  req.setAttribute("c06Take_vt", c06Take_vt);
			      	  	  req.setAttribute("p_edu_vt"  , p_edu_vt);
			      	  	  
			      	  	  dest = WebUtil.JspURL+"C/C06Take/C06EpTakeList.jsp";
			      	  	  Logger.info.println(this , "######## 3 ####### ");
			      	  }else if( jobid.equals("search")){
			      	  	  page  = box.get("page");
			      	  	  String reqyear    = Integer.toString(box.getInt("YEAR"));
			      	  	  Vector total_vt   = func1.getTakeList(user.empNo, reqyear);
			      	  	  
			      	  	  Vector c06Take_vt = (Vector)total_vt.get(0);
			      	  	  Vector p_edu_vt   = (Vector)total_vt.get(1);
			      	  	  
			      	  	  c06Take_vt = SortUtil.sort( c06Take_vt, "GBEGDA", "desc");
			      	  	  p_edu_vt   = SortUtil.sort( p_edu_vt,   "BEGDA",  "desc");
			      	  	  
			      	  	  Logger.debug.println(this,"c06Take_vt"+c06Take_vt.toString());
			      	  	  Logger.debug.println(this,"p_edu_vt"+p_edu_vt.toString());
			      	  	  
			      	  	  req.setAttribute("jobid", jobid);
			      	  	  req.setAttribute("year", reqyear);
			      	  	  req.setAttribute("page", page);
			      	  	  req.setAttribute("c06Take_vt", c06Take_vt);
			      	  	  req.setAttribute("p_edu_vt"  , p_edu_vt);
                    
			      	  	  dest = WebUtil.JspURL+"C/C06Take/C06EpTakeList.jsp";
			      	   } else if( jobid.equals("detail") ) {
			      	  	  C02CurriInfoData data = new C02CurriInfoData();
			      	  	  box.copyToEntity(data);
                    
			      	  	  C02CurriInfoRFC   func = new C02CurriInfoRFC();
			      	  	  Vector            ret   = func.getCurriInfo( data.GWAID, data.CHAID );
			      	  	    
			      	  	  Vector C02CurriEventInfoData_vt = (Vector)ret.get(0);
			      	  	  Vector C02CurriEventData_vt     = (Vector)ret.get(1);
			      	  	  Vector C02CurriData_Course_vt   = (Vector)ret.get(2);
			      	  	  Vector C02CurriData_Grint_vt    = (Vector)ret.get(3);
			      	  	  Vector C02CurriData_Get_vt      = (Vector)ret.get(4);
			      	      
			      	  	  req.setAttribute("C02CurriInfoData", data);
			      	  	  req.setAttribute("C02CurriEventInfoData_vt", C02CurriEventInfoData_vt);
			      	  	  req.setAttribute("C02CurriEventData_vt", C02CurriEventData_vt);
			      	  	  req.setAttribute("C02CurriData_Course_vt", C02CurriData_Course_vt);
			      	  	  req.setAttribute("C02CurriData_Grint_vt", C02CurriData_Grint_vt);
			      	  	  req.setAttribute("C02CurriData_Get_vt", C02CurriData_Get_vt);
	                  
			      	  	  dest = WebUtil.JspURL+"C/C06Take/C06EpTakeDetail.jsp";
			      	  } else {
			      	      throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
			      	  }
			      }
            printJspPage(req, res, dest);
            Logger.debug.println(this, " destributed = " + dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        } 
    }
}
