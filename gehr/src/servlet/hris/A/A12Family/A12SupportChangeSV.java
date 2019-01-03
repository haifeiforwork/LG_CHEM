/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항 추가입력                                           */
/*   Program Name : 부양가족 신청 수정                                          */
/*   Program ID   : A12SupportChangeSV                                          */
/*   Description  : 부양가족을 신청을 수정할 수 있도록 하는 Class               */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김도신                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.A.A12Family;

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
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A12SupportChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "07";   // 결재 업무타입(부양가족)
    private String UPMU_NAME = "부양가족";

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

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            /* 부양 가족 조회 */
            final A12FamilyBuyangRFC a12FamilyBuyangRFC = new A12FamilyBuyangRFC();
            a12FamilyBuyangRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

            Vector<A12FamilyBuyangData> resultList = a12FamilyBuyangRFC.getFamilyBuyang(); //결과 데이타
            A12FamilyBuyangData resultData = Utils.indexOf(resultList, 0);


            if (jobid.equals("first")) {  //제일처음 수정 화면에 들어온경우.
                // 부양가족 신청할 가족
                req.setAttribute("resultData", resultData);

                A12FamilyListRFC rfc_list             = new A12FamilyListRFC();
                Vector<A12FamilyListData> a12FamilyListData_vt = rfc_list.getFamilyList(resultData.PERNR, resultData.SUBTY, resultData.OBJPS);
                req.setAttribute("familyData", Utils.indexOf(a12FamilyListData_vt, 0));

                req.setAttribute("isUpdate", true); //등록 수정 여부

                detailApporval(req, res, a12FamilyBuyangRFC);

                printJspPage(req, res, WebUtil.JspURL + "A/A12Family/A12SupportBuild.jsp");

            } else if (jobid.equals("change")) {

                /* 실제 신청 부분 */
                dest = changeApproval(req, box, A12FamilyBuyangData.class, a12FamilyBuyangRFC, new ApprovalBaseServlet.ChangeFunction<A12FamilyBuyangData>() {

                    public String porcess(A12FamilyBuyangData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
                        A12FamilyBuyangRFC changeRFC = new A12FamilyBuyangRFC();
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
            Logger.error(e);
            throw new GeneralException(e);
        }
    }
}
