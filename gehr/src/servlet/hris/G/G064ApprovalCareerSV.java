/********************************************************************************/
/*                                                                                                                                                            */
/*   System Name   : e-HR                                                                                                                         */
/*   1Depth Name   : HR ������                                                                                                                */
/*   2Depth Name   : ���� �ؾ��� ����                                                                                                    */
/*   Program Name : ��� ���� ��û                                                                                                       */
/*   Program ID      : G064ApprovalCareerSV                                                                                               */
/*   Description       : ������� ���� ����� ����/�ݷ�                                                                           */
/*   Note               : ����                                                                                                                         */
/*   Creation          : 2006-04-17  ��뿵                                                                                                  */
/*   Update       :                                                                                                                                      */
/*                                                                                                                                                            */
/********************************************************************************/
package servlet.hris.G;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A19Career.A19CareerData;
import hris.A.A19Career.rfc.A19CareerRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;


public class G064ApprovalCareerSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="34";
    private String UPMU_NAME = "�������";

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

            final A19CareerRFC a19CareerRFC = new A19CareerRFC();
            a19CareerRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
            final A19CareerData careerData = Utils.indexOf(a19CareerRFC.getDetail(), 0); //��� ����Ÿ

            /* ���� �� */
            if("A".equals(jobid)) {
                /* ������ ���� �� */
                dest = accept(req, box, "T_ZHRA036T", careerData, a19CareerRFC, new ApprovalFunction<A19CareerData>() {
                    public boolean porcess(A19CareerData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
                         /* ����Ǵ� ���� �׸� */
                        careerData.PRINT_NUM = StringUtils.defaultIfEmpty(box.get("PRINT_NUM"), "1");
                        careerData.PRINT_CHK = box.get("PRINT_CHK");
                        careerData.ENTR_DATE = box.get("ENTR_DATE");
                        careerData.STELL = box.get("STELL");
                        careerData.STELLTX = box.get("STELLTX");
                        careerData.ORGEH = box.get("ORGEH");
                        careerData.ORGTX_E = box.get("ORGTX_E");
                        careerData.ORGTX_E2 = box.get("ORGTX_E2");
                        careerData.ADDRESS1 = box.get("ADDRESS1");
                        careerData.ADDRESS2 = box.get("ADDRESS2");

                        careerData.PHONE_NUM = box.get("PHONE_NUM");
                        careerData.SUBMIT_PLACE = box.get("SUBMIT_PLACE");
                        careerData.USE_PLACE = box.get("USE_PLACE");
                        careerData.JUSO_CODE = box.get("JUSO_CODE");
                        careerData.ORDER_TYPE = box.get("ORDER_TYPE");

                        return true;
                    }
                });

            /* �ݷ��� */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, careerData, a19CareerRFC, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, careerData, a19CareerRFC, null);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        }

    }


              

}