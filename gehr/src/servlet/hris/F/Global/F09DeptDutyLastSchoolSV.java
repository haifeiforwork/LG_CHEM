/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : �ο���Ȳ                                                    */
/*   Program Name : ������/�����зº�                                     		*/
/*   Program ID   : F09DeptDutyLastSchoolSV                            		    */
/*   Description  : ������/�����зº� ��ȸ�� ���� ����                  		*/
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-04 �����                                           */
/*   Update       : 2007-09-17  huang peng xiao                   */
/*                                                                              */
/********************************************************************************/

package servlet.hris.F.Global;

import java.util.HashMap;
import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.F.Global.F06DeptPositionClassServiceTitleData;
import hris.F.rfc.Global.*;
import hris.common.WebUserData;

/**
 * F09DeptDutyLastSchoolSV �μ��� ���� ������/�����зº� ������ �������� F09DeptDutyLastSchoolRFC ��
 * ȣ���ϴ� ���� class
 *
 * @author �����
 * @version 1.0
 */
public class F09DeptDutyLastSchoolSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		try {
			req.setCharacterEncoding("utf-8");
			HttpSession session = req.getSession(false);
			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId")); // �μ��ڵ�...
			String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); // �����μ�����.
			String excelDown = WebUtil.nvl(req.getParameter("hdn_excel")); // excelDown...
			WebUserData user = (WebUserData) session.getAttribute("user"); // ����.

			// �ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
			if (deptId.equals("")) {
				deptId = user.e_objid;
			}

			String dest = "";
			String E_RETURN = "";
			String E_MESSAGE = "�μ� ������ �������µ� �����Ͽ����ϴ�.";

			F09DeptDutyLastSchoolRFC func = null;
			Vector DeptDutySchoolTitle_vt = null;
			// Vector DeptDutySchoolNote_vt = null;

			if (!deptId.equals("")) {
				DeptDutySchoolTitle_vt = new Vector();
				// DeptDutySchoolNote_vt = new Vector();
				Vector ret = null;

				func = new F09DeptDutyLastSchoolRFC();
				ret = func.getDeptDutyLastSchool(deptId, checkYN);

				E_RETURN = (String) ret.get(0);
				E_MESSAGE = (String) ret.get(1);
				DeptDutySchoolTitle_vt = (Vector) ret.get(2);
				// DeptDutySchoolNote_vt = (Vector)ret.get(3);
			}
			Logger.debug.println(this, " E_RETURN = " + E_RETURN);
			HashMap meta = doWithData(DeptDutySchoolTitle_vt);
			Vector result = dataFilter(DeptDutySchoolTitle_vt);

			// RFC ȣ�� ������.
			//if (E_RETURN != null && E_RETURN.equals("S")) {
				req.setAttribute("checkYn", checkYN);
				req.setAttribute("DeptDutySchoolTitle_vt",
						result);
				// req
				// .setAttribute("DeptDutySchoolNote_vt",
				// DeptDutySchoolNote_vt);
				req.setAttribute("meta", meta);

				if (excelDown.equals("ED")) // ���������� ���.
					dest = WebUtil.JspURL + "F/F09DeptDutyLastSchoolExcel_Global.jsp";
				else
					dest = WebUtil.JspURL + "F/F09DeptDutyLastSchool_Global.jsp";

				// Logger.debug.println(this, "DeptDutySchoolNote_vt : "
				// + DeptDutySchoolNote_vt.toString());
				// RFC ȣ�� ���н�.
			/*} else {
				String msg = E_MESSAGE;
				String url = "location.href = '" + WebUtil.JspURL
						+ "F/F09DeptDutyLastSchool.jsp?checkYn=" + checkYN
						+ "';";
				req.setAttribute("msg", msg);
				req.setAttribute("url", url);
				dest = WebUtil.JspURL + "common/msg.jsp";
			}
*/
			Logger.debug.println(this, " destributed = " + dest);
			printJspPage(req, res, dest);
		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

	/**
	 * @param deptPositionClassTitle_vt
	 * if ZLEVEL is 2 or null, clear data
	 * @return
	 */
	private Vector dataFilter(Vector deptPositionClassTitle_vt) {
		Vector ret = new Vector();
		boolean flag = false;
		for(int i = 0 ; i < deptPositionClassTitle_vt.size() ; i ++){
			F06DeptPositionClassServiceTitleData entity = (F06DeptPositionClassServiceTitleData) deptPositionClassTitle_vt.get(i);
			if(entity.ZLEVEL == null || entity.ZLEVEL.equals("1")){// || entity.ZLEVEL.equals("2")){
				entity = (F06DeptPositionClassServiceTitleData)hris.common.util.AppUtil.initEntity( entity , "0" , "");
				flag = true;
			}
			ret.addElement(entity);
		}
		if(!flag){
			ret = new Vector();
			for (int i = 0; i < deptPositionClassTitle_vt.size() ; i++) {
				F06DeptPositionClassServiceTitleData entity = (F06DeptPositionClassServiceTitleData) deptPositionClassTitle_vt.get(i);
				if(entity.ZLEVEL == null || entity.ZLEVEL.equals("2")){// || entity.ZLEVEL.equals("2")){
					entity = (F06DeptPositionClassServiceTitleData)hris.common.util.AppUtil.initEntity( entity , "0" , "");
					//flag = true;
				}
				ret.addElement(entity);
			}
		}
		//ret.addElement(deptPositionClassTitle_vt.get(deptPositionClassTitle_vt.size() - 1));
		return ret;
	}

	//calculate rowspan
	private HashMap doWithData(Vector deptServiceTitle_vt) {
		HashMap tmp = new HashMap<String, Integer>();
		for (int i = 0; i < deptServiceTitle_vt.size(); i++) {
			F06DeptPositionClassServiceTitleData entity = (F06DeptPositionClassServiceTitleData) deptServiceTitle_vt
					.get(i);
			if (tmp.containsKey(entity.STEXT + entity.OBJID)) {
				Integer tmpStr = (Integer) tmp.get(entity.STEXT + entity.OBJID);
				int val = tmpStr.intValue() + 1;
				tmp.put(entity.STEXT + entity.OBJID, val);
			} else {
				tmp.put(entity.STEXT + entity.OBJID, 1);
			}
		}
		return tmp;
	}

}