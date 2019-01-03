/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : ����                                                        		*/
/*   Program Name : �μ��� �ް� ��� ��Ȳ                                       		*/
/*   Program ID   : F41DeptVacationSV                                           */
/*   Description  : �μ��� �ް� ��� ��Ȳ ��ȸ�� ���� ����                    		*/
/*   Note         : ����                                                        		*/
/*   Creation     : 2005-02-21 �����                                           		*/
/*   Update       : 2018-05-18 ��ȯ�� [WorkTime52] �����ް� �߰� ��				*/
/*                                                                              */
/********************************************************************************/

package servlet.hris.F;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import hris.F.rfc.F41DeptVacationNTMRFC;
import hris.F.rfc.F41DeptVacationRFC;
import hris.common.WebUserData;

/**
 * F41DeptVacationSV
 * �μ��� ���� ��ü �μ����� �ް� ��� ��Ȳ ������ ��������
 * F41DeptVacationRFC �� ȣ���ϴ� ���� class
 *
 * @author  �����
 * @version 1.0
 */
public class F41DeptVacationSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{
	        HttpSession session = req.getSession(false);
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//�μ��ڵ�...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//�����μ�����.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
	        WebUserData user    = (WebUserData)session.getAttribute("user");				//����.
	        String subView       = WebUtil.nvl(req.getParameter("subView"));				//tab���� ȣ��Ǵ��� ����

            //�ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
            if( deptId.equals("") ){
            	deptId = user.e_objid;
            }


	        String dest    		= "";
	        String E_RETURN  	= "";
	        String dest_deail = "";
	        //String E_MESSAGE 	= "�μ� ������ �������µ� �����Ͽ����ϴ�.";
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007") ;

	        if (!user.sapType.isLocal()){
	        	dest_deail = "Global";
	        }else {
	        	dest_deail = "KR";
		        if(  !user.e_timeadmin.equals("Y")&&!checkBelongGroup(req, res, deptId, "") ) return;
	        }

		        Vector DeptVacation_vt  = null;

		        if ( !deptId.equals("") ) {
		        	DeptVacation_vt  		= new Vector();
		            Vector ret 				= null;
		            
		            if(!user.sapType.isLocal()) {
		            	F41DeptVacationRFC func = new F41DeptVacationRFC();
		            	ret = func.getDeptVacation( user.sapType, deptId, checkYN);
		            } else {
		            	F41DeptVacationNTMRFC func = new F41DeptVacationNTMRFC();
		            	ret = func.getDeptVacation( user.sapType, deptId, checkYN);
		            }

		            E_RETURN   				= (String)ret.get(0);
		            E_MESSAGE  				= (String)ret.get(1);
		            DeptVacation_vt 		= (Vector)ret.get(2);
		        }
		        Logger.debug.println(this, " E_RETURN = " + E_RETURN);
	        	req.setAttribute("checkYn", checkYN);
		        //RFC ȣ�� ������.
		       // if(func.getReturn().isSuccess()){

			        req.setAttribute("DeptVacation_vt", DeptVacation_vt);
			        req.setAttribute("subView", subView);
		        	Logger.debug.println(this, " subView = " + subView);
			        if( excelDown.equals("ED") ) //���������� ���.
			            	dest = WebUtil.JspURL+"F/F41DeptVacationExcel_"+dest_deail+".jsp";
			        else
			        	dest = WebUtil.JspURL+"F/F41DeptVacation_"+dest_deail+".jsp";
			        Logger.debug.println(this, "DeptVacation_vt : "+ DeptVacation_vt.toString());
			    //RFC ȣ�� ���н�.
		        /*}else{
			        String msg = E_MESSAGE;
			        String url = "location.href = '"+WebUtil.JspURL+"F/F41DeptVacation_"+dest_deail+".jsp?checkYn="+checkYN+"';";
			        req.setAttribute("msg", msg);
			        req.setAttribute("url", url);
			        Logger.debug.println(this, " url = " + url);
			        dest = WebUtil.JspURL+"common/msg.jsp";
		        }*/

	        Logger.debug.println(this, " destributed = " + dest);
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}