/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 종합검진                                                    */
/*   Program Name : 종합검진 조회                                               */
/*   Program ID   : E15GeneralDetailSV                                          */
/*   Description  : 신청된 종합검진을 조회 및 삭제할 수 있도록 하는 Class       */
/*   Note         :                                                             */
/*   Creation     : 2002-01-25  이형석                                          */
/*   Update       : 2005-02-16  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E15General;

import java.util.Vector;
import javax.servlet.http.*;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.rfc.PersonInfoRFC;
import hris.E.E15General.E15GeneralData;
import hris.E.E15General.E15GeneralDayData;
import hris.E.E15General.rfc.*;

public class E15GeneralDetailSV extends ApprovalBaseServlet {

	private String UPMU_TYPE ="04";    // 결재 업무타입(종합검진)
    private String UPMU_NAME = "종합검진";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException  {

        try{
        	HttpSession session = req.getSession(false);
        	final WebUserData user = WebUtil.getSessionUser(req);

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

			Box box = WebUtil.getBox(req);

			String jobid = box.get("jobid", "first");
			String PERNR = box.get("PERNR", user.empNo);// getPERNR(box, user); //신청대상자 사번
			String AINF_SEQN = box.get("AINF_SEQN");

            final E15GeneralListRFC  e15Rfc       = new E15GeneralListRFC();
            e15Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // set DetailInput

            Vector E15General_vt  = null;

            E15General_vt = e15Rfc.getGeneralList( PERNR, AINF_SEQN );
            E15GeneralData e15GeneralData = (E15GeneralData)E15General_vt.get(0);

            //Logger.debug.println(this, "e15GeneralData=========== : " + e15GeneralData);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(e15GeneralData.PERNR);

            if( jobid.equals("first") ) {           //제일처음 신청 화면에 들어온경우.

                Logger.debug.println(this, "e15GeneralData : " + e15GeneralData.toString());

                //2634070 START
                E15GeneralDayData e15GeneralDayData = new E15GeneralDayData();
                E15GeneralGetDayRFC func = new E15GeneralGetDayRFC();
                Vector ret = func.getMedicday(e15GeneralData.PERNR);
                e15GeneralDayData = (E15GeneralDayData)ret.get(0); //사업장별 일정

                //java.text.SimpleDateFormat sdf1 = new java.text.SimpleDateFormat("yyyy-MM-dd");

                String nowDate = WebUtil.printDate(DataUtil.getCurrentDate(),"-");

                int toCompare = nowDate.compareTo(e15GeneralDayData.DATE_TO); //종료날짜 비교
                int fromCompare = nowDate.compareTo(e15GeneralDayData.DATE_FROM); //시작날짜 비교

                String reqDisable = "true"; //수정 불가 상태 확인.
                if ( toCompare <= 0 && fromCompare >= 0 ) {
                	reqDisable = "";
                }

                req.setAttribute("PERNR" , PERNR );
                req.setAttribute("PersonData" , phonenumdata );
                req.setAttribute("resultData", e15GeneralData);
                //req.setAttribute("E15General_vt"   , E15General_vt);
                //req.setAttribute("e15GeneralDayData",e15GeneralDayData);
                req.setAttribute("reqDisable" , reqDisable );

                if (!detailApporval(req, res, e15Rfc))
	                   return;

                if (e15GeneralData.ZDEFER.equals("X")) { //※C20130220_76495 이월종합검진신청자이면 : 메일및 결재함에서 링크처리 되기 때문에 분기함

                    printJspPage(req, res, WebUtil.JspURL + "E/E13CyGeneral/E13CyGeneralDetail.jsp");
                }else{

                    printJspPage(req, res, WebUtil.JspURL + "E/E15General/E15GeneralDetail.jsp");
                }

            } else if( jobid.equals("delete") ) {

            	String dest = deleteApproval(req, box, e15Rfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	E15GeneralListRFC deleteRFC = new E15GeneralListRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, e15Rfc.getApprovalHeader().AINF_SEQN);
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
            //Logger.debug.println(this, " destributed = " + dest);
            //printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }

    }
}
