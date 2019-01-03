/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �����ڱ�                                                    */
/*   Program Name : �����ڱ� ����                                               */
/*   Program ID   : E21ExpenseChangeSV                                          */
/*   Description  : ���ڱ�/���б� ������ �� �ֵ��� �ϴ� Class                   */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  �輺��                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                  2006-02-03  @v1.1 lsa ���ڱݽ�û����(��,����б����б��� ���ļ�ó���Ͽ� ���� ���� ó��) */
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

	private String UPMU_TYPE = "12"; // ���� ����Ÿ��(���ڱ�/���б�- ����� )
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
			String PERNR = box.get("PERNR", user.empNo);//getPERNR(box, user); //��û����� ���

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����
			String AINF_SEQN = box.get("AINF_SEQN");

			E21ExpenseRFC e21Rfc = new E21ExpenseRFC();
			e21Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // set DetailInput

			Vector E21ExpenseData_vt = new Vector();
			E21ExpenseData e21ExpenseData = new E21ExpenseData();

			E21ExpenseData_vt = e21Rfc.detail(PERNR,AINF_SEQN);

			Logger.debug.println(this, "�����ڱ� ��ȸ  : " + E21ExpenseData_vt);

			//firstData = (E21ExpenseData) E21ExpenseData_vt.get(0);
			e21ExpenseData = (E21ExpenseData) E21ExpenseData_vt.get(0);

			// �븮 ��û �߰�
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

			if (jobid.equals("first")) { // ����ó�� ��û ȭ�鿡 ���°��.

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

				req.setAttribute("isUpdate", true); //��� ���� ����
				req.setAttribute("e21ExpenseData", e21ExpenseData);  // ����
				req.setAttribute("resultData", e21ExpenseData);
				req.setAttribute("subty", box.get("subty"));// �������� ýũ
				req.setAttribute("objps", box.get("objps"));// �������� ýũ
				req.setAttribute("subf_type", box.get("subf_type"));// �������� ýũ
				req.setAttribute("PERNR", PERNR);

				detailApporval(req, res, e21Rfc);

				printJspPage(req, res, WebUtil.JspURL + "E/E21Expense/E21ExpenseChange_Global.jsp");


			} else if (jobid.equals("change")) {

				/* ���� ��û �κ� */
				dest = changeApproval(req, box, E21ExpenseData.class, e21Rfc, new ChangeFunction<E21ExpenseData>(){

					public String porcess(E21ExpenseData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine) throws GeneralException {

						Logger.debug.println("------expenseChangeSv 1 =====");

						inputData.PERNR_D = user.empNo;
                    	inputData.ZPERNR = user.empNo; // ��û�� ���(�븮��û, ���� ��û)
                    	inputData.UNAME = user.empNo; // ��û�� ���(�븮��û, ���� ��û)
                    	inputData.AEDTM = DataUtil.getCurrentDate(); // ������(���糯¥)

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
            			// if(e21ExpenseData.SUBTY.equals("0004")&&e21ExpenseData.SCHL_TYPE.equals("0002")&&(!firstData.OBJPS.equalsIgnoreCase(e21ExpenseData.OBJPS))){  Ȯ�� ��. firstData.OBJPS.equalsIgnoreCase(e21ExpenseData.OBJPS)
                				RepeatCheckRFC crfc=new RepeatCheckRFC();
                				Vector rmess = crfc.checkApp(user.companyCode,  box.get("PERNR"), UPMU_TYPE, appytype, inputData.OBJPS);

                				tmessage = (String) Utils.indexOf(rmess, 0);
                				amessage = (String) Utils.indexOf(rmess, 2);
            			 }else{
            				 tmessage = "N";
            			 }

                        if(tmessage.equalsIgnoreCase("N")){

                        	/* ���� ��û RFC ȣ�� */
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

                        /* ������ �ۼ� �κ� �� */
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
