package servlet.hris.F;

import java.util.HashMap;
import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.F.F01DeptPositionClassTitleGlobalData;
import hris.F.rfc.*;
import hris.common.WebUserData;

/**
 * F01DeptPositionClassSV
 * �μ��� ���� �ҼӺ�/���޺� �ο���Ȳ ������ ��������
 * F01DeptPositionClassRFC �� ȣ���ϴ� ���� class
 */
public class F01DeptPositionClassSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException{
    	try{
	        String deptId         = WebUtil.nvl(req.getParameter("hdn_deptId")); 			// �μ��ڵ�
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		// �����μ�����
	        String excelDown   = WebUtil.nvl(req.getParameter("hdn_excel"));  			// excelDown
	        WebUserData user = WebUtil.getSessionUser(req);		                            //����
	        String dest    	      = "";
	        boolean userArea = user.area.toString().equals("KR");

	        /*******************
             * ���α� �޴� �ڵ��
             *******************/
            String sMenuCode = WebUtil.nvl(req.getParameter("sMenuCode"));

	        //�ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
            if( deptId.equals("") ){
               	deptId = user.e_objid;
            }


           	/**
           	 * @$ ����������
           	 * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ
           	 */
           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}

		    // ����༺ �߰�
            if(!checkAuthorization(req, res)) return;

        	Vector ret                                   = null;
	        Vector F01DeptPositionClassTitle_vt = null;
	        Vector F01DeptPositionClassNote_vt  = null;
	        boolean RfcSuccess                      = false;
	        String EMessage                            = "";

	        if ( !deptId.equals("") ) {

	        	F01DeptPositionClassTitle_vt	= new Vector();

	            if( userArea ){
	            	F01DeptPositionClassRFC f01Rfc = null;
	            	f01Rfc       						       = new F01DeptPositionClassRFC();
	            	ret 						               = f01Rfc.getDeptPositionClass(deptId, checkYN, user.area.getMolga());

	            	F01DeptPositionClassNote_vt	= new Vector();
	            	RfcSuccess = f01Rfc.getReturn().isSuccess();
	            	EMessage = f01Rfc.getReturn().MSGTX;
	            }else {
	            	F01DeptPositionClassGlobalRFC f01RfcG = null;
	            	f01RfcG    						                = new F01DeptPositionClassGlobalRFC();
	            	ret 						                       = f01RfcG.getDeptPositionClass(deptId, checkYN, user.area.getMolga());
	            	RfcSuccess = f01RfcG.getReturn().isSuccess();
	            	EMessage = f01RfcG.getReturn().MSGTX;
	            }

	            F01DeptPositionClassTitle_vt	= (Vector)ret.get(0);
	            if( userArea ){
	            	F01DeptPositionClassNote_vt	= (Vector)ret.get(1);
	            }
	        }

	        //RFC ȣ�� ������.
	        if( RfcSuccess ){
		        req.setAttribute("checkYn", checkYN);
		        if( userArea ){
		        	req.setAttribute("F01DeptPositionClassTitle_vt", F01DeptPositionClassTitle_vt);
		        	req.setAttribute("F01DeptPositionClassNote_vt", F01DeptPositionClassNote_vt);
		        }else{
		        	req.setAttribute("F01DeptPositionClassTitle_vt", dataFilter(F01DeptPositionClassTitle_vt));
		        	req.setAttribute("meta", doWithData(F01DeptPositionClassTitle_vt));
		        }
		        String returnDest = "";
		        if( !userArea ) returnDest = "_Global";
		        if( excelDown.equals("ED") ) //���������� ���.
		            dest = WebUtil.JspURL+"F/F01DeptPositionClassExcel"+ returnDest + ".jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F01DeptPositionClass"+returnDest+".jsp";

		    //RFC ȣ�� ���н�.
	        }else{
	        	 throw new GeneralException(EMessage);
	        }

	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }

    }

	/**
	 * @param deptPositionClassTitle_vt
	 * @return
	 */
	private Vector dataFilter(Vector deptPositionClassTitle_vt) {
		Vector ret = new Vector();
		boolean flag = false;
		for (int i = 0; i < deptPositionClassTitle_vt.size(); i++) {
			F01DeptPositionClassTitleGlobalData entity = (F01DeptPositionClassTitleGlobalData) deptPositionClassTitle_vt.get(i);
			if (entity.ZLEVEL == null || entity.ZLEVEL.equals("1")) {
				entity = (F01DeptPositionClassTitleGlobalData) hris.common.util.AppUtil.initEntity(entity, "0", "");
				flag = true;
			}
			ret.addElement(entity);
		}
		if (!flag) {
			ret = new Vector();
			for (int i = 0; i < deptPositionClassTitle_vt.size(); i++) {
				F01DeptPositionClassTitleGlobalData entity = (F01DeptPositionClassTitleGlobalData) deptPositionClassTitle_vt.get(i);
				if (entity.ZLEVEL == null || entity.ZLEVEL.equals("2")) {
					entity = (F01DeptPositionClassTitleGlobalData) hris.common.util.AppUtil.initEntity(entity, "0", "");
				}
				ret.addElement(entity);
			}
		}
		return ret;
	}

	private HashMap doWithData(Vector deptServiceTitle_vt) {
		HashMap tmp = new HashMap();
		for (int i = 0; i < deptServiceTitle_vt.size(); i++) {
			F01DeptPositionClassTitleGlobalData entity = (F01DeptPositionClassTitleGlobalData) deptServiceTitle_vt.get(i);
			if (tmp.containsKey(entity.ORGTX + entity.ORGEH)) {
				Integer tmpStr = (Integer) tmp.get(entity.ORGTX + entity.ORGEH);
				tmp.put(entity.ORGTX + entity.ORGEH, tmpStr.intValue() + 1);
			} else {
				tmp.put(entity.ORGTX + entity.ORGEH, 1);
			}
		}
		return tmp;
	}
}