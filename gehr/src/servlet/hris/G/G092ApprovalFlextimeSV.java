/********************************************************************************/
/*   System Name  : ESS                                                         														*/
/*   1Depth Name  : �����ؾ��� ����                                            																*/
/*   2Depth Name  :                                                             															*/
/*   Program Name : Flextime ����                                                   															*/
/*   Program ID   : G092ApprovalFlextimeSV.java                                 												*/
/*   Description  : Flextime ����   �� ���� ����                                     														*/
/*   Note         : ����                                                        																		*/
/*   Creation     :  2017-08-01  eunha    [CSR ID:3438118] flexible time �ý��� ��û   								 */
/*   Update       :  2018-05-24  ��ȯ��     [WorkTime52] I_NTM Import value ����   								 */
/********************************************************************************/

package servlet.hris.G;

import hris.D.D20Flextime.D20FlextimeData;
import hris.D.D20Flextime.rfc.D20FlextimeRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class G092ApprovalFlextimeSV extends ApprovalBaseServlet
{

    private String UPMU_TYPE ="42";            // ���� ����Ÿ��(Flextime)

	private String UPMU_NAME = "Flextime";

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

            final D20FlextimeRFC d20FlextimeRFC = new D20FlextimeRFC();
            d20FlextimeRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
            final D20FlextimeData d20FlextimeData = Utils.indexOf(d20FlextimeRFC.getDetail(), 0); //��� ����Ÿ

            /* ���� �� */
            if("A".equals(jobid)) {
                /* ������ ���� �� */
                dest = accept(req, box,  "T_ZHRA041T", d20FlextimeData, d20FlextimeRFC, new ApprovalFunction<D20FlextimeData>() {
                    public boolean porcess(D20FlextimeData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                            inputData.UNAME     = user.empNo;
                            inputData.AEDTM     = DataUtil.getCurrentDate();
                            inputData.I_NTM 	= "X";
                        return true;
                    }
                });

            /* �ݷ��� */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, d20FlextimeData, d20FlextimeRFC, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, d20FlextimeData, d20FlextimeRFC, null);
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