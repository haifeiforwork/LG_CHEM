/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ϰ���                                                    */
/*   Program Name : �ϰ���                                                    */
/*   Program ID   : E38CancerListSV                                            */
/*   Description  : �� ���հ��� �������� ��ȸ�� �� �ֵ��� �ϴ� Class             */
/*   Note         :                                                             */
/*   Creation     : 2013-06-21  lsa  C20130620_53407                 */
/*   Update       :                                                              */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E38Cancer;

import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.rfc.PersonInfoRFC;

public class E38CancerListSV extends EHRBaseServlet {

    /**
	 *
	 */
	private static final long serialVersionUID = 1L;

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

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
                req.setAttribute("topPage", WebUtil.ServletURL+"hris.E.E38Cancer.E38CancerListSV?jobid=top&PERNR="+PERNR);
                req.setAttribute("endPage", WebUtil.ServletURL+"hris.E.E38Cancer.E38CancerListSV?jobid=end&PERNR="+PERNR);
                dest = WebUtil.JspURL+"E/E38Cancer/E38CancerView.jsp";

            } else if(jobid.equals("top")) {
                req.setAttribute("PERNR", PERNR);
                req.setAttribute("PersonData" , phonenumdata );
                dest = WebUtil.JspURL+"E/E38Cancer/E38Cancer01.jsp";

            } else if(jobid.equals("end")) {
                req.setAttribute("PERNR", PERNR);
                dest = WebUtil.JspURL+"E/E38Cancer/E38CancerGuide.jsp";

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            //Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}

