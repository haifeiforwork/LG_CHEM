/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 건강보험 재발급                                             */
/*   Program Name : 건강보험 재발급/추가발급/기재사항변경 신청 조회             */
/*   Program ID   : E02MedicareDetailSV                                         */
/*   Description  : 건강보험증 변경/재발급 조회/삭제 를 할수 있도록 하는 Class  */
/*   Note         :                                                             */
/*   Creation     : 2002-01-29  박영락                                          */
/*   Update       : 2005-02-28  윤정현                                          */
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
    private String UPMU_NAME = "건강보험 재발급";

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

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            final E02MedicareRFC e02MedicareRFC = new E02MedicareRFC();
            e02MedicareRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<E02MedicareData> E02MedicareData_vt = e02MedicareRFC.getDetail(); //결과 데이타

            if (jobid.equals("first")) {           //제일처음 신청 화면에 들어온경우.
                req.setAttribute("resultData", Utils.indexOf(E02MedicareData_vt, 0));
                if (!detailApporval(req, res, e02MedicareRFC))
                    return;
                printJspPage(req, res, WebUtil.JspURL + "E/E02Medicare/E02MedicareDetail.jsp");

            } else if (jobid.equals("delete")) {           //제일처음 신청 화면에 들어온경우.

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
