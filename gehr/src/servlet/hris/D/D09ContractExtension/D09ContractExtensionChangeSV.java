/********************************************************************************/
/*	  System Name  	: g-HR                                                														
/*   1Depth Name		: Application  
/*   2Depth Name  	: Time Management                                                    
/*   Program Name 	: Contract Extension                                              
/*   Program ID   		: D09ContractExtensionChangeSV.java
/*   Description  		: Contract Extension 신청 수정을 하는 Class                         
/*   Note         		:                                                            
/*   Creation     		: 2010-10-13 jungin @v1.0 Contract Extension 신규 개발      
/********************************************************************************/

package servlet.hris.D.D09ContractExtension;

import com.common.Utils;
import com.sns.jdf.BusinessException;
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
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;
import java.util.Vector;

public class D09ContractExtensionChangeSV extends ApprovalBaseServlet {

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

		try{
			final WebUserData user = WebUtil.getSessionUser(req);

			final Box box = WebUtil.getBox(req);

			String dest;

			String jobid = box.get("jobid", "first");
			String AINF_SEQN = box.get("AINF_SEQN");

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            /* 자격 정보 조회 */
			final D09ContractExtensionRFC d09ContractExtensionRFC = new D09ContractExtensionRFC();
			d09ContractExtensionRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

			D09ExtensionData resultData = d09ContractExtensionRFC.getDetail(null).get("T_RESULT"); //결과 데이타

			if( jobid.equals("first") ) {  //제일처음 수정 화면에 들어온경우.

				/* 초기값 조회 */
				D09ContractExtensionRFC currentRFC = new D09ContractExtensionRFC();
				currentRFC.setDetailInput(user.empNo, null, null);
				Map<String, D09ExtensionData> currnetResult = currentRFC.getDetail(resultData.PERNR);

				req.setAttribute("T_CURRENT", currnetResult.get("T_CURRENT"));

				req.setAttribute("applicationType", (new SelectedCodeRFC()).getSelectedCode("ZDAPTYP"));
				req.setAttribute("payType", (new SelectedCodeRFC()).getSelectedCode("ZPAYTYPE"));
				req.setAttribute("contractType", (new D09ContractExtensionTypeRFC()).getContractExtensionType("U"));

				req.setAttribute("T_RESULT", resultData);

				req.setAttribute("isUpdate", true); //등록 수정 여부

				detailApporval(req, res, d09ContractExtensionRFC);

				printJspPage(req, res, WebUtil.JspURL + "D/D09ContractExtension/D09ContractExtensionBuild.jsp");

			} else if( jobid.equals("change") ) {

                /* 실제 신청 부분 */
				dest = changeApproval(req, box, D09ExtensionData.class, d09ContractExtensionRFC, new ChangeFunction<D09ExtensionData>(){

					public String porcess(D09ExtensionData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
						D09ContractExtensionRFC changeRFC = new D09ContractExtensionRFC();
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
