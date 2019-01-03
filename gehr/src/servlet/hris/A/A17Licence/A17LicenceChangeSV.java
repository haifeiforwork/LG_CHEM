/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ��û                                                        */
/*   2Depth Name  : ���λ���                                                    */
/*   Program Name : �ڰݸ���                                                    */
/*   Program ID   : A13AddressApprovalChangeSV                                          */
/*   Description  : �ڰݸ��㸦 ���� �Ҽ� �ֵ��� �ϴ� Class                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-14  �ֿ�ȣ                                          */
/*   Update       : 2005-02-25  �����                                          */
/*                                                                              */
/********************************************************************************/
package	servlet.hris.A.A17Licence;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceGradeRFC;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A17LicenceChangeSV extends ApprovalBaseServlet {

    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "14";
        else return  "04"; // ���� ����Ÿ��(�ڰݸ�����)
    }

    protected String getUPMU_NAME() {

        if(g.getSapType().isLocal())  return "�ڰ�������";
        else return  "Register License & Certificate"; // ���� ����Ÿ��(�ڰݸ�����)
    }

	protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest;

            String jobid = box.get("jobid", "first");
            String AINF_SEQN = box.get("AINF_SEQN");

            //**********���� ��.****************************

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            /* �ڰ� ���� ��ȸ */
            final A17LicenceRFC a17LicenceRFC = new A17LicenceRFC();
            a17LicenceRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

            Vector<A17LicenceData> resultList = a17LicenceRFC.getLicence(); //��� ����Ÿ
            A17LicenceData resultData = Utils.indexOf(resultList, 0);


            if( jobid.equals("first") ) {  //����ó�� ���� ȭ�鿡 ���°��.
                req.setAttribute("resultData", resultData);

                if(user.area == Area.KR) {
                    //�ڰݵ��
                    req.setAttribute("gradeList", (new A17LicenceGradeRFC()).getLicenceGrade());
                }
                req.setAttribute("isUpdate", true); //��� ���� ����

                detailApporval(req, res, a17LicenceRFC);

                printJspPage(req, res, WebUtil.JspURL + "A/A17Licence/A17LicenceBuild_" + (user.area == Area.KR ? "KR" : "GLOBAL") + ".jsp");

            } else if( jobid.equals("change") ) {

                /* ���� ��û �κ� */
                dest = changeApproval(req, box, A17LicenceData.class, a17LicenceRFC, new ChangeFunction<A17LicenceData>(){

                    public String porcess(A17LicenceData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        A17LicenceBuildSV.checkDup(g, user, inputData); /* �ߺ� Ȯ�� - �ؿ� */

                        /* ���� ��û RFC ȣ�� */
                        A17LicenceRFC changeRFC = new A17LicenceRFC();
                        changeRFC.setChangeInput(user.empNo, getUPMU_TYPE(), approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

                        changeRFC.build(Utils.asVector(inputData), box, req);

                        if(!changeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }

                        return inputData.AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });

                printJspPage(req, res, dest);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}
