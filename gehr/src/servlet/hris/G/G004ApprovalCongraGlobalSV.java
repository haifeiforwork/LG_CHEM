/********************************************************************************/
/*                                                                              */
/*   System Name  : e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �ؾ��� ����                                            */
/*   Program Name : ������ ��û                                                 */
/*   Program ID   : G004ApprovalCongraSV                                        */
/*   Description  : ������ ��û �μ��� ����/�ݷ�                                */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-14  �̽���                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;
/*
 * �ۼ��� ��¥: 2005. 1. 31.
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
 * @author �̽���
 *
 */
public class G004ApprovalCongraGlobalSV extends ApprovalBaseServlet
{
	private String UPMU_TYPE	= "06";	// ���� ����Ÿ��(������)

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
            Vector<E19CongcondGlobalData> vE19CongcondData = e19CongraRequestGlobalRFC.getDetail(); //��� ����Ÿ
            E19CongcondGlobalData e19CongcondData = Utils.indexOf(vE19CongcondData, 0);


            PersonInfoRFC numfunc = new PersonInfoRFC();
            final PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(e19CongcondData.PERNR);


            /* ���� �� */
            if("A".equals(jobid)) {
                /* ������ ���� �� */
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

            /* �ݷ��� */
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


