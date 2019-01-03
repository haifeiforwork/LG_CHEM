/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ����                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : ������ �˻�                                                 */
/*   Program ID   : OrganListSV.java                                            */
/*   Description  : ������ �˻��ϴ� include ����                                */
/*   Note         : ����                                                        */
/*   Creation     : 2005-01-20 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
  
package servlet.hris.common;
 
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * OrganListSV
 * �μ��� ���� ��ü �μ������� �������� 
 * OrganListRFC �� ȣ���ϴ� ���� class
 *
 * @author  �����
 * @version 1.0
 */
public class OrganListPopSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        printJspPage(req, res, WebUtil.JspURL + "common/OrganListPop.jsp");
    }
    
}