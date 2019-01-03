/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �系���а���                                                */
/*   Program Name : �系���а�����û                                            */
/*   Program ID   : C04FtestBuildSV                                             */
/*   Description  : ���а�����û�� ���� ������ ������ �μ�Ʈ�� �ϴ� Class       */
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

public class C04FtestBuildSV extends EHRBaseServlet {

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

            PERNR = box.get("PERNR");
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR);

            if( jobid.equals("create")) {
                Vector C04FtestData_vt = new Vector();
                Vector C04Ftest_vt     = new Vector();

                C04FtestListRFC    func1   = new C04FtestListRFC();
                C04FtestFirstData  data    = new C04FtestFirstData();

                C04Ftest_vt = func1.getFtestList(PERNR, box.get("LANG_CODE"),box.get("EXAM_DATE"));

                if(C04Ftest_vt.size() > 0) {

                    String msg = "�̹� ��û�Ͻ� ����Ÿ�� �ֽ��ϴ�.";
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";

                } else {

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

                    func1.build( PERNR, data.LANG_CODE, data.EXAM_DATE, C04FtestData_vt );

                    String msg = "��û�Ǿ����ϴ�.";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.C.C04Ftest.C04FtestDetailSV?LANG_CODE="+data.LANG_CODE+"&EXAM_DATE="+data.EXAM_DATE+"&PERNR="+PERNR+"';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);

                    dest = WebUtil.JspURL+"common/msg.jsp";
                }

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
    }
}