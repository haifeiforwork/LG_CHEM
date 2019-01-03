/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name		: Benefit Management
/*   Program Name	: Celebration & Condolence
/*   Program ID		: E19CongraChangeSV
/*   Description 		: 경조금을 수장할 수 있도록 하는 Class
/*   Note         		: 없음
/*   Creation     		: 2001-12-19  김성일
/*   Update       		: 2005-02-14  이승희
/*                  		: 2005-02-24  윤정현
/*   Update       		: 2008-11-03  김정인  @v1.2  [C20081031_51421] 수습직원 직계가족 조사 신청 가능 변경.(LG CCI한함)
/********************************************************************************/

package servlet.hris.E.E19Congra;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.E.E19Congra.E19CongcondGlobalData;
import hris.E.E19Congra.rfc.E19CongraRFC;
import hris.E.E19Congra.rfc.E19CongraRequestGlobalRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.util.Vector;

public class E19CongraChangeGlobalSV extends ApprovalBaseServlet {

	private String UPMU_TYPE	= "06";	// 결재 업무타입(경조금)

	private String UPMU_NAME	= "Celebration & Condolence";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

	protected void performTask(final HttpServletRequest req, HttpServletResponse res)
			throws GeneralException {
		Connection con = null;

		try {
			final WebUserData user = WebUtil.getSessionUser(req);
			 final Box box = WebUtil.getBox(req);


			 String dest;

	            String jobid = box.get("jobid", "first");
	            String AINF_SEQN = box.get("AINF_SEQN");

	            //**********수정 끝.****************************

	            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서



	            /* 자격 정보 조회 */
	            final E19CongraRequestGlobalRFC e19CongraRequestGlobalRFC = new E19CongraRequestGlobalRFC();
	            e19CongraRequestGlobalRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

	            Vector<E19CongcondGlobalData> resultList = e19CongraRequestGlobalRFC.getDetail(); //결과 데이타
	            E19CongcondGlobalData e19CongcondData = Utils.indexOf(resultList, 0);

				 final String PERNR =e19CongcondData.PERNR;

	            PersonInfoRFC numfunc = new PersonInfoRFC();
	            final PersonData phonenumdata;
	            phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR);
	             req.setAttribute("PersonData" , phonenumdata );
				req.setAttribute("PERNR", PERNR);
				E19CongraRFC rfc_congra = new E19CongraRFC();
				Vector famyCode = rfc_congra.getEntryCode(PERNR, "", "0001");
	            Vector  Code_vt0 = (Vector) Utils.indexOf(famyCode, 0);
	            Vector  Code_vt3  = (Vector) Utils.indexOf(famyCode, 3);

	            if( jobid.equals("first") ) {  //제일처음 수정 화면에 들어온경우.
	                req.setAttribute("e19CongraData", e19CongcondData);

	                req.setAttribute("isUpdate", true); //등록 수정 여부
					req.setAttribute("famyCode", famyCode);
	                req.setAttribute("Code_vt0", Code_vt0);
	                req.setAttribute("Code_vt3", Code_vt3);
	                detailApporval(req, res, e19CongraRequestGlobalRFC);

	                printJspPage(req, res, WebUtil.JspURL + "E/E19Congra/E19CongraBuild_Global.jsp");

	            } else if( jobid.equals("change") ) {

	                /* 실제 신청 부분 */
	                dest = changeApproval(req, box, E19CongcondGlobalData.class, e19CongraRequestGlobalRFC, new ChangeFunction<E19CongcondGlobalData>(){

	                    public String porcess(E19CongcondGlobalData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {


	                        /* 결재 신청 RFC 호출 */
	                    	E19CongraRequestGlobalRFC changeRFC = new E19CongraRequestGlobalRFC();
	                    	changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

	                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

	                        changeRFC.build(inputData.PERNR,  inputData.CELTY,
	                    			inputData.FAMSA, inputData.FAMY_CODE,
	                    			inputData.CELDT,  Utils.asVector(inputData), box, req);

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


