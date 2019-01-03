/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재해신청                                                    */
/*   Program Name : 재해신청 조회                                               */
/*   Program ID   : E19CongraDetailSV                                           */
/*   Description  : 재해 신청을 조회할 수 있도록 하는 Class                     */
/*   Note         :                                                             */
/*   Creation     : 2001-12-19  김성일                                          */
/*   Update       : 2005-02-25  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E19Disaster;

import java.sql.*;
import java.util.Properties;
import java.util.Vector;
import javax.servlet.http.*;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalBaseServlet.DeleteFunction;
import hris.common.db.*;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.*;
import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.E.E19Disaster.E19CongcondData;
import hris.E.E19Disaster.rfc.*;

public class E19CongraDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="09";  // 결재 업무타입(경조금)
    private String UPMU_NAME = "재해";

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

            /* 조회 */
            E19CongcondData     e19CongcondData = null;
            final E19CongraRequestRFC e19CongraRequestRFC = new E19CongraRequestRFC();
            e19CongraRequestRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector resultList = e19CongraRequestRFC.getDetail(); //결과 데이타

            Vector E19CongcondData_vt = (Vector)resultList.get(0);

            Vector E19DisasterData_vt = (Vector)resultList.get(1);
            Logger.debug.println(this, "E19CongcondData_vt---"+E19CongcondData_vt.toString());
            Logger.debug.println(this, "E19DisasterData_vt---"+E19DisasterData_vt.toString());
            for( int i = 0 ; i < E19CongcondData_vt.size() ; i++ ){
                e19CongcondData = (E19CongcondData)E19CongcondData_vt.get(i);
                e19CongcondData.WAGE_WONX = Double.toString(Double.parseDouble(e19CongcondData.WAGE_WONX) * 100.0 ) ;  // 통상임금
                e19CongcondData.CONG_WONX = Double.toString(Double.parseDouble(e19CongcondData.CONG_WONX) * 100.0 ) ;  // 경조금
            }

            if (jobid.equals("first")) {           //제일처음 신청 화면에 들어온경우.

                req.setAttribute("e19CongcondData", e19CongcondData);
                req.setAttribute("E19DisasterData_vt", E19DisasterData_vt);
                req.setAttribute("resultData", e19CongcondData);

                if (!detailApporval(req, res, e19CongraRequestRFC))
                    return;


                printJspPage(req, res, WebUtil.JspURL + "E/E19Disaster/E19CongraDetail.jsp");

            } else if (jobid.equals("delete")) {           //제일처음 신청 화면에 들어온경우.

                String dest = deleteApproval(req, box, e19CongraRequestRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	E19CongraRequestRFC deleteRFC = new E19CongraRequestRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, e19CongraRequestRFC.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = deleteRFC.delete();

                        if(!returnEntity.isSuccess()) {
                            throw new GeneralException(e19CongraRequestRFC.getReturn().MSGTX);
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
