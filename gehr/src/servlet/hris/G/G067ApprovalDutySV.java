/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name  	: HR Approval Box
/*   2Depth Name  	: Requested Document
/*   Program Name 	: Duty Application
/*   Program ID   		: G067ApprovalDutySV
/*   Description  		: 초과 근무 신청부서장  결재/반려
/*   Note         		:
/*   Creation    		:
/*   Update       		: 2009-12-23 jungin @v1.0 [C20091222_81370] BOHAI법인 통문시간 체크
/*							: 2010-04-28 jungin @v1.1 [C20100427_55533] DAGU법인 통문시간 체크
/*                         : 2011-01-19 liu kuo @v1.2  [C20110118_09919]Global e-HR 중국 보티엔 법인 추가에 따른 WEB 수정 요청
/*							: 2012-10-12 dongxiaomian	@v1.3 [C20120921_87982] 单个值班审批                */
/*							: 2012-12-07 dongxiaomian	@v1.4 [C20121206_30728] 增加duty判断，有时间限制时申请不予通过 */
/********************************************************************************/

package servlet.hris.G;

import hris.D.D19Duty.D19DutyData;
import hris.D.D19Duty.D19DutyDetailData;
import hris.D.D19Duty.rfc.D19DutyRFC;
import hris.D.D19Duty.rfc.D19DutyEntryRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class G067ApprovalDutySV  extends ApprovalBaseServlet {

	private String UPMU_TYPE = "07";
	private String UPMU_NAME = "Duty";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException  {
        try{
        	HttpSession session = req.getSession(false);

            final WebUserData user = WebUtil.getSessionUser(req);
            final Box box = WebUtil.getBox(req);

            String dest	= "";

            String jobid	= box.get("jobid");
			String AINF_SEQN  = box.get("AINF_SEQN");
			String PERNR = box.get("PERNR", user.empNo);// getPERNR(box, user); //신청대상자 사번

         	final D19DutyData d19DutyData;
            Vector       vc05HouseData;
            D19DutyRFC d19Rfc = new D19DutyRFC();

            d19Rfc.setDetailInput(user.empNo, "1", AINF_SEQN);
            Vector D01OTData_vt  = null;
            D01OTData_vt = d19Rfc.getDetail(AINF_SEQN, PERNR);

            d19DutyData      = (D19DutyData)D01OTData_vt.get(0);

            //Logger.debug.println(this, "#####  d19DutyData()   ===" + d19DutyData );

            /* 승인 시 */
            if("A".equals(jobid)) {

            	dest = accept(req, box, "T_ZHR0150T", d19DutyData, d19Rfc, new ApprovalFunction<D19DutyData>() {
                    public boolean porcess(D19DutyData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                    	//Logger.debug.println(this, "#####  approvalHeader.isEditManagerArea()   ===" + approvalHeader.isEditManagerArea() );

                        /* 개발자 영역 시작 */

                    	box.copyToEntity(inputData);  //사용자가 입력한 데이타로 업데이트

                        String DUTY_CON		= box.getString("DUTY_CON");

                     	Logger.debug.println("#####	DUTY_CON	:	[ "	+	DUTY_CON + " ]");

        				D19DutyEntryRFC rfc2 = new D19DutyEntryRFC();
        				Vector ret = rfc2.getDutyEntry(d19DutyData.PERNR, d19DutyData.DUTY_DATE);

                    	Vector d19Duty = (Vector) ret.get(1);
        				Vector duty = new Vector();

        				String LGART="";

        				for(int i=0; i<d19Duty.size(); i++){
        		        	D19DutyDetailData data = (D19DutyDetailData)d19Duty.get(i);

        		        	if(data.DUTY.equals(DUTY_CON) ){
        		        	    Logger.debug.println("#####	[RFC].data.LGART		:	[ " + data.LGART + " ]");
        		        		Logger.debug.println("#####	[RFC].data.DUTY		:	[ " + data.DUTY + " ]	=	" + "	[WEB]	DUTY_CON	:	[ " + DUTY_CON + " ]");

        		        		LGART = data.LGART;

        		        		Logger.debug.println("#####	[RFC].data.LGART		:	[ " + data.LGART + " ]");
        		        	}
        		        }
        				inputData.UNAME     	= user.empNo;
        				inputData.AEDTM     	= DataUtil.getCurrentDate();
        				inputData.LGART		 	= LGART;
        				inputData.DUTY_REQ  	= DUTY_CON;


                        return true;
                    }
                });

            	/* 반려시 */
            } else if("R".equals(jobid)) {

            	dest = reject(req, box, null, d19DutyData, d19Rfc, null);

            } else if("C".equals(jobid)) {

            	dest = cancel(req, box, null, d19DutyData, d19Rfc, null);


            } else {
            	 throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if

            Logger.debug.println(this, "#####	destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        } finally {

        }
    }
}