/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : ���ο���                                                    */
/*   Program Name : ���ο���                                                    */
/*   Program ID   : E11PersonalDetailSV_m                                       */
/*   Description  : ���ο���/���̶������� ��ȸ�Ͽ� jsp�� �Ѱ��ִ� class         */
/*   Note         :                                                             */
/*   Creation     : 2002-02-01  �ڿ���                                          */
/*   Update       : 2005-01-25  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E11Personal;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.E.E11Personal.E11PersonalData;
import hris.E.E11Personal.rfc.*;
import hris.common.WebUserData;


public class E11PersonalDetailSV_m extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);

            String jobid_m = "";
            String dest    = "";
            
            WebUserData user = WebUtil.getSessionUser(req);
//          @����༺ �߰�
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }

            Box box = WebUtil.getBox(req);
            jobid_m = box.get("jobid_m");

            if( jobid_m.equals("") ){
                jobid_m = "first";
            }

            E11PersonalDetailRFC func1      = new E11PersonalDetailRFC();
            E11PersonalData      detailData = null;
            Vector E11PersonalData_vt = new Vector();

            if( jobid_m.equals("first") ) {

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());

                    E11PersonalData_vt = func1.getDetail(user_m.empNo, "", "");
                } // if ( user_m != null ) end

                Logger.debug.println(this, E11PersonalData_vt.toString() );

                req.setAttribute("E11PersonalData_vt", E11PersonalData_vt);

                dest = WebUtil.JspURL+"E/E11Personal/E11PersonalList_m.jsp";

            } else if( jobid_m.equals("detail") ) {

                detailData = new E11PersonalData();

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());

                    E11PersonalData_vt = func1.getDetail(user_m.empNo, box.get("PENT_TYPE"), box.get("ENTR_DATE"));

                    if( E11PersonalData_vt.size() > 0 ) {
                        detailData  = (E11PersonalData)E11PersonalData_vt.get(0);
                    }
                } // if ( user_m != null ) end

                Logger.debug.println(this, E11PersonalData_vt.toString() );

                req.setAttribute("detailData", detailData);

                dest = WebUtil.JspURL+"E/E11Personal/E11PersonalDetail_m.jsp";

            } else {
               throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            printJspPage(req, res, dest);
            Logger.debug.println(this, " destributed = " + dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}
