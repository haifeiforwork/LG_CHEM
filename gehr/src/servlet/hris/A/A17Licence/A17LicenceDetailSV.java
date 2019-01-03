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
package servlet.hris.A.A17Licence;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A17LicenceDetailSV extends ApprovalBaseServlet {

    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "14";
        else return  "04"; // 결재 업무타입(자격면허등록)
    }

    protected String getUPMU_NAME() {

        if(g.getSapType().isLocal())  return "자격증면허";
        else return  "Register License & Certificate"; // 결재 업무타입(자격면허등록)
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {

            final WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String jobid = box.get("jobid", "first");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            /* 자격 정보 조회 */
            final A17LicenceRFC a17LicenceRFC = new A17LicenceRFC();
            a17LicenceRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<A17LicenceData> resultList = a17LicenceRFC.getLicence(); //결과 데이타

            if (jobid.equals("first")) {           //제일처음 신청 화면에 들어온경우.

                req.setAttribute("resultData", Utils.indexOf(resultList, 0));

                if (!detailApporval(req, res, a17LicenceRFC))
                    return;


                printJspPage(req, res, WebUtil.JspURL + "A/A17Licence/A17LicenceDetail_" + (user.area == Area.KR ? "KR" : "GLOBAL") + ".jsp");

            } else if (jobid.equals("delete")) {           /*삭제 */

                String dest = deleteApproval(req, box, a17LicenceRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                        A17LicenceRFC deleteRFC = new A17LicenceRFC();
                        deleteRFC.setDeleteInput(user.empNo, getUPMU_TYPE(), a17LicenceRFC.getApprovalHeader().AINF_SEQN);

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
