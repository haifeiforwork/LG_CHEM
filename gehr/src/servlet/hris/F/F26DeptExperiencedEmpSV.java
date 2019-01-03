/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : �ο���Ȳ
*   Program Name : �μ��� ����Ի���
*   Program ID   : F26DeptExperiencedEmpSV
*   Description  : �μ��� ����Ի��� ��ȸ�� ���� ����
*   Note         : ����
*   Creation     :
*   Update       :
********************************************************************************/

package servlet.hris.F;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import hris.F.F26DeptExperiencedEmpData;
import hris.F.F26DeptExperiencedEmpGlobalData;
import hris.F.rfc.F26DeptExperiencedEmpRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.HashMap;
import java.util.Vector;

/**
 * F26DeptExperiencedEmpSV
 * �μ��� ���� ��ü �μ����� ����Ի��� ������ ��������
 * F26DeptExperiencedEmpRFC �� ȣ���ϴ� ���� class
 * @author
 * @version 1.0
 */
public class F26DeptExperiencedEmpSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException{
    	try{
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//�μ��ڵ�...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//�����μ�����.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
	        WebUserData user = WebUtil.getSessionUser(req);	                               //����
	        boolean userArea = user.area.toString().equals("KR");

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
            Vector DeptExperiencedEmp_vt  = new Vector();

            F26DeptExperiencedEmpRFC f26Rfc = null;

	        if ( !deptId.equals("") ) {
	        	f26Rfc       = new F26DeptExperiencedEmpRFC();
	            ret = f26Rfc.getDeptExperiencedEmp(deptId, checkYN, userArea);

	            RfcSuccess   = f26Rfc.getReturn().isSuccess();
            	E_MESSAGE = f26Rfc.getReturn().MSGTX;

	            DeptExperiencedEmp_vt = (Vector)ret.get(0);
	        }

	        //RFC ȣ�� ������.
	        if( RfcSuccess ){

	        	req.setAttribute("checkYn", checkYN);
		        req.setAttribute("DeptExperiencedEmp_vt", DeptExperiencedEmp_vt);

				HashMap<String, Integer> empCnt = new HashMap<String, Integer>();
				int cnt = 0;
				String oldPer = "";

				for (int i = 0; i < DeptExperiencedEmp_vt.size(); i++) {
					if( userArea ){
						F26DeptExperiencedEmpData data = (F26DeptExperiencedEmpData) DeptExperiencedEmp_vt.get(i);
						if (oldPer.equals(data.PERNR) || (i == 0)) {
							cnt++;
						} else {
							empCnt.put(oldPer, cnt);
							cnt = 1;
						}
						if (i == DeptExperiencedEmp_vt.size() - 1) {
							empCnt.put(data.PERNR, cnt);
						}
						oldPer = data.PERNR;
					}else{
						F26DeptExperiencedEmpGlobalData data = (F26DeptExperiencedEmpGlobalData) DeptExperiencedEmp_vt.get(i);
						if (oldPer.equals(data.PERNR) || (i == 0)) {
							cnt++;
						} else {
							empCnt.put(oldPer, cnt);
							cnt = 1;
						}
						if (i == DeptExperiencedEmp_vt.size() - 1) {
							empCnt.put(data.PERNR, cnt);
						}
						oldPer = data.PERNR;
					}
				}
				req.setAttribute("empCnt1", empCnt);

		        if( excelDown.equals("ED") ) //���������� ���.
		            dest = WebUtil.JspURL+"F/F26DeptExperiencedEmpExcel.jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F26DeptExperiencedEmp.jsp";
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