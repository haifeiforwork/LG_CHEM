/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : �ο���Ȳ
*   Program Name : ��å��/���޺� �ο���Ȳ
*   Program ID   : F05DeptGradeClassSV
*   Description  : ��å��/���޺� �ο���Ȳ ��ȸ�� ���� ����
*   Note         : ����
*   Creation     :
*   Update       :
*
********************************************************************************/

package servlet.hris.F;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import hris.F.F05DeptGradeClassTitleGlobalData;
import hris.F.rfc.F05DeptGradeClassGlobalRFC;
import hris.F.rfc.F05DeptGradeClassRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.HashMap;
import java.util.Vector;

/**
 * F05DeptGradeClassSV
 * �μ��� ���� ��å��/���޺� �ο���Ȳ ������ ��������
 * F05DeptGradeClassRFC �� ȣ���ϴ� ���� class
 * @author
 * @version 1.0
 */
public class F05DeptGradeClassSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
    	try{
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//�μ��ڵ�...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//�����μ�����.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
	        WebUserData user = WebUtil.getSessionUser(req);		                            //����
	        boolean userArea = user.area.toString().equals("KR");

            //�ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
            if( deptId.equals("") ){
               	deptId = user.e_objid;
            }

	        String dest    		= "";
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

            Vector ret                               = null;
            Vector F05DeptGradeClassTitle_vt	= null;
            Vector F05DeptGradeClassNote_vt		= null;
            boolean RfcSuccess                  = false;

            if ( !deptId.equals("") ) {

            	F05DeptGradeClassTitle_vt = new Vector();

				if( userArea ){
					F05DeptGradeClassRFC f05Rfc = null;
					f05Rfc                               = new F05DeptGradeClassRFC();
					ret                                   = f05Rfc.getDeptGradeClass(deptId, checkYN, user.area.getMolga());

	            	RfcSuccess = f05Rfc.getReturn().isSuccess();
	            	E_MESSAGE = f05Rfc.getReturn().MSGTX;
				}else {
					F05DeptGradeClassGlobalRFC f05RfcG = null;
					f05RfcG    						                = new F05DeptGradeClassGlobalRFC();
	            	ret 						                       = f05RfcG.getDeptGradeClass(deptId, checkYN, user.area.getMolga());

	            	RfcSuccess = f05RfcG.getReturn().isSuccess();
	            	E_MESSAGE = f05RfcG.getReturn().MSGTX;

	            }
				F05DeptGradeClassTitle_vt	= (Vector)ret.get(0);
	            if( userArea ){
	            	F05DeptGradeClassNote_vt	= (Vector)ret.get(1);
	            }
            }
	        //RFC ȣ�� ������.
	        if( RfcSuccess ){
		        req.setAttribute("checkYn", checkYN);
		        req.setAttribute("F05DeptGradeClassTitle_vt", F05DeptGradeClassTitle_vt);
		        if( userArea ){
		        	req.setAttribute("F05DeptGradeClassNote_vt", F05DeptGradeClassNote_vt);
		        }else{
		        	 req.setAttribute("meta", doWithData(F05DeptGradeClassTitle_vt) );
		        }
		        String returnDest = "";
		        if( !userArea ) returnDest = "_Global";
		        if( excelDown.equals("ED") ) //���������� ���.
		            dest = WebUtil.JspURL+"F/F05DeptGradeClassExcel"+ returnDest + ".jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F05DeptGradeClass"+ returnDest + ".jsp";

		    //RFC ȣ�� ���н�.
	        }else{
	        	throw new GeneralException(E_MESSAGE);
	        }
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }

	//calculate rowspan
	private HashMap doWithData(Vector deptServiceTitle_vt) {
		HashMap<String, Integer> tmp = new HashMap<String, Integer>();
		for ( int i = 0; i < deptServiceTitle_vt.size(); i++ ) {
			F05DeptGradeClassTitleGlobalData entity = (F05DeptGradeClassTitleGlobalData) deptServiceTitle_vt.get(i);
			if (tmp.containsKey(entity.PBTXT)) {
				Integer tmpStr = (Integer) tmp.get(entity.PBTXT);
				int val = tmpStr.intValue() + 1;
				tmp.put(entity.PBTXT, val);
			} else {
				tmp.put(entity.PBTXT, 1);
			}
		}
		return tmp;
	}
}