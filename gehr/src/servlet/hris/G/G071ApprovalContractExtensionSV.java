/********************************************************************************/
/*	  System Name  	: g-HR                                                														
/*   1Depth Name		: HR Approval Box  
/*   2Depth Name  	: Requested Document                                                   
/*   Program Name 	: Contract Extension                                              
/*   Program ID   		: G071ApprovalContractExtensionSV.java
/*   Description  		: Contract Extension 결재을 하는 Class                         
/*   Note         		:                                                            
/*   Creation     		: 2010-10-13 jungin @v1.0 Contract Extension 신규 개발
/*							: 2010-12-15 jungin @v1.1 Contract Extension 업무의 메일 수신자 변경 처리
/*																 (대상자(Emp.)가 아닌 대리신청자 (Part, Team Leader)임.)
/********************************************************************************/

package servlet.hris.G;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D09ContractExtension.D09ExtensionData;
import hris.D.D09ContractExtension.rfc.D09ContractExtensionRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;
import java.util.Vector;

/**
 * 
 * G071ApprovalContractExtensionSV 
 * 
 * @author jungin
 * @creation 2010/10/13
 */
public class G071ApprovalContractExtensionSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "16";		// 결재 업무타입(ContractExtension)

    private String UPMU_NAME = "Contract Extension";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) 
    		throws GeneralException {
        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";

            final Box box = WebUtil.getBox(req);

            String  AINF_SEQN  = box.get("AINF_SEQN");

            String jobid = box.get("jobid");
            /* 승인 반려 시 */

            final D09ContractExtensionRFC d09ContractExtensionRFC = new D09ContractExtensionRFC();
            d09ContractExtensionRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
            Map<String, D09ExtensionData> resultData = d09ContractExtensionRFC.getDetail(null); //결과 데이타

            D09ExtensionData extensionData = resultData.get("T_RESULT");

            /* 승인 시 */
            if("A".equals(jobid)) {
                /* 개발자 영역 끝 */
                dest = accept(req, box, "T_ZHR0241T", extensionData, d09ContractExtensionRFC, new ApprovalFunction<D09ExtensionData>() {
                    public boolean porcess(D09ExtensionData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        return true;
                    }
                });

            /* 반려시 */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, extensionData, d09ContractExtensionRFC, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, extensionData, d09ContractExtensionRFC, null);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        }

    }
    
}
