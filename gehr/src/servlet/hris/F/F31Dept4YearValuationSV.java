/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : �ο���Ȳ                                                    */
/*   Program Name : �μ��� 4���� ���ȭ ��                                    */
/*   Program ID   : F31Dept4YearValuationSV                                     */
/*   Description  : �μ��� 4���� ���ȭ �� ��ȸ�� ���� ����                 */
/*   Note         : ����                                                        */
/*   Creation     : 2005-02-01 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
  
package servlet.hris.F;
 
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.F.rfc.F31Dept4YearValuationRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * F31Dept4YearValuationSV
 * �μ��� ���� ��ü �μ����� 4���� ���ȭ �� ������ �������� 
 * F31Dept4YearValuationRFC �� ȣ���ϴ� ���� class
 *
 * @author  �����
 * @version 1.0
 */
public class F31Dept4YearValuationSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{ 
	        HttpSession session = req.getSession(false);
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//�μ��ڵ�...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//�����μ�����.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
	        WebUserData user    = (WebUserData)session.getAttribute("user");				//����.

            //�ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
            if( deptId.equals("") ){
            	deptId = user.e_objid;
            }
            
	        String dest    		= "";
	        boolean isSuccess = false;
	        String E_MESSAGE 	= "�μ� ������ �������µ� �����Ͽ����ϴ�.";
	        
           	/**
           	 * @$ ���������� rdcamel
           	 * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ 
           	 */
			if(!checkBelongGroup( req, res, deptId, "")){
				return;
			}
			// ����༺ �߰�
			if(!checkAuthorization(req, res)) return;

	//	      @����༺ �߰�

		        Vector Dept4YearValuation_vt  = null;
		   
		        if ( !deptId.equals("") ) {
					F31Dept4YearValuationRFC func  = new F31Dept4YearValuationRFC();
					Dept4YearValuation_vt				= func.getDept4YearValuation(deptId, checkYN);
					isSuccess = func.getReturn().isSuccess();
		
		        }

		        //RFC ȣ�� ������.
		        if( isSuccess){
		        	req.setAttribute("checkYn", checkYN);
			        req.setAttribute("Dept4YearValuation_vt", Dept4YearValuation_vt);
			        if( excelDown.equals("ED") ) //���������� ���.
			            dest = WebUtil.JspURL+"F/F31Dept4YearValuationExcel.jsp";
			        else
			        	dest = WebUtil.JspURL+"F/F31Dept4YearValuation.jsp";
			        
			        Logger.debug.println(this, "Dept4YearValuation_vt : "+ Dept4YearValuation_vt.toString());
			    //RFC ȣ�� ���н�.    
		        }else{
			        String msg = E_MESSAGE;
			        String url = "location.href = '"+WebUtil.JspURL+"F/F31Dept4YearValuation.jsp?checkYn="+checkYN+"';";
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