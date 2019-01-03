/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ڰݸ�����                                                */
/*   Program Name : �ڰݸ����� ��û                                           */
/*   Program ID   : A17LicenceBuildSV                                           */
/*   Description  : �ڰ������㸦 ��û�� �� �ֵ��� �ϴ� Class                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-11  �ֿ�ȣ                                          */
/*   Update       : 2005-02-15  ������                                          */
/*   Update       : 2005-02-23  �����                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.A.A17Licence;

import com.common.Global;
import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A01SelfDetailLicenseData;
import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceGradeRFC;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.A.rfc.A01SelfDetailLicenseRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A17LicenceBuildSV extends ApprovalBaseServlet {

    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "14";
        else return  "04"; // ���� ����Ÿ��(�ڰݸ�����)
    }

    protected String getUPMU_NAME() {

        if(g.getSapType().isLocal())  return "�ڰ�������";
        else return  "Register License & Certificate"; // ���� ����Ÿ��(�ڰݸ�����)
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest;

            String jobid = box.get("jobid", "first");

            if (jobid.equals("first")) {   //����ó�� ��û ȭ�鿡 ���°��.
                String PERNR = getPERNR(box, user); //��û����� ���

                //�������, ���� ��� ���� ��ȸ
                getApprovalInfo(req, PERNR);

                if(user.area == Area.KR) {
                    //�ڰݵ��
                    req.setAttribute("gradeList", (new A17LicenceGradeRFC()).getLicenceGrade());
                }

                req.setAttribute("RequestPageName", g.getRequestPageName(req));

                dest = WebUtil.JspURL + "A/A17Licence/A17LicenceBuild_" + (user.area == Area.KR ? "KR" : "GLOBAL") + ".jsp";
            } else if (jobid.equals("create")) {

                /* ���� ��û �κ� */
                dest = requestApproval(req, box, A17LicenceData.class, new RequestFunction<A17LicenceData>() {
                    public String porcess(A17LicenceData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        checkDup(g, user, inputData);  /* �ߺ� Ȯ�� - �ؿ� */

                        /* ���� ��û RFC ȣ�� */
                        A17LicenceRFC a17LicenceRFC = new A17LicenceRFC();
                        a17LicenceRFC.setRequestInput(user.empNo, getUPMU_TYPE());
                        String AINF_SEQN = a17LicenceRFC.build(Utils.asVector(inputData), box, req);

                        if(!a17LicenceRFC.getReturn().isSuccess()) {
                            throw new GeneralException(a17LicenceRFC.getReturn().MSGTX);
                        };

                        return AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });
            } else {
                throw new GeneralException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }

    /**
     * @return
     * @throws GeneralException
     */
    public static boolean checkDup(Global g, WebUserData user, A17LicenceData licenceData)
            throws GeneralException {
        if(!g.getSapType().isLocal()) {
            A01SelfDetailLicenseRFC licenseRFC = new A01SelfDetailLicenseRFC();
            Vector<A01SelfDetailLicenseData> resultList = licenseRFC.getLicenseList(user.empNo, user.area.getMolga(), "");

            for (A01SelfDetailLicenseData row : resultList) {
                if (StringUtils.equals(row.OBNDAT, WebUtil.printDate(licenceData.ACDATE, "")) &&
                        StringUtils.equals(row.LICNNM, licenceData.GRADE) && StringUtils.equals(row.PBORGH, licenceData.AUTHORITY) &&
                        StringUtils.equals(row.LNUMBER, licenceData.LNUMBER) && StringUtils.equals(row.EXDATE, licenceData.EXDATE))

                    throw new GeneralException(g.getMessage("MSG.A.A17.002"));
            }
        }
        return true;
    }


}
