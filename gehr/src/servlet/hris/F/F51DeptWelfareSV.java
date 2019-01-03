/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : �����Ļ�                                                    */
/*   Program Name : �μ��� �����Ļ� ��Ȳ                                        */
/*   Program ID   : F51DeptWelfareSV                                            */
/*   Description  : �μ��� �����Ļ� ��Ȳ ��ȸ�� ���� ����                     */
/*   Note         : ����                                                        */
/*   Creation     : 2005-02-21 �����                                           */
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
import hris.F.rfc.F51DeptWelfareRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * F51DeptWelfareSV
 * �μ��� ���� ��ü �μ����� �����Ļ� ��Ȳ ������ ��������
 * F51DeptWelfareRFC �� ȣ���ϴ� ���� class
 *
 * @author  �����
 * @version 1.0
 */
public class F51DeptWelfareSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{
	        HttpSession session = req.getSession(false);
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//�μ��ڵ�...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//�����μ�����.
	        String selGubun     = WebUtil.nvl(req.getParameter("sel_gubun"), "99"); 	//���� 99:��ü.
	        String startDay     = WebUtil.nvl(req.getParameter("txt_startDay")); 		//�˻�������.
	        String endDay       = WebUtil.nvl(req.getParameter("txt_endDay")); 			//�˻�������.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
	        WebUserData user    = (WebUserData)session.getAttribute("user");				//����.

	        String dest    		= "";
	        String dest_detail    		= "";
//	        String jobid = WebUtil.nvl(req.getParameter("jobid"));

	        //(.)����.
	        startDay 	= DataUtil.removeStructur(startDay, ".");
	        endDay 		= DataUtil.removeStructur(endDay, ".");

            String toDate1 = DataUtil.getCurrentDate();
            String preDate1 = null;
            String yearStr1 = toDate1.substring(0, 4);
            Integer year1 = Integer.parseInt(yearStr1);

            if(((year1 % 4 == 0 && year1 % 100 != 0) || year1 % 400 == 0)){
            	preDate1  = DataUtil.addDays(toDate1, -366);
            }else{
            	preDate1      = DataUtil.addDays(toDate1, -365);
            }
            if (!user.sapType.isLocal()) {
    	    startDay     = WebUtil.nvl(startDay, preDate1);
    	    endDay       = WebUtil.nvl(endDay, toDate1);
            }

            //�ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
            if( deptId.equals("") ){
            	deptId = user.e_objid;
            }

            if (!user.sapType.isLocal()) {
            	dest_detail = "Global";
            }else {
            	dest_detail = "KR";
            }
           	/**
           	 * @$ ���������� rdcamel
           	 * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ
           	 */
			   if(!checkBelongGroup(req, res, deptId, "")) return;
        	// @����༺ �߰�
			   if(!checkAuthorization(req, res)) return;

	        String E_RETURN  	= "";
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007") ;

		        F51DeptWelfareRFC func = null;
		        Vector DeptWelfare_vt  = null;

		        if ( !deptId.equals("") ) {
		        	func       			= new F51DeptWelfareRFC();
		        	DeptWelfare_vt  	= new Vector();
		            Vector ret 			= func.getDeptWelfare(deptId, checkYN, selGubun, startDay, endDay,DataUtil.getCurrentDate(),user.sapType);
		            E_RETURN   			= (String)ret.get(0);
		            E_MESSAGE  			= (String)ret.get(1);
		            DeptWelfare_vt 		= (Vector)ret.get(2);
		        }
		        Logger.debug.println(this, " E_RETURN = " + E_RETURN);
		        RFCReturnEntity result = func.getReturn();
		        //RFC ȣ�� ������.
		        if( result.isSuccess()){
		        	req.setAttribute("checkYn", checkYN);
		        	req.setAttribute("E_RETURN", E_RETURN);
		        	req.setAttribute("E_MESSAGE", E_MESSAGE);
			        req.setAttribute("DeptWelfare_vt", DeptWelfare_vt);
			        if( excelDown.equals("ED") ) //���������� ���.
			            dest = WebUtil.JspURL+"F/F51DeptWelfareExcel_"+dest_detail+".jsp";
			        else
			        	dest = WebUtil.JspURL+"F/F51DeptWelfare_"+dest_detail+".jsp";

			        Logger.debug.println(this, "DeptWelfare_vt : "+ DeptWelfare_vt.toString());
			    //RFC ȣ�� ���н�.
		        }else{
			        String msg = E_MESSAGE;
			        String url = "location.href = '"+WebUtil.JspURL+"F/F51DeptWelfare"+dest_detail+".jsp?checkYn="+checkYN+"';";
			        req.setAttribute("msg", msg);
			        req.setAttribute("url", url);
			        dest = WebUtil.JspURL+"common/msg.jsp?checkYn="+checkYN;
		        }

	        Logger.debug.println(this, " destributed = " + dest);
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}