/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : ����                                                        */
/*   Program Name : �ٹ� ��ȹǥ                                                 */
/*   Program ID   : F44DeptWorkScheduleSV                                       */
/*   Description  : �μ��� �ٹ� ��ȹǥ ��ȸ�� ���� ����                       */
/*   Note         : ����                                                        */
/*   Creation     : 2005-02-18 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.F;

import com.common.RFCReturnEntity;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.F.rfc.F44DeptWorkScheduleRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * F44DeptWorkScheduleSV
 * �μ��� ���� ��ü �μ����� �ٹ� ��ȹǥ ������ ��������
 * F44DeptWorkScheduleRFC �� ȣ���ϴ� ���� class
 *
 * @author  �����
 * @version 1.0
 */
public class F44DeptWorkScheduleSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{
	        HttpSession session = req.getSession(false);
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//�μ��ڵ�...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//�����μ�����.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
	        WebUserData user    = (WebUserData)session.getAttribute("user");				//����.
	        String E_BEGDA 		= "";
	        String E_ENDDA 		= "";
	        String dest_detail = "";
	        String dest    		= "";
	        String E_RETURN  	= "";
	        //String E_MESSAGE 	= "�μ� ������ �������µ� �����Ͽ����ϴ�.";
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007") ;
	        String yyyymm = "";
	        String subView       = WebUtil.nvl(req.getParameter("subView"));				//tab���� ȣ��Ǵ��� ����

            //�ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
            if( deptId.equals("") ){
            	deptId = user.e_objid;
            }
	        if (!user.sapType.isLocal() ){
	        	dest_detail="Global";
	        	String year = WebUtil.nvl(req.getParameter("year1"));
	        	String month = WebUtil.nvl(req.getParameter("month1"));
	        	if (year.equals("") || month.equals("")) {
	        		yyyymm = DataUtil.getCurrentDate().toString().substring(0, 6);
	        	} else {
	        		yyyymm = year + month;
	        	}
	         }else {
	        	 dest_detail="KR";
	         }
	            	/**
	            	 * @$ ���������� rdcamel
	            	 * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ
	            	 */
	 			   if(!checkBelongGroup(req, res, deptId, "")) return;
	         	// @����༺ �߰�
	 			   if(!checkAuthorization(req, res)) return;


		        F44DeptWorkScheduleRFC func    	= null;
		        Vector F44DeptScheduleTitle_vt 	= null;
		        Vector F44DeptScheduleData_vt  	= null;
		        Vector T_TPROG  						= null;

		        if ( !deptId.equals("") ) {
		        	func       				= new F44DeptWorkScheduleRFC();
		        	F44DeptScheduleTitle_vt	= new Vector();
		        	F44DeptScheduleData_vt	= new Vector();
		        	Vector ret 				= func.getDeptWorkSchedule(user.sapType,deptId, checkYN ,yyyymm);
		            E_RETURN   				= (String)ret.get(0);
		            E_MESSAGE  				= (String)ret.get(1);
		            F44DeptScheduleTitle_vt	= (Vector)ret.get(2);
		            F44DeptScheduleData_vt	= (Vector)ret.get(3);
		            if (user.sapType.isLocal()){
			            E_BEGDA  				= (String)ret.get(4);
			            E_ENDDA  				= (String)ret.get(5);
			            T_TPROG  				= (Vector)ret.get(6);	//���ϱٹ����� ���� �߰� 2018-02-09
		            }

		        }
		        Logger.debug.println(this, " E_RETURN = " + E_RETURN);
		        RFCReturnEntity result = func.getReturn();
		        req.setAttribute("subView", subView);
		        //RFC ȣ�� ������.
		        if( result.isSuccess()){
			        req.setAttribute("checkYn", checkYN);
			        req.setAttribute("E_BEGDA", E_BEGDA);
			        req.setAttribute("E_ENDDA", E_ENDDA);
			        req.setAttribute("E_YYYYMON", yyyymm);
			        req.setAttribute("F44DeptScheduleTitle_vt", F44DeptScheduleTitle_vt);
			        req.setAttribute("F44DeptScheduleData_vt", F44DeptScheduleData_vt);
			        req.setAttribute("T_TPROG", T_TPROG);	//���ϱٹ����� ���� �߰� 2018-02-09
		        	Logger.debug.println(this, " subView = " + subView);
			        if( excelDown.equals("ED") ) //���������� ���.
			            dest = WebUtil.JspURL+"F/F44DeptWorkScheduleExcel_"+dest_detail+".jsp";
			        else
			        	dest = WebUtil.JspURL+"F/F44DeptWorkSchedule_"+dest_detail+".jsp";

			        Logger.debug.println(this, "F44DeptScheduleTitle_vt : "+ F44DeptScheduleTitle_vt.toString());
			        Logger.debug.println(this, "F44DeptScheduleData_vt : "+ F44DeptScheduleData_vt.toString());
			    //RFC ȣ�� ���н�.
		        }else{
		        	req.setAttribute("checkYn", checkYN);
					req.setAttribute("E_YYYYMON", yyyymm);
					req.setAttribute("F44DeptScheduleTitle_vt",	F44DeptScheduleTitle_vt);
					req.setAttribute("F44DeptScheduleData_vt",	F44DeptScheduleData_vt);
			        String msg = E_MESSAGE;
			        String url = "location.href = '"+WebUtil.JspURL+"F/F44DeptWorkSchedule_"+dest_detail+".jsp?checkYn="+checkYN+"';";
			        //String url = "history.back();";
			        req.setAttribute("msg", msg);
			        req.setAttribute("url", url);
			        dest = WebUtil.JspURL + "F/F44DeptWorkSchedule_"+dest_detail+".jsp";
		        }

	        Logger.debug.println(this, " destributed = " + dest);
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}