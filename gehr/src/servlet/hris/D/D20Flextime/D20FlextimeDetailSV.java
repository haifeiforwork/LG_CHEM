/********************************************************************************/
/*                                                                              																*/
/*   System Name  : ESS                                                         														*/
/*   1Depth Name  : 휴가/근태                                                        															*/
/*   2Depth Name  : Flextime                                                        													*/
/*   Program Name : Flextime  상세                                                 															*/
/*   Program ID   : D20FlextimeDetailSV                                         													*/
/*   Description  : Flextime 상세조회 Class                            												                */
/*   Note         :                                                             																*/
/*   Creation     : 2017-08-01  eunha    [CSR ID:3438118] flexible time 시스템 요청                                            */
/*   Update       : 2018-05-10  성환희   	 [WorkTime52] 부분/완전선택 근무제 변경										*/
/********************************************************************************/
package servlet.hris.D.D20Flextime;

import hris.D.D20Flextime.D20FlextimeData;
import hris.D.D20Flextime.D20FlextimeScreen;
import hris.D.D20Flextime.rfc.D20FlextimeRFC;
import hris.D.D20Flextime.rfc.D20FlextimeSelectScreenRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

public class D20FlextimeDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="42";            // 결재 업무타입(휴가신청)

	private String UPMU_NAME = "Flextime";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {

            final WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String jobid = box.get("jobid", "first");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서
            String AINF_SEQN = box.get("AINF_SEQN");

            /* 자격 정보 조회 */
            final D20FlextimeRFC d20FlextimeRFC = new D20FlextimeRFC();
            d20FlextimeRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);
            Vector<D20FlextimeData> resultList = d20FlextimeRFC.getDetail(); //결과 데이타
            
            // 선택근무제 대상자 체크
        	// A:부분선택근무제 B:완전선택근무제
        	D20FlextimeSelectScreenRFC d20FlextimeSelectScreenRFC = new D20FlextimeSelectScreenRFC();
        	String E_SCREEN = d20FlextimeSelectScreenRFC.getE_SCREEN(user.empNo, AINF_SEQN);
        	final D20FlextimeScreen d20FlextimeScreen = D20FlextimeScreen.lookup(E_SCREEN);

            if (jobid.equals("first")) {           //제일처음 신청 화면에 들어온경우.

                req.setAttribute("resultData", Utils.indexOf(resultList, 0));

                if (!detailApporval(req, res, d20FlextimeRFC))
                    return;
                
                switch (d20FlextimeScreen) {
					case A:
						printJspPage(req, res, WebUtil.JspURL+"D/D20Flextime/D20FlextimeDetail.jsp");
						
						break;
					case B:
						printJspPage(req, res, WebUtil.JspURL+"D/D20Flextime/D20FlextimeSelectDetail.jsp");
						
						break;
					case NONE: default:
						break;
				}

            } else if (jobid.equals("delete")) {           /*삭제 */

                String dest = deleteApproval(req, box, d20FlextimeRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	D20FlextimeRFC deleteRFC = new D20FlextimeRFC();
                        deleteRFC.setDeleteInput(user.empNo, getUPMU_TYPE(), d20FlextimeRFC.getApprovalHeader().AINF_SEQN);

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
