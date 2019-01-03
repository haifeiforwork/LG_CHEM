/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 신청                                                        */
/*   2Depth Name  : 개인사항                                                    */
/*   Program Name : 자격면허                                                    */
/*   Program ID   : A13AddressApprovalChangeSV                                          */
/*   Description  : 자격면허를 수정 할수 있도록 하는 Class                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-14  최영호                                          */
/*   Update       : 2005-02-25  유용원                                          */
/*                                                                              */
/********************************************************************************/
package	servlet.hris.A.A17Licence;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceGradeRFC;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A17LicenceChangeSV extends ApprovalBaseServlet {

    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "14";
        else return  "04"; // 결재 업무타입(자격면허등록)
    }

    protected String getUPMU_NAME() {

        if(g.getSapType().isLocal())  return "자격증면허";
        else return  "Register License & Certificate"; // 결재 업무타입(자격면허등록)
    }

	protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest;

            String jobid = box.get("jobid", "first");
            String AINF_SEQN = box.get("AINF_SEQN");

            //**********수정 끝.****************************

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            /* 자격 정보 조회 */
            final A17LicenceRFC a17LicenceRFC = new A17LicenceRFC();
            a17LicenceRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

            Vector<A17LicenceData> resultList = a17LicenceRFC.getLicence(); //결과 데이타
            A17LicenceData resultData = Utils.indexOf(resultList, 0);


            if( jobid.equals("first") ) {  //제일처음 수정 화면에 들어온경우.
                req.setAttribute("resultData", resultData);

                if(user.area == Area.KR) {
                    //자격등급
                    req.setAttribute("gradeList", (new A17LicenceGradeRFC()).getLicenceGrade());
                }
                req.setAttribute("isUpdate", true); //등록 수정 여부

                detailApporval(req, res, a17LicenceRFC);

                printJspPage(req, res, WebUtil.JspURL + "A/A17Licence/A17LicenceBuild_" + (user.area == Area.KR ? "KR" : "GLOBAL") + ".jsp");

            } else if( jobid.equals("change") ) {

                /* 실제 신청 부분 */
                dest = changeApproval(req, box, A17LicenceData.class, a17LicenceRFC, new ChangeFunction<A17LicenceData>(){

                    public String porcess(A17LicenceData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        A17LicenceBuildSV.checkDup(g, user, inputData); /* 중복 확인 - 해외 */

                        /* 결재 신청 RFC 호출 */
                        A17LicenceRFC changeRFC = new A17LicenceRFC();
                        changeRFC.setChangeInput(user.empNo, getUPMU_TYPE(), approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

                        changeRFC.build(Utils.asVector(inputData), box, req);

                        if(!changeRFC.getReturn().isSuccess()) {
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

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}
