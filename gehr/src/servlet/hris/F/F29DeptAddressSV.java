/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : �ο���Ȳ
*   Program Name : �μ��� ���ּ�
*   Program ID   : F29DeptAddressSV
*   Description  : �μ��� ���ּ� ��ȸ�� ���� ����
*   Note         : ����
*   Creation     :
*   Update       :
********************************************************************************/

package servlet.hris.F;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import hris.F.F26DeptExperiencedEmpData;
import hris.F.F29DeptAddressData;
import hris.F.rfc.F27DeptRewardNPunishRFC;
import hris.F.rfc.F29DeptAddressRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.Vector;

/**
 * F29DeptAddressSV
 * �μ��� ���� ��ü �μ����� ���ּ� ������ ��������
 * F29DeptAddressRFC �� ȣ���ϴ� ���� class
 * @author
 * @version 1.0
 */
public class F29DeptAddressSV extends EHRBaseServlet {

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

           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}
		    // ����༺ �߰�
            if(!checkAuthorization(req, res)) return;


        	Vector ret = null;
        	F29DeptAddressRFC f29Rfc = null;
	        Vector DeptAddress_vt  = null;

	        if ( !deptId.equals("") ) {
	        	f29Rfc              = new F29DeptAddressRFC();
	        	DeptAddress_vt = new Vector();
	            ret                  = f29Rfc.getDeptLegalAssignment(deptId, checkYN);

	            RfcSuccess   = f29Rfc.getReturn().isSuccess();
            	E_MESSAGE = f29Rfc.getReturn().MSGTX;

	            DeptAddress_vt = (Vector)ret.get(0);
	        }

	        //RFC ȣ�� ������.
	        if( RfcSuccess ){
	        	req.setAttribute("checkYn", checkYN);
		        req.setAttribute("DeptAddress_vt", DeptAddress_vt);

				HashMap<String, Integer> empCnt = new HashMap<String, Integer>();
				int cnt = 0;
				String oldPer = "";

				for (int i = 0; i < DeptAddress_vt.size(); i++) {
					F29DeptAddressData data = (F29DeptAddressData) DeptAddress_vt.get(i);
					if (oldPer.equals(data.PERNR) || (i == 0)) {
						cnt++;
					} else {
						empCnt.put(oldPer, cnt);
						cnt = 1;
					}
					if (i == DeptAddress_vt.size() - 1) {
						empCnt.put(data.PERNR, cnt);
					}
					oldPer = data.PERNR;
				}
				req.setAttribute("empCnt1", empCnt);
		        if( excelDown.equals("ED") ) //���������� ���.
		            dest = WebUtil.JspURL+"F/F29DeptAddressExcel.jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F29DeptAddress.jsp";

		        Logger.debug.println(this, "DeptAddress_vt : "+ DeptAddress_vt.toString());
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