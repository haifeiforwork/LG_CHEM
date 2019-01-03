/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : �ο���Ȳ
*   Program Name : �ҼӺ�/������ �ο���Ȳ
*   Program ID   : F02DeptPositionDutySV
*   Description  : �ҼӺ�/������ �ο���Ȳ ��ȸ�� ���� ����
*   Note         : ����
*   Creation     :
*   Update       :
*
********************************************************************************/

package servlet.hris.F;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import hris.F.F02DeptPositionDutyTitleGlobalData;
import hris.F.rfc.F02DeptPositionDutyGlobalRFC;
import hris.F.rfc.F02DeptPositionDutyRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.HashMap;
import java.util.Vector;

/**
 * F02DeptPositionDutySV
 * �μ��� ���� �ҼӺ�/������ �ο���Ȳ ������ ��������
 * F02DeptPositionDutyRFC �� ȣ���ϴ� ���� class
 * @author
 * @version 1.0
 */
public class F02DeptPositionDutySV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
    	try{
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//�μ��ڵ�...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//�����μ�����.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
	        WebUserData user = WebUtil.getSessionUser(req);			                        //����
	        String dest    	      = "";
	        boolean userArea = user.area.toString().equals("KR");

            //�ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
            if( deptId.equals("") ){
            	deptId = user.e_objid;
            }

	        String E_RETURN  	= "";
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007");

           	/**
           	 * @$ ���������� rdcamel
           	 * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ
           	 */
           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}

		    // ����༺ �߰�
            if(!checkAuthorization(req, res)) return;

        	Vector ret                                   = null;
	        Vector F02DeptPositionDutyTitle_vt	= null;
	        Vector F02DeptPositionDutyNote_vt   = null;
	        boolean RfcSuccess                      = false;
	        E_MESSAGE                            = "";

	        if ( !deptId.equals("") ) {

	        	F02DeptPositionDutyTitle_vt		= new Vector();
	        	F02DeptPositionDutyNote_vt	    = new Vector();

	            if( userArea ){
	            	F02DeptPositionDutyRFC f02Rfc = null;
	            	f02Rfc       						       = new F02DeptPositionDutyRFC();
	            	ret 						               = f02Rfc.getDeptPositionDuty(deptId, checkYN, user.area.getMolga());

	            	RfcSuccess = f02Rfc.getReturn().isSuccess();
	            	E_MESSAGE = f02Rfc.getReturn().MSGTX;
	            }else {
	            	F02DeptPositionDutyGlobalRFC f02RfcG = null;
	            	f02RfcG    						                = new F02DeptPositionDutyGlobalRFC();
	            	ret 						                       = f02RfcG.getDeptPositionDuty(deptId, checkYN, user.area.getMolga());
	            	RfcSuccess = f02RfcG.getReturn().isSuccess();
	            	E_MESSAGE = f02RfcG.getReturn().MSGTX;
	            }
	            F02DeptPositionDutyTitle_vt	= (Vector)ret.get(0);
	            F02DeptPositionDutyNote_vt	= (Vector)ret.get(1);
	        }

	        //RFC ȣ�� ������.
	        if( RfcSuccess ){
		        req.setAttribute("checkYn", checkYN);
		        req.setAttribute("F02DeptPositionDutyTitle_vt", F02DeptPositionDutyTitle_vt);
		        req.setAttribute("F02DeptPositionDutyNote_vt", F02DeptPositionDutyNote_vt);
		        if( !userArea ) req.setAttribute("meta", doWithData(F02DeptPositionDutyTitle_vt) );

		        String returnDest = "";
		        if( !userArea ) returnDest = "_Global";

		        if( excelDown.equals("ED") ) //���������� ���.
		            dest = WebUtil.JspURL+"F/F02DeptPositionDutyExcel"+ returnDest + ".jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F02DeptPositionDuty"+ returnDest + ".jsp";
			//RFC ȣ�� ���н�.
	        }else{
	        	 throw new GeneralException(E_MESSAGE);
	        }

	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }

	private HashMap doWithData(Vector deptServiceTitle_vt) {

		HashMap tmp = new HashMap();
		for (int i = 0; i < deptServiceTitle_vt.size(); i++) {
			F02DeptPositionDutyTitleGlobalData entity = (F02DeptPositionDutyTitleGlobalData) deptServiceTitle_vt.get(i);
			if (tmp.containsKey(entity.PERST)) {
				tmp.put(entity.PERST, ((Integer) tmp.get(entity.PERST)).intValue() + 1);
			} else {
				tmp.put(entity.PERST, 1);
			}
		}
		return tmp;
	}
}