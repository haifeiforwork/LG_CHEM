/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �系���а���                                                */
/*   Program Name : �系���а�����û ��ȸ                                       */
/*   Program ID   : C04FtestDetailSV                                            */
/*   Description  : ���а�����û�� ���� ������ ��ȸ�ϴ� Class                 */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  ������                                          */
/*   Update       : 2005-02-15  ������                                          */
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

public class C04FtestDetailSV extends EHRBaseServlet {

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
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            Vector C04FtestData_vt = null;

            PERNR = box.get("PERNR");
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR);

            if( jobid.equals("first") ) {

                C04FtestFirstData data = new C04FtestFirstData();
                box.copyToEntity(data);

                C04FtestData_vt = (new C04FtestListRFC()).getFtestList(PERNR, data.LANG_CODE, data.EXAM_DATE);

                req.setAttribute("PERNR" , PERNR );
                req.setAttribute("PersonData" , phonenumdata );
                req.setAttribute("C04FtestData_vt", C04FtestData_vt);
                dest = WebUtil.JspURL+"C/C04Ftest/C04FtestDetail.jsp";

            } else if( jobid.equals("delete") ) {

                C04FtestListRFC func1 = new C04FtestListRFC();
                C04FtestFirstData data = new C04FtestFirstData();
                box.copyToEntity(data);

                func1.delete(PERNR, data.LANG_CODE,data.EXAM_DATE);

                String msg = "�����Ǿ����ϴ�.";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.C.C04Ftest.C04FtestListSV?PERNR="+PERNR+"';";

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