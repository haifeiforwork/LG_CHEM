/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재직증명서 신청                                             */
/*   Program Name : 재직증명서 신청 수정                                        */
/*   Program ID   : A15CertiChangeSV                                            */
/*   Description  : 재직증명서 신청을 수정 할수 있도록 하는 Class               */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  박영락                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A.A15Certi;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A15Certi.A15CertiData;
import hris.A.A15Certi.rfc.A15CertiCodeRFC;
import hris.A.A15Certi.rfc.A15CertiRFC;
import hris.A.A15Certi.rfc.A15CertiUseCodeRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A15CertiChangeSV extends ApprovalBaseServlet {

    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "16";
        else return  "05";
    }

    protected String getUPMU_NAME() {

        if(g.getSapType().isLocal())  return "재직증명서";
        else return  "Internal Certificate"; // 결재 업무타입(자격면허등록)
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
            final A15CertiRFC a15CertiRFC = new A15CertiRFC();
            a15CertiRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

            Vector<A15CertiData> resultList = a15CertiRFC.getDetail(); //결과 데이타
            A15CertiData resultData = Utils.indexOf(resultList, 0);


            if( jobid.equals("first") ) {  //제일처음 수정 화면에 들어온경우.
                req.setAttribute("resultData", resultData);

                req.setAttribute("isUpdate", true); //등록 수정 여부

                detailApporval(req, res, a15CertiRFC);

                /* 해외 기본 데이타 */
                if(!g.getSapType().isLocal()) {
                    req.setAttribute("certCode_vt", (new A15CertiCodeRFC()).getCertiCode(resultData.PERNR));

                    PersonInfoRFC personInfoRFC = new PersonInfoRFC();
                    PersonData personInfo = personInfoRFC.getPersonInfo(resultData.PERNR);

                    /* 난징일 경우 */
                    if("1800".equals(personInfo.getE_WERKS())) {
                        req.setAttribute("isNanjing", true);
                        req.setAttribute("useCodeList", (new A15CertiUseCodeRFC()).getUseCodeList(resultData.PERNR, resultData.CERT_CODE));
                    }
                }

                printJspPage(req, res, WebUtil.JspURL + "A/A15Certi/A15CertiBuild_" + (user.area == Area.KR ? "KR" : "GLOBAL") + ".jsp");

            } else if( jobid.equals("change") ) {

                /* 실제 신청 부분 */
                dest = changeApproval(req, box, A15CertiData.class, a15CertiRFC, new ChangeFunction<A15CertiData>(){

                    public String porcess(A15CertiData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
                        A15CertiRFC changeRFC = new A15CertiRFC();
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
