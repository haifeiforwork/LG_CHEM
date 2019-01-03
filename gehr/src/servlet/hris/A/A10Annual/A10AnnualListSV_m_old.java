package	servlet.hris.A.A10Annual;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.A.A10Annual.*;
import hris.A.A10Annual.rfc.*;

/**
 * A10AnnualListSV_m.java
 * 연봉계약을 조회 하고 연봉계약서를 볼수 있도록 하는 Class
 *[CSR ID:2703410] 웹취약성 최종 적용
 * @author 박영락   
 * @version 1.0, 2002/01/10
 */
public class A10AnnualListSV_m_old extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            HttpSession session = req.getSession(false);

            WebUserData user_m = WebUtil.getSessionMSSUser(req);
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String dest   = "";
            String jobid  = "";    // 2개의 값 page처리시 page, 상세조회시 - search
            String page   = "";    //paging 처리
            String imgURL = "";    //image경로 설정
            
//          @웹취약성 추가
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }

            jobid = box.get("jobid");
            page  = box.get("page");

            if( jobid.equals("") || page == null ) {
                jobid = "page";
            }
            
            if( page.equals("") || page == null ){ //페이지 설정
                page = "1";
            }
            A10AnnualData a10AnnualData = null;
            if ( user_m != null ) {
	            
	            Logger.debug.println(this, "[jobid] = "+jobid + " [user_m] : "+user_m.toString()+"  servlet Page : " + page);
	
	            if( jobid.equals("page") ){
	                Vector A10AnnualData_vt = ( new A10AnnualRFC() ).getAnnualList( user_m.empNo );//사번, 현재날짜
	//                    if ( A10AnnualData_vt.size() == 0 ) {
	//                        Logger.debug.println(this, "Data Not Found");
	//                        String msg = "msg004";
	//                        //String url = "history.back();";
	//                        req.setAttribute("msg", msg);
	//                        //req.setAttribute("url", url);
	//                        dest = WebUtil.JspURL+"common/caution.jsp";
	//                    } else {
	                req.setAttribute( "page", page );
	                req.setAttribute( "A10AnnualData_vt", A10AnnualData_vt );
	                dest = WebUtil.JspURL+"A/A10Annual/A10AnnualList_m.jsp";
	//                    }
	              //  }
	            } else if( jobid.equals("search") ) { //해당연도 데이타만을 받는다.
	                String ZYEAR = box.get("ZYEAR");
	                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.A.A10Annual.A10AnnualListSV_m?jobid=print&ZYEAR="+ZYEAR );
	                dest = WebUtil.JspURL+"common/printFrame.jsp";
	                Logger.debug.println(this, WebUtil.ServletURL+"hris.A.A10Annual.A10AnnualListSV_m?jobid=print&ZYEAR="+ZYEAR );
	
	            } else if( jobid.equals("print") ) {
	                String ZYEAR = box.get("ZYEAR");
	                a10AnnualData = new A10AnnualData();
	
	                Vector A10AnnualData_vt = ( new A10AnnualRFC() ).getAnnualList( user_m.empNo );//사번, 현재날짜
	                for( int i = A10AnnualData_vt.size()-1; i >=0 ; i-- ){
	                    A10AnnualData data = (A10AnnualData)A10AnnualData_vt.get(i);
	                    if( ZYEAR.equals( data.ZYEAR ) ){
	                        a10AnnualData = data;
	                    }
	                }
	                req.setAttribute( "a10AnnualData", a10AnnualData );
	                Logger.debug.println(this, a10AnnualData.toString() );
	                
	                if( (user_m.companyCode).equals("C100") ){ //test중
	                	if(  Integer.parseInt(a10AnnualData.ZYEAR) >2007  ) {
	                    	// [CSR ID:3006173] 임원 연봉계약서 Online화를 위한 시스템 구축 요청    
	                    	if(user.e_persk.equals("11")){
	                    		dest = WebUtil.JspURL+"A/A20AnnualBoard/C100/"+a10AnnualData.ZYEAR+"/A20AnnualDetail.jsp";
	                            imgURL = WebUtil.JspURL+"A/A20AnnualBoard/C100/"+a10AnnualData.ZYEAR+"/";
	                    	}else{
		                        dest = WebUtil.JspURL+"A/A10Annual/C100/"+a10AnnualData.ZYEAR+"/A10AnnualDetail.jsp";
		                        imgURL = WebUtil.JspURL+"A/A10Annual/C100/"+a10AnnualData.ZYEAR+"/";
	                    	}
	                    } else {
		                    dest = WebUtil.JspURL+"A/A10Annual/C100/A10AnnualDetail_m.jsp";
		                    imgURL = WebUtil.JspURL+"A/A10Annual/C100/";
	                    }
	                } else {
	                    if( (a10AnnualData.ZYEAR).equals("2001") ) {
	                        char compChar = (a10AnnualData.TRFGR).charAt(0);
	                        Logger.debug.println( this, "직급구분 첫문자 : "+compChar );
	                        if( compChar == 'Ⅰ' || compChar == 'Ⅱ' ){//LG석유 직급구분값.....
	                            dest = WebUtil.JspURL+"A/A10Annual/N100/A10AnnualDetail02_m.jsp";//간부
	                        } else {
	                            dest = WebUtil.JspURL+"A/A10Annual/N100/A10AnnualDetail_m.jsp";//사원
	                        }
	//                  2004년 연봉계약서의 경우 2004년 상세조회 리스트를 조회한다.
	                    } else if( (a10AnnualData.ZYEAR).equals("2004") ) {
	                        Vector A10AnnualDetail_vt = ( new A10AnnualRFC() ).getAnnualDetail( user_m.empNo );//사번, 현재날짜
	                        
	                        req.setAttribute( "A10AnnualDetail_vt", A10AnnualDetail_vt );
	                        
	                        dest = WebUtil.JspURL+"A/A10Annual/N100/A10AnnualDetail04_m.jsp";
	                    } else {
	                        dest = WebUtil.JspURL+"A/A10Annual/N100/A10AnnualDetail_m.jsp";
	                    }
	                    imgURL = WebUtil.JspURL+"A/A10Annual/N100/";
	                }
	                
	            }
            }else{
            	 req.setAttribute( "a10AnnualData", a10AnnualData );
            	 dest = WebUtil.JspURL+"A/A10Annual/C100/A10AnnualDetail_m.jsp";
                 imgURL = WebUtil.JspURL+"A/A10Annual/C100/";
            }
            req.setAttribute( "imgURL", imgURL );
            Logger.debug.println( this, " destributed = " + dest );
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}