/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:  �μ�����													*/
/*   2Depth Name		:  ����														*/
/*   Program Name	:  																*/
/*   Program ID		:  D40OrganListPopSV.java								*/
/*   Description		:  �������� �μ�ã�� �˾�									*/
/*   Note				:  																*/
/*   Creation			:  2017-12-08  ������                                          	*/
/*   Update				:  2017-12-08  ������                                          	*/
/*                                                                              			*/
/********************************************************************************/

package servlet.hris.D.D40TmGroup;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class D40OrganListPopSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/common/D40OrganSmListPop.jsp");
    }

}