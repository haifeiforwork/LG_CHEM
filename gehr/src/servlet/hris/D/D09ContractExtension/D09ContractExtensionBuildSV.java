/********************************************************************************/
/*	  System Name  	: g-HR                                                														
/*   1Depth Name		: Application  
/*   2Depth Name  	: Time Management                                                    
/*   Program Name 	: Contract Extension                                              
/*   Program ID   		: D09ContractExtensionBuildSV.java
/*   Description  		: Contract Extension 신청을 하는 Class                         
/*   Note         		:                                                            
/*   Creation     		: 2010-10-13 jungin @v1.0 Contract Extension 신규 개발      
/********************************************************************************/

package servlet.hris.D.D09ContractExtension;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.D.D09ContractExtension.D09ExtensionData;
import hris.D.D09ContractExtension.rfc.D09ContractExtensionRFC;
import hris.D.D09ContractExtension.rfc.D09ContractExtensionTypeRFC;
import hris.common.SelectedCodeRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;
import java.util.Vector;

public class D09ContractExtensionBuildSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "16";		// 결재 업무타입(ContractExtension)

	private String UPMU_NAME = "Contract Extension";

	protected String getUPMU_TYPE() {
		return UPMU_TYPE;
	}

	protected String getUPMU_NAME() {
		return UPMU_NAME;
	}

	protected void performTask(final HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {

		try {
			final WebUserData user = WebUtil.getSessionUser(req);

			final Box box = WebUtil.getBox(req);

			String dest;

			String jobid = box.get("jobid", "first");

//			String PAYDR = box.get("PAYDR", "CW");


			if (jobid.equals("first")) {   //제일처음 신청 화면에 들어온경우.
				String PERNR = getPERNR(box, user); //신청대상자 사번

				/*ApprovalLineInput inputData = new ApprovalLineInput();*/

				//결재라인, 결재 헤더 정보 조회
				getApprovalInfo(req, PERNR);

				/* 초기값 조회 */
				D09ContractExtensionRFC d09ContractExtensionRFC = new D09ContractExtensionRFC();
				d09ContractExtensionRFC.setDetailInput(user.empNo, null, null);
				Map<String, D09ExtensionData> resultData = d09ContractExtensionRFC.getDetail(PERNR);

				req.setAttribute("T_CURRENT", resultData.get("T_CURRENT"));

				req.setAttribute("applicationType", (new SelectedCodeRFC()).getSelectedCode("ZDAPTYP"));
				req.setAttribute("payType", (new SelectedCodeRFC()).getSelectedCode("ZPAYTYPE"));
				req.setAttribute("contractType", (new D09ContractExtensionTypeRFC()).getContractExtensionType("U"));

				dest = WebUtil.JspURL + "D/D09ContractExtension/D09ContractExtensionBuild.jsp";
			} else if (jobid.equals("create")) {

                /* 실제 신청 부분 */
				dest = requestApproval(req, box, D09ExtensionData.class, new RequestFunction<D09ExtensionData>() {
					public String porcess(D09ExtensionData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
						D09ContractExtensionRFC d09ContractExtensionRFC = new D09ContractExtensionRFC();
						d09ContractExtensionRFC.setRequestInput(user.empNo, UPMU_TYPE);
						String AINF_SEQN = d09ContractExtensionRFC.build(Utils.asVector(inputData), box, req);

						if(!d09ContractExtensionRFC.getReturn().isSuccess()) {
							throw new GeneralException(d09ContractExtensionRFC.getReturn().MSGTX);
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
