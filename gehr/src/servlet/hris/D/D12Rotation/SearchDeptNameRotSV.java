/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ����                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : �μ��� �˻�                                                 */
/*   Program ID   : OrganListSV.java                                            */
/*   Description  : �μ��� �˻��ϴ� include ����                                */
/*   Note         : ����                                                        */
/*   Creation     : 2005-02-20 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/


package  servlet.hris.D.D12Rotation;
import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.D.D12Rotation.rfc.SearchDeptNameRotDeptTimeRFC;
import hris.D.D12Rotation.rfc.SearchDeptNameRotRFC;
import hris.common.rfc.*;
import hris.common.WebUserData;

/**
 * SearchDeptNameSV
 * ���ѿ� ���� ��ü �μ��� ������ ��������
 * SearchDeptNameRFC �� ȣ���ϴ� ���� class
 *
 * @author  �����
 * @version 1.0
 */
public class SearchDeptNameRotSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getAttribute("user");
            Box box = WebUtil.getBox(req);
	        String deptNm      =   box.get("txt_deptNm"); //�μ���...
	        String I_GBN      =   box.get("I_GBN"); //���� ORGEH �μ���,PERNR ����

            String dest    		= "";
            String DEPTNM		= "";
	        String ENAME	= "";
	        String E_MESSAGE 	= "DATA�� �������� �ʽ��ϴ�.";
	        SearchDeptNameRotDeptTimeRFC func = null;
	        Vector DeptName_vt  = null;
	        if (I_GBN.equals("PERNR")) {
	        	DEPTNM="";
	        	ENAME=deptNm;
	        }else if (I_GBN.equals("ORGEH")) {
	        	DEPTNM=deptNm;
	        	ENAME="";
	        }else if (I_GBN.equals("RECENT")) {
	        	DEPTNM="";
	        	ENAME="";
	        }
	       // if ( !deptNm.equals("") ) {
	        	func       		= new SearchDeptNameRotDeptTimeRFC();
	        	DeptName_vt  	= new Vector();
	            Vector ret 		= func.getDeptName(user.empNo, DEPTNM, ENAME); //���� Set!!!
	            Logger.debug.println(this ,"userNo =" + user.empNo + " ENAME = " + ENAME + " DEPTNM =" + DEPTNM);
	            DeptName_vt 	= (Vector)ret.get(0);
	       // }
	        //RFC ȣ�� ������.
	        if( DeptName_vt.size() >0 ){
		        req.setAttribute("DeptName_vt", DeptName_vt);
		        req.setAttribute("I_GBN", I_GBN);
		        req.setAttribute("DEPTNM", DEPTNM);
		        req.setAttribute("ENAME", ENAME);
		        dest = WebUtil.JspURL+"D/D12Rotation/SearchDeptNamePopIF_Rot.jsp";

		        Logger.debug.println(this, "DeptName_vt : "+ DeptName_vt.toString());
		    //RFC ȣ�� ���н�.
	        }else{
		        String msg = E_MESSAGE;
		        String url = " parent.close(); ";

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