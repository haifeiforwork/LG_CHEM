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
 * A10AnnualViewSV.java
 * 당해년도 연봉을 조회 할 수 있도록 하는 Class
 *
 * @author 박영락   
 * @version 1.0, 2002/01/10
 */
public class A10AnnualViewSV_m extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            WebUserData user = WebUtil.getSessionUser(req);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);

            String dest   = "";
            
//          @웹취약성 추가
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }

            Logger.debug.println(this, " [user] : "+user.toString() );

            String ZYEAR = DataUtil.getCurrentYear(); //플레그 추가
            int    year  = Integer.parseInt(ZYEAR);

//          2003.01.02. - 03월 이전일경우 작년 연봉계약서를 보여준다.
            String ZMONTH = DataUtil.getCurrentMonth();
            int    month  = Integer.parseInt(ZMONTH);
            if( month < 3 ) {
                year = year - 1;
            }
            
            if ( user_m != null ) {
	            Vector A10AnnualData_vt = ( new A10AnnualRFC() ).getAnnualList( user_m.empNo );//사번, 현재날짜
	            if ( A10AnnualData_vt.size() == 0 ) {
	                Logger.debug.println(this, "Data Not Found");
	                String msg = "msg004";
	                req.setAttribute("msg", msg);
	                dest = WebUtil.JspURL+"common/caution.jsp";
	            } else {
	                //해당연도의 연봉이 있는지 없는지를 검색
	//                for( int i = 0; i < A10AnnualData_vt.size(); i++ ){
	//                  2003.04.15 - 가장 최근의 연봉을 조회한다.
	                    A10AnnualData data = (A10AnnualData)A10AnnualData_vt.get(0);
	                    year = Integer.parseInt(data.ZYEAR);
	//                if( year == Integer.parseInt( data.ZYEAR ) ){
	
	//                        if( (data.BETRG).equals("0.0") ){
	//                            year = year - 1;
	//                        }
	//                    }
	//                }
	                ZYEAR = year+"";
	                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.A.A10Annual.A10AnnualListSV_m?jobid=print&ZYEAR="+ZYEAR );
	                req.setAttribute( "isPopUp", "false" );
	                dest = WebUtil.JspURL+"common/printFrame.jsp";
	                Logger.debug.println(this, WebUtil.ServletURL+"hris.A.A10Annual.A10AnnualListSV_m?jobid=print&ZYEAR="+ZYEAR );
	            }
            }else{
            	 req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.A.A10Annual.A10AnnualListSV_m?jobid=print&ZYEAR="+ZYEAR );
                 req.setAttribute( "isPopUp", "false" );
                 dest = WebUtil.JspURL+"common/printFrame.jsp";
            }
            Logger.debug.println( this, " destributed = " + dest );
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}