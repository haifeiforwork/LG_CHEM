/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : �ο���Ȳ                                                    */
/*   Program Name : �μ��� ���� �������� ��ȸ                                   */
/*   Program ID   : F23DeptLanguageSV                                           */
/*   Description  : �μ��� ���� �������� ��ȸ�� ���� ����                     */
/*   Note         : ����                                                        */
/*   Creation     : 2005-01-28 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
  
package servlet.hris.F;
 
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.SortUtil;
import com.sns.jdf.util.WebUtil;
import hris.F.F23DeptLanguageData;
import hris.F.rfc.F23DeptLanguageRFC;
import hris.common.WebUserData;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * F23DeptLanguageSV
 * �μ��� ���� ��ü �μ����� ���� �������� ������ �������� 
 * F23DeptLanguageRFC �� ȣ���ϴ� ���� class
 *
 * @author  �����
 * @version 1.0
 */
public class F23DeptLanguageSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{ 
	        HttpSession session = req.getSession(false);
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//�μ��ڵ�...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//�����μ�����.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
	        WebUserData user    = (WebUserData)session.getAttribute("user");				//����.

            Box         box     = WebUtil.getBox( req ) ;
            
            ///////////  SORT    /////////////
            String sortField = "";   //sortFieldName or sortFieldIndex
            String sortValue = "";  //sortValue ex) desc, asc
            sortField = box.get( "sortField" );
            sortValue = box.get( "sortValue" );
            if( sortField.equals("")  ) {
                sortField = "LGA_LAP_ORAL"; //LGA_LAP
            }
            if( sortValue.equals("")  ) {
                sortValue = "desc";  //���Ĺ��
            }
            
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
	        int orgFlag = user.e_authorization.indexOf("M");    //���������ѿ���.

			if(!checkBelongGroup( req, res, deptId, "")){
				return;
			}
			// ����༺ �߰�
			if(!checkAuthorization(req, res)) return;

			F23DeptLanguageRFC func = null;
			Vector<F23DeptLanguageData> DeptLanguage_vt  = new Vector();

			if (StringUtils.isNotBlank(deptId)) {
				func       = new F23DeptLanguageRFC();
				DeptLanguage_vt = func.getDeptLanguage(deptId, checkYN);
				isSuccess = func.getReturn().isSuccess();
			}

			DeptLanguage_vt = SortUtil.sort( DeptLanguage_vt, sortField, sortValue ); //Vector Sort
			req.setAttribute( "sortField", sortField );
			req.setAttribute( "sortValue", sortValue );
			req.setAttribute( "hdn_deptId", deptId );

			//RFC ȣ�� ������.
			if( isSuccess ){
				req.setAttribute("checkYn", checkYN);
				req.setAttribute("DeptLanguage_vt", DeptLanguage_vt);
				if( excelDown.equals("ED") ) //���������� ���.
					dest = WebUtil.JspURL+"F/F23DeptLanguageExcel.jsp";
				else
					dest = WebUtil.JspURL+"F/F23DeptLanguage.jsp?checkYn="+checkYN+"&hdn_deptId="+deptId;

				Logger.debug.println(this, " dest = " + dest);
				Logger.debug.println(this, "DeptLanguage_vt : "+ DeptLanguage_vt.toString());
				//RFC ȣ�� ���н�.
			}else{
				String msg = E_MESSAGE;
				String url = "location.href ='"+WebUtil.JspURL+"F/F23DeptLanguage.jsp?checkYn="+checkYN+"&hdn_deptId="+deptId+"';";

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