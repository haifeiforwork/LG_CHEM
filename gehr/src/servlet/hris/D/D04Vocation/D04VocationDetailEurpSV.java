/********************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Personal HR Info                                          */
/*   2Depth Name  : Time management                                        */
/*   Program Name : Leave                                                			*/
/*   Program ID   : D04VocationDetailEurpSV.java                          */
/*   Description  : 개인의 휴가현황 정보를 jsp로 넘겨주는 class[유럽]      */
/*   Note         :                                                             			*/
/*   Creation     : 2010-07-30 yji                                                */
/********************************************************************************/
package servlet.hris.D.D04Vocation;

import java.util.HashMap;
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

import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VacationUsedData;
import hris.D.D03Vocation.rfc.D03GetWorkdayRFCEurp;
import hris.common.WebUserData;

/**
 * D04VocationDetailEurpSV.java
 * 개인의 휴가현황 정보를 jsp로 넘겨주는 class[유럽]
 * 개인의 휴가현황 정보를 가져오는 D03GetWorkdayRFCEurp 호출하여 D04VocationDetailEurp.jsp로 개인의 휴가현황 정보를 넘겨준다.
 *
 * @author chldudgh
 * @version 1.0, 2010/07/30
 */
public class D04VocationDetailEurpSV extends EHRBaseServlet {

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

            HashMap d04VocationDetailDataMap = null;
            D03RemainVocationData dataITABData = null;
            D03VacationUsedData    dataITAB3Data = null;
            Vector    dataITAB2_vt = null;

            D03GetWorkdayRFCEurp getWorkDayrfcEurp = new D03GetWorkdayRFCEurp();
            d04VocationDetailDataMap = getWorkDayrfcEurp.getNoOfWorkday(user.empNo, year);

            dataITABData = (D03RemainVocationData) d04VocationDetailDataMap.get("dataITAB");
            dataITAB3Data = (D03VacationUsedData) d04VocationDetailDataMap.get("dataITAB3");
            dataITAB2_vt = (Vector) d04VocationDetailDataMap.get("dataITAB2");


            req.setAttribute("year", year);
            req.setAttribute("dataITABData", dataITABData);
            req.setAttribute("dataITAB3Data", dataITAB3Data);
            req.setAttribute("dataITAB2_vt", dataITAB2_vt);

            dest = WebUtil.JspURL+"D/D04VocationDetail_Eurp.jsp?jobid=search";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

         } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}