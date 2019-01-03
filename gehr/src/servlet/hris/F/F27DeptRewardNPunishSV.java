/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : �ο���Ȳ
*   Program Name : �μ��� ����/¡�� ����
*   Program ID   : F27DeptRewardNPunishSV
*   Description  : �μ��� ����/¡�� ���� ��ȸ�� ���� ����
*   Note         : ����
*   Creation     :
*   Update       :
********************************************************************************/

package servlet.hris.F;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import hris.F.F27DeptRewardNPunish01Data;
import hris.F.F27DeptRewardNPunish01GlobalData;
import hris.F.F27DeptRewardNPunish02Data;
import hris.F.F27DeptRewardNPunish02GlobalData;
import hris.F.rfc.F27DeptRewardNPunishRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.HashMap;
import java.util.Vector;

/**
 * F27DeptRewardNPunishSV
 * �μ��� ���� ��ü �μ����� ����/¡�� ���� ������ ��������
 * F27DeptRewardNPunishRFC �� ȣ���ϴ� ���� class
 * @author
 * @version 1.0
 */
public class F27DeptRewardNPunishSV extends EHRBaseServlet {

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
	        F27DeptRewardNPunishRFC f27Rfc = null;
	        Vector DeptReward_vt  = null;
	        Vector DeptPunish_vt  = null;

	        if ( !deptId.equals("") ) {
	        	f27Rfc       = new F27DeptRewardNPunishRFC();
	            DeptReward_vt  = new Vector();
		        DeptPunish_vt  = new Vector();
	            ret = f27Rfc.getDeptRewardNPunish(deptId, checkYN, userArea);

	            RfcSuccess   = f27Rfc.getReturn().isSuccess();
            	E_MESSAGE = f27Rfc.getReturn().MSGTX;

	            DeptReward_vt = (Vector)ret.get(0);
	            DeptPunish_vt = (Vector)ret.get(1);
	        }

	        //RFC ȣ�� ������.
	        if( RfcSuccess ){
	        	req.setAttribute("checkYn", checkYN);
		        req.setAttribute("DeptReward_vt", DeptReward_vt);
		        req.setAttribute("DeptPunish_vt", DeptPunish_vt);

				HashMap<String, Integer> empCnt = new HashMap<String, Integer>();
				int cnt = 0;
				String oldPer = "";

				for (int i = 0; i < DeptReward_vt.size(); i++) {
					if( userArea ){
						F27DeptRewardNPunish01Data data = (F27DeptRewardNPunish01Data) DeptReward_vt.get(i);
						if (oldPer.equals(data.PERNR) || (i == 0)) {
							cnt++;
						} else {
							empCnt.put(oldPer, cnt);
							cnt = 1;
						}
						if (i == DeptReward_vt.size() - 1) {
							empCnt.put(data.PERNR, cnt);
						}
						oldPer = data.PERNR;
					}else{
						F27DeptRewardNPunish01GlobalData data = (F27DeptRewardNPunish01GlobalData) DeptReward_vt.get(i);
						if (oldPer.equals(data.PERNR) || (i == 0)) {
							cnt++;
						} else {
							empCnt.put(oldPer, cnt);
							cnt = 1;
						}
						if (i == DeptReward_vt.size() - 1) {
							empCnt.put(data.PERNR, cnt);
						}
						oldPer = data.PERNR;
					}
				}
				req.setAttribute("empCnt1", empCnt);


				empCnt = new HashMap<String, Integer>();
				cnt = 0;
				oldPer = "";
				for (int i = 0; i < DeptPunish_vt.size(); i++) {
					if( userArea ){
						F27DeptRewardNPunish02Data data = (F27DeptRewardNPunish02Data) DeptPunish_vt.get(i);
						if (oldPer.equals(data.PERNR) || (i == 0)) {
							cnt++;
						} else {
							empCnt.put(oldPer, cnt);
							cnt = 1;
						}
						if (i == DeptPunish_vt.size() - 1) {
							empCnt.put(data.PERNR, cnt);
						}
						oldPer = data.PERNR;
					}else{
						F27DeptRewardNPunish02GlobalData data = (F27DeptRewardNPunish02GlobalData) DeptPunish_vt.get(i);
						if (oldPer.equals(data.PERNR) || (i == 0)) {
							cnt++;
						} else {
							empCnt.put(oldPer, cnt);
							cnt = 1;
						}
						if (i == DeptPunish_vt.size() - 1) {
							empCnt.put(data.PERNR, cnt);
						}
						oldPer = data.PERNR;

					}
				}
				req.setAttribute("empCnt2", empCnt);

		        if( excelDown.equals("ED") ) //���������� ���.
		            dest = WebUtil.JspURL+"F/F27DeptRewardNPunishExcel.jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F27DeptRewardNPunish.jsp";

		    //RFC ȣ�� ���н�.
	        }else{
	        	throw new GeneralException(E_MESSAGE);
	        }


	        Logger.debug.println(this, " destributed = " + dest);
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}