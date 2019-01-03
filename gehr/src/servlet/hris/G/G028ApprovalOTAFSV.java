/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                       */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 초과 근무 신청                                              */
/*   Program ID   : G028ApprovalOTSV                                            */
/*   Description  : 초과 근무 신청부서장  결재/반려                             */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                                                */
/*   Update       : 2006-01-18  @v1.1 전자결재연동실패로 인해 메일발송과 위치변경                     */
/*                  2017-04-03  김은하  [CSR ID:3340999]  대만 당월근태기간동안 46시간 제한           */
/*                  2017-04-17  김은하  [CSR ID:3303691] 결재기간제어 로직추가                        */
/*					2018-02-12  rdcamel [CSR ID:3608185] e-HR 초과근무 사후신청 관련 시스템 개선 요청 */
/*                  2017-04-17  [WorkTime52] I_NTM 변수 추가                                          */
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
    private String UPMU_NAME = "초과근무 사후신청";
    private String OT_AFTER = "";//[CSR ID:3608185]사후 문구 추가

    protected String getUPMU_TYPE() {
        if(g.getSapType().isLocal())  return "44";
        else return  "01";   }

    protected String getUPMU_NAME() {
        if(g.getSapType().isLocal())  return "초과근무"+OT_AFTER+"신청";
        else return  "OverTime";
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            final WebUserData user = WebUtil.getSessionUser(req);

            /* 해외 업무 타입*/
/*           if(user.area != Area.KR) {
               UPMU_NAME = "OverTime";
           } else {
               UPMU_NAME = "초과근무신청";
           }
           getUPMU_NAME();//[CSR ID:3608185]
*/
            D01OTData   d01OTData;

            String dest  = "";
            String jobid = "";
            String bankflag  = "01";

            final Box box = WebUtil.getBox(req);

            String  AINF_SEQN  = box.get("AINF_SEQN");

            // 처리 후 돌아 갈 페이지
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

            /* 해외 업무 타입
             *	tableName은 null로 처리하면 SAP에서 알아서 처리함.(적정한 table을 찾아서 처리)
             */
/*           if(user.area != Area.KR) {
               UPMU_TYPE = "01"; // 결재 업무타입
               UPMU_NAME = "Overtime";
//               tableName = "T_ZHR0045T";

           } else {
               UPMU_TYPE = "17";
               UPMU_NAME = "초과근무신청";
//               tableName = "T_ZHRA022T";
//               tableName = "T_ZHR0045T";
           }
*/
            /* 승인 시 */
            if("A".equals(jobid)) {
                /* 개발자 영역 끝 */
                dest = accept(req, box, null, d01OTData, rfc, new ApprovalFunction<D01OTData>() {
                    public boolean porcess(D01OTData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas)
                    		throws GeneralException {

                        /* 개발자 영역 시작 */
                        box.copyToEntity(inputData);  // 사용자가 입력한 데이타로 업데이트
                        inputData = d01sv.doWithData(inputData); // time formatting (ksc)2016/12/21
                        inputData.UNAME = user.empNo;
                        inputData.AEDTM = DataUtil.getCurrentDate();
                        inputData.I_NTM = "X"; // [WorkTime52]
                        D01OTCheckGlobalRFC d01OTCheckGlobalRFC = new D01OTCheckGlobalRFC();

                        // [CSR ID:3608185] e-HR 초과근무 사후신청 관련 시스템 개선 요청
                        OTAfterCheck(inputData);
                        Logger.debug.println(this, getUPMU_NAME());
                        // [CSR ID:3608185] e-HR 초과근무 사후신청 관련 시스템 개선 요청

                        // 2017-04-03 김은하 [CSR ID:3340999] 대만 당월근태기간동안 46시간 제한 START
                        if (!g.getSapType().isLocal()) {
                            d01OTCheckGlobalRFC.checkOvertimeTp46Hours(req, inputData.PERNR, "A", inputData.AINF_SEQN, inputData.WORK_DATE, inputData.STDAZ);
                            if ("E".equals(d01OTCheckGlobalRFC.getReturn().MSGTY)) {
                                throw new GeneralException(g.getMessage("MSG.D.D01.0109"));// The Approved overtime hours of this payroll period are over 46 hours.
                            }
                            // [CSR ID:3359686] 남경 결재 5일제어 START
                            d01OTCheckGlobalRFC.checkApprovalPeriod(req, inputData.PERNR, "A", inputData.WORK_DATE, UPMU_TYPE, "");
                            if ("E".equals(d01OTCheckGlobalRFC.getReturn().MSGTY)) {
                                throw new GeneralException(g.getMessage("MSG.D.D01.0108")); // The request date has passed 5 working days. You could not approve it.
                            }
                            // [CSR ID:3359686] 남경 결재 5일제어 END

                        }
                        // 2017-04-03 김은하 [CSR ID:3340999] 대만 당월근태기간동안 46시간 제한 END

                        return true;
                    }
                });

            /* 반려시 */
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

    //[WorkTime52] e-HR 초과근무 사후신청 관련 시스템
    protected void OTAfterCheck(D01OTData data){
    	int dayCount = DataUtil.getBetween(data.BEGDA, data.WORK_DATE);
        if (dayCount < 0)
        	OT_AFTER = "사후";
        else
        	OT_AFTER = "";
    }
}