/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항 추가입력                                           */
/*   Program Name : 부양가족 신청 조회                                          */
/*   Program ID   : A12SupportDetailSV                                          */
/*   Description  : 부양가족을 신청을 조회할 수 있도록 하는 Class               */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김도신                                          */
/*   Update       : 2005-03-03  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package	servlet.hris.A.A12Family;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A12Family.A12FamilyBuyangData;
import hris.A.A12Family.A12FamilyListData;
import hris.A.A12Family.rfc.A12FamilyBuyangRFC;
import hris.A.A12Family.rfc.A12FamilyListRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A12SupportDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="07";   // 결재 업무타입(부양가족)
    private String UPMU_NAME = "부양가족";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {

            final WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String jobid = box.get("jobid", "first");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서


            /* 부양 가족  정보 조회 */
            final A12FamilyBuyangRFC a12FamilyBuyangRFC = new A12FamilyBuyangRFC();
            a12FamilyBuyangRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<A12FamilyBuyangData> resultList = a12FamilyBuyangRFC.getFamilyBuyang(); //결과 데이타

            if (jobid.equals("first")) {           //제일처음 신청 화면에 들어온경우.
                A12FamilyBuyangData resultData = Utils.indexOf(resultList, 0);
                req.setAttribute("resultData", resultData);

                if (!detailApporval(req, res, a12FamilyBuyangRFC))
                    return;

                A12FamilyListRFC rfc_list             = new A12FamilyListRFC();
                Vector<A12FamilyListData> a12FamilyListData_vt = rfc_list.getFamilyList(resultData.PERNR, resultData.SUBTY, resultData.OBJPS);
                req.setAttribute("familyData", Utils.indexOf(a12FamilyListData_vt, 0));

                printJspPage(req, res, WebUtil.JspURL + "A/A12Family/A12SupportDetail.jsp");

            } else if (jobid.equals("delete")) {           //제일처음 신청 화면에 들어온경우.

                String dest = deleteApproval(req, box, a12FamilyBuyangRFC, new ApprovalBaseServlet.DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                        A12FamilyBuyangRFC deleteRFC = new A12FamilyBuyangRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, a12FamilyBuyangRFC.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = deleteRFC.delete();

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });

                printJspPage(req, res, dest);

            } else if( jobid.equals("print_hospital") ) {  //새창띠움
                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.A.A12Family.A12SupportDetailSV?subView="+box.get("subView")+"&jobid=print&AINF_SEQN="+box.get("AINF_SEQN"));

                printJspPage(req, res, WebUtil.JspURL+"common/printFrame.jsp");
            } else if( jobid.equals("print") ) {

                Logger.debug.println("[A12SupportDetailSV]   3)   jobid  :::  print");

                if(resultList.size() < 1){
                    moveMsgPage(req, res, "print 될 항목의 데이터를 읽어들이던 중 오류가 발생했습니다.", "history.back();");
                }else{
                    A12FamilyBuyangData resultData = Utils.indexOf(resultList, 0);
                    req.setAttribute("resultData", resultData);

                    Vector a12FamilyListData_vt   = (new A12FamilyListRFC()).getFamilyList(resultData.PERNR, resultData.SUBTY, resultData.OBJPS);
                    req.setAttribute("detailData", Utils.indexOf(a12FamilyListData_vt, 0));


                    PersonInfoRFC personInfoRFC = new PersonInfoRFC();
                    req.setAttribute("personInfo" , personInfoRFC.getPersonInfo(resultData.PERNR));

                    printJspPage(req, res, WebUtil.JspURL+"A/A04FamilyPrintpage.jsp");
                }

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }


        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }
}
