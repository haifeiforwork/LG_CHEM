/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : �ο���Ȳ
*   Program Name : �ҼӺ� ����,���� �ο���Ȳ
*   Program ID   : F10DeptRaceClassSV
*   Description  : �ҼӺ� ����,���� �ο���Ȳ ��ȸ�� ���� ����
*   Note         : ����
*   Creation     :
*   Update       : [CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ 2017-07-07 eunha
*
********************************************************************************/

package servlet.hris.F;

import hris.F.F10DeptRaceClassTitleGlobalData;
import hris.F.rfc.F10DeptRaceClassGlobalRFC;
import hris.common.WebUserData;

import java.util.HashMap;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

/**
 * F10DeptRaceClassSV �μ��� ���� �ҼӺ� ����,���� �ο���Ȳ ������ �������� F10DeptRaceClassRFC ��
 * ȣ���ϴ� ���� class
 * @author
 * @version 1.0
  */
public class F10DeptRaceClassSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		try {
			req.setCharacterEncoding("utf-8");
			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId")); // �μ��ڵ�...
			String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); // �����μ�����.
			String excelDown = WebUtil.nvl(req.getParameter("hdn_excel")); // excelDown...
	        WebUserData user = WebUtil.getSessionUser(req);

			// �ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
			if (deptId.equals("")) {
				deptId = user.e_objid;
			}

			String dest = "";
			boolean E_RETURN = false;
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007");

	        F10DeptRaceClassGlobalRFC f10Rfc = null;
			Vector F10DeptRaceClassTitle_vt = null;

			// [CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ start
           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}
		    // ����༺ �߰�
            if(!checkAuthorization(req, res)) return;
            //[CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ end

			if (!deptId.equals("")) {
				F10DeptRaceClassTitle_vt = new Vector();
				Vector ret = null;

				f10Rfc = new F10DeptRaceClassGlobalRFC();
				ret = f10Rfc.getDeptRaceClass(deptId, checkYN, user.area.getMolga());

				E_RETURN   = f10Rfc.getReturn().isSuccess();
            	E_MESSAGE = f10Rfc.getReturn().MSGTX;
				F10DeptRaceClassTitle_vt = (Vector) ret.get(0);
			}

			// RFC ȣ�� ������.
			if (E_RETURN) {
				req.setAttribute("checkYn", checkYN);
				req.setAttribute("DeptRaceClassTitle_vt", dataFilter(F10DeptRaceClassTitle_vt));
				req.setAttribute("meta", doWithData(F10DeptRaceClassTitle_vt));

				req.setAttribute("han_sum", han_sum);
				req.setAttribute("chosen_sum", chosen_sum);
				req.setAttribute("man_sum", man_sum);
				req.setAttribute("other_sum", other_sum);
				req.setAttribute("total_sum", total_sum);

				if (excelDown.equals("ED")) // ���������� ���.
					dest = WebUtil.JspURL + "F/F10DeptRaceClassExcel_Global.jsp";
				else
					dest = WebUtil.JspURL + "F/F10DeptRaceClass_Global.jsp";
				han_sum = 0 ;
				chosen_sum = 0;
				man_sum = 0;
				other_sum = 0 ;
			//RFC ȣ�� ���н�.
	        }else{
	        	throw new GeneralException(E_MESSAGE);
	        }
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
			F10DeptRaceClassTitleGlobalData entity = (F10DeptRaceClassTitleGlobalData) deptPositionClassTitle_vt.get(i);
			if(entity.ZLEVEL == null || entity.ZLEVEL.equals("1")){// || entity.ZLEVEL.equals("2")){
				entity = (F10DeptRaceClassTitleGlobalData)hris.common.util.AppUtil.initEntity( entity , "0" , "");
				flag = true;
			}
			ret.addElement(entity);
		}
		if(!flag){
			ret = new Vector();
			for (int i = 0; i < deptPositionClassTitle_vt.size() ; i++) {
				F10DeptRaceClassTitleGlobalData entity = (F10DeptRaceClassTitleGlobalData) deptPositionClassTitle_vt.get(i);
				if(entity.ZLEVEL == null || entity.ZLEVEL.equals("2")){// || entity.ZLEVEL.equals("2")){
					entity = (F10DeptRaceClassTitleGlobalData)hris.common.util.AppUtil.initEntity( entity , "0" , "");
				}
				ret.addElement(entity);
			}
		}
		return ret;
	}

	//calculate rowspan
	int han_sum = 0;
	int chosen_sum = 0 ;
	int man_sum = 0 ;
	int other_sum = 0 ;
	int total_sum = 0 ;
	private HashMap doWithData(Vector deptServiceTitle_vt) {
		HashMap tmp = new HashMap<String, Integer>();
		for (int i = 0; i < deptServiceTitle_vt.size(); i++) {
			F10DeptRaceClassTitleGlobalData entity = (F10DeptRaceClassTitleGlobalData) deptServiceTitle_vt.get(i);
			if (tmp.containsKey(entity.STEXT + entity.OBJID)) {
				Integer tmpStr = (Integer) tmp.get(entity.STEXT + entity.OBJID);
				tmp.put(entity.STEXT + entity.OBJID, new Integer(tmpStr.intValue() + 1));
			} else {
				tmp.put(entity.STEXT + entity.OBJID, new Integer(1));
			}
			han_sum += Integer.parseInt(entity.F1.equals("")?"0":entity.F1);
			chosen_sum += Integer.parseInt(entity.F2.equals("")?"0":entity.F2);
			man_sum += Integer.parseInt(entity.F3.equals("")?"0":entity.F3);
			other_sum += Integer.parseInt(entity.F4.equals("")?"0":entity.F4);
			total_sum += Integer.parseInt(entity.F8.equals("")?"0":entity.F8);
		}
		return tmp;
	}
}