/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 경조금                                                      */
/*   Program Name : 경조금 신청 조회                                            */
/*   Program ID   : E19CongraDetailSV                                           */
/*   Description  : 경조금을 신청조회할 수 있도록 하는 Class                    */
/*   Note         : 없음                                                        */
/*   Creation     : 2001-12-19  김성일                                          */
/*   Update       : 2005-02-14  이승희                                          */
/*                  2005-02-24  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E19Congra;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.E.E19Congra.E19CongcondGlobalData;
import hris.E.E19Congra.rfc.E19CongraRFC;
import hris.E.E19Congra.rfc.E19CongraRequestGlobalRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class E19CongraDetailGlobalSV extends ApprovalBaseServlet {

	private String UPMU_TYPE	= "06";	// 결재 업무타입(경조금)

	private String UPMU_NAME	= "Celebration & Condolence";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
	protected void performTask(HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {

		try {


            final WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String jobid = box.get("jobid", "first");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            final E19CongraRequestGlobalRFC e19CongraRequestGlobalRFC = new E19CongraRequestGlobalRFC();
            e19CongraRequestGlobalRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<E19CongcondGlobalData> vE19CongcondData = e19CongraRequestGlobalRFC.getDetail(); //결과 데이타
            E19CongcondGlobalData e19CongcondData = Utils.indexOf(vE19CongcondData, 0);

            Vector  Code_vt = ( new E19CongraRFC() ).getEntryCode(e19CongcondData.PERNR, "", e19CongcondData.CELTY);
            Vector  Code_vt0 = (Vector) Utils.indexOf(Code_vt, 0);
            Vector  Code_vt3  = (Vector) Utils.indexOf(Code_vt, 3);


            if (jobid.equals("first")) {           //제일처음 신청 화면에 들어온경우.
Logger.debug.println(this, "e19CongcondData---------------"+e19CongcondData);
                req.setAttribute("e19CongcondData", e19CongcondData);
                req.setAttribute("Code_vt0", Code_vt0);
                req.setAttribute("Code_vt3", Code_vt3);

                if (!detailApporval(req, res, e19CongraRequestGlobalRFC))
                    return;

				  	boolean bFlag = false;
				  	Vector  vcAppLineData = e19CongraRequestGlobalRFC.getApprovalLine();
	              	for (int i = 0; i < vcAppLineData.size(); i++) {
	              		ApprovalLineData appLineData = (ApprovalLineData) vcAppLineData.get(i);
						DataUtil.fixNull(appLineData);

			        	if((appLineData.APPR_TYPE.equals("01"))&&(appLineData.APPU_TYPE.equals("02")) && (user.empNo.equals(appLineData.APPU_NUMB)) ){
		          			bFlag = true;
		          		}
		           	  }
	              	req.setAttribute("bFlag", bFlag);
					int k = 0;
					int seq = 0;
					for (int i = 0; i < vcAppLineData.size(); i++) {
						ApprovalLineData appLineData = (ApprovalLineData) vcAppLineData.get(i);
					  	if(appLineData.APPU_TYPE.equals("02") && appLineData.APPR_STAT.equals("") ){
					    	k = i;
					    	seq = Integer.parseInt(appLineData.APPR_SEQN);	//현재 결재순서
					    	break;
					  	}
					}
                printJspPage(req, res, WebUtil.JspURL + "E/E19Congra/E19CongraDetail_Global.jsp");

            } else if (jobid.equals("delete")) {           //제일처음 신청 화면에 들어온경우.

                String dest = deleteApproval(req, box, e19CongraRequestGlobalRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	E19CongraRequestGlobalRFC deleteRFC = new E19CongraRequestGlobalRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, e19CongraRequestGlobalRFC.getApprovalHeader().AINF_SEQN);

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
