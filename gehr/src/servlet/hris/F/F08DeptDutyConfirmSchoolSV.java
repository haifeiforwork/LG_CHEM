/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : �ο���Ȳ
*   Program Name : ������/�����зº�
*   Program ID   : F08DeptDutyConfirmSchoolSV
*   Description  : ������/�����зº� ��ȸ�� ���� ����
*   Note         : ����
*   Creation     :
*   Update       :
*
********************************************************************************/

package servlet.hris.F;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import hris.F.F08DeptDutySchoolTitleGlobalData;
import hris.F.rfc.F08DeptDutyConfirmSchoolGlobalRFC;
import hris.F.rfc.F08DeptDutyConfirmSchoolRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.HashMap;
import java.util.Vector;

/**
 * F08DeptDutyConfirmSchoolSV
 * �μ��� ���� ������/�����зº� ������ ��������
 * F08DeptDutyConfirmSchoolRFC �� ȣ���ϴ� ���� class
 * @author
 * @version 1.0
 */
public class F08DeptDutyConfirmSchoolSV extends EHRBaseServlet {

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
           	 * @$ ����������
           	 * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ
           	 */
           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}

		    // ����༺ �߰�
            if(!checkAuthorization(req, res)) return;

            Vector ret                                  = null;
	        Vector F08DeptDutySchoolTitle_vt		= null;
	        Vector F08DeptDutySchoolNote_vt		= null;
	        boolean RfcSuccess                  = false;

	        if ( !deptId.equals("") ) {
	        	F08DeptDutySchoolTitle_vt = new Vector();

	        	if( userArea ){
	        		F08DeptDutyConfirmSchoolRFC f08Rfc = null;
	        		f08Rfc                               = new F08DeptDutyConfirmSchoolRFC();
					ret                                   = f08Rfc.getDeptDutyConfirmSchool(deptId, checkYN, user.area.getMolga());

	            	RfcSuccess = f08Rfc.getReturn().isSuccess();
	            	E_MESSAGE = f08Rfc.getReturn().MSGTX;
				}else {
					F08DeptDutyConfirmSchoolGlobalRFC f08RfcG = null;
					f08RfcG    						                = new F08DeptDutyConfirmSchoolGlobalRFC();
	            	ret 						                       = f08RfcG.getDeptDutyConfirmSchool(deptId, checkYN, user.area.getMolga());

	            	RfcSuccess = f08RfcG.getReturn().isSuccess();
	            	E_MESSAGE = f08RfcG.getReturn().MSGTX;
	            }
				F08DeptDutySchoolTitle_vt	= (Vector)ret.get(0);
	            if( userArea ){
	            	F08DeptDutySchoolNote_vt	= (Vector)ret.get(1);
	            }
	        }

	        //RFC ȣ�� ������.
	        if( RfcSuccess ){
		        req.setAttribute("checkYn", checkYN);
		        if( userArea ){
		        	req.setAttribute("F08DeptDutySchoolTitle_vt", F08DeptDutySchoolTitle_vt);
		        	req.setAttribute("F08DeptDutySchoolNote_vt", F08DeptDutySchoolNote_vt);
		        }else{
		        	req.setAttribute("F08DeptDutySchoolTitle_vt", dataFilter(F08DeptDutySchoolTitle_vt));
		        	req.setAttribute("meta", doWithData(F08DeptDutySchoolTitle_vt) );
		        }
		        String returnDest = "";
		        if( !userArea ) returnDest = "_Global";
		        if( excelDown.equals("ED") ) //���������� ���.
		            dest = WebUtil.JspURL+"F/F08DeptDutyConfirmSchoolExcel"+ returnDest + ".jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F08DeptDutyConfirmSchool"+ returnDest + ".jsp";

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
	private Vector dataFilter(Vector F08DeptPositionClassTitle_vt) {
		Vector ret = new Vector();
		boolean flag = false;
		for(int i = 0 ; i < F08DeptPositionClassTitle_vt.size() ; i ++){
			F08DeptDutySchoolTitleGlobalData entity = (F08DeptDutySchoolTitleGlobalData) F08DeptPositionClassTitle_vt.get(i);
			if(entity.ZLEVEL == null || entity.ZLEVEL.equals("1")){// || entity.ZLEVEL.equals("2")){
				entity = (F08DeptDutySchoolTitleGlobalData)hris.common.util.AppUtil.initEntity( entity , "0" , "");
				flag = true;
			}
			ret.addElement(entity);
		}
		if(!flag){
			ret = new Vector();
			for (int i = 0; i < F08DeptPositionClassTitle_vt.size() ; i++) {
				F08DeptDutySchoolTitleGlobalData entity = (F08DeptDutySchoolTitleGlobalData) F08DeptPositionClassTitle_vt.get(i);
				if(entity.ZLEVEL == null || entity.ZLEVEL.equals("2")){// || entity.ZLEVEL.equals("2")){
					entity = (F08DeptDutySchoolTitleGlobalData)hris.common.util.AppUtil.initEntity( entity , "0" , "");
				}
				ret.addElement(entity);
			}
		}
		return ret;
	}

	//calculate rowspan
	private HashMap doWithData(Vector deptServiceTitle_vt) {
		HashMap tmp = new HashMap<String, Integer>();
		for ( int i = 0; i < deptServiceTitle_vt.size(); i++ ) {
			F08DeptDutySchoolTitleGlobalData entity = (F08DeptDutySchoolTitleGlobalData) deptServiceTitle_vt.get(i);
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