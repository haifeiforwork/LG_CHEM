/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �������� ��û                                             */
/*   Program Name : �������� ��û ����                                        */
/*   Program ID   : A15CertiChangeSV                                            */
/*   Description  : �������� ��û�� ���� �Ҽ� �ֵ��� �ϴ� Class               */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  �ڿ���                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A.A15Certi;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A15Certi.A15CertiData;
import hris.A.A15Certi.rfc.A15CertiCodeRFC;
import hris.A.A15Certi.rfc.A15CertiRFC;
import hris.A.A15Certi.rfc.A15CertiUseCodeRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A15CertiChangeSV extends ApprovalBaseServlet {

    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "16";
        else return  "05";
    }

    protected String getUPMU_NAME() {

        if(g.getSapType().isLocal())  return "��������";
        else return  "Internal Certificate"; // ���� ����Ÿ��(�ڰݸ�����)
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
            final A15CertiRFC a15CertiRFC = new A15CertiRFC();
            a15CertiRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

            Vector<A15CertiData> resultList = a15CertiRFC.getDetail(); //��� ����Ÿ
            A15CertiData resultData = Utils.indexOf(resultList, 0);


            if( jobid.equals("first") ) {  //����ó�� ���� ȭ�鿡 ���°��.
                req.setAttribute("resultData", resultData);

                req.setAttribute("isUpdate", true); //��� ���� ����

                detailApporval(req, res, a15CertiRFC);

                /* �ؿ� �⺻ ����Ÿ */
                if(!g.getSapType().isLocal()) {
                    req.setAttribute("certCode_vt", (new A15CertiCodeRFC()).getCertiCode(resultData.PERNR));

                    PersonInfoRFC personInfoRFC = new PersonInfoRFC();
                    PersonData personInfo = personInfoRFC.getPersonInfo(resultData.PERNR);

                    /* ��¡�� ��� */
                    if("1800".equals(personInfo.getE_WERKS())) {
                        req.setAttribute("isNanjing", true);
                        req.setAttribute("useCodeList", (new A15CertiUseCodeRFC()).getUseCodeList(resultData.PERNR, resultData.CERT_CODE));
                    }
                }

                printJspPage(req, res, WebUtil.JspURL + "A/A15Certi/A15CertiBuild_" + (user.area == Area.KR ? "KR" : "GLOBAL") + ".jsp");

            } else if( jobid.equals("change") ) {

                /* ���� ��û �κ� */
                dest = changeApproval(req, box, A15CertiData.class, a15CertiRFC, new ChangeFunction<A15CertiData>(){

                    public String porcess(A15CertiData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        /* ���� ��û RFC ȣ�� */
                        A15CertiRFC changeRFC = new A15CertiRFC();
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
