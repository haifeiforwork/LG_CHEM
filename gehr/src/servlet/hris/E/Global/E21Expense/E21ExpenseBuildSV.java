/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 장학자금                                                    */
/*   Program Name : 장학자금 신청                                               */
/*   Program ID   : E21ExpenseBuildSV                                           */
/*   Description  : 학자금/장학금 신청할 수 있도록 하는 Class                   */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김성일                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                     2006-02-03  @v1.1 lsa 학자금신청오류(중,고등학교입학금을 합쳐서처리하여 따로 따로 처리) */
/*			            2017-05-25 eunha [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치  */
/********************************************************************************/

package servlet.hris.E.Global.E21Expense;

import hris.E.Global.E17Hospital.E17HospitalDetailData2;
import hris.E.Global.E17Hospital.rfc.E17HospitalFmemberRFC;
import hris.E.Global.E21Expense.E21ExpenseData;
import hris.E.Global.E21Expense.E21ExpenseData1;
import hris.E.Global.E21Expense.E21ExpenseStructData;
import hris.E.Global.E21Expense.rfc.E21ExpenseRFC;
import hris.E.Global.E21Expense.rfc.E21ExpenseSchoolRFC;

import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;
import hris.common.rfc.RepeatCheckRFC;

import java.io.File;
import java.io.FileOutputStream;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.io.IOUtils;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class E21ExpenseBuildSV extends ApprovalBaseServlet {

	/**
	 *
	 */
	private static final long serialVersionUID = 2491023233442518764L;

	private String UPMU_TYPE = "12"; // 결재 업무타입(학자금/장학금- 주재원 )
	private String UPMU_NAME = "Tuition Fee";

	protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

	protected void performTask(final HttpServletRequest req, HttpServletResponse res) 	throws GeneralException {

		try {
			HttpSession session = req.getSession(false);
			final Box box = WebUtil.getBox(req);
			final WebUserData user = WebUtil.getSessionUser(req);

			String dest = "";
			String jobid = box.get("jobid", "first");
			String PERNR = getPERNR(box, user); //신청대상자 사번

			box.put("PERNR", PERNR);

			//if(!checkAuthorization(req, res)) return;

			// 대리 신청 추가
			PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR, "X");  //phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR);
			req.setAttribute("PersonData", phonenumdata);

			final Vector E21ExpenselFile_vt = new  Vector();

	        try {

				String path =  WebUtil.UploadFilePath+ File.separator +"E21"+ File.separator;  // path check

				File dir = new File(path);

				if(!dir.exists()) dir.mkdirs();

                for(int n = 1; n <= 5; n++) {
					FileItem fileItem = (FileItem) box.getObject("File0" + n);

					if(fileItem != null) {
						//[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
						//String fileName =new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+new Double(Math.random()*1000).intValue(); // newSourceName+"_"+new Double(Math.random()*10000).intValue();
						String fileName =new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+new Double(new SecureRandom().nextDouble()*1000).intValue(); // newSourceName+"_"+new Double(Math.random()*10000).intValue();
						//[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 end
						String lname=fileItem.getFieldName();
						String sourceName = fileItem.getName();
						String newSourceName= sourceName.substring(sourceName.lastIndexOf("\\")+1);

						//Logger.debug.println("newSourceName====================="+newSourceName);

						// 첨부 파일 보안
						String suffix = sourceName.substring(sourceName.lastIndexOf("."));
						if( !(suffix.equalsIgnoreCase(".jpg") || suffix.equalsIgnoreCase(".jpeg") || suffix.equalsIgnoreCase(".gif") || suffix.equalsIgnoreCase(".tif")
								|| suffix.equalsIgnoreCase(".bmp") || suffix.equalsIgnoreCase(".png") || suffix.equalsIgnoreCase(".xls") || suffix.equalsIgnoreCase(".xlsx")
								|| suffix.equalsIgnoreCase(".ppt") || suffix.equalsIgnoreCase(".pptx") || suffix.equalsIgnoreCase(".doc")|| suffix.equalsIgnoreCase(".docx")
							|| suffix.equalsIgnoreCase(".pdf")|| suffix.equalsIgnoreCase(".hwp")) ) {

							moveMsgPage(req, res, g.getMessage("MSG.COMMON.UPLOAD.EXTFAIL"), "history.back();");
						}
						//item.getFieldName();
						E17HospitalDetailData2 e17Hfile=new E17HospitalDetailData2();
						//e17Hfile.AINF_SEQN=AINF_SEQN;
						e17Hfile.FILE_NM= fileName;
						e17Hfile.FILE_PATH=path;
						e17Hfile.FILE_TYPE=suffix;
						e17Hfile.CREATE_BY=user.empNo;
						e17Hfile.PERNR=user.empNo;
						e17Hfile.REQ_TYPE="M";
						E21ExpenselFile_vt.addElement(e17Hfile);

						String fpath= path + fileName + suffix;

						//Logger.debug.println("******** fpath =========********"+fpath);

						IOUtils.copy(fileItem.getInputStream(),  new FileOutputStream(fpath));
					}

	            }
	        }catch (Exception e) {
	        	Logger.error(e);
	        	throw new GeneralException(e);
	        }
			//--------2016.11.18 end---


			if (jobid.equals("first")) { // 제일처음 신청 화면에 들어온경우.

				//결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);

                Vector<E21ExpenseData1> fnames = new Vector();
				Vector names = (new E17HospitalFmemberRFC()).getCodeVector1(PERNR);
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

				req.setAttribute("PERNR", PERNR);

				E21ExpenseSchoolRFC schrfc = new E21ExpenseSchoolRFC();
				Vector schools = schrfc.display(PERNR, "0001");

				//req.setAttribute("schools", schools);
				req.setAttribute("schoolsKind",  (Vector)Utils.indexOf(schools, 0) );
				req.setAttribute("schoolsType", (Vector)Utils.indexOf(schools, 1) );

				//Logger.debug.println(this, "schools="+schools.toString());

				E21ExpenseRFC erfc = new E21ExpenseRFC();
				E21ExpenseStructData expenseData = erfc.displayData(PERNR, "0001", "0001", "", DataUtil.getCurrentDate(), "","");

				req.setAttribute("resultData", expenseData);

				String pwaers  = erfc.displayWaers(PERNR, DataUtil.getCurrentDate());
				req.setAttribute("pwaers", pwaers);

				//Logger.debug.println(this, expenseData.toString());

				dest = WebUtil.JspURL + "E/E21Expense/E21ExpenseBuild_Global.jsp";

			} else if (jobid.equals("create")) {


				/* 실제 신청 부분 */
                dest = requestApproval(req, box, E21ExpenseData.class, new RequestFunction<E21ExpenseData>() {
                    public String porcess(E21ExpenseData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
                    	E21ExpenseRFC e21Rfc = new E21ExpenseRFC();
                    	e21Rfc.setRequestInput(user.empNo, UPMU_TYPE);

                    	//inputData.PERNR = box.get("PERNR");
                    	inputData.PERNR_D = user.empNo;
                    	inputData.ZPERNR = user.empNo; // 신청자 사번(대리신청, 본인 신청)
                    	inputData.UNAME = user.empNo; // 신청자 사번(대리신청, 본인 신청)
                    	inputData.AEDTM = DataUtil.getCurrentDate(); // 변경일(현재날짜)

        				if(inputData.REIM_AMTH_CONV==null||inputData.REIM_AMTH_CONV.equals("")){
        					inputData.REIM_AMTH_CONV="0";
        				}
        				inputData.REIM_CNTH = Integer.toString(Integer.parseInt(inputData.REIM_CNTH)+1);

        				box.put("I_GTYPE", "2");  // insert
                    	box.put("I_RTYPE", "M"); //2016.11.18

                    	String appytype = ((ApprovalLineData)approvalLine.get(0)).APPR_TYPE;

                    	String tmessage = "N";
                    	String amessage = "";

                    	if(inputData.SUBTY.equals("0004")&&inputData.SCHL_TYPE.equals("0002")){

                    		RepeatCheckRFC crfc = new RepeatCheckRFC();
            				Vector rmess = crfc.checkApp(user.companyCode, box.get("PERNR"), UPMU_TYPE, appytype, inputData.OBJPS);
            				tmessage = (String)rmess.get(0);
            				amessage = (String)rmess.get(2);
                    	}else{
                    		tmessage = "N";
                    	}

        				if(tmessage.equalsIgnoreCase("N") ){

	                        //String AINF_SEQN = e21Rfc.build(box.get("PERNR"), "", E21ExpenseData_vt);
	                        //String AINF_SEQN = e21Rfc.build(Utils.asVector(inputData), box, req);
	                        String AINF_SEQN = e21Rfc.build(Utils.asVector(inputData), box, req, E21ExpenselFile_vt);

	                        if(!e21Rfc.getReturn().isSuccess()) {
	                        	 throw new GeneralException(e21Rfc.getReturn().MSGTX);
	                        }
	                        return AINF_SEQN;
                    	}else {
                    		throw new GeneralException( amessage );
                    	}
                        /* 개발자 작성 부분 끝 */
                    }
                });

			} else {
				throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
			}
			//Logger.debug.println(this, " destributed = " + dest);
			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

}
