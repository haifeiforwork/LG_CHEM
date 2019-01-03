/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : �ο���Ȳ
*   Program Name : �ҼӺ�/���޺� ��տ���
*   Program ID   : F07DeptPositionClassAgeSV
*   Description  : �ҼӺ�/���޺� ��տ��� ��ȸ�� ���� ����
*   Note         : ����
*   Creation     :
*   Update       :
*
********************************************************************************/

package servlet.hris.F;

import java.util.HashMap;
import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.F.F07DeptPositionClassAgeTitleGlobalData;
import hris.F.rfc.*;
import hris.common.WebUserData;

/**
 * F07DeptPositionClassAgeSV
 * �μ��� ���� �ҼӺ�/���޺� ��տ��� ������ ��������
 * F07DeptPositionClassAgeRFC �� ȣ���ϴ� ���� class
 * @author
 * @version 1.0
 */
public class F07DeptPositionClassAgeSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException{
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

            Vector ret                                  = null;
            Vector F07DeptAgeTitle_vt		= null;
            Vector F07DeptAgeNote_vt		= null;
	        boolean RfcSuccess                  = false;

            if ( !deptId.equals("") ) {
            	F07DeptAgeTitle_vt			= new Vector();
            	if( userArea ){
            		F07DeptPositionClassAgeRFC f07Rfc = null;
            		f07Rfc = new F07DeptPositionClassAgeRFC();
            		ret                                   = f07Rfc.getDeptPositionClassAge(deptId, checkYN, user.area.getMolga());

	            	RfcSuccess = f07Rfc.getReturn().isSuccess();
	            	E_MESSAGE = f07Rfc.getReturn().MSGTX;
            	}else{
            		F07DeptPositionClassAgeGlobalRFC f07RfcG = null;
            		f07RfcG = new F07DeptPositionClassAgeGlobalRFC();
            		ret                                   = f07RfcG.getDeptPositionClassAge(deptId, checkYN, user.area.getMolga());

            		RfcSuccess = f07RfcG.getReturn().isSuccess();
            		E_MESSAGE = f07RfcG.getReturn().MSGTX;
            	}

				F07DeptAgeTitle_vt			= (Vector)ret.get(0);
				if( userArea ){
					F07DeptAgeNote_vt			= (Vector)ret.get(1);
				}
            }

	        //RFC ȣ�� ������.
	        if( RfcSuccess ){
		        req.setAttribute("checkYn", checkYN);
		        if( userArea ){
			        req.setAttribute("F07DeptAgeTitle_vt", F07DeptAgeTitle_vt);
			        req.setAttribute("F07DeptAgeNote_vt", F07DeptAgeNote_vt);
		        }else{
		        	req.setAttribute("F07DeptAgeTitle_vt", dataFilter(F07DeptAgeTitle_vt));
		        	req.setAttribute("meta", doWithData(F07DeptAgeTitle_vt) );
		        }
		        String returnDest = "";
		        if( !userArea ) returnDest = "_Global";
		        if( excelDown.equals("ED") ) //���������� ���.
		            dest = WebUtil.JspURL+"F/F07DeptPositionClassAgeExcel"+ returnDest + ".jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F07DeptPositionClassAge"+ returnDest + ".jsp";
		    //RFC ȣ�� ���н�.
	        }else{
	        	throw new GeneralException(E_MESSAGE);
	        }
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }

	/**
	 * @param deptPositionClassTitle_vt
	 * if ZLEVEL is 2 or null, clear data
	 * @return
	 */
	private Vector dataFilter(Vector deptPositionClassTitle_vt) {
		Vector ret = new Vector();
		boolean flag = false;
		for (int i = 0; i < deptPositionClassTitle_vt.size(); i++) {
			F07DeptPositionClassAgeTitleGlobalData entity = (F07DeptPositionClassAgeTitleGlobalData) deptPositionClassTitle_vt.get(i);
			if (entity.ZLEVEL == null || entity.ZLEVEL.equals("1")) {// ||
				entity = (F07DeptPositionClassAgeTitleGlobalData) hris.common.util.AppUtil.initEntity(entity, "0", "");
				flag = true;
			}
			ret.addElement(entity);
		}
		if (!flag) {
			ret = new Vector();
			for (int i = 0; i < deptPositionClassTitle_vt.size(); i++) {
				F07DeptPositionClassAgeTitleGlobalData entity = (F07DeptPositionClassAgeTitleGlobalData) deptPositionClassTitle_vt.get(i);
				if (entity.ZLEVEL == null || entity.ZLEVEL.equals("2")) {// ||
					entity = (F07DeptPositionClassAgeTitleGlobalData) hris.common.util.AppUtil.initEntity(entity, "0", "");
				}
				ret.addElement(entity);
			}
		}
		return ret;
	}

	//calculate rowspan
	private HashMap doWithData(Vector deptServiceTitle_vt) {
		HashMap tmp = new HashMap<String, Integer>();
		for (int i = 0; i < deptServiceTitle_vt.size(); i++) {
			F07DeptPositionClassAgeTitleGlobalData entity = (F07DeptPositionClassAgeTitleGlobalData) deptServiceTitle_vt.get(i);
			if (tmp.containsKey(entity.STEXT + entity.OBJID)) {
				Integer tmpStr = (Integer) tmp.get(entity.STEXT + entity.OBJID);
				tmp.put(entity.STEXT + entity.OBJID, tmpStr.intValue() + 1);
			} else {
				tmp.put(entity.STEXT + entity.OBJID, 1);
			}
		}
		return tmp;
	}
}