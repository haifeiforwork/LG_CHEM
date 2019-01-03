/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 경조금 신청                                                 */
/*   Program ID   : G004ApprovalCongraSV                                        */
/*   Description  : 경조금 신청 부서장 결재/반려                                */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;
/*
 * 작성된 날짜: 2005. 1. 31.
 *
 */
import hris.E.E19Congra.E19CongcondGlobalData;
import hris.E.E19Congra.rfc.E19CongraRequestGlobalRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

/**
 * @author 이승희
 *
 */
public class G004ApprovalCongraGlobalSV extends ApprovalBaseServlet
{
	private String UPMU_TYPE	= "06";	// 결재 업무타입(경조금)

	private String UPMU_NAME	= "Celebration & Condolence";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res)
            throws GeneralException
    {
        try{
//----------------------------------------------------------------------------------------------------------------------------------------------
            final WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";

            final Box box = WebUtil.getBox(req);

            final E19CongcondGlobalData     e19CongcondGlobalData ;

            String  AINF_SEQN  = box.get("AINF_SEQN");

            String jobid = box.get("jobid");

            final E19CongraRequestGlobalRFC e19CongraRequestGlobalRFC = new E19CongraRequestGlobalRFC();
            e19CongraRequestGlobalRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
            Vector<E19CongcondGlobalData> vE19CongcondData = e19CongraRequestGlobalRFC.getDetail(); //결과 데이타
            E19CongcondGlobalData e19CongcondData = Utils.indexOf(vE19CongcondData, 0);


            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(e19CongcondData.PERNR);


            /* 승인 시 */
            if("A".equals(jobid)) {
                /* 개발자 영역 끝 */
                dest = accept(req, box, "T_ZHR0037T", e19CongcondData, e19CongraRequestGlobalRFC, new ApprovalFunction<E19CongcondGlobalData>() {
                    public boolean porcess(E19CongcondGlobalData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
                        if(approvalHeader. isChargeArea()) {
                        	box.copyToEntity(inputData);
                        	inputData.AEDTM   =   DataUtil.getCurrentDate();
                        	 Logger.debug.println(this, "inputData.AEDTM-------------------"+inputData.AEDTM);

                        	inputData.UNAME   =   user.empNo;
                        	inputData.CERT_DATE = box.get("CERT_DATE");
                        	inputData.CERT_FLAG = box.get("CERT_FLAG");
                        	inputData.PAYM_DATE = box.get("PAYM_DATE");
                        	inputData.PAYM_AMNT = box.get("PAYM_AMNT");
                            Logger.debug.println(this, "CERT_DATE-------------------"+box.get("CERT_DATE")+inputData.CERT_DATE);
                            Logger.debug.println(this, "CERT_FLAG-------------------"+box.get("CERT_FLAG"));
                            Logger.debug.println(this, "PAYM_DATE-------------------"+box.get("PAYM_DATE"));
                            Logger.debug.println(this, "inputData-------------------"+inputData);
                        }


                        return true;
                    }
                });

            /* 반려시 */
            } else if("R".equals(jobid)) {
                dest = reject(req, box,  null, e19CongcondData, e19CongraRequestGlobalRFC, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box,  null, e19CongcondData, e19CongraRequestGlobalRFC, null);
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


