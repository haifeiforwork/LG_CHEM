/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 자격면허등록                                                */
/*   Program Name : 자격면허등록 신청                                           */
/*   Program ID   : D30MembershipFeeBuildSV                                           */
/*   Description  : 자격증면허를 신청할 수 있도록 하는 Class                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-11  최영호                                          */
/*   Update       : 2005-02-15  윤정현                                          */
/*   Update       : 2005-02-23  유용원                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D15EmpPayInfo;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.CodeEntity;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D15EmpPayInfo.D15EmpPayData;
import hris.D.D15EmpPayInfo.rfc.D15EmpPayRFC;
import hris.D.D15EmpPayInfo.rfc.D15EmpPayTypeGlobalRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class D15EmpPayBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "17";     // 결재 업무타입(자격면허등록)
    private String UPMU_NAME = "지급/공제";

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

                //결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);
                D15EmpPayTypeGlobalRFC rfc = new D15EmpPayTypeGlobalRFC();
                req.setAttribute("payTypeList", rfc.getEmpPayType(user.empNo, DataUtil.getCurrentYear() + DataUtil.getCurrentMonth()));


                Vector<CodeEntity> monthList = DataUtil.getYearMonthList(3);
                Vector<CodeEntity> yearmonthList = new Vector<CodeEntity>();
                D01OTCheckGlobalRFC checkGlobalRFC = new D01OTCheckGlobalRFC();

                for(CodeEntity yearMonth : monthList) {
                    String flag = checkGlobalRFC.check1(user.empNo, yearMonth.getCode() + "20", getUPMU_TYPE());        // 신청자사번, 신청날짜, 업무타입
                    if (!"Y".equals(flag)) {
                        continue;
//                        yearMonth.setValue1("disabled"); //선택 불가능 날짜check
                    }
                    yearmonthList.add(yearMonth);
                }

                req.setAttribute("yearMonthList", yearmonthList);

                dest = WebUtil.JspURL + "D/D15EmpPayInfo/D15EmpPayBuild.jsp";

            } else if (jobid.equals("create")) {

                /* 실제 신청 부분 */
                dest = requestApproval(req, box, D15EmpPayData.class, new RequestFunction<D15EmpPayData>() {
                    public String porcess(D15EmpPayData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        D01OTCheckGlobalRFC checkGlobalRFC = new D01OTCheckGlobalRFC();
                        if(!"Y".equals(checkGlobalRFC.check1(user.empNo, box.get("I_YYYYMM") + "20", getUPMU_TYPE()))){
                            throw new GeneralException("You can not apply this data");
                        }

                        /* 결재 신청 RFC 호출 */
                        D15EmpPayRFC d15EmpPayRFC = new D15EmpPayRFC();
                        d15EmpPayRFC.setRequestInput(user.empNo, UPMU_TYPE);

                        Vector<D15EmpPayData> inputList = box.getVector(D15EmpPayData.class, "LIST_");

                        String AINF_SEQN = d15EmpPayRFC.build(inputList, box, req);

                        if(!d15EmpPayRFC.getReturn().isSuccess()) {
                            throw new GeneralException(d15EmpPayRFC.getReturn().MSGTX);
                        };

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
