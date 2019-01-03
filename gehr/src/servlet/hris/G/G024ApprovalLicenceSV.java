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
import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;


public class G024ApprovalLicenceSV extends ApprovalBaseServlet {

//    private String UPMU_TYPE = "14";     // ���� ����Ÿ��(�ڰݸ�����)
//    private String UPMU_NAME = "�ڰ�������";

    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "14";
        else return  "04"; // ���� ����Ÿ��(�ڰݸ�����)
    }

    protected String getUPMU_NAME() {

        if(g.getSapType().isLocal())  return "�ڰ�������";
        else return  "Register License & Certificate"; // ���� ����Ÿ��(�ڰݸ�����)
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            final WebUserData user = WebUtil.getSessionUser(req);


            String dest  = "";

            final Box box = WebUtil.getBox(req);

            String  AINF_SEQN  = box.get("AINF_SEQN");

            String jobid = box.get("jobid");
            /* ���� �ݷ� �� */

            final A17LicenceRFC a17LicenceRFC = new A17LicenceRFC();
            a17LicenceRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
            final A17LicenceData licenceData = Utils.indexOf(a17LicenceRFC.getLicence(), 0); //��� ����Ÿ

            /* ���� �� */
            if("A".equals(jobid)) {
                /* ������ ���� �� */
                dest = accept(req, box, g.getSapType().isLocal() ? "T_ZHRA018T" : "T_ZHR0043T", licenceData, a17LicenceRFC, new ApprovalFunction<A17LicenceData>() {
                    public boolean porcess(A17LicenceData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        /* ������ ���  ������ ���� ���� */
                        if(g.getSapType().isLocal() && approvalHeader.isEditManagerArea()) {
                            box.copyToEntity(inputData);  //����ڰ� �Է��� ����Ÿ�� ������Ʈ
                            if (inputData.WAERS.equals("KRW")) {
                                inputData.LICN_AMNT = DataUtil.changeGlobalAmount(inputData.LICN_AMNT, "KRW") ;  // �ڰ� ���� sap�� ����� ����Ÿ /100 �κ�
                            } // end if

                            inputData.UNAME     = user.empNo;
                            inputData.AEDTM     = DataUtil.getCurrentDate();
                        }

                        if(!g.getSapType().isLocal()) {
                            inputData.CERT_FLAG = box.get("CERT_FLAG");
                            inputData.CERT_DATE = box.get("CERT_DATE");
                        }

                        return true;
                    }
                });

            /* �ݷ��� */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, licenceData, a17LicenceRFC, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, licenceData, a17LicenceRFC, null);
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