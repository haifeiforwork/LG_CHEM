/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ����Ϸ� ����                                               */
/*   2Depth Name  :                                                             */
/*   Program Name : �ް� ����Ϸ�                                               */
/*   Program ID   : F02DeptPositionDutySV                                       */
/*   Description  : �ް� ����Ϸ� ��ȸ�� ���� ����                            */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-10 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03RemainVocationRFC;
import hris.D.D03Vocation.rfc.D03VocationRFC;
import hris.common.PersInfoData;
import hris.common.WebUserData;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.util.AppUtil;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class G056ApprovalFinishVacationSV extends EHRBaseServlet
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector          vcAppLineData      = null;
            Vector          d03VocationData_vt = null;
            D03VocationData d03VocationData    = null;

            String dest  = "";
            String jobid = "";

            Box box = WebUtil.getBox(req);
            String  AINF_SEQN  = box.get("AINF_SEQN");

            // ó�� �� ���� �� ������
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            jobid = box.get("jobid");

            if(jobid == null || jobid.equals("") ){
                jobid = "search";
            }// end if

            if( jobid.equals("search") ) {

                //�ް� ��ȸ
                D03VocationRFC  rfc = new D03VocationRFC();
                d03VocationData_vt = rfc.getVocation( user.empNo, AINF_SEQN );
                Logger.debug.println(this, "�ް� ��ȸ : " + d03VocationData_vt.toString());

                if( d03VocationData_vt.size() < 1 ){
                    String msg = "System Error! \n\n ��ȸ�� �׸��� �����ϴ�.";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                }else{
                    // �ް�
                    d03VocationData  = (D03VocationData)d03VocationData_vt.get(0);

                    // �ܿ��ް��ϼ�, ��ġ����ٹ��� üũ
                    D03RemainVocationRFC  rfcRemain                = null;
                    D03RemainVocationData d03RemainVocationData    = new D03RemainVocationData();

                    rfcRemain             = new D03RemainVocationRFC();
                    d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(user.empNo, DataUtil.getCurrentDate());

                    // ������ ����
                    vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

                    // ���� ����.
                    PersInfoWithNoRFC piRfc = new PersInfoWithNoRFC();
                    PersInfoData      pid   = (PersInfoData) piRfc.getApproval(d03VocationData.PERNR).get(0);

                    req.setAttribute("PersInfoData" ,pid );
                    req.setAttribute("vcAppLineData" , vcAppLineData);
                    req.setAttribute("d03VocationData_vt", d03VocationData_vt);
                    req.setAttribute("d03RemainVocationData",  d03RemainVocationData);

                    dest = WebUtil.JspURL+"G/G056ApprovalFinishVacation.jsp";
                } // end if
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        } finally {
        }
    }
}
