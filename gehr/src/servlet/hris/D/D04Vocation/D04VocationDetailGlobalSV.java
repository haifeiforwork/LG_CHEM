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
/********************************************************************************/
package servlet.hris.D.D04Vocation;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.Utils;
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
public class D04VocationDetailGlobalSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user   = (WebUserData)session.getAttribute("user");

            String jobid = "";
            String dest = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
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
           	d04VocationDetailData_vt = getWorkDayrfc.getNoOfWorkday(user.empNo, year);

           	Logger.debug.println(this, "d04VocationDetailData_vt.size() = "+d04VocationDetailData_vt.size());



            D03RemainVocationData remainVocationData =Utils.indexOf(d04VocationDetailData_vt, 0, D03RemainVocationData.class);
            D03VacationGeneratedData vcationGenerateData = Utils.indexOf(d04VocationDetailData_vt, 1, D03VacationGeneratedData.class);
            D03VacationUsedData vocationUsedData = Utils.indexOf(d04VocationDetailData_vt, 2, D03VacationUsedData.class);

            Logger.debug.println(this, "remainVocationData"+remainVocationData);
            Logger.debug.println(this, "vcationGenerateData"+vcationGenerateData);
            Logger.debug.println(this, "vocationUsedData"+vocationUsedData);

            req.setAttribute("year", year);
            req.setAttribute("d04VocationDetailData_vt", d04VocationDetailData_vt);

            dest = WebUtil.JspURL+"D/D04VocationDetail_Global.jsp?jobid=search";

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

         } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}