/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �ؾ��� ����                                            */
/*   Program Name : �ڰ� ������  ��û                                         */
/*   Program ID   : G024ApprovalLicenceSV                                       */
/*   Description  : �ڰ� ������ ���� ����� ����/�ݷ�                         */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-14  �̽���                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D15EmpPayInfo.D15EmpPayData;
import hris.D.D15EmpPayInfo.rfc.D15EmpPayRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;


public class G090ApprovalEmpPaySV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "17";     // ���� ����Ÿ��(�ڰݸ�����)
    private String UPMU_NAME = "����/����";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";

            final Box box = WebUtil.getBox(req);

            String  AINF_SEQN  = box.get("AINF_SEQN");

            String jobid = box.get("jobid");
            /* ���� �ݷ� �� */

            final D15EmpPayRFC d15EmpPayRFC = new D15EmpPayRFC();
            d15EmpPayRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
            final Vector<D15EmpPayData> empPayList = d15EmpPayRFC.getDetail(); //��� ����Ÿ

            final D15EmpPayData firstData = Utils.indexOf(empPayList, 0); //��� ����Ÿ

            box.put("BEGDA", firstData.BEGDA);

            for(D15EmpPayData row : empPayList) {
                row.ZMONTH = row.YYYYMM;
            }

            /* ���� �� */
            if("A".equals(jobid)) {
                /* ������ ���� �� */
                dest = accept(req, box, "T_ZGHR3001T", empPayList, d15EmpPayRFC, new ApprovalFunction<Vector<D15EmpPayData>>() {
                    public boolean porcess(Vector<D15EmpPayData> inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
                        return true;
                    }
                });

            /* �ݷ��� */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, empPayList, d15EmpPayRFC, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, empPayList, d15EmpPayRFC, null);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        }
    }
}