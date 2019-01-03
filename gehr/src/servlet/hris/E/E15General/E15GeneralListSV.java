/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 종합검진                                                    */
/*   Program Name : 종합검진                                                    */
/*   Program ID   : E15GeneralListSV                                            */
/*   Description  : 종합검진 상세일정을 조회할 수 있도록 하는 Class             */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  이형석                                          */
/*   Update       : 2005-02-15  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E15General;

import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.rfc.PersonInfoRFC;

public class E15GeneralListSV extends EHRBaseServlet {

    private String UPMU_TYPE ="04";            // 결재 업무타입(종합검진)
    private String UPMU_NAME = "종합검진";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{
            HttpSession session = req.getSession(false);

            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String dest = "";
            String jobid = box.get("jobid", "first");

            String PERNR = getPERNR(box, user); // WebUtil.getRepresentative(req);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

            if( jobid.equals("first") ) {           //제일처음 신청 화면에 들어온경우.
                req.setAttribute("topPage", WebUtil.ServletURL+"hris.E.E15General.E15GeneralListSV?jobid=top&PERNR="+PERNR);
                req.setAttribute("endPage", WebUtil.ServletURL+"hris.E.E15General.E15GeneralListSV?jobid=end&PERNR="+PERNR);
                dest = WebUtil.JspURL+"E/E15General/E15GeneralView.jsp";

            } else if(jobid.equals("top")) {
                req.setAttribute("PERNR", PERNR);
                req.setAttribute("PersonData" , phonenumdata );
                req.setAttribute("oPersonData" , phonenumdata );
                dest = WebUtil.JspURL+"E/E15General/E15General01.jsp";

            } else if(jobid.equals("end")) {
                req.setAttribute("PERNR", PERNR);
                dest = WebUtil.JspURL+"E/E15General/E15GeneralGuide.jsp";

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }

    }
}

