/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 암검진                                                    */
/*   Program Name : 암검진 조회                                               */
/*   Program ID   : E38CancerDetailSV                                          */
/*   Description  : 신청된 암검진을 조회 및 삭제할 수 있도록 하는 Class       */
/*   Note         :                                                             */
/*   Creation     : 2013-06-21  lsa  C20130620_53407                 */
/*   Update       :                                                              */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E38Cancer;

import java.util.Vector;
import javax.servlet.http.*;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalBaseServlet.DeleteFunction;
import hris.common.rfc.PersonInfoRFC;
import hris.E.E38Cancer.E38CancerData;
import hris.E.E38Cancer.E38CancerDayData;
import hris.E.E38Cancer.rfc.*;

public class E38CancerDetailSV extends ApprovalBaseServlet {

    /**
	 *
	 */
	private static final long serialVersionUID = 1L;
	private String UPMU_TYPE ="39";  // 결재 업무타입(암검진)
    private String UPMU_NAME = "추가암검진(7종암)";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{
        	HttpSession session = req.getSession(false);
        	final WebUserData user = WebUtil.getSessionUser(req);

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

			Box box = WebUtil.getBox(req);

			String jobid = box.get("jobid", "first");
			String PERNR = box.get("PERNR", user.empNo);//getPERNR(box, user); //신청대상자 사번
			String AINF_SEQN = box.get("AINF_SEQN");

            final E38CancerListRFC  e38Rfc       = new E38CancerListRFC();
            e38Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // set DetailInput

            Vector E38Cancer_vt  = null;
            E38Cancer_vt = e38Rfc.getGeneralList( PERNR, AINF_SEQN );

            //Logger.debug.println(this, "======E38Cancer_vt====== : " +  E38Cancer_vt.toString()  );

            E38CancerData E38CancerData = (E38CancerData)E38Cancer_vt.get(0);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(E38CancerData.PERNR);

            if( jobid.equals("first") ) {           //제일처음 신청 화면에 들어온경우.

                Logger.debug.println(this, "E38Cancer_vt : " + E38Cancer_vt.toString());

                //2634070 START
                E38CancerDayData e15GeneralDayData = new E38CancerDayData();

                E38CancerGetDayRFC func = new E38CancerGetDayRFC();
                Vector ret = func.getMedicday(E38CancerData.PERNR);
                e15GeneralDayData = (E38CancerDayData)ret.get(0); //사업장별 일정

                java.text.SimpleDateFormat sdf1 = new java.text.SimpleDateFormat("yyyy-MM-dd");
                String nowDate = WebUtil.printDate(DataUtil.getCurrentDate(),"-");
                int toCompare = nowDate.compareTo(e15GeneralDayData.DATE_TO); //종료날짜 비교
                int fromCompare = nowDate.compareTo(e15GeneralDayData.DATE_FROM); //시작날짜 비교
                //2634070 END

                String reqDisable = "true"; //수정 불가 상태 확인.
                if (!I_APGUB.equals("1") ) { // 결재해야 할 문서에서 오면 승인 / 반려 버튼 안보이게 처리.
                      reqDisable = "";
                }else {
                	 if (  toCompare <= 0 && fromCompare >= 0 ) {
                     	reqDisable = "";
                     }
                }

                req.setAttribute("PERNR" , PERNR );
                req.setAttribute("PersonData" , phonenumdata );
                req.setAttribute("resultData", E38CancerData);
                req.setAttribute("reqDisable" , reqDisable );

                if (!detailApporval(req, res, e38Rfc))
	                   return;

                printJspPage(req, res, WebUtil.JspURL + "E/E38Cancer/E38CancerDetail.jsp");

            } else if( jobid.equals("delete") ) {

            	String dest = deleteApproval(req, box, e38Rfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	E38CancerListRFC deleteRFC = new E38CancerListRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, e38Rfc.getApprovalHeader().AINF_SEQN);
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

        } catch(Exception e) {
            throw new GeneralException(e);
        }

    }
}
