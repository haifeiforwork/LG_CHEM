/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 신청                                                        		*/
/*   2Depth Name  : 근태                                                        		*/
/*   Program Name : 휴가 상세                                                   		*/
/*   Program ID   : D03VocationDetailSV                                         */
/*   Description  : 휴가 조회/삭제 할수 있도록 하는 Class                       	*/
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  김도신                                          		*/
/*   Update       : 2005-03-04  유용원                                          		*/
/*                : 2016-10-10 FD-038 GEHR통합작업-KSC 							*/
/*                : 2017-05-17 성환희 [WorkTime52] 보상휴가 추가 건 				*/
/*                                                                              */
/********************************************************************************/
package servlet.hris.D.D03Vocation;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03RemainVocationOfficeRFC;
import hris.D.D03Vocation.rfc.D03RemainVocationRFC;
import hris.D.D03Vocation.rfc.D03VocationRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.rfc.AuthCheckNTMRFC;
import hris.common.rfc.PersonInfoRFC;

public class D03VocationDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="18";            // 결재 업무타입(휴가신청)

	private String UPMU_NAME = "휴가";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
    protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException
    {
       // Connection con = null;

        try{
            HttpSession session = req.getSession(false);
            final WebUserData user    = (WebUserData)session.getAttribute("user");

            String dest         = "";
            String jobid        = "";

            final Box box = WebUtil.getBox(req);
            jobid = box.get("jobid", "first");

            /**         * Start: 국가별 분기처리 */
           if (user.area.equals(Area.KR) ) {
			} else if (user.area.equals(Area.PL) || user.area.equals(Area.DE)) { // PL 폴랜드, DE 독일 은 유럽화면으로
        	   printJspPage(req, res, WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationDetailEurpSV" );
		       	return;
			} else{
				printJspPage(req, res, WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationDetailGlobalSV" );
		       	return;
			}
            /**             * END: 국가별 분기처리             */

			//final String PERNR = box.get("PERNR", user.empNo);

            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            //**********수정 시작 (20050304:유용원)**********
            final String          AINF_SEQN           = box.get("AINF_SEQN");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서


            final D03VocationRFC  rfc                 = new D03VocationRFC();
            //D03VocationData d03VocationData     = new D03VocationData();

            Vector          d03VocationData_vt  = null;

            rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);
            //휴가신청 조회
            d03VocationData_vt = rfc.getVocation( user.empNo, AINF_SEQN );

            if( d03VocationData_vt.size() < 1 ){
                String msg = "조회할 항목이 없습니다.";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
                return ;
            }

            final D03VocationData  firstData           = (D03VocationData)Utils.indexOf(d03VocationData_vt, 0);
            Logger.debug.println(this, "휴가신청 조회 : " + d03VocationData_vt.toString());

            // 대리 신청 추가
            PersonInfoRFC numfunc         = new PersonInfoRFC();
            PersonData phonenumdata    = null;
            phonenumdata  = (PersonData)numfunc.getPersonInfo(firstData.PERNR, "X");
            req.setAttribute("PersonData" , phonenumdata );

            //**********수정 끝.****************************

            if( jobid.equals("first") ) {

            	// 보상휴가 권한체크
                AuthCheckNTMRFC authCheckNTMRFC = new AuthCheckNTMRFC();
            	String E_AUTH = authCheckNTMRFC.getAuth(firstData.PERNR, "S_ESS");
            	req.setAttribute("E_AUTH", E_AUTH);
            	
                // 잔여휴가일수, 장치교대근무조 체크
                D03RemainVocationData d03RemainVocationData    = new D03RemainVocationData();
                
                if("Y".equals(E_AUTH)) {	//사무직
                	String vocaType = (firstData.AWART.equals("0111") 
                						|| firstData.AWART.equals("0112") 
                						|| firstData.AWART.equals("0113")) ? "B" : "A";
                	D03RemainVocationOfficeRFC  rfcRemain = new D03RemainVocationOfficeRFC();
                	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(firstData.PERNR, firstData.APPL_FROM, vocaType);
                } else {
                	D03RemainVocationRFC rfcRemain             = new D03RemainVocationRFC();
                	d03RemainVocationData = (D03RemainVocationData)rfcRemain.getRemainVocation(firstData.PERNR, firstData.APPL_FROM);
                }

                Logger.debug.println(this, "휴가결재 조회 : " + d03VocationData_vt.toString());

                req.setAttribute("d03RemainVocationData",  d03RemainVocationData);
                req.setAttribute("d03VocationData_vt", d03VocationData_vt);

                if (!detailApporval(req, res, rfc))                    return;

                dest = WebUtil.JspURL+"D/D03Vocation/D03VocationDetail.jsp";

                /////////////////////////////////////////////////////////////////////////////
                // 휴가신청 삭제..
                /////////////////////////////////////////////////////////////////////////////

            } else if( jobid.equals("delete") ) {


                dest = deleteApproval(req, box, rfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	//D01OTRFC deleteRFC = new D01OTRFC();
                        rfc.setDeleteInput(user.empNo, UPMU_TYPE, rfc.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = rfc.delete( firstData.PERNR, AINF_SEQN  );

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });


// 2002.07.25.---------------------------------------------------------------------------
//              신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
//              결재
//              신청건 삭제시 메일 보내기 위해 필요한 결재자 정보를 가져온다.
// 2002.07.25.---------------------------------------------------------------------------
/*

                    String url ;

                    //  삭제 실행후 삭제전 페이지로 이동하기 위한 구분
                    if(RequestPageName != null &&  !RequestPageName.equals("") ){
                        url = "location.href = '" + RequestPageName.replace('|','&') + "';";
                    } else {
                        url = "location.href = '" + WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationBuildSV';";
                    } // end if
                    //**********수정 끝.****************************
*/
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {

        }
    }
}