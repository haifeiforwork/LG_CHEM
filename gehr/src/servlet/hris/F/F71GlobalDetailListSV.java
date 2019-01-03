/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : Global����POOL                                              */
/*   Program Name : Global����POOL ������ ��ȭ��                              */
/*   Program ID   : F71GlobalDetailListSV                                       */
/*   Description  : Global����POOL ������ ��ȭ�� ��ȸ�� ���� ����           */
/*   Note         : ����                                                        */
/*   Creation     : 2006-03-16 LSA                                              */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
   
package servlet.hris.F; 
   
import hris.F.rfc.F71GlobalDetailListRFC;
import hris.N.EHRComCRUDInterfaceRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

/**
 * F02DeptPositionDutySV
 * Global����POOL ������ ��ȭ�� ������ �������� 
 * F71GlobalDetailListRFC �� ȣ���ϴ� ���� class
 *
 * @author  ����� 
 * @version 1.0 
 */
public class F71GlobalDetailListSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{ 
	        HttpSession session = req.getSession(false);
	        Box         box 	= WebUtil.getBox(req);
	        WebUserData user    = (WebUserData)session.getAttribute("user");				      //����.
	        
	        String gubun  	= box.get("hdn_gubun");		//���а�.
	        String deptId 	= box.get("hdn_deptId");	//�μ��ڵ�
	        String checkYN	= box.get("chck_yeno");		//�����μ�����.
	        String paramA 	= box.get("hdn_paramA");	//�Ķ��Ÿ
	        String paramB 	= box.get("hdn_paramB");	//�Ķ��Ÿ
	        String paramC 	= box.get("hdn_paramC");	//�Ķ��Ÿ
	        String paramD 	= box.get("hdn_paramD");	//�Ķ��Ÿ
	        String excel  	= box.get("hdn_excel");		//��������.
	        
	        Logger.debug.println(this, " gubun = " + gubun);
	        Logger.debug.println(this, " deptId = " + deptId);
	        Logger.debug.println(this, " checkYN = " + checkYN);
	        Logger.debug.println(this, " paramA = " + paramA);
	        Logger.debug.println(this, " paramB = " + paramB);
	        Logger.debug.println(this, " paramC = " + paramC);
	        Logger.debug.println(this, " paramD = " + paramD);
            
	        String dest    		= ""; 
	        String E_RETURN  	= ""; 
	        String E_MESSAGE 	= "�� ������ �������µ� �����Ͽ����ϴ�.";
	        
           	/**
           	 * @$ ���������� rdcamel
           	 * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ 
           	 */
	        int orgFlag = user.e_authorization.indexOf("M");    //���������ѿ���.
	        
	        //checkBelongGroup(req, res, user, deptId);
	//	      @����༺ �߰�
	            checkAuthorization(req, res);
		        
		        F71GlobalDetailListRFC func    	    = null; 
		        Vector F71GlobalDetailListData_vt   	= null;
		   
		        if ( !gubun.equals("") && !deptId.equals("") ) { 
		        	func       						= new F71GlobalDetailListRFC();
		        	F71GlobalDetailListData_vt		= new Vector();
		            Vector ret 						= func.getDeptDetailList(gubun, deptId, checkYN, paramA, paramB, paramC, paramD);	
		  
		            E_RETURN   						= (String)ret.get(0);
		            E_MESSAGE  						= (String)ret.get(1);
		            F71GlobalDetailListData_vt		= (Vector)ret.get(2);
		        }
		        Logger.debug.println(this, " E_RETURN = " + E_RETURN);
		        
		        //RFC ȣ�� ������.
		        if( E_RETURN != null && E_RETURN.equals("S") ){
			        req.setAttribute("F71GlobalDetailListData_vt", F71GlobalDetailListData_vt);
			        if( excel.equals("ED") ) //���������� ���.
			            dest = WebUtil.JspURL+"F/F71GlobalDetailListExcel.jsp";
			        else
			        	dest = WebUtil.JspURL+"F/F71GlobalDetailList.jsp";
			        
			        Logger.debug.println(this, "F71GlobalDetailListData_vt : "+ F71GlobalDetailListData_vt.toString());
			    //RFC ȣ�� ���н�.    
		        }else{
		        	Logger.debug.println(this, " E_MESSAGE = " + E_MESSAGE);
			        String msg = E_MESSAGE;
			        String url = "history.back();";
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