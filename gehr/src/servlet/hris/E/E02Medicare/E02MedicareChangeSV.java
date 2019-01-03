/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 건강보험 재발급                                             */
/*   Program Name : 건강보험 재발급/추가발급/기재사항변경 신청 수정             */
/*   Program ID   : E02MedicareChangeSV                                         */
/*   Description  : 건강보험증 변경/재발급 수정을 할 수 있도록 하는 Class       */
/*   Note         :                                                             */
/*   Creation     : 2002-01-29  박영락                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E02Medicare;

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
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;
import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.E.E02Medicare.E02MedicareData;
import hris.E.E02Medicare.rfc.*;

public class E02MedicareChangeSV extends ApprovalBaseServlet {

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
            String AINF_SEQN = box.get("AINF_SEQN");

            //**********수정 끝.****************************

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            final E02MedicareRFC e02MedicareRFC = new E02MedicareRFC();
            e02MedicareRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

            Vector<E02MedicareData> resultList = e02MedicareRFC.getDetail(); //결과 데이타
            E02MedicareData resultData = Utils.indexOf(resultList, 0);



            if( jobid.equals("first") ) {
            	Logger.debug.println("resultData----------------------------------------------------"+resultData);
            	req.setAttribute("resultData", resultData);
                req.setAttribute("isUpdate", true); //등록 수정 여부
                req.setAttribute("targetName_vt" , new E02MedicareTargetNameRFC().getName(resultData.PERNR) );
                req.setAttribute("e02MedicareIssue_vt" ,  new E02MedicareIssueRFC().getIssue() );
                req.setAttribute("e02MedicareReIssue_vt" ,  new E02MedicareReIssueRFC().getReIssue() );
                req.setAttribute("e02MedicareREQ_vt" ,   new E02MedicareREQRFC().getRequest() );
                req.setAttribute("e02MedicareEnroll_vt" ,   new E02MedicareEnrollRFC().getEnroll() );

                detailApporval(req, res, e02MedicareRFC);

                printJspPage(req, res, WebUtil.JspURL + "E/E02Medicare/E02MedicareBuild.jsp");

            } else if( jobid.equals("change") ) {

                /* 실제 신청 부분 */
                dest = changeApproval(req, box, E02MedicareData.class, e02MedicareRFC, new ChangeFunction<E02MedicareData>(){

                    public String porcess(E02MedicareData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {


                        /* 결재 신청 RFC 호출 */
                    	E02MedicareRFC changeRFC = new E02MedicareRFC();
                        changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

                        changeRFC.build(Utils.asVector(inputData), box, req);

                        if(!changeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(changeRFC.getReturn().MSGTX);
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
        }
	}
}