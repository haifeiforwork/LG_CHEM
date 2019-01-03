/********************************************************************************/
/*   System Name  : ESS                                                         														*/
/*   1Depth Name  : �ް�/����                                               																	*/
/*   2Depth Name  : Flextime ��������                                                														*/
/*   Program Name : Flextime ��������                                                														*/
/*   Program ID   : D20FlextimeListSV.java                                    													*/
/*   Description  : ������  FLEXTIME ������ jsp�� �Ѱ��ִ� class                 												*/
/*   Note         :                                                             																*/
/*   Creation     :  2017-08-01  eunha    [CSR ID:3438118] flexible time �ý��� ��û   								 */
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
 * ������  FLEXTIME ������ jsp�� �Ѱ��ִ� class
 * ������ FLEXTIME ������ �������� D20FlextimeListRFC�� ȣ���Ͽ� D20FlextimeList.jsp �� ������ �����ٹ� ������ �Ѱ��ش�.
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

			Logger.debug.println(this, "���糯¥ = " + year);

			D20FlextimeListRFC rfc = new D20FlextimeListRFC();
			Vector<D20FlextimeListData> resultList = rfc.getList(user.empNo,	year); // ��� ����Ÿ
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

			Logger.debug.println(this, "Flextime���� : " + resultList.toString());

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