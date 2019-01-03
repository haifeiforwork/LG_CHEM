/********************************************************************************/
/*                                                                                                                                                            */
/*   System Name   : MSS                                                                                                                       */
/*   1Depth Name   : MY HR 정보                                                                                      */
/*   2Depth Name   : 재직증명서 신청                                                                                */
/*   Program Name : 경력증명서 신청 수정                                                                          */
/*   Program ID   : A19CareerChangeSV                                                                                                */
/*   Description  : 경력증명서 신청을 수정 할수 있도록 하는 Class                                                       */
/*   Note         :                                                                                                                                       */
/*   Creation     : 2002-04-11  김대영                                                                                */
/*   Update       :                                                                                                                                     */
/*                                                                                                                                                            */
/********************************************************************************/

package	servlet.hris.A.A19Career;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A19Career.A19CareerData;
import hris.A.A19Career.rfc.A19CareerRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A19CareerChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="34";
    private String UPMU_NAME = "경력증명서";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest;

            String jobid = box.get("jobid", "first");
            String AINF_SEQN = box.get("AINF_SEQN");

            //**********수정 끝.****************************

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            /* 자격 정보 조회 */
            final A19CareerRFC a19CareerRFC = new A19CareerRFC();
            a19CareerRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

            Vector<A19CareerData> resultList = a19CareerRFC.getDetail(); //결과 데이타
            A19CareerData resultData = Utils.indexOf(resultList, 0);


            if (jobid.equals("first")) {  //제일처음 수정 화면에 들어온경우.
                req.setAttribute("resultData", resultData);

                req.setAttribute("isUpdate", true); //등록 수정 여부

                detailApporval(req, res, a19CareerRFC);

                printJspPage(req, res, WebUtil.JspURL + "A/A19Career/A19CareerBuild.jsp");

            } else if (jobid.equals("change")) {

                /* 실제 신청 부분 */
                dest = changeApproval(req, box, A19CareerData.class, a19CareerRFC, new ChangeFunction<A19CareerData>() {

                    public String porcess(A19CareerData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
                        A19CareerRFC changeRFC = new A19CareerRFC();
                        changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

                        changeRFC.build(Utils.asVector(inputData), box, req);

                        if (!changeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }

                        return inputData.AINF_SEQN;
                        /* 개발자 작성 부분 끝 */
                    }
                });

                printJspPage(req, res, dest);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
