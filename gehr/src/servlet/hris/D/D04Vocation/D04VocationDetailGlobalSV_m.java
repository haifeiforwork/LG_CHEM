/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 휴가실적정보                                                */
/*   Program Name : 휴가실적정보                                                */
/*   Program ID   : D04VocationDetailSV.java                                    */
/*   Description  : 개인의 휴가현황 정보를 jsp로 넘겨주는 class                 */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-12-21  @v1.1 lsa C2005122101000000223 2005년도 사용일수가 안나타남 */
/*                  2006-01-17  @v1.2 lsa 사용일수 로직 오류수정                */
/*                : 2007-09-13  zhouguangwen  global e-hr update                                                            */
/*                  @PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel  */
/********************************************************************************/
package servlet.hris.D.D04Vocation;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

//import java.io.*;
//import java.sql.*;
import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VacationGeneratedData;
import hris.D.D03Vocation.D03VacationUsedData;
import hris.D.D03Vocation.rfc.D03GetWorkdayGlobalRFC;
import hris.common.WebUserData;

/**
 * D04VocationDetailSV.java
 * 개인의 휴가현황 정보를 jsp로 넘겨주는 class
 * 개인의 휴가현황 정보를 가져오는 D04VocationDetailRFC를 호출하여 D04VocationDetail.jsp로 개인의 휴가현황 정보를 넘겨준다.
 *
 * @author chldudgh
 * @version 1.0, 2002/01/21
 * update by zhouguangwen 2007/09/13
 */
public class D04VocationDetailGlobalSV_m extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user_m   =(WebUserData) WebUtil.getSessionMSSUser(req);

            String jobid = "";
            String dest = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");

            /**         * Start: 국가별 분기처리 */
            String fdUrl = ".";

            if (user_m.area.equals(Area.PL) || user_m.area.equals(Area.DE) || user_m.area.equals(Area.US)|| user_m.area.equals(Area.MX)) { // PL 폴랜드, DE 독일 은 유럽화면으로   @PJ.멕시코 법인 Rollout
        	   fdUrl = "hris.D.D04Vocation.D04VocationDetailEurpSV_m";
			}
           Logger.debug.println(this, "-------------[user.area] = "+user_m.area + " fdUrl: " + fdUrl );

            if( !".".equals(fdUrl )){
            	printJspPage(req, res, WebUtil.ServletURL+fdUrl);
		       	return;
           }
            /**             * END: 국가별 분기처리             */

            if( jobid.equals("") ){
                jobid = "search";
            }

            String year  = box.get("year");

            if(year == null|| year.equals("")){

            	year = DataUtil.getCurrentDate().substring(0,4);
            }

            Logger.debug.println(this, "Search Year = "+year);

            D03GetWorkdayGlobalRFC getWorkDayrfc = new D03GetWorkdayGlobalRFC();

            Vector d04VocationDetailData_vt = null;
           	d04VocationDetailData_vt = getWorkDayrfc.getNoOfWorkday(user_m.empNo, year);

           	Logger.debug.println(this, "d04VocationDetailData_vt.size() = "+d04VocationDetailData_vt.size());




            req.setAttribute("year", year);
            req.setAttribute("d04VocationDetailData_vt", d04VocationDetailData_vt);

            dest = WebUtil.JspURL+"D/D04VocationDetail_Global_m.jsp?jobid=search";

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

         } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}