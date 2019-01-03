/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : �ο���Ȳ                                                    */
/*   Program Name : �μ��� �ڰ� ������ ��ȸ                                     */
/*   Program ID   : F24DeptQualificationSV                                      */
/*   Description  : �μ��� �ڰ� ������ ��ȸ�� ���� ����                       */
/*   Note         : ����                                                        */
/*   Creation     : 2005-01-31 �����                                           */
/*   Update       : 2007-09-28  zhouguangwen  global e-hr update          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.F;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.F.F24DeptQualificationData;
import hris.F.rfc.F24DeptQualificationRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Vector;

/**
 * F24DeptQualificationSV
 * �μ��� ���� ��ü �μ����� �ڰ� ������ ������ ��������
 * F24DeptQualificationRFC �� ȣ���ϴ� ���� class
 *
 * @author  �����
 * @version 1.0
 */
public class F24DeptQualificationSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{
    		req.setCharacterEncoding("utf-8");
	        HttpSession session = req.getSession(false);
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//�μ��ڵ�...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//�����μ�����.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
	        WebUserData user    = (WebUserData)session.getAttribute("user");				//����.
			if( deptId.equals("") ){
				deptId = user.e_objid;
			}

			if(!checkBelongGroup( req, res, deptId, "")){
				return;
			}
			// ����༺ �߰�
			if(!checkAuthorization(req, res)) return;

            //�ʱ�ȭ�� ���½� �α��� ������� �����͸� �����ش�.


	        String dest    		= "";
	        String E_RETURN  	= "";
	        String E_MESSAGE 	= "Failed to take the department infomation."; //"�μ� ������ �������µ� �����Ͽ����ϴ�."

	        F24DeptQualificationRFC f24DeptQualificationRFC = null;
	        Vector DeptQualification_vt  = new Vector();

	        if ( !deptId.equals("") ) {
	        	f24DeptQualificationRFC       = new F24DeptQualificationRFC();
	            DeptQualification_vt = f24DeptQualificationRFC.getDeptQualification(deptId, checkYN);

	        }
	        Logger.debug.println(this, " E_RETURN = " + f24DeptQualificationRFC.getReturn().MSGTX);

	        //RFC ȣ�� ������.
	        if(f24DeptQualificationRFC.getReturn().isSuccess() ){
	        	req.setAttribute("checkYn", checkYN);
		        req.setAttribute("DeptQualification_vt", DeptQualification_vt);

		        HashMap<String, Integer> empCnt = new HashMap<String, Integer>();
		        int cnt = 0;
		        String oldPer = "";
	            for( int i = 0; i < DeptQualification_vt.size(); i++ ){
	            	F24DeptQualificationData data = (F24DeptQualificationData)DeptQualification_vt.get(i);
	                if(oldPer.equals(data.PERNR)||(i==0)){
	                	cnt ++;
	                }else{
	                	empCnt.put(oldPer,cnt);
	                	cnt = 1;
	                }
	                if(i==DeptQualification_vt.size()-1){
	                	empCnt.put(data.PERNR,cnt);
	                }
	                oldPer = data.PERNR;
	            }
	            req.setAttribute("empCnt", empCnt);

		        if( excelDown.equals("ED") ) //���������� ���.
		            dest = WebUtil.JspURL+"F/F24DeptQualificationExcel.jsp";
		        else
		        	dest = WebUtil.JspURL+"F/F24DeptQualification.jsp";

		        Logger.debug.println(this, "DeptQualification_vt : "+ DeptQualification_vt.toString());
		    //RFC ȣ�� ���н�.
	        }else{
		        String msg =f24DeptQualificationRFC.getReturn().MSGTX;
		        String url = "location.href ='"+WebUtil.JspURL+"F/F24DeptQualification.jsp?checkYn="+checkYN+"';";
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