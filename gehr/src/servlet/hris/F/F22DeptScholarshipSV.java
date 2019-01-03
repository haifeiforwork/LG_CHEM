/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : �ο���Ȳ
*   Program Name : �μ��� �з���ȸ
*   Program ID   : F22DeptScholarshipSV.java
*   Description  : �μ��� �з��� �˻��� ���� ����
*   Note         : ����
*   Creation     :
*   Update       :
********************************************************************************/

package servlet.hris.F;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import hris.F.F22DeptScholarshipData;
import hris.F.F22DeptScholarshipGlobalData;
import hris.F.rfc.F22DeptScholarshipRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.HashMap;
import java.util.Vector;

/**
 * F22DeptScholarshipSV.java
 * �μ��� ���� ��ü �μ����� �з������� ��������
 * F22DeptScholarshipRFC �� ȣ���ϴ� ���� class
 * @author
 * @version 1.0
 */
public class F22DeptScholarshipSV extends EHRBaseServlet {

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
            Vector DeptScholarship_vt  = new Vector();

            if ( !deptId.equals("") ) {
        		F22DeptScholarshipRFC f22Rfc = null;
        		f22Rfc       = new F22DeptScholarshipRFC();

        		ret            = f22Rfc.getDeptScholarship(deptId, checkYN, userArea);

            	RfcSuccess = f22Rfc.getReturn().isSuccess();
            	E_MESSAGE = f22Rfc.getReturn().MSGTX;

	            DeptScholarship_vt = (Vector)ret.get(0);
            }

            //RFC ȣ�� ������.
            if( RfcSuccess ){

	        	req.setAttribute("checkYn", checkYN);
		        req.setAttribute("DeptScholarship_vt", DeptScholarship_vt);



				HashMap<String, Integer> empCnt = new HashMap<String, Integer>();
				int cnt = 0;
				String oldPer = "";

				for (int i = 0; i < DeptScholarship_vt.size(); i++) {
					if( userArea ){
						F22DeptScholarshipData data = (F22DeptScholarshipData) DeptScholarship_vt.get(i);
						if (oldPer.equals(data.PERNR) || (i == 0)) {
							cnt++;
						} else {
							empCnt.put(oldPer, cnt);
							cnt = 1;
						}
						if (i == DeptScholarship_vt.size() - 1) {
							empCnt.put(data.PERNR, cnt);
						}
						oldPer = data.PERNR;
					}else{
						F22DeptScholarshipGlobalData data = (F22DeptScholarshipGlobalData) DeptScholarship_vt.get(i);
						if (oldPer.equals(data.PERNR) || (i == 0)) {
							cnt++;
						} else {
							empCnt.put(oldPer, cnt);
							cnt = 1;
						}
						if (i == DeptScholarship_vt.size() - 1) {
							empCnt.put(data.PERNR, cnt);
						}
						oldPer = data.PERNR;
					}
				}
				req.setAttribute("empCnt1", empCnt);

		        if( excelDown.equals("ED") ) //���������� ���.
		            dest = WebUtil.JspURL+"F/F22DeptScholarshipExcel.jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F22DeptScholarship.jsp";
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