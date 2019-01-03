/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : ����                                                        */
/*   Program Name : �ϰ� ���� ����ǥ                                            */
/*   Program ID   : F43DeptDayWorkConditionSV                                   */
/*   Description  : �μ��� �ϰ� ���� ����ǥ ��ȸ�� ���� ����                  */
/*   Note         : ����                                                        */
/*   Creation     : 2005-02-17 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.F;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.servlet.*;

import hris.F.rfc.*;
import hris.common.WebUserData;

/**
 * F43DeptDayWorkConditionSV
 * �μ��� ���� ��ü �μ����� �ϰ� ���� ����ǥ ������ ��������
 * F42DeptMonthWorkConditionRFC �� ȣ���ϴ� ���� class
 *
 * @author  �����
 * @version 1.0
 */
public class F43DeptDayWorkConditionSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{
	        HttpSession session = req.getSession(false);
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//�μ��ڵ�...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//�����μ�����.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
            String year   = WebUtil.nvl(req.getParameter("year1"));
            String month  = WebUtil.nvl(req.getParameter("month1"));
            String yymmdd   = "";
	        WebUserData user    = (WebUserData)session.getAttribute("user");				//����.
	        String subView       = WebUtil.nvl(req.getParameter("subView"));				//tab���� ȣ��Ǵ��� ����

            //�ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
            if( deptId.equals("") ){
            	deptId = user.e_objid;
            }
			if(year.equals("")||month.equals("")){
				yymmdd = DataUtil.getCurrentDate();
			} else {
				yymmdd = year + month + "20";
			}

	        String dest    		= "";
	        String E_RETURN  	= "";
	        //String E_MESSAGE 	= "�μ� ������ �������µ� �����Ͽ����ϴ�.";
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007");
	        String E_YYYYMON 	= "";
	        String E_DAY_CNT 	= "";



	        /*************************************************************
	         * @$ ���������� marco257
	         * ���ǿ� �ִ� e_timeadmin = Y �� ����� �μ� ���� ������ ����.
	         * user.e_authorization.equals("E") ���� !user.e_timeadmin.equals("Y")�� ����
	         *
	         * @ sMenuCode �ڵ� �߰�
	         * �μ����� ������ �ִ� ����� MSS������ �ִ� ����� üũ�ϱ� ���� �߰�
	         * 1406 : �μ����� ������ �ִ� �޴��ڵ�(e_timeadmin ���� üũ)
	         * 1184 : �μ��λ������� -> ������� -> ���� -> �������� ����ǥ�� ������ �ִ»��
	         * �߰�: �޴� �ڵ尡 ������� ���� ������ �켱�Ѵ�.
	         *  (e_timeadmin ���� üũ���� )
	         **************************************************************/

	        String sMenuCode = WebUtil.nvl(req.getParameter("sMenuCode"));
	        //Logger.debug.println(this, sMenuCode + " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+user.e_timeadmin+checkTimeAuthorization(req, res));

	        Logger.debug(sMenuCode + " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+user.e_timeadmin);
	        if(sMenuCode.equals("ESS_HRA_DAIL_STATE")){                            //�����λ����� > ��û > �μ�����
	        	if(!checkTimeAuthorization(req, res)) return;
	        }else{                                                               //�μ��λ�����
//	    	 @����༺ �߰�
	        	if ( user.e_authorization.equals("E")) {
	        		if(!checkTimeAuthorization(req, res)) return;
	        	}
	        }



	        F42DeptMonthWorkConditionRFC func    = null;
	        Vector F43DeptDayTitle_vt  = null;
	        Vector F43DeptDayData_vt   = null;

	        if ( !deptId.equals("") ) {
	        	func       				= new F42DeptMonthWorkConditionRFC();
	        	F43DeptDayTitle_vt  	= new Vector();
	        	F43DeptDayData_vt  		= new Vector();
	            Vector ret 				= func.getDeptMonthWorkCondition(deptId, yymmdd, "","2", checkYN,user.sapType,user.area);	// �ϰ� '2' set!

	            E_RETURN   				= (String)ret.get(0);
	            E_MESSAGE  				= (String)ret.get(1);
	            E_YYYYMON  				= (String)ret.get(2);

	            F43DeptDayTitle_vt 		= (Vector)ret.get(3);
	            F43DeptDayData_vt 		= (Vector)ret.get(4);
            	E_DAY_CNT  				= (String)ret.get(5); // ���ڼ�
	        }
	        Logger.debug.println(this, " E_RETURN = " + E_RETURN);

	        //RFC ȣ�� ������.
	        if(func.getReturn().isSuccess()){
		        req.setAttribute("checkYn", checkYN);
		        req.setAttribute("E_YYYYMON", E_YYYYMON);
		        req.setAttribute("E_DAY_CNT", E_DAY_CNT);
		        req.setAttribute("F43DeptDayTitle_vt", F43DeptDayTitle_vt);
		        req.setAttribute("F43DeptDayData_vt", F43DeptDayData_vt);
		        req.setAttribute("subView", subView);
	        	Logger.debug.println(this, " subView = " + subView);
		        if( excelDown.equals("ED") ) //���������� ���.
		            dest = WebUtil.JspURL+"F/F43DeptDayWorkConditionExcel_KR.jsp";
		        else if( excelDown.equals("print") ) //����� ���.
		            dest = WebUtil.JspURL+"F/F43DeptDayWorkConditionPrint_KR.jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F43DeptDayWorkCondition_KR.jsp";

		        Logger.debug.println(this, "F43DeptDayTitle_vt : "+ F43DeptDayTitle_vt.toString());
		        Logger.debug.println(this, "F43DeptDayData_vt : "+ F43DeptDayData_vt.toString());
		    //RFC ȣ�� ���н�.
	        }else{
		        String msg = E_MESSAGE;
                String url = "history.back();";
		        //String url = "location.href = '"+WebUtil.JspURL+"F/F43DeptDayWorkCondition.jsp?checkYn="+checkYN+"';";
		        req.setAttribute("msg", msg);
		        req.setAttribute("url", url);
		        dest = WebUtil.JspURL+"common/caution.jsp";
	        }

	        Logger.debug.println(this, " destributed = " + dest);
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}