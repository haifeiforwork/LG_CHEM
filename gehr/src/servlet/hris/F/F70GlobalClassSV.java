/********************************************************************************/
/*                                                                              */
/*   System Name  : EHR                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : Global����POOL                                              */
/*   Program Name : HPI Global����POOL                                          */
/*   Program ID   : F70GlobalClassSV                                            */
/*   Description  : HPI Global����POOL ��ȸ�� ���� ����                       */
/*   Note         : ����                                                        */
/*   Creation     : 2006-03-15 LSA                                              */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
   
package servlet.hris.F;
   
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.F.rfc.F70GlobalClassRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * F70GlobalClassSV
 * �μ��� ���� HPI Global����POOL ������ �������� 
 * F70GlobalClassRFC �� ȣ���ϴ� ���� class
 *
 * @author  ����� 
 * @version 1.0
 */
public class F70GlobalClassSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{ 
	        HttpSession session = req.getSession(false);
	        String jobid        = WebUtil.nvl(req.getParameter("jobid")); 			      //�ʱ�null...
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			  //�μ��ڵ�...
	        String hdn_deptNm   = WebUtil.nvl(req.getParameter("hdn_deptNm")); 			  //�μ���...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//�����μ�����.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			  //excelDown...
	        String pool_gubn    = WebUtil.nvl(req.getParameter("pool"));  	   		    //01: HPI02: ����������03: HPI&����������04: ����MBA05: HPI&����MBA06: �����屳���̼���07: Ȯ��MBA08: �ؿ�������09: R&D�ڻ�10: �����ܱ��αٹ���11: �߱�����������12: �߱�������������13: TOEIC 800�� �̻���14: HSK 5��� �̻���15: LGA 3.5�� �̻���16: �߱��� ������17: ����&�߱��� ������
	        WebUserData user    = (WebUserData)session.getAttribute("user");				      //����.

            //�ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.
            //if( deptId.equals("") ){
            //   	deptId = user.e_objid;          
            //}
          if( jobid.equals("") && !pool_gubn.equals("")) {
              jobid = "first";
          }            
          if( !pool_gubn.equals("")) {
              pool_gubn  = pool_gubn.substring(0,2);
          }            
	        String dest    		= "";
	        String E_RETURN  	= ""; 
	        //String E_MESSAGE 	= "�μ� ������ �������µ� �����Ͽ����ϴ�.";
	        String E_MESSAGE 	= "�޴������� �������µ� �����Ͽ����ϴ�.";
	        Logger.debug.println(this, " pool_gubn = " + pool_gubn+"[deptId:"+deptId);
	        
           	/**
           	 * @$ ���������� rdcamel
           	 * �ش� ����� ������ ��ȸ �Ҽ� �ִ��� üũ 
           	 */
			checkBelongGroup(req, res, deptId, "");
		        
	//	      @����༺ �߰�
	            checkAuthorization(req, res);
		        
		        F70GlobalClassRFC func    	= null;
		        Vector F70GlobalClassTitle_vt	= null;
		        Vector F70GlobalClassNote_vt  = null;
		   
		        if ( !deptId.equals("") ) { 
		        	func       						= new F70GlobalClassRFC();
		        	F70GlobalClassTitle_vt	= new Vector();
		        	F70GlobalClassNote_vt		= new Vector();
		            Vector ret 						= func.getDeptPositionClass(deptId, checkYN,DataUtil.getCurrentDate(),pool_gubn);	
		
		            E_RETURN   						= (String)ret.get(0);
		            E_MESSAGE  						= (String)ret.get(1);
		            F70GlobalClassTitle_vt	= (Vector)ret.get(2);
		            F70GlobalClassNote_vt		= (Vector)ret.get(3);
		        }
		        Logger.debug.println(this, " E_RETURN = " + E_RETURN+"jobid:"+jobid+"checkYn:"+checkYN);
		        
		        //RFC ȣ�� ������.
		        if( jobid.equals("first") ) {    
		        	
			          req.setAttribute("checkYn", checkYN);
			          req.setAttribute("pool"   , pool_gubn);
			          req.setAttribute("jobid"   , jobid);
			          req.setAttribute("F70GlobalClassTitle_vt", F70GlobalClassTitle_vt);
			          req.setAttribute("F70GlobalClassNote_vt", F70GlobalClassNote_vt);
			          dest = WebUtil.JspURL+"F/F70GlobalClass.jsp";
			        
		        }else if( E_RETURN != null && E_RETURN.equals("S") ){
			        req.setAttribute("checkYn", checkYN);
			        req.setAttribute("pool"   , pool_gubn);
			        req.setAttribute("F70GlobalClassTitle_vt", F70GlobalClassTitle_vt);
			        req.setAttribute("F70GlobalClassNote_vt", F70GlobalClassNote_vt);
			        req.setAttribute("jobid"   , jobid);
			        if( excelDown.equals("ED") ) //���������� ���.
			            dest = WebUtil.JspURL+"F/F70GlobalClassExcel.jsp";
			        else
			        	dest = WebUtil.JspURL+"F/F70GlobalClass.jsp";
			        
			        Logger.debug.println(this, "F70GlobalClassTitle_vt : "+ F70GlobalClassTitle_vt.toString());
			        Logger.debug.println(this, "F70GlobalClassNote_vt : "+ F70GlobalClassNote_vt.toString());
			    //RFC ȣ�� ���н�.    
		        }else if( pool_gubn == null || pool_gubn.equals("") ){
			        String msg = E_MESSAGE;
			        String url = "history.back();";
			        req.setAttribute("msg", msg);
			        req.setAttribute("url", url);
			        req.setAttribute("jobid"   , jobid);
			        dest = WebUtil.JspURL+"common/msg.jsp";
		        }else{
			        String msg = E_MESSAGE;
			        String url = "location.href = '"+WebUtil.JspURL+"F/F70GlobalClass.jsp?checkYn="+checkYN+"&pool="+pool_gubn+"&jobid="+jobid+"&hdn_deptId="+deptId+"&hdn_deptNm="+hdn_deptNm+"';";
			        req.setAttribute("msg", msg);
			        req.setAttribute("url", url);
			        req.setAttribute("jobid"   , jobid);
			        dest = WebUtil.JspURL+"common/msg.jsp";
		        }
	    	
	        Logger.debug.println(this, " destributed = " + dest);
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }        
    }
}