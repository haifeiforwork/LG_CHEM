/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 교육출장                                                    */
/*   Program Name : 교육출장 신청                                               */
/*   Program ID   : D19EduTripBuild.java                                        */
/*   Description  : 교육출장신청을 하는 Class                                   */
/*   Note         :                                                             */
/*   Creation     : 2010-31-31 lsa                                              */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D19EduTrip;

import hris.D.D19EduTrip.D19EduTripData;
import hris.D.D19EduTrip.rfc.D19DupCheckRFC;
import hris.D.D19EduTrip.rfc.D19EduTripRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;

import java.sql.Connection;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

/**
 * D19EduTripBuildSV.java
 * 교육, 출장를 신청할 수 있도록 하는 Class
 *
 * @author 김도신
 * @version 1.0, 2002/01/03
 */
public class D19EduTripBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="35";            // 결재 업무타입(교육, 출장신청)

	private String UPMU_NAME = "교육/출장 신청";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
	  protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest = "";
            String jobid = box.get("jobid", "first");
            final String PERNR = getPERNR(box, user); //신청대상자 사번

            if( jobid.equals("first") ) {           //제일처음 신청 화면에 들어온경우.

                //결재라인, 결재 헤더 정보 조회

                getApprovalInfo(req, PERNR);
                dest = WebUtil.JspURL+"D/D19EduTrip/D19EduTripBuild.jsp";
                req.setAttribute("jobid", jobid);
                req.setAttribute("message", "");

            } else if (jobid.equals("create")) {

                /* 실제 신청 부분 */
                dest = requestApproval(req, box, D19EduTripData.class, new RequestFunction<D19EduTripData>() {
                    public String porcess(D19EduTripData inputData,Vector<ApprovalLineData> approvalLine) throws GeneralException {
                        //------------------------------------ 중복 체크 ------------------------------------//
                        /* 결재 신청 RFC 호출 */
                    	D19EduTripRFC d19EduTripRFC = new D19EduTripRFC();
                    	d19EduTripRFC.setRequestInput(user.empNo, UPMU_TYPE);
                    	//중복체크
                    	checkDup(inputData);
                        String AINF_SEQN = d19EduTripRFC.build(Utils.asVector(inputData), box, req);

                        if(!d19EduTripRFC.getReturn().isSuccess()) {
                        	 throw new GeneralException(d19EduTripRFC.getReturn().MSGTX);
                        }
                        return AINF_SEQN;
                        /* 개발자 작성 부분 끝 */
                    }
                });
              }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);


        } catch(Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
	}

	    /**
	     * @return
	     * @throws GeneralException
	     */
	    public static boolean checkDup(D19EduTripData eduTripData)
	            throws GeneralException {
	        D19DupCheckRFC d19DupCheckRFC = new D19DupCheckRFC();
	        RFCReturnEntity returnEntity = d19DupCheckRFC.check(eduTripData);
            if(returnEntity.MSGTY.equals("E")) {
            	    throw new GeneralException(d19DupCheckRFC.getReturn().MSGTX);
            	}
	        return true;
	    }

}
