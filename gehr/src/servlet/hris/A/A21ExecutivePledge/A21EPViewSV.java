package	servlet.hris.A.A21ExecutivePledge;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A10Annual.A10AnnualData;
import hris.A.A10Annual.rfc.A10AnnualRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

/**
 * A21EPViewSV.java
 * 임원들의 서약서를 조회 할 수 있도록 하는 Class
 *
 * @author 이지은
 * @version 1.0, 2016-03-09      [CSR ID:3006173] 임원 연봉계약서 Online화를 위한 시스템 구축 요청
 *                   : 2017-04-07      eunha [CSR ID:3348752] 임원 연봉계약 및 집행임원서약서 온라인 징구 관련 지원 요청의 건
 */
public class A21EPViewSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);

            String dest   = "";

            Logger.debug.println(this, " [user] : "+user.toString() );

            String ZYEAR = DataUtil.getCurrentYear(); //플레그 추가
            int    year  = Integer.parseInt(ZYEAR);

//          2003.01.02. - 03월 이전일경우 작년 연봉계약서를 보여준다.
            String ZMONTH = DataUtil.getCurrentMonth();
            int    month  = Integer.parseInt(ZMONTH);
            if( month < 3 ) {
                year = year - 1;
            }

            Vector A10AnnualData_vt = ( new A10AnnualRFC() ).getAnnualList( user.empNo );//사번, 현재날짜
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
              //2017-04-07    eunha  [CSR ID:3348752] 임원 연봉계약 및 집행임원서약서 온라인 징구 관련 지원 요청의 건(local하드코딩제거) start
               // if(WebUtil.isLocal(req)) ZYEAR = "2016";
                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.A.A21ExecutivePledge.A21EPListSV?jobid=print&ZYEAR="+ZYEAR );
                //2017-04-07    eunha  [CSR ID:3348752] 임원 연봉계약 및 집행임원서약서 온라인 징구 관련 지원 요청의 건(local하드코딩제거) end
                req.setAttribute( "isPopUp", "false" );
                dest = WebUtil.JspURL+"common/printFrame.jsp";
                Logger.debug.println(this, WebUtil.ServletURL+"hris.A.A21ExecutivePledge.A21EPListSV?jobid=print&ZYEAR="+ZYEAR );
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