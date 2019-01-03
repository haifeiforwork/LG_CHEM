/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: HR Approval Box
/*   2Depth Name  	: Requested Document
/*   Program Name 	: Time Sheet
/*   Program ID   		: G072ApprovalTimeSheetUsaSV.java
/*   Description  		: Time Sheet 결재하는 Class (USA - LGCPI(G400))
/*   Note         		:
/*   Creation     		: 2010-11-16 jungin @v1.0 LGCPI 법인 Time Sheet 신규 개발
/********************************************************************************/

package servlet.hris.G;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D07TimeSheet.D07TimeSheetDetailDataUsa;
import hris.D.D07TimeSheet.rfc.D07TimeSheetRFCUsa;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalInput;
import hris.common.approval.ApprovalLineData;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;


/**
 *
 * G072ApprovalTimeSheetUsaSV.java
 *
 * @author jungin
 * @creation v1.0, 2010/11/16
 */
public class G072ApprovalTimeSheetUsaSV extends ApprovalBaseServlet {


	private String UPMU_TYPE = "15";		// 결재 업무타입(TimeSheet)

	private String UPMU_NAME = "TimeSheet";


    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res)
    		throws GeneralException {


        try{
            HttpSession session = req.getSession(false);

            final WebUserData user = (WebUserData)session.getAttribute("user");
            final Box box = WebUtil.getBox(req);

            String dest = "";
            String jobid = "";
            final String PERNR =  box.get("PERNR", user.empNo);

            jobid = box.get("jobid");

			final String AINF_SEQN = box.get("AINF_SEQN");

			final String I_DATLO = DataUtil.getCurrentDate();
			String I_PAYDR = box.get("I_PAYDR","CW");
			String I_LCLDT = box.get("I_LCLDT",WebUtil.deleteStr(box.get("TBEGDA",I_DATLO),"."));
			String APPR_STAT = box.get("APPR_STAT","");
			String I_APGUB = (String) req.getAttribute("I_APGUB");


			String APPL_BEGDA = box.get("APPL_BEGDA");

            String empNo = req.getParameter("APPL_PERNR");


        	final D07TimeSheetRFCUsa d07TimeSheetRFCUsa = new D07TimeSheetRFCUsa();
        	d07TimeSheetRFCUsa.setDetailInput(user.empNo, "1", AINF_SEQN);
			ApprovalInput approvalInput  = d07TimeSheetRFCUsa.getApprovalInput();
			approvalInput.setI_PERNR( PERNR);

			final Vector D07TimeSheetDataUsa_vt = d07TimeSheetRFCUsa.getTimeSheetDetail(PERNR, I_PAYDR, I_LCLDT,APPR_STAT);
           final Vector<D07TimeSheetDetailDataUsa>  D07TimeSheetDetailDataUsa_vt = (Vector)D07TimeSheetDataUsa_vt.get(0);

Logger.debug.println(D07TimeSheetDataUsa_vt.toString());
//--------------------------------------------------------------------------------------------------
            if("A".equals(jobid)) {

				for (int i = D07TimeSheetDetailDataUsa_vt.size() - 1; i >= 0; i--) {
					D07TimeSheetDetailDataUsa  d07TimeSheetDetailData = (D07TimeSheetDetailDataUsa)D07TimeSheetDetailDataUsa_vt.get(i);
					if(StringUtils.isBlank(StringUtils.remove(d07TimeSheetDetailData.PERNR, "0"))) {
						D07TimeSheetDetailDataUsa_vt.remove(i);
					}
				}
                         /* 개발자 영역 끝 */
                dest = accept(req, box, "T_ZHR0237T", D07TimeSheetDetailDataUsa_vt, d07TimeSheetRFCUsa, new ApprovalFunction<Vector<D07TimeSheetDetailDataUsa>>() {
                    public boolean porcess(Vector <D07TimeSheetDetailDataUsa>inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                    	Vector D07TimeSheetDeatilData_vt = new Vector();



                    	for (int i = 0; i < D07TimeSheetDetailDataUsa_vt.size(); i++) {
                     		D07TimeSheetDetailDataUsa  d07TimeSheetDetailData = (D07TimeSheetDetailDataUsa)D07TimeSheetDetailDataUsa_vt.get(i);

                      		Utils.setFieldValue(d07TimeSheetDetailData, "AINF_SEQN", AINF_SEQN) ;
                      		Utils.setFieldValue(d07TimeSheetDetailData, "APPR_STAT", "A") ;
                      		Utils.setFieldValue(d07TimeSheetDetailData, "PERNR_D", PERNR) ;
                      		Utils.setFieldValue(d07TimeSheetDetailData, "ZPERNR", user.empNo) ;
                      		Utils.setFieldValue(d07TimeSheetDetailData, "AEDTM", I_DATLO) ;
                      		Utils.setFieldValue(d07TimeSheetDetailData, "UNAME", user.empNo) ;
                      		Utils.setFieldValue(d07TimeSheetDetailData, "TBEGDA",  WebUtil.deleteStr(d07TimeSheetDetailData.TBEGDA ,"-")) ;
                      		Utils.setFieldValue(d07TimeSheetDetailData, "TENDDA", WebUtil.deleteStr(d07TimeSheetDetailData.TENDDA ,"-")) ;
                      		Utils.setFieldValue(d07TimeSheetDetailData, "BEGDA",  d07TimeSheetRFCUsa.getApprovalHeader().RQDAT) ;
         					DataUtil.fixNull(d07TimeSheetDetailData);

        					D07TimeSheetDeatilData_vt.add(i, d07TimeSheetDetailData);

                      	 }
                        inputData = D07TimeSheetDeatilData_vt;
                        Logger.debug.println("inputData------------------------"+inputData.toString());
                        return true;
                    }
                });

            /* 반려시 */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, "T_ZHR0237T", D07TimeSheetDetailDataUsa_vt, d07TimeSheetRFCUsa, new ApprovalFunction<Vector<D07TimeSheetDetailDataUsa>>() {
                    public boolean porcess(Vector <D07TimeSheetDetailDataUsa>inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
                    	Vector D07TimeSheetDeatilData_vt = new Vector();

                   for (int i = 0; i < inputData.size(); i++) {
                	     D07TimeSheetDetailDataUsa  d07TimeSheetDetailData = (D07TimeSheetDetailDataUsa)D07TimeSheetDetailDataUsa_vt.get(i);
                   		 Utils.setFieldValue(d07TimeSheetDetailData, "AINF_SEQN", AINF_SEQN) ;
                   		 Utils.setFieldValue(d07TimeSheetDetailData, "APPR_STAT", "R") ;
                   		 Utils.setFieldValue(d07TimeSheetDetailData, "PERNR_D", PERNR) ;
                   		 Utils.setFieldValue(d07TimeSheetDetailData, "ZPERNR", user.empNo) ;
                   		 Utils.setFieldValue(d07TimeSheetDetailData, "AEDTM", I_DATLO) ;
                   		 Utils.setFieldValue(d07TimeSheetDetailData, "UNAME", user.empNo) ;
                   		 Utils.setFieldValue(d07TimeSheetDetailData, "TBEGDA",  WebUtil.deleteStr(d07TimeSheetDetailData.TBEGDA ,"-")) ;
                   		 Utils.setFieldValue(d07TimeSheetDetailData, "TENDDA", WebUtil.deleteStr(d07TimeSheetDetailData.TENDDA ,"-")) ;
                   		 Utils.setFieldValue(d07TimeSheetDetailData, "BEGDA", d07TimeSheetRFCUsa.getApprovalHeader().RQDAT) ;
                   		 	DataUtil.fixNull(d07TimeSheetDetailData);
                   		 	D07TimeSheetDeatilData_vt.add(i, d07TimeSheetDetailData);
                  	 }
                   inputData = D07TimeSheetDeatilData_vt;
                   Logger.debug.println(inputData.toString());
                   	return true;
                   }
               });

            } else if("C".equals(jobid)) {
            	 dest = cancel(req, box, "T_ZHR0237T", D07TimeSheetDetailDataUsa_vt, d07TimeSheetRFCUsa, new ApprovalFunction<Vector<D07TimeSheetDetailDataUsa>>() {
                     public boolean porcess(Vector <D07TimeSheetDetailDataUsa>inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
                     	Vector D07TimeSheetDeatilData_vt = new Vector();
                    for (int i = 0; i < inputData.size(); i++) {
                 	     D07TimeSheetDetailDataUsa  d07TimeSheetDetailData = (D07TimeSheetDetailDataUsa)D07TimeSheetDetailDataUsa_vt.get(i);
                    		 Utils.setFieldValue(d07TimeSheetDetailData, "AINF_SEQN", AINF_SEQN) ;
                    		 Utils.setFieldValue(d07TimeSheetDetailData, "APPR_STAT", "") ;
                    		 Utils.setFieldValue(d07TimeSheetDetailData, "PERNR_D", user.empNo) ;
                    		 Utils.setFieldValue(d07TimeSheetDetailData, "ZPERNR", user.empNo) ;
                    		 Utils.setFieldValue(d07TimeSheetDetailData, "AEDTM", I_DATLO) ;
                    		 Utils.setFieldValue(d07TimeSheetDetailData, "UNAME", user.empNo) ;
                    		 Utils.setFieldValue(d07TimeSheetDetailData, "TBEGDA",  WebUtil.deleteStr(d07TimeSheetDetailData.TBEGDA ,"-")) ;
                    		 Utils.setFieldValue(d07TimeSheetDetailData, "TENDDA", WebUtil.deleteStr(d07TimeSheetDetailData.TENDDA ,"-")) ;
                    		 Utils.setFieldValue(d07TimeSheetDetailData, "BEGDA", d07TimeSheetRFCUsa.getApprovalHeader().RQDAT) ;
                    		 DataUtil.fixNull(d07TimeSheetDetailData);
                    		 D07TimeSheetDeatilData_vt.add(i, d07TimeSheetDetailData);
                    	 }
                    inputData = D07TimeSheetDeatilData_vt;
                    Logger.debug.println(inputData.toString());
                    	return true;
                    }
                });
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
