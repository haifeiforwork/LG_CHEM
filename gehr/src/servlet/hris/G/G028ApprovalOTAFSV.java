/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                       */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �ؾ��� ����                                            */
/*   Program Name : �ʰ� �ٹ� ��û                                              */
/*   Program ID   : G028ApprovalOTSV                                            */
/*   Description  : �ʰ� �ٹ� ��û�μ���  ����/�ݷ�                             */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-14  �̽���                                                                */
/*   Update       : 2006-01-18  @v1.1 ���ڰ��翬�����з� ���� ���Ϲ߼۰� ��ġ����                     */
/*                  2017-04-03  ������  [CSR ID:3340999]  �븸 ������±Ⱓ���� 46�ð� ����           */
/*                  2017-04-17  ������  [CSR ID:3303691] ����Ⱓ���� �����߰�                        */
/*					2018-02-12  rdcamel [CSR ID:3608185] e-HR �ʰ��ٹ� ���Ľ�û ���� �ý��� ���� ��û */
/*                  2017-04-17  [WorkTime52] I_NTM ���� �߰�                                          */
/********************************************************************************/
package servlet.hris.G;

import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D01OT.D01OTData;
import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import servlet.hris.D.D01OT.D01OTBuildGlobalSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;
import hris.D.D01OT.rfc.D01OTAFRFC;


public class G028ApprovalOTAFSV extends ApprovalBaseServlet
{
    private String UPMU_TYPE ="44";
    private String UPMU_NAME = "�ʰ��ٹ� ���Ľ�û";
    private String OT_AFTER = "";//[CSR ID:3608185]���� ���� �߰�

    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "44";
        else return  "01";   }

    protected String getUPMU_NAME() {
        if(g.getSapType().isLocal())  return "�ʰ��ٹ�"+OT_AFTER+"��û";
        else return  "OverTime";
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            final WebUserData user = WebUtil.getSessionUser(req);

            /* �ؿ� ���� Ÿ��*/
/*           if(user.area != Area.KR) {
               UPMU_NAME = "OverTime";
           } else {
               UPMU_NAME = "�ʰ��ٹ���û";
           }
           getUPMU_NAME();//[CSR ID:3608185]
*/
            D01OTData   d01OTData;

            String dest  = "";
            String jobid = "";
            String bankflag  = "01";

            final Box box = WebUtil.getBox(req);

            String  AINF_SEQN  = box.get("AINF_SEQN");

            // ó�� �� ���� �� ������
            String RequestPageName = box.get("RequestPageName");

            req.setAttribute("RequestPageName", RequestPageName);

            jobid =box.get("jobid", "search");

            final D01OTAFRFC rfc           = new D01OTAFRFC();
            rfc.setDetailInput(user.empNo, "1", AINF_SEQN);
            final D01OTBuildGlobalSV d01sv = new D01OTBuildGlobalSV();
            final Vector vcD01OTData = rfc.getDetail( AINF_SEQN, "");
            d01OTData      = (D01OTData)vcD01OTData.get(0);
            d01OTData = d01sv.doWithData(d01OTData);
            Logger.debug.println(this, "------------");
            Logger.debug.println(this, vcD01OTData);

//            String tableName = "T_ZHRA024T";

            /* �ؿ� ���� Ÿ��
             *	tableName�� null�� ó���ϸ� SAP���� �˾Ƽ� ó����.(������ table�� ã�Ƽ� ó��)
             */
/*           if(user.area != Area.KR) {
               UPMU_TYPE = "01"; // ���� ����Ÿ��
               UPMU_NAME = "Overtime";
//               tableName = "T_ZHR0045T";

           } else {
               UPMU_TYPE = "17";
               UPMU_NAME = "�ʰ��ٹ���û";
//               tableName = "T_ZHRA022T";
//               tableName = "T_ZHR0045T";
           }
*/
            /* ���� �� */
            if("A".equals(jobid)) {
                /* ������ ���� �� */
                dest = accept(req, box, null, d01OTData, rfc, new ApprovalFunction<D01OTData>() {
                    public boolean porcess(D01OTData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas)
                    		throws GeneralException {

                        /* ������ ���� ���� */
                        box.copyToEntity(inputData);  // ����ڰ� �Է��� ����Ÿ�� ������Ʈ
                        inputData = d01sv.doWithData(inputData); // time formatting (ksc)2016/12/21
                        inputData.UNAME = user.empNo;
                        inputData.AEDTM = DataUtil.getCurrentDate();
                        inputData.I_NTM = "X"; // [WorkTime52]
                        D01OTCheckGlobalRFC d01OTCheckGlobalRFC = new D01OTCheckGlobalRFC();

                        // [CSR ID:3608185] e-HR �ʰ��ٹ� ���Ľ�û ���� �ý��� ���� ��û
                        OTAfterCheck(inputData);
                        Logger.debug.println(this, getUPMU_NAME());
                        // [CSR ID:3608185] e-HR �ʰ��ٹ� ���Ľ�û ���� �ý��� ���� ��û

                        // 2017-04-03 ������ [CSR ID:3340999] �븸 ������±Ⱓ���� 46�ð� ���� START
                        if (!g.getSapType().isLocal()) {
                            d01OTCheckGlobalRFC.checkOvertimeTp46Hours(req, inputData.PERNR, "A", inputData.AINF_SEQN, inputData.WORK_DATE, inputData.STDAZ);
                            if ("E".equals(d01OTCheckGlobalRFC.getReturn().MSGTY)) {
                                throw new GeneralException(g.getMessage("MSG.D.D01.0109"));// The Approved overtime hours of this payroll period are over 46 hours.
                            }
                            // [CSR ID:3359686] ���� ���� 5������ START
                            d01OTCheckGlobalRFC.checkApprovalPeriod(req, inputData.PERNR, "A", inputData.WORK_DATE, UPMU_TYPE, "");
                            if ("E".equals(d01OTCheckGlobalRFC.getReturn().MSGTY)) {
                                throw new GeneralException(g.getMessage("MSG.D.D01.0108")); // The request date has passed 5 working days. You could not approve it.
                            }
                            // [CSR ID:3359686] ���� ���� 5������ END

                        }
                        // 2017-04-03 ������ [CSR ID:3340999] �븸 ������±Ⱓ���� 46�ð� ���� END

                        return true;
                    }
                });

            /* �ݷ��� */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, vcD01OTData, rfc, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, vcD01OTData, rfc, null);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        }
    }

    //[WorkTime52] e-HR �ʰ��ٹ� ���Ľ�û ���� �ý���
    protected void OTAfterCheck(D01OTData data){
    	int dayCount = DataUtil.getBetween(data.BEGDA, data.WORK_DATE);
        if (dayCount < 0)
        	OT_AFTER = "����";
        else
        	OT_AFTER = "";
    }
}