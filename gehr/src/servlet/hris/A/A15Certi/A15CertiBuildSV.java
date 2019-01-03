/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재직증명서 신청                                             */
/*   Program Name : 재직증명서 신청                                             */
/*   Program ID   : A15CertiBuildSV                                             */
/*   Description  : 재직증명서를 신청할 수 있도록 하는 Class                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  박영락                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A.A15Certi;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A15Certi.A15CertiData;
import hris.A.A15Certi.rfc.A15CertiCodeRFC;
import hris.A.A15Certi.rfc.A15CertiRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A15CertiBuildSV extends ApprovalBaseServlet {


    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "16";
        else return  "05";
    }

    protected String getUPMU_NAME() {

        if(g.getSapType().isLocal())  return "재직증명서";
        else return  "Internal Certificate"; // 결재 업무타입(자격면허등록)
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            Logger.debug("---------- user.area  " + user.area);

            String dest;

            String jobid = box.get("jobid", "first");

            if (jobid.equals("first")) {   //제일처음 신청 화면에 들어온경우.
                String PERNR = getPERNR(box, user); //신청대상자 사번

                PersonInfoRFC personInfoRFC = new PersonInfoRFC();
                PersonData personInfo = personInfoRFC.getPersonInfo(PERNR, "X");
                req.setAttribute("personInfo", personInfo);

                //결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);

                if(!g.getSapType().isLocal()) {
                    req.setAttribute("certCode_vt", (new A15CertiCodeRFC()).getCertiCode(PERNR));

                    if("1800".equals(personInfo.getE_WERKS())) {
                        req.setAttribute("isNanjing", true);
                    }
                }

                dest = WebUtil.JspURL + "A/A15Certi/A15CertiBuild_" + (user.area == Area.KR ? "KR" : "GLOBAL") + ".jsp";
            } else if (jobid.equals("create")) {

                /* 실제 신청 부분 */
                dest = requestApproval(req, box, A15CertiData.class, new RequestFunction<A15CertiData>() {
                    public String porcess(A15CertiData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
                        A15CertiRFC a15CertiRFC = new A15CertiRFC();
                        a15CertiRFC.setRequestInput(user.empNo, getUPMU_TYPE());
                        String AINF_SEQN = a15CertiRFC.build(Utils.asVector(inputData), box, req);

                        if(!a15CertiRFC.getReturn().isSuccess()) {
                            throw new GeneralException(a15CertiRFC.getReturn().MSGTX);
                        };

                        return AINF_SEQN;
                        /* 개발자 작성 부분 끝 */
                    }
                });
            } else if( jobid.equals("print_form") ) {               //새창띠움(빈페이지)

                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.A.A15Certi.A15CertiBuildSV?jobid=print_form_print");
                dest = WebUtil.JspURL+"common/printFrame.jsp";

            } else if( jobid.equals("print_form_print") ) {

                dest = WebUtil.JspURL+"A/A15Certi/A15CertiPrintForm.jsp";
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
