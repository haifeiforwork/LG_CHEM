/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항 추가입력                                           */
/*   Program Name : 부양가족 신청                                               */
/*   Program ID   : A12SupportBuildSV                                           */
/*   Description  : 부양가족을 신청할 수 있도록 하는 Class                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김도신                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A.A12Family;

import com.common.Utils;
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
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A12SupportBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="07";   // 결재 업무타입(부양가족)
    private String UPMU_NAME = "부양가족";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{

            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest;

            String jobid = box.get("jobid", "first");

            if (jobid.equals("first")) {   //제일처음 신청 화면에 들어온경우.
                String PERNR = getPERNR(box, user); //신청대상자 사번

                //결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);
                A12FamilyListRFC  rfc_list             = new A12FamilyListRFC();

                // 부양가족 신청할 가족
                Vector<A12FamilyListData> a12FamilyListData_vt = rfc_list.getFamilyList(PERNR, box.get("SUBTY"), box.get("OBJPS"));
                req.setAttribute("familyData", Utils.indexOf(a12FamilyListData_vt, 0));
                req.setAttribute("RequestPageName", g.getRequestPageName(req));

                dest = WebUtil.JspURL+"A/A12Family/A12SupportBuild.jsp";
            } else if (jobid.equals("create")) {

                /* 실제 신청 부분 */
                dest = requestApproval(req, box, A12FamilyBuyangData.class, new RequestFunction<A12FamilyBuyangData>() {
                    public String porcess(A12FamilyBuyangData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
                        A12FamilyBuyangRFC  rfc = new A12FamilyBuyangRFC();

                        rfc.setRequestInput(user.empNo, UPMU_TYPE);
                        String AINF_SEQN = rfc.build(Utils.asVector(inputData), box, req);

                        if(!rfc.getReturn().isSuccess()) {
                            throw new GeneralException(rfc.getReturn().MSGTX);
                        };

                        return AINF_SEQN;
                        /* 개발자 작성 부분 끝 */
                    }
                });
            } else {
                throw new GeneralException("내부명령(jobid)이 올바르지 않습니다. ");
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }
}
