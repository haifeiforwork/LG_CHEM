/********************************************************************************/
/*                                                                                                                                                            */
/*   System Name   : MSS                                                                                                                       */
/*   1Depth Name   : MY HR 정보                                                                                      */
/*   2Depth Name   : 경력증명서 신청                                                                                */
/*   Program Name : 경력증명서 신청                                                                                */
/*   Program ID      : A19CareerBuildSV                                                                                                 */
/*   Description      : 경력증명서를 신청할 수 있도록 하는 Class                                                           */
/*   Note                :                                                                                                                                */
/*   Creation          : 2006-04-11  김대영                                                                            */
/*   Update            :                                                                                                                                */
/*                                                                                                                                                            */
/********************************************************************************/

package	servlet.hris.A.A19Career;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A19Career.A19CareerData;
import hris.A.A19Career.rfc.A19CareerRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A19CareerBuildSV extends ApprovalBaseServlet {

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

            if (jobid.equals("first")) {   //제일처음 신청 화면에 들어온경우.
                String PERNR = getPERNR(box, user); //신청대상자 사번

                PersonInfoRFC personInfoRFC = new PersonInfoRFC();
                req.setAttribute("personInfo", personInfoRFC.getPersonInfo(PERNR, "X"));

                //결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);

                dest = WebUtil.JspURL + "A/A19Career/A19CareerBuild.jsp";
            } else if (jobid.equals("create")) {

                /* 실제 신청 부분 */
                dest = requestApproval(req, box, A19CareerData.class, new ApprovalBaseServlet.RequestFunction<A19CareerData>() {
                    public String porcess(A19CareerData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
                        A19CareerRFC a19CareerRFC = new A19CareerRFC();
                        a19CareerRFC.setRequestInput(user.empNo, UPMU_TYPE);
                        String AINF_SEQN = a19CareerRFC.build(Utils.asVector(inputData), box, req);

                        if(!a19CareerRFC.getReturn().isSuccess()) {
                            throw new GeneralException(a19CareerRFC.getReturn().MSGTX);
                        };

                        /*if (data.CAREER_TYPE.equals("4") ){//영문
                            msg2 = "";
                        }else if (data.PRINT_CHK.equals("1")){ //본인발행
                            msg2 = "담당자 결재 후 HR센타 - 결재함 - 결재완료문서 에서 출력가능합니다.";
                        }*/

                        return AINF_SEQN;
                        /* 개발자 작성 부분 끝 */
                    }
                });

            } else {
                throw new GeneralException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }


    }


}
