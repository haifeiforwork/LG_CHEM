/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 장학자금                                                    */
/*   Program Name : 장학자금 수정                                               */
/*   Program ID   : E21ExpenseChangeSV                                          */
/*   Description  : 학자금/장학금 수정할 수 있도록 하는 Class                   */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김성일                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                  2006-02-03  @v1.1 lsa 학자금신청오류(중,고등학교입학금을 합쳐서처리하여 따로 따로 처리) */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.Global.E21Expense;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.E.Global.E17Hospital.rfc.E17HospitalDetailRFC01;
import hris.E.Global.E17Hospital.rfc.E17HospitalFmemberRFC;
import hris.E.Global.E21Expense.E21ExpenseData;
import hris.E.Global.E21Expense.E21ExpenseData1;
import hris.E.Global.E21Expense.rfc.E21ExpenseRFC;
import hris.E.Global.E21Expense.rfc.E21ExpenseSchoolRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;
import hris.common.rfc.RepeatCheckRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

public class E21ExpenseChangeSV extends ApprovalBaseServlet {

	/**
	 *
	 */
	private static final long serialVersionUID = -7123120454484000402L;

	private String UPMU_TYPE = "12"; // 결재 업무타입(학자금/장학금- 주재원 )
	private String UPMU_NAME = "Tuition Fee";

	protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

	protected void performTask(final HttpServletRequest req, HttpServletResponse res)	throws GeneralException {

		try {
			HttpSession session = req.getSession(false);
			final WebUserData user = WebUtil.getSessionUser(req);
			final Box box = WebUtil.getBox(req);

			String dest = "";
			String jobid = box.get("jobid", "first");
			String PERNR = box.get("PERNR", user.empNo);//getPERNR(box, user); //신청대상자 사번

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서
			String AINF_SEQN = box.get("AINF_SEQN");

			E21ExpenseRFC e21Rfc = new E21ExpenseRFC();
			e21Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // set DetailInput

			Vector E21ExpenseData_vt = new Vector();
			E21ExpenseData e21ExpenseData = new E21ExpenseData();

			E21ExpenseData_vt = e21Rfc.detail(PERNR,AINF_SEQN);

			Logger.debug.println(this, "장학자금 조회  : " + E21ExpenseData_vt);

			//firstData = (E21ExpenseData) E21ExpenseData_vt.get(0);
			e21ExpenseData = (E21ExpenseData) E21ExpenseData_vt.get(0);

			// 대리 신청 추가
			PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(e21ExpenseData.PERNR);
			req.setAttribute("PersonData", phonenumdata);

			//--2016.11.18------start--
			E17HospitalDetailRFC01 rfc01=new E17HospitalDetailRFC01();
			final Vector E17HdataFile_vt = rfc01.getMediDetail01(e21ExpenseData.PERNR, AINF_SEQN, "M", "1");
			req.setAttribute("E17HdataFile_vt", E17HdataFile_vt);
			Logger.debug.println("------E17HdataFile_vt1====="+E17HdataFile_vt);
			//--2016.11.18--------end--

			if (jobid.equals("first")) { // 제일처음 신청 화면에 들어온경우.

				Vector<E21ExpenseData1> fnames = new Vector();
				Vector names = (new E17HospitalFmemberRFC()).getCodeVector1(e21ExpenseData.PERNR);
				for(int i=0;i<names.size();i++){
					E21ExpenseData1 entity= (E21ExpenseData1) names.get(i);
					if(entity.code.equals("2")){
						fnames.addElement(entity);
					}
				}

				Vector  nameDetailData_vt= new Vector();
				Vector  nameObjData_vt= new Vector();

				for(int i=0;i<fnames.size();i++){
					E21ExpenseData1 ndata =(E21ExpenseData1)fnames.get(i);
					nameDetailData_vt.add(i,ndata.value);
					nameObjData_vt.add(i,ndata.obj);
				}

				req.setAttribute("nameDetailData_vt", nameDetailData_vt);
				req.setAttribute("nameObjData_vt", nameObjData_vt);
				//Logger.debug.println(this, "=============="+fnames.toString());

				E21ExpenseSchoolRFC schrfc = new E21ExpenseSchoolRFC();
				Vector schools = schrfc.display(e21ExpenseData.PERNR, "0001");

				req.setAttribute("schoolsKind",  (Vector)Utils.indexOf(schools, 0) );
				req.setAttribute("schoolsType", (Vector)Utils.indexOf(schools, 1) );

				//e21ExpenseData = (E21ExpenseData) E21ExpenseData_vt.get(0);

				req.setAttribute("isUpdate", true); //등록 수정 여부
				req.setAttribute("e21ExpenseData", e21ExpenseData);  // 삭제
				req.setAttribute("resultData", e21ExpenseData);
				req.setAttribute("subty", box.get("subty"));// 수정에서 첵크
				req.setAttribute("objps", box.get("objps"));// 수정에서 첵크
				req.setAttribute("subf_type", box.get("subf_type"));// 수정에서 첵크
				req.setAttribute("PERNR", PERNR);

				detailApporval(req, res, e21Rfc);

				printJspPage(req, res, WebUtil.JspURL + "E/E21Expense/E21ExpenseChange_Global.jsp");


			} else if (jobid.equals("change")) {

				/* 실제 신청 부분 */
				dest = changeApproval(req, box, E21ExpenseData.class, e21Rfc, new ChangeFunction<E21ExpenseData>(){

					public String porcess(E21ExpenseData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine) throws GeneralException {

						Logger.debug.println("------expenseChangeSv 1 =====");

						inputData.PERNR_D = user.empNo;
                    	inputData.ZPERNR = user.empNo; // 신청자 사번(대리신청, 본인 신청)
                    	inputData.UNAME = user.empNo; // 신청자 사번(대리신청, 본인 신청)
                    	inputData.AEDTM = DataUtil.getCurrentDate(); // 변경일(현재날짜)

                    	Logger.debug.println("------expenseChangeSv 2 =====");
                    	inputData.PERNR = inputData.PERNR;
        				if(inputData.REIM_AMTH_CONV==null||inputData.REIM_AMTH_CONV.equals("")){
        					inputData.REIM_AMTH_CONV="0";
        				}

                    	box.put("I_GTYPE", "3");

                        String appytype = ((ApprovalLineData)approvalLine.get(0)).APPR_TYPE;
                        String tmessage ="N";
                        String amessage = "";

                        if(inputData.SUBTY.equals("0004")&&inputData.SCHL_TYPE.equals("0002")){
            			// if(e21ExpenseData.SUBTY.equals("0004")&&e21ExpenseData.SCHL_TYPE.equals("0002")&&(!firstData.OBJPS.equalsIgnoreCase(e21ExpenseData.OBJPS))){  확인 필. firstData.OBJPS.equalsIgnoreCase(e21ExpenseData.OBJPS)
                				RepeatCheckRFC crfc=new RepeatCheckRFC();
                				Vector rmess = crfc.checkApp(user.companyCode,  box.get("PERNR"), UPMU_TYPE, appytype, inputData.OBJPS);

                				tmessage = (String) Utils.indexOf(rmess, 0);
                				amessage = (String) Utils.indexOf(rmess, 2);
            			 }else{
            				 tmessage = "N";
            			 }

                        if(tmessage.equalsIgnoreCase("N")){

                        	/* 결재 신청 RFC 호출 */
                        	E21ExpenseRFC changeRFC = new E21ExpenseRFC();
                    		changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);
                        	changeRFC.build(Utils.asVector(inputData), box, req, E17HdataFile_vt);

                        	 //Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  changeRFC.getReturn().isSuccess() );
                             //Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  changeRFC.getReturn() );

	                        if(!changeRFC.getReturn().isSuccess()) {
	                        	 throw new GeneralException(changeRFC.getReturn().MSGTX);
	                        }
	                        return inputData.AINF_SEQN;
                    	}else {
                    		throw new GeneralException(amessage );
                    	}

                        /* 개발자 작성 부분 끝 */
                    }
                });

				 printJspPage(req, res, dest);

			} else {
				throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
			}

		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}
}
