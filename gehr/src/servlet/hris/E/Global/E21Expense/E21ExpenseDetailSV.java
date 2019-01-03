/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 장학자금                                                    */
/*   Program Name : 장학자금 조회                                               */
/*   Program ID   : E21ExpenseDetailSV                                          */
/*   Description  : 학자금/장학금 조회할 수 있도록 하는 Class                   */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김성일                                          */
/*   Update       : 2005-03-01  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.Global.E21Expense;

import hris.E.Global.E17Hospital.rfc.E17HospitalDetailRFC01;
import hris.E.Global.E21Expense.E21ExpenseData;
import hris.E.Global.E21Expense.rfc.E21ExpenseRFC;
import hris.E.Global.E21Expense.rfc.E21ExpenseSchoolRFC;
import hris.E.Global.E23Language.rfc.E23LanguageRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalBaseServlet.DeleteFunction;
import hris.common.rfc.PersonInfoRFC;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class E21ExpenseDetailSV extends ApprovalBaseServlet {

	/**
	 *
	 */
	private static final long serialVersionUID = 2372129978673315114L;

	private String UPMU_TYPE = "12"; // 결재 업무타입(학자금/장학금- 주재원 )
	private String UPMU_NAME = "Tuition Fee";

	protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

	protected void performTask(HttpServletRequest req, HttpServletResponse res) 	throws GeneralException {

		try {
			HttpSession session = req.getSession(false);
			final WebUserData user = WebUtil.getSessionUser(req);

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

			Box box = WebUtil.getBox(req);

			String jobid = box.get("jobid", "first");
			String PERNR = box.get("PERNR", user.empNo);//getPERNR(box, user); //신청대상자 사번
			String AINF_SEQN = box.get("AINF_SEQN");

			final E21ExpenseRFC e21Rfc = new E21ExpenseRFC();
			e21Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // set DetailInput

			//E21ExpenseData firstData = new E21ExpenseData();
			Vector E21ExpenseData_vt = new Vector();
			E21ExpenseData e21ExpenseData = new E21ExpenseData();

			E21ExpenseData_vt = e21Rfc.detail(PERNR, AINF_SEQN);

			//Logger.debug.println(this, "장학자금 조회  : " + E21ExpenseData_vt);

			//firstData = (E21ExpenseData) E21ExpenseData_vt.get(0);
			e21ExpenseData = (E21ExpenseData) E21ExpenseData_vt.get(0);

			PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(e21ExpenseData.PERNR);
			req.setAttribute("PersonData", phonenumdata);

			if (jobid.equals("first")) {
				//--2016.11.18------start--
				E17HospitalDetailRFC01 rfc01=new E17HospitalDetailRFC01();
				Vector E17HdataFile_vt = rfc01.getMediDetail01(e21ExpenseData.PERNR, AINF_SEQN, "M", "1");
				req.setAttribute("E17HdataFile_vt", E17HdataFile_vt);
				//--2016.11.18--------end--

				E23LanguageRFC  rfc_lang            = new E23LanguageRFC();
	            Vector         names  = rfc_lang.getLanguageDetail(e21ExpenseData.PERNR, "1", "02", "2");
	            Vector 		  fnames = (Vector) names.get(2);  //Utils.indexOf(names, 2);
	            req.setAttribute("fnames", fnames);
	            Logger.debug.println(this, fnames.toString());

				E21ExpenseSchoolRFC schrfc = new E21ExpenseSchoolRFC();
				Vector schools = schrfc.display(e21ExpenseData.PERNR, "0001");

				req.setAttribute("schools", schools);
				req.setAttribute("schoolsKind",  (Vector)Utils.indexOf(schools, 0) );
				req.setAttribute("schoolsType", (Vector)Utils.indexOf(schools, 1) );
				req.setAttribute("e21ExpenseData", e21ExpenseData); // 확인 후 삭제
				req.setAttribute("resultData", e21ExpenseData);
				req.setAttribute("PERNR", PERNR);

				if (!detailApporval(req, res, e21Rfc))
	                   return;

					printJspPage(req, res, WebUtil.JspURL + "E/E21Expense/E21ExpenseDetail_Global.jsp");

			} else if (jobid.equals("delete")) {

				String dest = deleteApproval(req, box, e21Rfc, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	E21ExpenseRFC deleteRFC = new E21ExpenseRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, e21Rfc.getApprovalHeader().AINF_SEQN);
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
			throw new GeneralException(e);
		}

	}
}