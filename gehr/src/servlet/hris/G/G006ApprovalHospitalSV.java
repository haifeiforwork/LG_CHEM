/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                        */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 결재 해야할 문서                                            */
/*   Program Name : 의료비 신청                                                 */
/*   Program ID   : G006ApprovalHospitalSV                                      */
/*   Description  : 의료비 신청 부서장 ,담당자 ,담당부서장 결재/반려            */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-14  이승희                                          */
/*   Update       : 2005-10-28  LSA   자녀인 경우에 300만원한도체크로직이 빠져 있어 추가함CSR:C2005102601000000764  */
/*                   : 2013/09/04 @CSR1 한도체크 결재시 로직보안 결재진행중 금액도 합산하여 한도체크로 변경   */
/*                   : 2014/05/19 @CSR2 시간선택제 (사무직(4H), 사무직(6H), 계약직(4H), 계약직(6H)) 의료비/학자금 신청 시 알림 popup 추가    */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.E.E17Hospital.E17BillData;
import hris.E.E17Hospital.E17HospitalData;
import hris.E.E17Hospital.E17HospitalResultData;
import hris.E.E17Hospital.E17SickData;
import hris.E.E17Hospital.rfc.E17HospitalRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalImport;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class G006ApprovalHospitalSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="03";  // 결재 업무타입(의료비)
    private String UPMU_NAME = "의료비";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";

            final Box box = WebUtil.getBox(req);

            String  AINF_SEQN  = box.get("AINF_SEQN");

            String jobid = box.get("jobid");
            /* 승인 반려 시 */

            final E17HospitalRFC hospitalRFC = new E17HospitalRFC();
            hospitalRFC.setDetailInput(user.empNo, "1", box.get("AINF_SEQN"));
            E17HospitalResultData resultData = hospitalRFC.detail(); //결과 데이타

            Vector<E17SickData> E17SickData_vt = resultData.T_ZHRA006T;
            Vector<E17HospitalData> E17HospitalData_vt = resultData.T_ZHRW005A;
            Vector<E17BillData> E17BillData_vt = resultData.T_ZHRW006A;

            final E17SickData e17SickData = Utils.indexOf(E17SickData_vt, 0);

            /* 승인 시 */
            if("A".equals(jobid)) {

                /* 개발자 영역 끝 */
                dest = accept(req, box, "T_ZHRA006T", e17SickData, hospitalRFC, new ApprovalFunction<E17SickData>() {
                    public boolean porcess(E17SickData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
                         /* 변경되는 가능 항목 */


// 의료비 기초 자료
                        box.copyToEntity(e17SickData);

                        e17SickData.COMP_WONX = DataUtil.changeGlobalAmount(e17SickData.COMP_WONX, e17SickData.WAERS);  // 통상임금
                        e17SickData.YTAX_WONX = DataUtil.changeGlobalAmount(e17SickData.YTAX_WONX, e17SickData.WAERS);  // 경조금
                            //e17SickData.YTAX_WONX = Double.toString(Double.parseDouble(e17SickData.YTAX_WONX) / 100.0) ;  // 경조금

                        e17SickData.UNAME   =   user.empNo;
                        e17SickData.AEDTM   =   DataUtil.getCurrentDate();

                        Vector vcE17HospitalData = new Vector();

                        int nRowCount = Integer.parseInt(box.getString("HospitalRowCount"));
                        for (int i = 0; i < nRowCount; i++) {
                            E17HospitalData e17HospitalData = new E17HospitalData();
                            box.copyToEntity(e17HospitalData ,i);
                            e17HospitalData.BEGDA   =   e17SickData.BEGDA;
                            e17HospitalData.COMP_WONX = e17SickData.COMP_WONX;

                            e17HospitalData.EMPL_WONX = DataUtil.changeGlobalAmount(e17HospitalData.EMPL_WONX, e17SickData.WAERS);
                            e17HospitalData.YTAX_WONX = DataUtil.changeGlobalAmount(e17HospitalData.YTAX_WONX, e17SickData.WAERS);

                            vcE17HospitalData.add(e17HospitalData);
                        } // end for

                        box.put(APPROVAL_IMPORT, new ApprovalImport("T_ZHRW005A", vcE17HospitalData));

                        return true;
                    }
                });

            /* 반려시 */
            } else if("R".equals(jobid)) {
                dest = reject(req, box, null, e17SickData, hospitalRFC, null);
            } else if("C".equals(jobid)) {
                dest = cancel(req, box, null, e17SickData, hospitalRFC, null);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        }
	}
}