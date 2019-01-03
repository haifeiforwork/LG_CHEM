/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 교육출장                                                    */
/*   Program Name : 교육출장 신청                                               */
/*   Program ID   : D19EduTripChangeSV.java                                     */
/*   Description  : 교육출장신청을 하는 Class                                   */
/*   Note         :                                                             */
/*   Creation     : 2010-31-31 lsa                                              */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
package servlet.hris.D.D19EduTrip;

import java.sql.*;
import java.util.Properties;
import java.util.Vector;
import javax.servlet.http.*;

import servlet.hris.A.A17Licence.A17LicenceBuildSV;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.ChangeFunction;
import hris.common.db.*;
import hris.common.util.*;
import hris.common.rfc.*;
import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceGradeRFC;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.D.D19EduTrip.*;
import hris.D.D19EduTrip.rfc.*;

/**
 * D19EduTripChangeSV.java
 * 교육,출장신청을 수정할 수 있도록 하는 Class
 *
 * @author lsa
 * @version 1.0, 2006/08/21
 */
public class D19EduTripChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="35";            // 결재 업무타입(교육,출장신청)
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

            String dest;

            String jobid = box.get("jobid", "first");
            String AINF_SEQN = box.get("AINF_SEQN");

            //**********수정 끝.****************************

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            /* 교육출장 정보 조회 */
            final D19EduTripRFC d19EduTripRFC = new D19EduTripRFC();
            d19EduTripRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<D19EduTripData> resultList = d19EduTripRFC.getVocation(); //결과 데이타

            D19EduTripData resultData = Utils.indexOf(resultList, 0);


            if( jobid.equals("first") ) {           //제일처음 신청 화면에 들어온경우.
                req.setAttribute("jobid", jobid);
                req.setAttribute("message", "");
                req.setAttribute("resultData", resultData);
                req.setAttribute("D19EduTripData_vt", resultList);
                req.setAttribute("isUpdate", true); //등록 수정 여부
                detailApporval(req, res, d19EduTripRFC);

                printJspPage(req, res, WebUtil.JspURL + "D/D19EduTrip/D19EduTripBuild.jsp");


            } else if( jobid.equals("change") ) {       //

            	  dest = changeApproval(req, box, D19EduTripData.class, d19EduTripRFC, new ChangeFunction<D19EduTripData>(){

                      public String porcess(D19EduTripData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                    	  D19EduTripBuildSV.checkDup(inputData); /* 중복 확인 - 해외 */

                          /* 결재 신청 RFC 호출 */
                          D19EduTripRFC changeRFC = new D19EduTripRFC();
                          changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                          Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

                          changeRFC.build(Utils.asVector(inputData), box, req);

                          if(!changeRFC.getReturn().isSuccess()) {
                              throw new GeneralException(d19EduTripRFC.getReturn().MSGTX);
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
        } finally {
            DBUtil.close(con);
        }
	}
}
