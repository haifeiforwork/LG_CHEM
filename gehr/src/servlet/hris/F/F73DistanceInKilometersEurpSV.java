/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Organization & Staffing
*   2Depth Name  : Headcount
*   Program Name : Org.Unit/Distance
*   Program ID   : F73DistanceInKilometersEurpSV
*   Description  : �ҼӺ� ��ٰŸ��� �ο���Ȳ ��ȸ�� ���� ����
*   Note         : ����
*   Creation     :
*    Update       : [CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ 2017-07-07 eunha
********************************************************************************/

package servlet.hris.F;

import hris.F.F73DistanceInKilometersEurpGlobalData;
import hris.F.rfc.F73DistanceInKilometersEurpGlobalRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

/**
 * F73DistanceInKilometersEurpSV
 * �μ��� ���� ������ ��/��ٰŸ� ������ �������� F73DistanceInKilometersRFCEurp�� ȣ���ϴ� ���� class
 * @author
 * @version 1.0
 */
public class F73DistanceInKilometersEurpSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		try {
			req.setCharacterEncoding("utf-8");
			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId")); // �μ��ڵ�...
			String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); // �����μ�����.
			String excelDown = WebUtil.nvl(req.getParameter("hdn_excel")); // excelDown...
			WebUserData user = WebUtil.getSessionUser(req);		                            //����

			String i_datum = DataUtil.getCurrentDate();

			// �ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
			if (deptId.equals("")) {
				deptId = user.e_objid;
			}

			String dest = "";
	        boolean E_RETURN  = false;
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007");

	        F73DistanceInKilometersEurpGlobalRFC f73Rfc = null;
			Vector F73DistanceInKilometersTitle_vt = null;

			// [CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ start
           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}
		    // ����༺ �߰�
            if(!checkAuthorization(req, res)) return;
            //[CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ end


			if (!deptId.equals("")) {
				f73Rfc = new F73DistanceInKilometersEurpGlobalRFC();
				F73DistanceInKilometersTitle_vt = new Vector();

				Vector ret = f73Rfc.getDistanceInKilometers(deptId, checkYN, i_datum, user.area.getMolga());

				E_RETURN = f73Rfc.getReturn().isSuccess();
            	E_MESSAGE = f73Rfc.getReturn().MSGTX;
				F73DistanceInKilometersTitle_vt = (Vector) ret.get(0);
			}


			// RFC ȣ�� ������.
			if (E_RETURN) {
				req.setAttribute("checkYn", checkYN);
				req.setAttribute("F73DistanceInKilometersTitle_vt",  dataFilter(F73DistanceInKilometersTitle_vt));
				if (excelDown.equals("ED")) // ���������� ���.
					dest = WebUtil.JspURL + "F/F73DistanceInKilometersExcelEurp.jsp";
				else
					dest = WebUtil.JspURL + "F/F73DistanceInKilometersEurp.jsp";
			    //RFC ȣ�� ���н�.
	        }else{
	        	throw new GeneralException(E_MESSAGE);
	        }
			printJspPage(req, res, dest);
		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

	private Vector dataFilter(Vector F73DistanceInKilometersTitle_vt) {
		Vector ret = new Vector();
		boolean flag = false;
		for(int i = 0 ; i < F73DistanceInKilometersTitle_vt.size() ; i ++){
			F73DistanceInKilometersEurpGlobalData entity = (F73DistanceInKilometersEurpGlobalData) F73DistanceInKilometersTitle_vt.get(i);
			if(entity.ZLEVEL == null || entity.ZLEVEL.equals("1")){
				entity = (F73DistanceInKilometersEurpGlobalData)hris.common.util.AppUtilEurp.initEntity( entity , "0" , "");
				flag = true;
			}
			ret.addElement(entity);
		}
		if(!flag){
			ret = new Vector();
			for (int i = 0; i < F73DistanceInKilometersTitle_vt.size() ; i++) {
				F73DistanceInKilometersEurpGlobalData entity = (F73DistanceInKilometersEurpGlobalData) F73DistanceInKilometersTitle_vt.get(i);
				if(entity.ZLEVEL == null || entity.ZLEVEL.equals("2")){
					entity = (F73DistanceInKilometersEurpGlobalData)hris.common.util.AppUtilEurp.initEntity( entity , "0" , "");
				}
				ret.addElement(entity);
			}
		}
		return ret;
	}


}