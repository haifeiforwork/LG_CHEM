/********************************************************************************/
/*   System Name  : ESS                                                         														*/
/*   1Depth Name  : 휴가/근태                                               																	*/
/*   2Depth Name  : Flextime 실적정보                                                														*/
/*   Program Name : Flextime 실적정보                                                														*/
/*   Program ID   : D20FlextimeListSV.java                                    													*/
/*   Description  : 개인의  FLEXTIME 정보를 jsp로 넘겨주는 class                 												*/
/*   Note         :                                                             																*/
/*   Creation     :  2017-08-01  eunha    [CSR ID:3438118] flexible time 시스템 요청   								 */
/*   Update       : 																														*/
/********************************************************************************/
package servlet.hris.D.D20Flextime;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D20Flextime.D20FlextimeListData;
import hris.D.D20Flextime.rfc.D20FlextimeListRFC;
import hris.common.WebUserData;

/**
 * D20FlextimeListSV.java
 * 개인의  FLEXTIME 정보를 jsp로 넘겨주는 class
 * 개인의 FLEXTIME 정보를 가져오는 D20FlextimeListRFC를 호출하여 D20FlextimeList.jsp 로 개인의 유연근무 정보를 넘겨준다.
 *
 */
public class D20FlextimeListSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

			WebUserData user = WebUtil.getSessionUser(req);

			String dest = "";

			Box box = WebUtil.getBox(req);

			String jobid = box.get("jobid", "first");

			String year = box.get("year",DataUtil.getCurrentDate().substring(0, 4));

			Logger.debug.println(this,	"[year] = " + year + " [user] : " + user.toString());

			Logger.debug.println(this, "현재날짜 = " + year);

			D20FlextimeListRFC rfc = new D20FlextimeListRFC();
			Vector<D20FlextimeListData> resultList = rfc.getList(user.empNo,	year); // 결과 데이타
			//D20FlextimeListData resultData = new D20FlextimeListData();

			/*
			 * if(!rfc.getReturn().isSuccess()) { throw new
			 * GeneralException(rfc.getReturn().MSGTX); }
			 */

			/*if (resultList.size() > 0) {
				resultData = Utils.indexOf(resultList, 0);
			} else {
				DataUtil.fixNull(resultData);
			}*/

			Logger.debug.println(this, "Flextime내역 : " + resultList.toString());

			req.setAttribute("resultList", resultList);
			req.setAttribute("year", year);

			dest = WebUtil.JspURL + "D/D20Flextime/D20FlextimeList.jsp";

			Logger.debug.println(this, " destributed = " + dest);
			printJspPage(req, res, dest);

        }catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}