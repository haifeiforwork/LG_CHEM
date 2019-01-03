/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재직증명서 신청                                             */
/*   Program Name : 재직증명서 신청 조회                                        */
/*   Program ID   : A15CertiDetailSV                                            */
/*   Description  : 재직증명서 신청을 조회할 수 있도록 하는 Class               */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  박영락                                          */
/*   Update       : 2005-03-04  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A.A15Certi;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A15Certi.A15CertiData;
import hris.A.A15Certi.rfc.A15CertiCodeRFC;
import hris.A.A15Certi.rfc.A15CertiPrintRFC;
import hris.A.A15Certi.rfc.A15CertiRFC;
import hris.A.A15Certi.rfc.A15CertiUseCodeRFC;
import hris.G.rfc.BizPlaceDataRFC;
import hris.G.rfc.StellRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;
import java.util.Vector;

public class A15CertiDetailSV extends ApprovalBaseServlet {

    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "16";
        else return  "05";
    }

    protected String getUPMU_NAME() {

        if(g.getSapType().isLocal())  return "재직증명서";
        else return  "Internal Certificate"; // 결재 업무타입(자격면허등록)
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {

            final WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String jobid = box.get("jobid", "first");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서
            String AINF_SEQN = box.get("AINF_SEQN");

            /* 자격 정보 조회 */
            final A15CertiRFC a15CertiRFC = new A15CertiRFC();
            a15CertiRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<A15CertiData> resultList = a15CertiRFC.getDetail(); //결과 데이타
            A15CertiData resultData = Utils.indexOf(resultList, 0);

            if (jobid.equals("first")) {           //제일처음 신청 화면에 들어온경우.

                req.setAttribute("resultData", resultData);

                if (!detailApporval(req, res, a15CertiRFC))
                    return;

                ApprovalHeader approvalHeader = (ApprovalHeader) req.getAttribute("approvalHeader");


                if(user.area == Area.KR) {
                     /* 한국 일 경우 기본 데이타 */
                    // 사업장 주소 가져오기
                    Vector vcBizPlaceCodeEntity =  (new BizPlaceDataRFC()).getBizPlacesCodeEntity(approvalHeader.PERNR ,"16");
                    req.setAttribute("vcBizPlaceCodeEntity", vcBizPlaceCodeEntity);

                } else {
                    /* 해외 기본 데이타 */
                    req.setAttribute("certCode_vt", (new A15CertiCodeRFC()).getCertiCode(resultData.PERNR));

                    PersonInfoRFC personInfoRFC = new PersonInfoRFC();
                    PersonData personInfo = personInfoRFC.getPersonInfo(resultData.PERNR);

                    /* 난징일 경우 */
                    if("1800".equals(personInfo.getE_WERKS())) {
                        req.setAttribute("isNanjing", true);
                        req.setAttribute("useCodeList", (new A15CertiUseCodeRFC()).getUseCodeList(resultData.PERNR, resultData.CERT_CODE));
                    }
                }

                /*한국일 경우 결재페이지가 상이해 분리함 */
                if(user.area == Area.KR && "X".equals(approvalHeader.ACCPFL)) {

                    // 직무 코드 가져오기
                    Vector vcStellCodeEntity = (Vector) (new StellRFC()).getStellCodeEntity();
                    req.setAttribute("vcStellCodeEntity", vcStellCodeEntity);

                    printJspPage(req, res, WebUtil.JspURL + "G/G026ApprovalCerti.jsp");
                } else {
                    printJspPage(req, res, WebUtil.JspURL + "A/A15Certi/A15CertiDetail_" + (user.area == Area.KR ? "KR" : "GLOBAL") + ".jsp");
                }

            } else if (jobid.equals("delete")) {           //제일처음 신청 화면에 들어온경우.

                String dest = deleteApproval(req, box, a15CertiRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                        A15CertiRFC deleteRFC = new A15CertiRFC();
                        deleteRFC.setDeleteInput(user.empNo, getUPMU_TYPE(), a15CertiRFC.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = deleteRFC.delete();

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });

                printJspPage(req, res, dest);

            } else if( jobid.equals("print_certi") ) {               //새창띠움(빈페이지)

                // 재직 증명
                req.setAttribute("AINF_SEQN", AINF_SEQN);
                req.setAttribute("PERNR" ,       resultData.PERNR );
                req.setAttribute("MENU" ,      "CERTI");
                req.setAttribute("GUEN_TYPE" ,  "");
                req.setAttribute("print_page_name", WebUtil.ServletURL+"hris.A.A15Certi.A15CertiDetailSV?AINF_SEQN="+AINF_SEQN+"&jobid=print_certi_print");

                printJspPage(req, res, WebUtil.JspURL+"common/printFrame_Acerti.jsp");
            } else if( jobid.equals("print_certi_print") ) {
                // 결재자 정보
                PersonData phonenumdata;
                PersonInfoRFC numfunc			=	new PersonInfoRFC();
//              프린트는 1회로 출력을 제한한다.
                //           func.updateFlag(resultData.PERNR, AINF_SEQN);
// 프린트는 1회로 출력을 제한한다.
                A15CertiPrintRFC rfc_print = new A15CertiPrintRFC();
                Map<String, Object> ret         = rfc_print.getDetail("1", resultData.PERNR, AINF_SEQN,"1");
                Vector T_RESULT    = (Vector) ret.get("T_RESULT");
                String E_JUSO_TEXT = (String) ret.get("E_JUSO_TEXT");
                String E_KR_REPRES = (String) ret.get("E_KR_REPRES");

                phonenumdata    =   (PersonData)numfunc.getPersonInfo(resultData.PERNR, "X");

                req.setAttribute("PersInfoData" ,phonenumdata );

                req.setAttribute("T_RESULT",    T_RESULT);
                req.setAttribute("E_JUSO_TEXT", E_JUSO_TEXT);
                req.setAttribute("E_KR_REPRES", E_KR_REPRES);

                printJspPage(req, res, WebUtil.JspURL+"A/A15Certi/A15CertiPrintCerti.jsp");

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }


        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }

    }
}
