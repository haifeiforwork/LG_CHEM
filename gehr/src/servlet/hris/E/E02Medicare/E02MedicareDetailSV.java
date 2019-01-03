/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ǰ����� ��߱�                                             */
/*   Program Name : �ǰ����� ��߱�/�߰��߱�/������׺��� ��û ��ȸ             */
/*   Program ID   : E02MedicareDetailSV                                         */
/*   Description  : �ǰ������� ����/��߱� ��ȸ/���� �� �Ҽ� �ֵ��� �ϴ� Class  */
/*   Note         :                                                             */
/*   Creation     : 2002-01-29  �ڿ���                                          */
/*   Update       : 2005-02-28  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E02Medicare;

import hris.E.E02Medicare.E02MedicareData;
import hris.E.E02Medicare.rfc.E02MedicareRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;

import java.sql.Connection;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

public class E02MedicareDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="21";
    private String UPMU_NAME = "�ǰ����� ��߱�";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            final WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String jobid = box.get("jobid", "first");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            final E02MedicareRFC e02MedicareRFC = new E02MedicareRFC();
            e02MedicareRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<E02MedicareData> E02MedicareData_vt = e02MedicareRFC.getDetail(); //��� ����Ÿ

            if (jobid.equals("first")) {           //����ó�� ��û ȭ�鿡 ���°��.
                req.setAttribute("resultData", Utils.indexOf(E02MedicareData_vt, 0));
                if (!detailApporval(req, res, e02MedicareRFC))
                    return;
                printJspPage(req, res, WebUtil.JspURL + "E/E02Medicare/E02MedicareDetail.jsp");

            } else if (jobid.equals("delete")) {           //����ó�� ��û ȭ�鿡 ���°��.

                String dest = deleteApproval(req, box, e02MedicareRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	E02MedicareRFC deleteRFC = new E02MedicareRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, e02MedicareRFC.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = deleteRFC.delete();

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });

                printJspPage(req, res, dest);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }

}
