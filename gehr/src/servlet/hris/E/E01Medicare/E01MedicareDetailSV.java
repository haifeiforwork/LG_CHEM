/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 건강보험 피부양자 조회                                      */
/*   Program Name : 건강보험 피부양자 취득/상실 조회                            */
/*   Program ID   : E01MedicareDetailSV                                         */
/*   Description  : 건강보험 피부양자 자격(취득/상실) 신청에 대한 상세내용을    */
/*                  조회하여 E01MedicareDetail.jsp 값을 넘겨주는 class          */
/*                  jobid가 first일 경우는 AppLineDB.class를 호출하여 값을      */
/*                  jsp페이지로 넘겨주고,                                       */
/*                  jobid가 delete일 경우는 AppLineDB.class를 호출하여 DB에     */
/*                  값을 delete 시킨다.                                         */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  김도신                                          */
/*   Update       : 2005-02-28  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E01Medicare;

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
import hris.common.util.*;
import hris.common.rfc.*;
import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.E.E01Medicare.E01HealthGuaranteeData;
import hris.E.E01Medicare.rfc.*;

public class E01MedicareDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="20";   // 결재 업무타입(자격변경)
    private String UPMU_NAME = "건강보험 피부양자";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }


    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {

        try{

            final WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);


            String jobid = box.get("jobid", "first");
            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            final E01HealthGuaranteeRFC e01HealthGuaranteeRFC = new E01HealthGuaranteeRFC();
            e01HealthGuaranteeRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<E01HealthGuaranteeData> e01HealthGuaranteeData_vt = e01HealthGuaranteeRFC.getDetail(); //결과 데이타


            Logger.debug.println(this, "피부양자 자격 신청 조회 : " + e01HealthGuaranteeData_vt.toString());

            E01HealthGuaranteeData firstData = Utils.indexOf(e01HealthGuaranteeData_vt, 0);


            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            // XxxDetailSV.java 와 XxxDetail.jsp 에 '목록' 버튼 활성화 여부를 가려주는 부분
            String ThisJspName = box.get("ThisJspName");
            req.setAttribute("ThisJspName", ThisJspName);
            //XxxDetailSV.java 와 XxxDetail.jsp 에 '목록' 버튼 활성화 여부를 가려주는 부분

            if( jobid.equals("first") ) {

            	 req.setAttribute("e01HealthGuaranteeData_vt", e01HealthGuaranteeData_vt);
            	 req.setAttribute("firstData", firstData);

                if (!detailApporval(req, res, e01HealthGuaranteeRFC))
                    return;
                printJspPage(req, res, WebUtil.JspURL+"E/E01Medicare/E01MedicareDetail.jsp");

//---------------------------------------------------------------------------------------------------------
            } else if (jobid.equals("delete")) {           //제일처음 신청 화면에 들어온경우.

                String dest = deleteApproval(req, box, e01HealthGuaranteeRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	E01HealthGuaranteeRFC deleteRFC = new E01HealthGuaranteeRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, e01HealthGuaranteeRFC.getApprovalHeader().AINF_SEQN);

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

