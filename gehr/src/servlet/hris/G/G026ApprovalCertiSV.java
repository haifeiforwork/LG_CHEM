/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �ؾ��� ����                                            */
/*   Program Name : �� ���� ��û                                                */
/*   Program ID   : G026ApprovalCertiSV                                         */
/*   Description  : �� ���� ���� ����� ����/�ݷ�                               */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-14  �̽���                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
package servlet.hris.G;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A15Certi.A15CertiData;
import hris.A.A15Certi.rfc.A15CertiRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;


public class G026ApprovalCertiSV extends ApprovalBaseServlet {

    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "16";
        else return  "05";
    }

    protected String getUPMU_NAME() {

        if(g.getSapType().isLocal())  return "��������";
        else return  "Internal Certificate"; // ���� ����Ÿ��(�ڰݸ�����)
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{
            final WebUserData user = WebUtil.getSessionUser(req);


            String dest  = "";

            final Box box = WebUtil.getBox(req);

            String  AINF_SEQN  = box.get("AINF_SEQN");

            String jobid = box.get("jobid");
            /* ���� �ݷ� �� */

            final A15CertiRFC a15CertiRFC = new A15CertiRFC();
            a15CertiRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
            final A15CertiData certiData = Utils.indexOf(a15CertiRFC.getDetail(), 0); //��� ����Ÿ

            /* ���� �� */
            if("A".equals(jobid)) {

                String tableName = user.area == Area.KR ? "T_ZHRA017T" : "T_ZHR0036T";
                /* ������ ���� �� */
                dest = accept(req, box, tableName, certiData, a15CertiRFC, new ApprovalFunction<A15CertiData>() {
                    public boolean porcess(A15CertiData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        if(user.area == Area.KR) {
                        /* ����Ǵ� ���� �׸� */
                            certiData.PRINT_NUM = StringUtils.defaultIfEmpty(box.get("PRINT_NUM"), "1");
                            certiData.PRINT_CHK = box.get("PRINT_CHK");
                            certiData.ENTR_DATE = box.get("ENTR_DATE");
                            certiData.TITEL_FLAG = box.get("chTITEL_FLAG"); //��뿩�� Ȯ��
                            certiData.STELL = box.get("STELL");
                            certiData.STELLTX = box.get("STELLTX");
                            certiData.ORGEH = box.get("ORGEH");
                            certiData.ORGTX_E = box.get("ORGTX_E");
                            certiData.ORGTX_E2 = box.get("ORGTX_E2");
                            certiData.ADDRESS1 = box.get("ADDRESS1");
                            certiData.ADDRESS2 = box.get("ADDRESS2");

                            certiData.PHONE_NUM = box.get("PHONE_NUM");
                            certiData.SUBMIT_PLACE = box.get("SUBMIT_PLACE");
                            certiData.USE_PLACE = box.get("USE_PLACE");
                            certiData.JUSO_CODE = box.get("JUSO_CODE");
                        }

                        return true;
                    }
                });

            /* �ݷ��� */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, certiData, a15CertiRFC, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, certiData, a15CertiRFC, null);
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