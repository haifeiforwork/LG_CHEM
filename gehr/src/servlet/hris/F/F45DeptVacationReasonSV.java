/********************************************************************************/
/*                                                                                   */
/*   System Name  : MSS                                                    */
/*   1Depth Name  : Manager's Desc                                      */
/*   2Depth Name  : ����                                                                   */
/*   Program Name : �μ��� �ް� ���� ����Ʈ                                      */
/*   Program ID   : F45DeptVacationReasonSV                          */
/*   Description  : �μ��� �ް� ���� ��Ȳ ��ȸ�� ���� ����                 */
/*   Note         : ����                                                                          */
/*   Creation     : 2010-03-16 lsa                                           */
/*   Update       :                                                                */
/*                                                                                     */
/********************************************************************************/

package servlet.hris.F;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.F.rfc.F45DeptVacationReasonRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * F42DeptVacationReasonSV
 * �μ��� ���� ��ü �μ����� �ް� ���� ��Ȳ ������ ��������
 * F41DeptVacationRFC �� ȣ���ϴ� ���� class
 *
 * @author  �����
 * @version 1.0
 */
public class F45DeptVacationReasonSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{
	        HttpSession session = req.getSession(false);
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//�μ��ڵ�...
	        String deptName       = WebUtil.nvl(req.getParameter("hdn_deptNm")); 			//�μ��ڵ�...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//�����μ�����.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
	        String year            = WebUtil.nvl(req.getParameter("year1"),DataUtil.getCurrentYear() ); 		//��
	        String month          = WebUtil.nvl(req.getParameter("month1"),DataUtil.getCurrentMonth());  		//��
	        String i_gubun      = WebUtil.nvl(req.getParameter("i_gubun"),"1");  //1 - �ް�, 2 - �̰����ް�, 3 - �ʰ��ٹ�, 4 - �̰����ʰ��ٹ�
	        WebUserData user    = (WebUserData)session.getAttribute("user");				//����.
	        String subView       = WebUtil.nvl(req.getParameter("subView"));				//tab���� ȣ��Ǵ��� ����

            //�ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
            if( deptId.equals("") ){
            	deptId = user.e_objid;
            }

	        String dest    		= "";
	        String E_RETURN  	= "";
	        //String E_MESSAGE 	= "�μ� ������ �������µ� �����Ͽ����ϴ�.";
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007") ;

           	/**
           	 * @$ ���������� rdcamel
           	 * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ
           	 */
			   if(!checkBelongGroup(req, res, deptId, "")) return;
        	// @����༺ �߰�
			   if(!checkAuthorization(req, res)) return;

		        F45DeptVacationReasonRFC func = null;
		        Vector DeptVacation_vt  = null;

		        if ( !deptId.equals("") ) {
		        	func       				= new F45DeptVacationReasonRFC();
		        	DeptVacation_vt  	= new Vector();
		            Vector ret 				= func.getDeptVacation(deptId, checkYN,year+month,i_gubun);

		            E_RETURN   				= (String)ret.get(0);
		            E_MESSAGE  				= (String)ret.get(1);
		            DeptVacation_vt 	= (Vector)ret.get(2);
		        }
		        Logger.debug.println(this, " E_RETURN = " + E_RETURN+"deptId:"+deptId+"year:"+year+"month:"+month+"i_gubun:"+i_gubun);
		        req.setAttribute("subView", subView);
		        req.setAttribute("checkYn", checkYN);
		        //RFC ȣ�� ������.
		        if(func.getReturn().isSuccess()){

		        	req.setAttribute("i_gubun", i_gubun);
		        	req.setAttribute("year", year);
		        	req.setAttribute("month",month);
			        req.setAttribute("DeptVacation_vt", DeptVacation_vt);
			        if( excelDown.equals("ED") ) //���������� ���.
			            dest = WebUtil.JspURL+"F/F45DeptVacationReasonExcel.jsp";
			        else
			        	dest = WebUtil.JspURL+"F/F45DeptVacationReason.jsp";

			        Logger.debug.println(this, "DeptVacation_vt : "+ DeptVacation_vt.toString());
			    //RFC ȣ�� ���н�.
		       }else{
			        String msg = E_MESSAGE;
			        String url = "location.href = '"+WebUtil.JspURL+"F/F45DeptVacationReason.jsp?subView="+subView+"&chck_yeno="+checkYN+"&hdn_deptId="+deptId+"&hdn_deptNm="+deptName+"&year="+year+"&month="+month+"&i_gubun="+i_gubun+"';";
			        req.setAttribute("msg", msg);
			        req.setAttribute("url", url);
			        dest = WebUtil.JspURL+"common/msg.jsp";
		        }

	        Logger.debug.println(this, " destributed = " + dest);
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}