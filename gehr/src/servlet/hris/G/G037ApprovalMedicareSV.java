/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �ؾ��� ����                                            */
/*   Program Name : �ǰ����� �Ǻξ��� ��û                                      */
/*   Program ID   : G037ApprovalMedicareSV                                      */
/*   Description  : �ǰ����� �Ǻξ��� ��û ����� ����/�ݷ�                     */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-14  �̽���                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E01Medicare.E01HealthGuaranteeData;
import hris.E.E01Medicare.rfc.E01HealthGuaranteeRFC;
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


public class G037ApprovalMedicareSV extends ApprovalBaseServlet
{
    private String UPMU_TYPE ="20";   // ���� ����Ÿ��(�ڰݺ���)
    private String UPMU_NAME = "�ǰ����� �Ǻξ���";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

                final WebUserData user = WebUtil.getSessionUser(req);


                String dest  = "";

                final Box box = WebUtil.getBox(req);

                String  AINF_SEQN  = box.get("AINF_SEQN");

                String jobid = box.get("jobid");
                /* ���� �ݷ� �� */

                final E01HealthGuaranteeRFC e01HealthGuaranteeRFC = new E01HealthGuaranteeRFC();
                e01HealthGuaranteeRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
                Vector<E01HealthGuaranteeData> e01HealthGuaranteeData_vt = e01HealthGuaranteeRFC.getDetail(); //��� ����Ÿ
                E01HealthGuaranteeData firstData = Utils.indexOf(e01HealthGuaranteeData_vt, 0);
                /* ���� �� */
                if("A".equals(jobid)) {
                    /* ������ ���� �� */
                    dest = accept(req, box, null, firstData, e01HealthGuaranteeRFC, new ApprovalFunction<E01HealthGuaranteeData>() {
                        public boolean porcess(E01HealthGuaranteeData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {


                            return true;
                        }
                    });
                    /* �ݷ��� */
                } else if("R".equals(jobid)) {

                    dest = reject(req, box, null, firstData, e01HealthGuaranteeRFC, null);
                } else if("C".equals(jobid)) {
                    dest = cancel(req, box, null, firstData, e01HealthGuaranteeRFC, null);
                }  else {
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


