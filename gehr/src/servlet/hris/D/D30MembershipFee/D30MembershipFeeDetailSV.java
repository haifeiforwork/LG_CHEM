/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 신청                                                        */
/*   2Depth Name  : 개인사항                                                    */
/*   Program Name : 자격면허                                                    */
/*   Program ID   : A17LicenceDetailSV                                          */
/*   Description  : 자격면허를 조회/삭제 할수 있도록 하는 Class                 */
/*   Note         :                                                             */
/*   Creation     : 2002-01-14  최영호                                          */
/*   Update       : 2005-02-25  유용원                                          */
/*                                                                              */
/********************************************************************************/
package servlet.hris.D.D30MembershipFee;

import com.common.RFCReturnEntity;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.D.D30MembershipFee.D30MembershipFeeData;
import hris.D.D30MembershipFee.rfc.D30MembershipFeeRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class D30MembershipFeeDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "18";     // 결재 업무타입(자격면허등록)
    private String UPMU_NAME = "회비";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {

            final WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String jobid = box.get("jobid", "first");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            /* 자격 정보 조회 */
            final D30MembershipFeeRFC membershipFeeRFC = new D30MembershipFeeRFC();
            membershipFeeRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<D30MembershipFeeData> resultList = membershipFeeRFC.getDetail(); //결과 데이타

            if (jobid.equals("first")) {           //제일처음 신청 화면에 들어온경우.

//                req.setAttribute("resultData", Utils.indexOf(resultList, 0));
                req.setAttribute("resultList", resultList);

                if (!detailApporval(req, res, membershipFeeRFC))
                    return;

                printJspPage(req, res, WebUtil.JspURL + "D/D30MembershipFee/D30MembershipFeeDetail.jsp");

            } else if (jobid.equals("delete")) {           //제일처음 신청 화면에 들어온경우.

                String dest = deleteApproval(req, box, membershipFeeRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                        D30MembershipFeeRFC deleteRFC = new D30MembershipFeeRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, membershipFeeRFC.getApprovalHeader().AINF_SEQN);

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
