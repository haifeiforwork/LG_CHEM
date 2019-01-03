/********************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Organization & Staffing                                              */
/*   2Depth Name  : Headcount                                                    */
/*   Program Name : Org.Unit/Distance                                    */
/*   Program ID   : F73DistanceInKilometersHeaderSV                                      */
/*   Description  : �ٹ�����/���޺� �ο���Ȳ ��ȸ�� ���� ����[NonChina-��������ڿ�]                 */
/*   Note         : ����                                                        */
/*   Creation     : 2010-08-02 yji                                           */
/********************************************************************************/

package servlet.hris.F.Global;

import hris.F.Global.F73DistanceInKilometersDataEurp;
import hris.F.rfc.Global.F73DistanceInKilometersRFCEurp;
import hris.common.WebUserData;
import hris.common.rfc.BukrsCodeByOrgehRFCEurp;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

/**
 * F73DistanceInKilometersHeaderSV
 * �μ��� ���� ������ ��/��ٰŸ� ������ �������� F73DistanceInKilometersRFCEurp�� ȣ���ϴ� ���� class
 * [NonChina-��������ڿ�]
 *
 * @author yji
 * @version 1.0
 */
public class F73DistanceInKilometersHeaderSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		try {
			req.setCharacterEncoding("utf-8");
			HttpSession session = req.getSession(false);
			String deptId = WebUtil.nvl(req.getParameter("hdn_deptId")); // �μ��ڵ�...
			String checkYN = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); // �����μ�����.
			String excelDown = WebUtil.nvl(req.getParameter("hdn_excel")); // excelDown...

	        WebUserData user = (WebUserData) session.getAttribute("user");
			WebUserData user_m = (WebUserData) session.getAttribute("user_m");

			Logger.debug.println(this, "[user.e_area]" + user.e_area);
			Logger.debug.println(this, "[user_m.e_area]" + user_m.e_area);

			String popflag = WebUtil.nvl(req.getParameter("hdn_Popflag"));
	        String E_RETURN2 = "";
	        String E_BUKRS   = "";
	        String E_BUTXT   = "";
			String i_datum = DataUtil.getCurrentDate();

			// �ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
			if (deptId.equals("")) {
				deptId = user.e_objid;
			}

			String dest = "";
			String E_RETURN = "";
			String E_MESSAGE = "�μ� ������ �������µ� �����Ͽ����ϴ�.";

			F73DistanceInKilometersRFCEurp func = null;
			Vector F73DistanceInKilometersTitle_vt = null;

			if (!deptId.equals("")) {

				Logger.debug.println("[ popflag ]" + popflag);

	        	if(popflag.equals("Y")){

			    	//���� Head����ڿ� ���������� ��������ڸ� �������� ��� ������������ �̵��Ѵ�.
			    	//�����˾����� ���õ� �����ڵ忡 ���� �����ڵ带 �����ϴ� RFC�� ȣ���Ѵ�.
			    	BukrsCodeByOrgehRFCEurp rfc = new BukrsCodeByOrgehRFCEurp();
			    	Vector vt = rfc.getBukrsCode(deptId);
			        E_RETURN2 = (String)vt.get(0);
			        E_BUKRS   = (String)vt.get(1);
			        E_BUTXT   = (String)vt.get(2);
			        Logger.debug.println("�μ����� [E_RETURN2::]"  + E_RETURN2 +  " [E_BUKRS::]" + E_BUKRS + " [E_BUTXT::]" + E_BUTXT);
	        	}

				func = new F73DistanceInKilometersRFCEurp();
				F73DistanceInKilometersTitle_vt = new Vector();

				Logger.debug.println("deptId::" + deptId + ": checkYN: "  +  checkYN  + " : i_datum: " + i_datum);
				Vector ret = func.getDistanceInKilometers(deptId, checkYN, i_datum);

				E_RETURN = (String) ret.get(0);
				E_MESSAGE = (String) ret.get(1);
				F73DistanceInKilometersTitle_vt = (Vector) ret.get(2);
			}

			Logger.debug.println(this, " F73DistanceInKilometersTitle_vt ��� ��============= " + F73DistanceInKilometersTitle_vt);
			Logger.debug.println(this, " E_RETURN = " + E_RETURN);

			F73DistanceInKilometersTitle_vt = dataFilter(F73DistanceInKilometersTitle_vt); //�߰�

				req.setAttribute("checkYn", checkYN);
				req.setAttribute("F73DistanceInKilometersTitle_vt", F73DistanceInKilometersTitle_vt);

		        if(popflag.equals("Y")){

			        if( excelDown.equals("ED") ){ //���������� ���.

			        	 if(E_BUKRS.equals("G290") || E_BUKRS.equals("G260")){
			        		 dest = WebUtil.JspURL+"F/F73DistanceInKilometersExcelEurp.jsp";

			        	 }else{
			        		 dest = WebUtil.JspURL+"F/F73DistanceInKilometersExcelHeader.jsp";
			        	 }

			        }else{

			        	if(E_BUKRS.equals("G290") || E_BUKRS.equals("G260")){
			        		dest = WebUtil.JspURL + "F/F73DistanceInKilometersEurp.jsp";
			        	}else{
			        		dest = WebUtil.JspURL + "F/F73DistanceInKilometersHeader.jsp";
			        	}
			        }

		        }else{

			        if( excelDown.equals("ED") ){ //���������� ���.
			        		 dest = WebUtil.JspURL+"F/F73DistanceInKilometersExcelHeader.jsp";
			        }else{
			        		dest = WebUtil.JspURL+"F/F73DistanceInKilometersHeader.jsp";
			        }
		        }

			Logger.debug.println(this, " destributed = " + dest);
			printJspPage(req, res, dest);
		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

	private Vector dataFilter(Vector F73DistanceInKilometersTitle_vt) {
		Vector ret = new Vector();
		boolean flag = false;
		for(int i = 0 ; i < F73DistanceInKilometersTitle_vt.size() ; i ++){
			F73DistanceInKilometersDataEurp entity = (F73DistanceInKilometersDataEurp) F73DistanceInKilometersTitle_vt.get(i);
			if(entity.ZLEVEL == null || entity.ZLEVEL.equals("1")){
				entity = (F73DistanceInKilometersDataEurp)hris.common.util.AppUtil.initEntity( entity , "0" , "");
				flag = true;
			}
			ret.addElement(entity);
		}
		if(!flag){
			ret = new Vector();
			for (int i = 0; i < F73DistanceInKilometersTitle_vt.size() ; i++) {
				F73DistanceInKilometersDataEurp entity = (F73DistanceInKilometersDataEurp) F73DistanceInKilometersTitle_vt.get(i);
				if(entity.ZLEVEL == null || entity.ZLEVEL.equals("2")){
					entity = (F73DistanceInKilometersDataEurp)hris.common.util.AppUtil.initEntity( entity , "0" , "");
				}
				ret.addElement(entity);
			}
		}
		return ret;
	}


}