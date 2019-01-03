/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 건강보험 재발급                                             */
/*   Program Name : 건강보험 재발급/추가발급/기재사항변경 신청                  */
/*   Program ID   : E02MedicareBuildSV                                          */
/*   Description  : 건강보험증 변경/재발급 신청을 할수 있도록 하는 Class        */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  박영락                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E02Medicare;

import java.sql.*;
import java.util.Properties;
import java.util.Vector;
import javax.servlet.http.*;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.RequestFunction;
import hris.common.db.*;
import hris.common.rfc.*;
import hris.common.util.AppUtil;
import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceGradeRFC;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.E.E01Medicare.rfc.E01HealthGuarReqsRFC;
import hris.E.E02Medicare.E02MedicareData;
import hris.E.E02Medicare.rfc.*;

public class E02MedicareBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="21";
    private String UPMU_NAME = "건강보험 재발급";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {


        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest;

            String jobid = box.get("jobid", "first");

            if( jobid.equals("first") ) {

                String PERNR = getPERNR(box, user); //신청대상자 사번

                //결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);
                E02MedicareTargetNameRFC func      = new E02MedicareTargetNameRFC();



                req.setAttribute("PERNR" , PERNR );
                req.setAttribute("targetName_vt" , new E02MedicareTargetNameRFC().getName(PERNR) );
                req.setAttribute("e02MedicareIssue_vt" ,  new E02MedicareIssueRFC().getIssue() );
                req.setAttribute("e02MedicareReIssue_vt" ,  new E02MedicareReIssueRFC().getReIssue() );
                req.setAttribute("e02MedicareREQ_vt" ,   new E02MedicareREQRFC().getRequest() );
                req.setAttribute("e02MedicareEnroll_vt" ,   new E02MedicareEnrollRFC().getEnroll() );



                dest = WebUtil.JspURL + "E/E02Medicare/E02MedicareBuild.jsp";

            } else if (jobid.equals("create")) {

                /* 실제 신청 부분 */
                dest = requestApproval(req, box, E02MedicareData.class, new RequestFunction<E02MedicareData>() {
                    public String porcess(E02MedicareData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {


                        /* 결재 신청 RFC 호출 */
                    	E02MedicareRFC e02MedicareRFC = new E02MedicareRFC();
                    	e02MedicareRFC.setRequestInput(user.empNo, UPMU_TYPE);
                        String AINF_SEQN = e02MedicareRFC.build(Utils.asVector(inputData), box, req);

                        if(!e02MedicareRFC.getReturn().isSuccess()) {
                            throw new GeneralException(e02MedicareRFC.getReturn().MSGTX);
                        };

                        return AINF_SEQN;
                        /* 개발자 작성 부분 끝 */
                    }
                });
            } else {
                throw new GeneralException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }
}