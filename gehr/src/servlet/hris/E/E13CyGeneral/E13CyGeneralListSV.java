/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �̿����հ���                                                    */
/*   Program Name : �̿����հ���                                                    */
/*   Program ID   : E13CyGeneralListSV                                            */
/*   Description  : �̿� ���հ��� �������� ��ȸ�� �� �ֵ��� �ϴ� Class             */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  ������                                          */
/*   Update       : 2005-02-15  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E13CyGeneral;

import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.rfc.PersonInfoRFC;

public class E13CyGeneralListSV extends EHRBaseServlet {

    /**
	 *
	 */
	private static final long serialVersionUID = 1L;

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String dest = "";
            String jobid = box.get("jobid", "first");
            String PERNR = getPERNR(box, user); //WebUtil.getRepresentative(req);

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

            if( jobid.equals("first") ) {           //����ó�� ��û ȭ�鿡 ���°��.
                req.setAttribute("topPage", WebUtil.ServletURL+"hris.E.E13CyGeneral.E13CyGeneralListSV?jobid=top&PERNR="+PERNR);
                req.setAttribute("endPage", WebUtil.ServletURL+"hris.E.E13CyGeneral.E13CyGeneralListSV?jobid=end&PERNR="+PERNR);
                dest = WebUtil.JspURL+"E/E13CyGeneral/E13CyGeneralView.jsp";

            } else if(jobid.equals("top")) {
                req.setAttribute("PERNR", PERNR);
                req.setAttribute("PersonData" , phonenumdata );
                dest = WebUtil.JspURL+"E/E13CyGeneral/E13CyGeneral01.jsp";

            } else if(jobid.equals("end")) {
                req.setAttribute("PERNR", PERNR);
                dest = WebUtil.JspURL+"E/E13CyGeneral/E13CyGeneralGuide.jsp";

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}

