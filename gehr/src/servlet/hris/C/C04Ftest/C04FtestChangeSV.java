/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 사내어학검정                                                */
/*   Program Name : 사내어학검정신청 수정                                       */
/*   Program ID   : C04FtestChangeSV                                            */
/*   Description  : 어학검정신청에 대한 상세정보를 가져와 수정을 하는 Class     */
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

public class C04FtestChangeSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String jobid = "";
            String PERNR;

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");

            if( jobid.equals("") ){
                jobid = "first";
            }

            PERNR = box.get("PERNR");
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR);

            if( jobid.equals("first") ) {
                Vector C04FtestData_vt = new Vector();
                C04FtestFirstData data  = new C04FtestFirstData();
                box.copyToEntity(data);

                C04FtestData_vt = (new C04FtestListRFC()).getFtestList(PERNR, data.LANG_CODE,data.EXAM_DATE);

                Logger.debug.println(this, "C04FtestData_vt"+C04FtestData_vt.toString());

                req.setAttribute("PERNR" , PERNR );
                req.setAttribute("PersonData" , phonenumdata );
                req.setAttribute("C04FtestData_vt", C04FtestData_vt);
                dest = WebUtil.JspURL+"C/C04Ftest/C04FtestChange.jsp";

            } else if( jobid.equals("change") ) {

                C04FtestListRFC    func1   = new C04FtestListRFC();
                C04FtestFirstData data  = new C04FtestFirstData();
                Vector C04FtestData_vt  = new Vector();

                data.BUKRS     = box.get("BUKRS")    ;
                data.REQS_DATE = box.get("REQS_DATE");
                data.EXAM_DATE = box.get("EXAM_DATE");
                data.EXIM_DTIM = box.get("EXIM_DTIM");
                data.FROM_DATE = box.get("FROM_DATE");
                data.FROM_TIME = box.get("FROM_TIME");
                data.LANG_CODE = box.get("LANG_CODE");
                data.TOXX_DATE = box.get("TOXX_DATE");
                data.TOXX_TIME = box.get("TOXX_TIME");
                data.LANG_NAME = box.get("LANG_NAME");
                data.AREA_CODE = box.get("AREA_CODE");
                data.AREA_DESC = box.get("AREA_DESC");

                C04FtestData_vt.addElement(data);

                Logger.debug.println(this, C04FtestData_vt.toString());

                func1.change( PERNR, data.LANG_CODE, data.EXAM_DATE, C04FtestData_vt );

                String msg = "수정되었습니다.";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.C.C04Ftest.C04FtestDetailSV?LANG_CODE="+data.LANG_CODE+"&EXAM_DATE="+data.EXAM_DATE+"&PERNR="+PERNR+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                dest = WebUtil.JspURL+"common/msg.jsp";

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
