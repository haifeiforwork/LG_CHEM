/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �������� �߰��Է�                                           */
/*   Program Name : �ξ簡�� ��û ��ȸ                                          */
/*   Program ID   : A12SupportDetailSV                                          */
/*   Description  : �ξ簡���� ��û�� ��ȸ�� �� �ֵ��� �ϴ� Class               */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  �赵��                                          */
/*   Update       : 2005-03-03  ������                                          */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A.A12Family;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A12Family.A12FamilyBuyangData;
import hris.A.A12Family.A12FamilyListData;
import hris.A.A12Family.rfc.A12FamilyBuyangRFC;
import hris.A.A12Family.rfc.A12FamilyListRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A12SupportDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="07";   // ���� ����Ÿ��(�ξ簡��)
    private String UPMU_NAME = "�ξ簡��";

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


            /* �ξ� ����  ���� ��ȸ */
            final A12FamilyBuyangRFC a12FamilyBuyangRFC = new A12FamilyBuyangRFC();
            a12FamilyBuyangRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<A12FamilyBuyangData> resultList = a12FamilyBuyangRFC.getFamilyBuyang(); //��� ����Ÿ

            if (jobid.equals("first")) {           //����ó�� ��û ȭ�鿡 ���°��.
                A12FamilyBuyangData resultData = Utils.indexOf(resultList, 0);
                req.setAttribute("resultData", resultData);

                if (!detailApporval(req, res, a12FamilyBuyangRFC))
                    return;

                A12FamilyListRFC rfc_list             = new A12FamilyListRFC();
                Vector<A12FamilyListData> a12FamilyListData_vt = rfc_list.getFamilyList(resultData.PERNR, resultData.SUBTY, resultData.OBJPS);
                req.setAttribute("familyData", Utils.indexOf(a12FamilyListData_vt, 0));

                printJspPage(req, res, WebUtil.JspURL + "A/A12Family/A12SupportDetail.jsp");

            } else if (jobid.equals("delete")) {           //����ó�� ��û ȭ�鿡 ���°��.

                String dest = deleteApproval(req, box, a12FamilyBuyangRFC, new ApprovalBaseServlet.DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                        A12FamilyBuyangRFC deleteRFC = new A12FamilyBuyangRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, a12FamilyBuyangRFC.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = deleteRFC.delete();

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });

                printJspPage(req, res, dest);

            } else if( jobid.equals("print_hospital") ) {  //��â���
                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.A.A12Family.A12SupportDetailSV?subView="+box.get("subView")+"&jobid=print&AINF_SEQN="+box.get("AINF_SEQN"));

                printJspPage(req, res, WebUtil.JspURL+"common/printFrame.jsp");
            } else if( jobid.equals("print") ) {

                Logger.debug.println("[A12SupportDetailSV]   3)   jobid  :::  print");

                if(resultList.size() < 1){
                    moveMsgPage(req, res, "print �� �׸��� �����͸� �о���̴� �� ������ �߻��߽��ϴ�.", "history.back();");
                }else{
                    A12FamilyBuyangData resultData = Utils.indexOf(resultList, 0);
                    req.setAttribute("resultData", resultData);

                    Vector a12FamilyListData_vt   = (new A12FamilyListRFC()).getFamilyList(resultData.PERNR, resultData.SUBTY, resultData.OBJPS);
                    req.setAttribute("detailData", Utils.indexOf(a12FamilyListData_vt, 0));


                    PersonInfoRFC personInfoRFC = new PersonInfoRFC();
                    req.setAttribute("personInfo" , personInfoRFC.getPersonInfo(resultData.PERNR));

                    printJspPage(req, res, WebUtil.JspURL+"A/A04FamilyPrintpage.jsp");
                }

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }


        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }
}
