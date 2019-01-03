/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 신청                                                        */
/*   2Depth Name  : 제증명신청                                                  */
/*   Program Name : 원천징수영수증 수정                                         */
/*   Program ID   : A18DeductChangeSV                                           */
/*   Description  : 원천징수영수증를 수정 할수 있도록 하는 Class                */
/*   Note         :                                                             */
/*   Creation     : 2002-10-22  김도신                                          */
/*   Update       : 2005-03-04  유용원                                          */
/*                                                                              */
/********************************************************************************/
package	servlet.hris.A.A18Deduct;

import com.common.Utils;
import com.sns.jdf.BusinessException;
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
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A18DeductChangeSV extends ApprovalBaseServlet {

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
            String AINF_SEQN = box.get("AINF_SEQN");

            //**********수정 끝.****************************

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            /* 자격 정보 조회 */
            final A18DeductRFC a18DeductRFC = new A18DeductRFC();
            a18DeductRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

            Vector<A18DeductData> resultList = a18DeductRFC.getDetail(); //결과 데이타
            A18DeductData resultData = Utils.indexOf(resultList, 0);


            if (jobid.equals("first")) {  //제일처음 수정 화면에 들어온경우.
                req.setAttribute("resultData", resultData);

                req.setAttribute("isUpdate", true); //등록 수정 여부

                detailApporval(req, res, a18DeductRFC);

                hris.D.rfc.D00TaxAdjustPeriodRFC periodRFC           = new hris.D.rfc.D00TaxAdjustPeriodRFC();
                D00TaxAdjustPeriodData taxAdjustPeriodData = (hris.D.D00TaxAdjustPeriodData) periodRFC.getPeriod(user.companyCode, resultData.PERNR);

                String openDate = DataUtil.removeSeparate(taxAdjustPeriodData.YEAR_OPEN); //연말정산기간관리 원천징수오픈일
                String currDate = DataUtil.removeSeparate(DataUtil.getCurrentDate());

                //원천징수오픈일 이후 부터 신청가능  C20140106_63914
                if (Long.parseLong(currDate) >= Long.parseLong(openDate)) {
                    req.setAttribute("openDYear", Integer.parseInt(taxAdjustPeriodData.YEA_YEAR));
                } else {
                    req.setAttribute("openDYear", Integer.parseInt(taxAdjustPeriodData.YEA_YEAR) - 1);
                }

                req.setAttribute("gubunList", (new A18GuenTypeRFC()).getGuenType());

                printJspPage(req, res, WebUtil.JspURL + "A/A18Deduct/A18DeductBuild.jsp");

            } else if (jobid.equals("change")) {

                /* 실제 신청 부분 */
                dest = changeApproval(req, box, A18DeductData.class, a18DeductRFC, new ChangeFunction<A18DeductData>() {

                    public String porcess(A18DeductData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
                        A18DeductRFC changeRFC = new A18DeductRFC();
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
