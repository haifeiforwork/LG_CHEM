/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : �ο���Ȳ
*   Program Name : �ο���Ȳ ������ ��ȭ��
*   Program ID   : F00DeptDetailListSV
*   Description  : �ο���Ȳ ������ ��ȭ�� ��ȸ�� ���� ����
*   Note         : ����
*   Creation     :
*   Update       :
*
********************************************************************************/

package servlet.hris.F;

import hris.F.rfc.F00DeptDetailListGlobalRFC;
import hris.F.rfc.F00DeptDetailListRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

/**
 * F02DeptPositionDutySV
 * �ο���Ȳ ������ ��ȭ�� ������ ��������
 * F00DeptDetailListRFC �� ȣ���ϴ� ���� class
 * @author
 * @version 1.0
 */
public class F00DeptDetailListSV extends EHRBaseServlet {
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
    	try{
	        Box         box 	= WebUtil.getBox(req);
	        WebUserData user = WebUtil.getSessionUser(req);	  //����
	        boolean userArea = user.area.toString().equals("KR");

	        String gubun  	= box.get("hdn_gubun");		//���а�.
	        String deptId 	= box.get("hdn_deptId");	//�μ��ڵ�
	        String checkYN	= box.get("chck_yeno");		//�����μ�����.
	        String paramA 	= box.get("hdn_paramA");	//�Ķ��Ÿ
	        String paramB 	= box.get("hdn_paramB");	//�Ķ��Ÿ
	        String paramC 	= box.get("hdn_paramC");	//�Ķ��Ÿ
	        String paramD 	= box.get("hdn_paramD");	//�Ķ��Ÿ
	        String paramE 	= box.get("hdn_paramE");	//�Ķ��Ÿ
	        String paramF = "";
	        if( !userArea ){
	        	paramF 	= box.get("hdn_paramF");;
	        }
	        String excel  	= box.get("hdn_excel");		//��������.

	        String dest    		= "";
	        boolean E_RETURN  	=false;
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007"); //"�� ������ �������µ� �����Ͽ����ϴ�.";

           	/**
           	 * @$ ����������
           	 * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ
           	 */
           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}

		    // ����༺ �߰�
            if(!checkAuthorization(req, res)) return;

            Vector F00DeptDetailListData_vt = null;
            F00DeptDetailListData_vt		    = new Vector();
            Vector ret                               = null;

	        if ( !gubun.equals("") && !deptId.equals("") ) {
	        	if( userArea ){
	        		F00DeptDetailListRFC f00Rfc  = null;
	        		f00Rfc       						   = new F00DeptDetailListRFC();

	        		ret 						           = f00Rfc.getDeptDetailList(gubun, deptId, checkYN, user.area.getMolga(), paramA, paramB, paramC, paramD, paramE);

	        		E_RETURN = f00Rfc.getReturn().isSuccess();
	        		E_MESSAGE = f00Rfc.getReturn().MSGTX;
	        	}else{
	        		F00DeptDetailListGlobalRFC f00RfcG  = null;
	        		f00RfcG       						   = new F00DeptDetailListGlobalRFC();
	        		ret 						               = f00RfcG.getDeptDetailList(gubun, deptId, checkYN, user.area.getMolga(), paramA, paramB, paramC, paramD, paramE, paramF);

	        		E_RETURN = f00RfcG.getReturn().isSuccess();
	            	E_MESSAGE = f00RfcG.getReturn().MSGTX;
	        	}
	            F00DeptDetailListData_vt		= (Vector)ret.get(0);
	        }

	        //RFC ȣ�� ������.
	        if( E_RETURN ){

		        req.setAttribute("F00DeptDetailListData_vt", F00DeptDetailListData_vt);
		        String returnDest = "";
		        if( !userArea ) returnDest = "_Global";
		        if( excel.equals("ED") ) //���������� ���.
		            dest = WebUtil.JspURL+"F/F00DeptDetailListExcel"+ returnDest + ".jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F00DeptDetailList"+ returnDest + ".jsp";
	        }else{
	        	throw new GeneralException(E_MESSAGE);
	        }
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}