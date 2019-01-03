/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 건강보험 피부양자 신청                                      */
/*   Program Name : 건강보험 피부양자 취득/상실 신청                            */
/*   Program ID   : E01MedicareBuildSV                                          */
/*   Description  : 건강보험 피부양자 자격(취득/상실)신청 하는 Class            */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김도신                                          */
/*   Update       : 2005-03-07 윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E01Medicare;

import java.sql.*;
import java.util.Properties;
import java.util.Vector;
import javax.servlet.http.*;

import com.common.Utils;
import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.RequestFunction;
import hris.common.db.*;
import hris.common.util.*;
import hris.common.rfc.*;
import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.A.rfc.A04FamilyDetailRFC;
import hris.D.D07TimeSheet.D07TimeSheetDetailDataUsa;
import hris.E.E01Medicare.E01HealthGuaranteeData;
import hris.E.E01Medicare.rfc.*;

public class E01MedicareBuildSV extends ApprovalBaseServlet {


    private String UPMU_TYPE ="20";   // 결재 업무타입(자격변경)
    private String UPMU_NAME = "건강보험 피부양자";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            String dest = "";

            String subty = "";
            String objps = "";

            final Box box = WebUtil.getBox(req);

            subty = box.get("SUBTY");
            objps = box.get("OBJPS");
            Logger.debug.println(this, "[SUBTY] = "+subty );
            Logger.debug.println(this, "[OBJPS] = "+objps);
            String jobid = box.get("jobid", "first");

            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            final String PERNR =  getPERNR(box, user); //신청대상자 사번


            if( jobid.equals("first") || jobid.equals("add")) {           //제일처음 신청 화면에 들어온경우.
            	getApprovalInfo(req, PERNR);
                E01TargetNameRFC       rfc_name   = new E01TargetNameRFC();
                E01HealthGuarAccqRFC   rfc_accq   = new E01HealthGuarAccqRFC();
                E01HealthGuarLossRFC   rfc_loss   = new E01HealthGuarLossRFC();
                E01HealthGuarHintchRFC rfc_hintch = new E01HealthGuarHintchRFC();

                Vector e01TargetNameData_vt       = null;
                Vector e01HealthGuarAccqData_vt   = null;
                Vector e01HealthGuarLossData_vt   = null;
                Vector e01HealthGuarHintchData_vt = null;

                Vector e01HealthGuaranteeData_vt  = new Vector();


                E01HealthGuaranteeData e01Data = new E01HealthGuaranteeData();
                e01Data.PERNR = PERNR;
                req.setAttribute("e01HealthGuaranteeData" , e01Data );



                // 가족리스트를 구성한다.
                e01TargetNameData_vt = rfc_name.getTargetName(PERNR);

                if( e01TargetNameData_vt.size() == 0 ) {
                    Logger.debug.println(this, "가족사항데이터 : FamilyDetail Data Not Found");
                    String msg = "가족사항을 먼저 등록하세요.";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.A.A12Family.A12FamilyBuildSV';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                } else {

                    // 취득사유
                    e01HealthGuarAccqData_vt   = rfc_accq.getHealthGuarAccq();

                    // 상실사유
                    e01HealthGuarLossData_vt   = rfc_loss.getHealthGuarLoss();

                    // 장애인 종별부호
                    e01HealthGuarHintchData_vt = rfc_hintch.getHealthGuarHintch();

                    req.setAttribute("e01TargetNameData_vt", e01TargetNameData_vt);
                    req.setAttribute("isUpdate", box.get("isUpdate"));
                    req.setAttribute("e01HealthGuarAccqData_vt", e01HealthGuarAccqData_vt);
                    req.setAttribute("e01HealthGuarLossData_vt", e01HealthGuarLossData_vt);
                    req.setAttribute("e01HealthGuarHintchData_vt", e01HealthGuarHintchData_vt);
                    req.setAttribute("e01HealthGuarReqsData_vt", new E01HealthGuarReqsRFC().getHealthGuarReqs());

                    int rowcount_data = box.getInt("RowCount_data");
                    for( int i = 0; i < rowcount_data; i++) {
                        E01HealthGuaranteeData e01HealthGuaranteeData = new E01HealthGuaranteeData();
                        String                 idx                    = Integer.toString(i);

                        if( box.get("use_flag"+idx).equals("N") ) continue;

                        e01HealthGuaranteeData.PERNR          = PERNR;
                        e01HealthGuaranteeData.APPL_TYPE      = box.get("APPL_TYPE"+idx);       // 건강보험 피부양자 자격/취득 신청구분
                        e01HealthGuaranteeData.SUBTY          = box.get("SUBTY"+idx);           // 하부유형
                        e01HealthGuaranteeData.OBJPS          = box.get("OBJPS"+idx);           // 오브젝트식별
                        e01HealthGuaranteeData.ACCQ_LOSS_DATE = box.get("ACCQ_LOSS_DATE"+idx);  // 취득/상실일자
                        e01HealthGuaranteeData.ACCQ_LOSS_TYPE = box.get("ACCQ_LOSS_TYPE"+idx);  // 건강보험 피부양자 자격 신청(취득/상실)구분
                        e01HealthGuaranteeData.HITCH_TYPE     = box.get("HITCH_TYPE"+idx);      // 장애인 종별 부호
                        e01HealthGuaranteeData.HITCH_GRADE    = box.get("HITCH_GRADE"+idx);     // 장애등급
                        e01HealthGuaranteeData.HITCH_DATE     = box.get("HITCH_DATE"+idx);      // 장애등록일
                        e01HealthGuaranteeData.APPL_TEXT      = box.get("APPL_TEXT"+idx);       // 건강보험 피부양자 신청구분 텍스트
                        e01HealthGuaranteeData.ACCQ_LOSS_TEXT = box.get("ACCQ_LOSS_TEXT"+idx);  // 건강보험 피부양자 취득 상실 텍스트
                        e01HealthGuaranteeData.HITCH_TEXT     = box.get("HITCH_TEXT"+idx);      // 장애인 종별 부호 취득 텍스트
                        e01HealthGuaranteeData.ENAME          = box.get("ENAME"+idx);           // 대상자 이름
                        e01HealthGuaranteeData.APRT_CODE      = box.get("APRT_CODE"+idx);       // 원격지발급여부

                        e01HealthGuaranteeData_vt.addElement(e01HealthGuaranteeData);
                    }
                    Logger.debug.println(this, e01HealthGuaranteeData_vt.toString());

                    req.setAttribute("e01HealthGuaranteeData_vt", e01HealthGuaranteeData_vt);

                    // XxxDetailSV.java 와 XxxDetail.jsp 에 '목록/앞화면' 버튼 활성화 여부를 가려주는 부분
                    String ThisJspName = box.get("ThisJspName");
                    req.setAttribute("ThisJspName", ThisJspName);
                    //  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록/앞화면' 버튼 활성화 여부를 가려주는 부분

                    if( ThisJspName.equals("A04FamilyDetail_KR.jsp") ) {    // 가족사항 신규입력 확인에서 신청할경우..
                      req.setAttribute("subty", subty);
                      req.setAttribute("objps", objps);
                    }

                    dest = WebUtil.JspURL+"E/E01Medicare/E01MedicareBuild.jsp";
                }
                /*--------------- 2002.06.05. 여러건을 한번에 신청하도록 수정 ---------------*/

            } else if (jobid.equals("create")) {

                /* 실제 신청 부분 */
                dest = requestApproval(req, box, E01HealthGuaranteeData.class, new RequestFunction<E01HealthGuaranteeData>() {
                    public String porcess(E01HealthGuaranteeData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
                    	E01HealthGuaranteeRFC  e01HealthGuaranteeRFC  = new E01HealthGuaranteeRFC();
                    	Vector e01HealthGuaranteeData_vt = new Vector();

                    	e01HealthGuaranteeRFC.setRequestInput(user.empNo, UPMU_TYPE);
                    	 String ThisJspName = box.get("ThisJspName");

                         int rowcount_data = box.getInt("RowCount_data");
                         for( int i = 0; i < rowcount_data; i++) {
                             E01HealthGuaranteeData e01HealthGuaranteeData = new E01HealthGuaranteeData();
                             String                 idx                    = Integer.toString(i);
                             e01HealthGuaranteeData.MANDT          = user.clientNo;
                             e01HealthGuaranteeData.PERNR          = PERNR;
                             e01HealthGuaranteeData.BEGDA          = box.get("BEGDA");               // 신청일자
                             e01HealthGuaranteeData.INDX_NUMB      = (i+1)+"";                       // 순번
                             e01HealthGuaranteeData.APPL_TYPE      = box.get("APPL_TYPE"+idx);       // 건강보험 피부양자 자격/취득 신청구분
                             e01HealthGuaranteeData.SUBTY          = box.get("SUBTY"+idx);           // 하부유형
                             e01HealthGuaranteeData.OBJPS          = box.get("OBJPS"+idx);           // 오브젝트식별
                             e01HealthGuaranteeData.ACCQ_LOSS_DATE = box.get("ACCQ_LOSS_DATE"+idx);  // 취득/상실일자
                             e01HealthGuaranteeData.ACCQ_LOSS_TYPE = box.get("ACCQ_LOSS_TYPE"+idx);  // 건강보험 피부양자 자격 신청(취득/상실)구분
                             e01HealthGuaranteeData.HITCH_TYPE     = box.get("HITCH_TYPE"+idx);      // 장애인 종별 부호
                             e01HealthGuaranteeData.HITCH_GRADE    = box.get("HITCH_GRADE"+idx);     // 장애등급
                             e01HealthGuaranteeData.HITCH_DATE     = box.get("HITCH_DATE"+idx);      // 장애등록일
                             e01HealthGuaranteeData.APPL_TEXT      = box.get("APPL_TEXT"+idx);       // 건강보험 피부양자 신청구분 텍스트
                             e01HealthGuaranteeData.ACCQ_LOSS_TEXT = box.get("ACCQ_LOSS_TEXT"+idx);  // 건강보험 피부양자 취득 상실 텍스트
                             e01HealthGuaranteeData.HITCH_TEXT     = box.get("HITCH_TEXT"+idx);      // 장애인 종별 부호 취득 텍스트
                             e01HealthGuaranteeData.ENAME          = box.get("ENAME"+idx);           // 대상자 이름
                             e01HealthGuaranteeData.APRT_CODE      = box.get("APRT_CODE"+idx);       // 원격지발급여부
                             e01HealthGuaranteeData.ZPERNR         = user.empNo;                     // 신청자 사번(대리신청, 본인 신청)
                             e01HealthGuaranteeData.UNAME          = user.empNo;                     // 신청자 사번(대리신청, 본인 신청)
                             e01HealthGuaranteeData.AEDTM          = DataUtil.getCurrentDate();      // 변경일(현재날짜)
                             e01HealthGuaranteeData_vt.addElement(e01HealthGuaranteeData);
                         }
                         Logger.debug.println(this, "건강보험 피부양자 자격 신청 : " + e01HealthGuaranteeData_vt.toString());

                        String AINF_SEQN = e01HealthGuaranteeRFC.build(e01HealthGuaranteeData_vt, box, req);
                        Logger.debug.println(this, "AINF_SEQNAINF_SEQNAINF_SEQNAINF_SEQN : " + AINF_SEQN);

                        if(!e01HealthGuaranteeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(e01HealthGuaranteeRFC.getReturn().MSGTX);
                        };

                        return AINF_SEQN;
                        /* 개발자 작성 부분 끝 */
                    }
                });
            } else {
            	Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
                throw new GeneralException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }
}


