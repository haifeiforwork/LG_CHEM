/*******************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : �ο���Ȳ
*   Program Name : �μ��� �������� ����
*   Program ID   : F25DeptLegalAssignmentSV
*   Description  : �μ��� �������� ���� ��ȸ�� ���� ����
*   Note         : ����
*   Creation     :
*   Update       :
********************************************************************************/

package servlet.hris.F;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import hris.F.F25DeptLegalAssignmentData;
import hris.F.rfc.F25DeptLegalAssignmentRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.Vector;

/**
 * F25DeptLegalAssignmentSV
 * �μ��� ���� ��ü �μ����� �������� ���� ������ ��������
 * F25DeptLegalAssignmentRFC �� ȣ���ϴ� ���� class
 * @author
 * @version 1.0
 */
public class F25DeptLegalAssignmentSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException{
    	try{
	        HttpSession session = req.getSession(false);
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//�μ��ڵ�...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//�����μ�����.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
	        WebUserData user    = (WebUserData)session.getAttribute("user");				//����.

            //�ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
            if( deptId.equals("") ){
            	deptId = user.e_objid;
            }

	        String dest    		= "";
	        boolean RfcSuccess  	= false;
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

        	Vector ret = null;
            F25DeptLegalAssignmentRFC f24Rfc = null;
            Vector DeptLegalAssignment_vt  = new Vector();

	        if ( !deptId.equals("") ) {
	        	f24Rfc       = new F25DeptLegalAssignmentRFC();
	            ret = f24Rfc.getDeptLegalAssignment(deptId, checkYN);

	            RfcSuccess   = f24Rfc.getReturn().isSuccess();
            	E_MESSAGE = f24Rfc.getReturn().MSGTX;
	            DeptLegalAssignment_vt = (Vector)ret.get(0);
	        }

	        //RFC ȣ�� ������.
	        if( RfcSuccess ){
	        	req.setAttribute("checkYn", checkYN);
		        req.setAttribute("DeptLegalAssignment_vt", DeptLegalAssignment_vt);

				HashMap<String, Integer> empCnt = new HashMap<String, Integer>();
				int cnt = 0;
				String oldPer = "";

				for (int i = 0; i < DeptLegalAssignment_vt.size(); i++) {
					F25DeptLegalAssignmentData data = (F25DeptLegalAssignmentData) DeptLegalAssignment_vt.get(i);
					if (oldPer.equals(data.PERNR) || (i == 0)) {
						cnt++;
					} else {
						empCnt.put(oldPer, cnt);
						cnt = 1;
					}
					if (i == DeptLegalAssignment_vt.size() - 1) {
						empCnt.put(data.PERNR, cnt);
					}
					oldPer = data.PERNR;
				}
				req.setAttribute("empCnt1", empCnt);
		        if( excelDown.equals("ED") ) //���������� ���.
		            dest = WebUtil.JspURL+"F/F25DeptLegalAssignmentExcel.jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F25DeptLegalAssignment.jsp";
		    //RFC ȣ�� ���н�.
	        }else{
	        	throw new GeneralException(E_MESSAGE);
	        }
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}