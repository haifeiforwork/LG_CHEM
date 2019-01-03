/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ��û                                                        */
/*   2Depth Name  : �������û                                                  */
/*   Program Name : ��õ¡�������� ��                                         */
/*   Program ID   : A18DeductDetailSV                                           */
/*   Description  : ��õ¡���������� ��ȸ/���� �Ҽ� �ֵ��� �ϴ� Class           */
/*   Note         :                                                             */
/*   Creation     : 2002-10-22  �赵��                                          */
/*   Update       : 2005-03-04  �����                                          */
/*                                                                              */
/********************************************************************************/
package	servlet.hris.A.A18Deduct;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A18Deduct.A18DeductData;
import hris.A.A18Deduct.rfc.A18DeductRFC;
import hris.A.A18Deduct.rfc.A18GuenTypeRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A18DeductDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="28";
    private String UPMU_NAME = "��õ¡��������";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {

            final WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String jobid = box.get("jobid", "first");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����
            String AINF_SEQN = box.get("AINF_SEQN");

            /* �ڰ� ���� ��ȸ */
            final A18DeductRFC a18DeductRFC = new A18DeductRFC();
            a18DeductRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<A18DeductData> resultList = a18DeductRFC.getDetail(); //��� ����Ÿ

            A18DeductData resultData = Utils.indexOf(resultList, 0);

            if (jobid.equals("first")) {           //����ó�� ��û ȭ�鿡 ���°��.

                req.setAttribute("resultData", resultData);

                if (!detailApporval(req, res, a18DeductRFC))
                    return;

                req.setAttribute("gubunList", (new A18GuenTypeRFC()).getGuenType());

                ApprovalHeader approvalHeader = (ApprovalHeader) req.getAttribute("approvalHeader");

                if("X".equals(approvalHeader.ACCPFL)) {
                    printJspPage(req, res, WebUtil.JspURL + "G/G059ApprovalDeduct.jsp");
                } else {
                    printJspPage(req, res, WebUtil.JspURL + "A/A18Deduct/A18DeductDetail.jsp");
                }

            } else if (jobid.equals("delete")) {           //����ó�� ��û ȭ�鿡 ���°��.

                String dest = deleteApproval(req, box, a18DeductRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                        A18DeductRFC deleteRFC = new A18DeductRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, a18DeductRFC.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = deleteRFC.delete();

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });

                printJspPage(req, res, dest);
            } else if( jobid.equals("print_certi") ) {               //��â���(��������)

                req.setAttribute("AINF_SEQN", AINF_SEQN);
                req.setAttribute("PERNR" ,       resultData.PERNR );
                req.setAttribute("MENU" ,      "DEDUCT");
                req.setAttribute("GUEN_TYPE",   resultData.GUEN_TYPE);
                req.setAttribute("print_page_name", WebUtil.ServletURL+"hris.A.A18Deduct.A18DeductDetailSV?AINF_SEQN="+AINF_SEQN+"&jobid=print_certi_print");

                printJspPage(req, res, WebUtil.JspURL + "common/printFrame_Deduct.jsp");
            } else if( jobid.equals("print_certi_print") ) {
                String dest = "";

                String GUEN_TYPE = box.get("GUEN_TYPE");

                Logger.debug.println(this, "��õ¡�� ��ȸ : rfc_02"  );

                //Vector             ret    = new Vector();

//              ����Ʈ�� 1ȸ�� ����� �����Ѵ�.
                // func.updateFlag(resultData.PERNR, AINF_SEQN);
//����Ʈ�� 1ȸ�� ����� �����Ѵ�.

                String sTargetYear = resultData.EBEGDA.substring(0,4);   // ��û����

                if("01".equals(resultData.GUEN_TYPE)) {                //01:�ٷμҵ� ��õ¡�� ������
                    //String sTargetYear = String.valueOf(DateTime.getYear() - 1);   // �ͼӿ���
                    req.setAttribute("sPerNR",      resultData.PERNR);
                    req.setAttribute("sTargetYear", sTargetYear);
                    req.setAttribute("sAinfSeqn",   AINF_SEQN);
                    dest = WebUtil.JspURL+"A/A18Deduct/A18DeductPrintFormEmbedGunroSoduk.jsp";

                } else if("02".equals(resultData.GUEN_TYPE)) {          //02:���ټ� ��õ¡�� ����
                	/*
//                  �����ٷμҵ� ��û ���� ��ȸ
                    resultData dataA18 = new resultData();

                    resultData_vt = func.getDetail( resultData.PERNR, box.get("AINF_SEQN") );

                    Logger.debug.println(this, "��õ¡�� ��ȸ : 02:" + resultData_vt.toString());

                    if( resultData_vt.size() > 0 ) {     dataA18 = (resultData)resultData_vt.get(0);     }

                    //                  �����ٷμҵ� �޿����� ��ȸ
                    ret = rfc_02.detail(resultData.PERNR, AINF_SEQN);
                    Logger.debug.println(this, "��õ¡�� ��ȸ : 02:----1" + ret.toString());

                    A18CertiPrintBusiData dataBus            = (A18CertiPrintBusiData)ret.get(0);
                    Vector                A18CertiPrint02_vt = (Vector)ret.get(1);
                    Logger.debug.println(this, "��õ¡�� ��ȸ : 02:----2" + dataBus.toString());
                    Logger.debug.println(this, "��õ¡�� ��ȸ : 02:----3" + A18CertiPrint02_vt.toString());

                   // func.updateFlag(resultData.PERNR, AINF_SEQN);
                    req.setAttribute("dataA18",            dataA18);
                    req.setAttribute("dataBus",            dataBus);
                    req.setAttribute("publicdata",     publicdata);
                    req.setAttribute("A18CertiPrint02_vt", A18CertiPrint02_vt);
                    dest = WebUtil.JspURL+"A/A18Deduct/A18DeductPrintCerti02.jsp";
 */

                    //String sTargetYear = String.valueOf(DateTime.getYear() - 1);   // �ͼӿ���
                    req.setAttribute("sPerNR",      resultData.PERNR);
                    req.setAttribute("sTargetYear", sTargetYear);
                    req.setAttribute("sAinfSeqn",   AINF_SEQN);
                    dest = WebUtil.JspURL+"A/A18Deduct/A18DeductPrintFormEmbedGabgnse.jsp";

                }

                printJspPage(req, res, dest);

            }  else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }


        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }

    }
}
