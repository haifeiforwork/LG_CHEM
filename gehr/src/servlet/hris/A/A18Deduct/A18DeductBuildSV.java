/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 원천징수영수증 신청                                         */
/*   Program Name : 원천징수영수증 신청                                         */
/*   Program ID   : A18DeductBuildSV                                            */
/*   Description  : 근로소득 원천징수 영수증, 갑근세 원천징수 증명서 신청을     */
/*                  할수 있도록 하는 Class                                      */
/*   Note         :                                                             */
/*   Creation     : 2002-10-22  김도신                                          */
/*   Update       : 2005-02-18  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A.A18Deduct;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A18Deduct.A18DeductData;
import hris.A.A18Deduct.rfc.A18DeductRFC;
import hris.A.A18Deduct.rfc.A18GuenTypeRFC;
import hris.D.D00TaxAdjustPeriodData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A18DeductBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="28";
    private String UPMU_NAME = "원천징수영수증";

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

                /*PersonInfoRFC personInfoRFC = new PersonInfoRFC();
                req.setAttribute("personInfo", personInfoRFC.getPersonInfo(PERNR));*/

                //결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);

                hris.D.rfc.D00TaxAdjustPeriodRFC periodRFC           = new hris.D.rfc.D00TaxAdjustPeriodRFC();
                D00TaxAdjustPeriodData taxAdjustPeriodData = (hris.D.D00TaxAdjustPeriodData) periodRFC.getPeriod(user.companyCode,PERNR);

                String openDate = DataUtil.removeSeparate(taxAdjustPeriodData.YEAR_OPEN); //연말정산기간관리 원천징수오픈일
                String currDate = DataUtil.removeSeparate(DataUtil.getCurrentDate());

                //원천징수오픈일 이후 부터 신청가능  C20140106_63914
                if (Long.parseLong(currDate) >= Long.parseLong(openDate)) {
                    req.setAttribute("openDYear", Integer.parseInt(taxAdjustPeriodData.YEA_YEAR));
                } else {
                    req.setAttribute("openDYear", Integer.parseInt(taxAdjustPeriodData.YEA_YEAR) - 1);
                }

                req.setAttribute("gubunList", (new A18GuenTypeRFC()).getGuenType());

                dest = WebUtil.JspURL + "A/A18Deduct/A18DeductBuild.jsp";
            } else if (jobid.equals("create")) {

                /* 실제 신청 부분 */
                dest = requestApproval(req, box, A18DeductData.class, new ApprovalBaseServlet.RequestFunction<A18DeductData>() {
                    public String porcess(A18DeductData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
                        A18DeductRFC a18DeductRFC = new A18DeductRFC();
                        a18DeductRFC.setRequestInput(user.empNo, UPMU_TYPE);
                        String AINF_SEQN = a18DeductRFC.build(Utils.asVector(inputData), box, req);

                        if(!a18DeductRFC.getReturn().isSuccess()) {
                            throw new GeneralException(a18DeductRFC.getReturn().MSGTX);
                        }

                        return AINF_SEQN;
                        /* 개발자 작성 부분 끝 */

                        /*
                        if (data.PRINT_CHK.equals("1")){ //본인발행
                            msg2 = "담당자 결재 후 HR센타 - 결재함 - 결재완료문서 에서 출력가능합니다.";
                        }
                     */
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
