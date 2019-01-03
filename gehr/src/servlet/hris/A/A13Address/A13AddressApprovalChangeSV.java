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
package servlet.hris.A.A13Address;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A13Address.A13AddressApprovalData;
import hris.A.A13Address.rfc.A13AddressApprovalRFC;
import hris.A.A13Address.rfc.A13AddressTypeRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A13AddressApprovalChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "14";     // 결재 업무타입(자격면허등록)
    private String UPMU_NAME = "address";

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

            String dest = null;

            String jobid = box.get("jobid", "first");
            String AINF_SEQN = box.get("AINF_SEQN");

            //**********수정 끝.****************************

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            /* 자격 정보 조회 */
            final A13AddressApprovalRFC addressApprovalRFC = new A13AddressApprovalRFC();
            addressApprovalRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

            Vector<A13AddressApprovalData> resultList = addressApprovalRFC.getDetail(); //결과 데이타
            A13AddressApprovalData resultData = Utils.indexOf(resultList, 0);


            if( jobid.equals("first") ) {  //제일처음 수정 화면에 들어온경우.
                req.setAttribute("resultData", resultData);
                req.setAttribute("subTypeList", (new A13AddressTypeRFC()).getAddressType("01"));

                req.setAttribute("isUpdate", true); //등록 수정 여부

                detailApporval(req, res, addressApprovalRFC);

                printJspPage(req, res, WebUtil.JspURL+"A/A13Address/A13AddressApprovalBuild_" + user.area +".jsp");

            } else if( jobid.equals("change") ) {

                /*실제 신청 부분*/ 
                dest = changeApproval(req, box, A13AddressApprovalData.class, addressApprovalRFC, new ChangeFunction<A13AddressApprovalData>(){

                    public String porcess(A13AddressApprovalData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                         /*결재 신청 RFC 호출*/ 
                        A13AddressApprovalRFC changeRFC = new A13AddressApprovalRFC();
                        changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

                        changeRFC.build(Utils.asVector(inputData), box, req);

                        if(!changeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }

                        return inputData.AINF_SEQN;
                         /*개발자 작성 부분 끝*/ 
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
