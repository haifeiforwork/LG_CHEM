/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 사내어학검정                                                */
/*   Program Name : 사내어학검정 신청                                           */
/*   Program ID   : C04FtestListSV                                              */
/*   Description  : 어학검정에 대한 일정을 가져오는 Class                       */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  이형석                                          */
/*   Update       : 2005-02-15  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.C.C04Ftest;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.rfc.PersonInfoRFC;
import hris.C.C04Ftest.C04FtestFirstData;
import hris.C.C04Ftest.rfc.*;

public class C04FtestListSV extends EHRBaseServlet {
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String jobid = "";
            String page  = "";
            String PERNR;

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            page  = box.get("page");

            if( jobid.equals("") ){
                jobid = "first";
            }

            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            PERNR = box.get("PERNR");
            
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if
            
            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

            if( jobid.equals("first") ) {

                req.setAttribute("PersonData" , phonenumdata );

                Vector C04FtestFirstData_vt = new Vector();
                C04FtestFirstData_vt = (new C04FtestFirstRFC()).getFtestFirst(PERNR, "");

                Vector C04FtestData_vt = new Vector();
                C04FtestData_vt = (new C04FtestListRFC()).getFtestList(PERNR,"","");

                req.setAttribute("page", page);
                req.setAttribute("PERNR", PERNR);
                req.setAttribute("C04FtestData_vt",C04FtestData_vt);
                req.setAttribute("C04FtestFirstData_vt", C04FtestFirstData_vt);
                dest = WebUtil.JspURL+"C/C04Ftest/C04FtestList.jsp";

            } else if( jobid.equals("detail")) {

                C04FtestFirstData data  = new C04FtestFirstData();
                data.PERNR = PERNR;
                box.copyToEntity(data);

                req.setAttribute("PersonData" , phonenumdata );
                req.setAttribute("c04FtestFirstData", data);
                dest = WebUtil.JspURL+"C/C04Ftest/C04FtestBuild.jsp";

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {

        }
    }
}
