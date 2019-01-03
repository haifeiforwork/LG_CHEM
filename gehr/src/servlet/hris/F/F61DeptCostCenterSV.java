/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : �ڽ�Ʈ����                                                  */
/*   Program Name : �μ��� �ڽ�Ʈ���� ��ȸ                                      */
/*   Program ID   : F61DeptCostCenterSV                                         */
/*   Description  : �μ��� �ڽ�Ʈ���� ��ȸ ��ȸ�� ���� ����                   */
/*   Note         : ����                                                        */
/*   Creation     : 2005-02-21 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
  
package servlet.hris.F;
 
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.F.rfc.F61DeptCostCenterRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * F61DeptCostCenterSV
 * �μ��� ���� ��ü �ڽ�Ʈ���� ��ȸ ������ �������� 
 * F61DeptCostCenterRFC �� ȣ���ϴ� ���� class
 *
 * @author  �����
 * @version 1.0
 */
public class F61DeptCostCenterSV extends EHRBaseServlet {

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
	        String E_RETURN  	= ""; 
	        String E_MESSAGE 	= "�μ� ������ �������µ� �����Ͽ����ϴ�.";
	        
           	/**
           	 * @$ ���������� rdcamel
           	 * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ 
           	 */
			checkBelongGroup(req, res, deptId, "");
	//	      @����༺ �߰�
	            checkAuthorization(req, res);
		        
		        F61DeptCostCenterRFC func = null;
		        Vector DeptCostCenter_vt  = null;
		   
		        if ( !deptId.equals("") ) { 
		        	func       			= new F61DeptCostCenterRFC();
		        	DeptCostCenter_vt  	= new Vector();
		            Vector ret 			= func.getDeptCostCenter(deptId, checkYN);		
		
		            E_RETURN   			= (String)ret.get(0);
		            E_MESSAGE  			= (String)ret.get(1);
		            DeptCostCenter_vt 	= (Vector)ret.get(2);
		        }
		        Logger.debug.println(this, " E_RETURN = " + E_RETURN);
		        
		        //RFC ȣ�� ������.
		        if( E_RETURN != null && E_RETURN.equals("S") ){
		        	req.setAttribute("checkYn", checkYN);
			        req.setAttribute("DeptCostCenter_vt", DeptCostCenter_vt);
			        if( excelDown.equals("ED") ) //���������� ���.
			            dest = WebUtil.JspURL+"F/F61DeptCostCenterExcel.jsp";
			        else
			        	dest = WebUtil.JspURL+"F/F61DeptCostCenter.jsp";
			        
			        Logger.debug.println(this, "DeptCostCenter_vt : "+ DeptCostCenter_vt.toString());
			    //RFC ȣ�� ���н�.    
		        }else{
			        String msg = E_MESSAGE;
			        String url = "location.href = '"+WebUtil.JspURL+"F/F61DeptCostCenter.jsp?checkYn="+checkYN+"';";
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