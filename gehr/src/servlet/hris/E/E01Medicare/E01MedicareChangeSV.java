/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 건강보험 피부양자 신청                                      */
/*   Program Name : 건강보험 피부양자 취득/상실 신청 수정                       */
/*   Program ID   : E01MedicareChangeSV                                         */
/*   Description  : 건강보험 피부양자 자격(취득/상실) 신청을 수정하는 Class     */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김도신                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E01Medicare;

import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.E.E01Medicare.E01HealthGuaranteeData;
import hris.E.E01Medicare.rfc.E01HealthGuarAccqRFC;
import hris.E.E01Medicare.rfc.E01HealthGuarHintchRFC;
import hris.E.E01Medicare.rfc.E01HealthGuarLossRFC;
import hris.E.E01Medicare.rfc.E01HealthGuarReqsRFC;
import hris.E.E01Medicare.rfc.E01HealthGuaranteeRFC;
import hris.E.E01Medicare.rfc.E01TargetNameRFC;
import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.ChangeFunction;
import hris.common.db.AppLineDB;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import java.sql.Connection;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import servlet.hris.A.A17Licence.A17LicenceBuildSV;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class E01MedicareChangeSV extends ApprovalBaseServlet {


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
            final Box box = WebUtil.getBox(req);

            String dest;
            String jobid = box.get("jobid", "first");
            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            final E01HealthGuaranteeRFC e01HealthGuaranteeRFC = new E01HealthGuaranteeRFC();
            e01HealthGuaranteeRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
             Vector<E01HealthGuaranteeData> e01HealthGuaranteeData_vt = e01HealthGuaranteeRFC.getDetail(); //결과 데이타

            Logger.debug.println(this, "피부양자 자격 신청 조회 : " + e01HealthGuaranteeData_vt.toString());

            final E01HealthGuaranteeData firstData = Utils.indexOf(e01HealthGuaranteeData_vt, 0);

            String begda     = box.get("BEGDA");
            final String ainf_seqn = box.get("AINF_SEQN");


            if( jobid.equals("first")|| jobid.equals("add") ) {           //제일처음 수정 화면에 들어온경우.

            	Vector<E01HealthGuaranteeData> changeE01HealthGuaranteeData_vt = new Vector();
                detailApporval(req, res, e01HealthGuaranteeRFC);

                E01TargetNameRFC       rfc_name   = new E01TargetNameRFC();
                E01HealthGuarAccqRFC   rfc_accq   = new E01HealthGuarAccqRFC();
                E01HealthGuarLossRFC   rfc_loss   = new E01HealthGuarLossRFC();
                E01HealthGuarHintchRFC rfc_hintch = new E01HealthGuarHintchRFC();

                Vector e01TargetNameData_vt       = null;
                Vector e01HealthGuarAccqData_vt   = null;
                Vector e01HealthGuarLossData_vt   = null;
                Vector e01HealthGuarHintchData_vt = null;


                // 가족리스트를 구성한다.
                e01TargetNameData_vt = rfc_name.getTargetName(firstData.PERNR);

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


                    Logger.debug.println(this, "가족리스트 : "+ e01TargetNameData_vt.toString());
                    Logger.debug.println(this, "취득사유 : "+ e01HealthGuarAccqData_vt.toString());
                    Logger.debug.println(this, "상실사유 : "+ e01HealthGuarLossData_vt.toString());
                    Logger.debug.println(this, "장애인 종별부호 : "+ e01HealthGuarHintchData_vt.toString());
                    Logger.debug.println(this, "피부양자 자격 신청 수정 조회 : " + e01HealthGuaranteeData_vt.toString());

                    //-----모두 삭제될 경우를 대비하여 신청일자, 결재번호를 미리 저장해두었다가 .jsp페이지로 넘겨준다.
                    req.setAttribute("begda",                      begda);
                    req.setAttribute("ainf_seqn",                  ainf_seqn);
                    //-----모두 삭제될 경우를 대비하여 신청일자, 결재번호를 미리 저장해두었다가 .jsp페이지로 넘겨준다.

                    int rowcount_data = box.getInt("RowCount_data");
                    for( int i = 0; i < rowcount_data; i++) {
                        E01HealthGuaranteeData e01HealthGuaranteeData = new E01HealthGuaranteeData();
                        String                 idx                    = Integer.toString(i);

                        //-----모두 삭제될 경우를 대비하여 신청일자, 결재번호를 미리 저장해두었다가 .jsp페이지로 넘겨준다.

                        //-----모두 삭제될 경우를 대비하여 신청일자, 결재번호를 미리 저장해두었다가 .jsp페이지로 넘겨준다.
                        if( box.get("use_flag"+idx).equals("N") ) continue;

                        e01HealthGuaranteeData.BEGDA          = begda;                          // 신청일자
                        e01HealthGuaranteeData.AINF_SEQN      = ainf_seqn;                      // 결재번호
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

                        changeE01HealthGuaranteeData_vt.addElement(e01HealthGuaranteeData);
                    }
                    Logger.debug.println(this, changeE01HealthGuaranteeData_vt.toString());

                    if(jobid.equals("add")){
                    	req.setAttribute("e01HealthGuaranteeData_vt", changeE01HealthGuaranteeData_vt);
                    }else {
                    	req.setAttribute("e01HealthGuaranteeData_vt", e01HealthGuaranteeData_vt);
                    }


                    req.setAttribute("e01HealthGuaranteeData",     firstData);
                    req.setAttribute("isUpdate", true); //등록 수정 여부
                    req.setAttribute("e01TargetNameData_vt", e01TargetNameData_vt);
                    req.setAttribute("e01HealthGuarAccqData_vt", e01HealthGuarAccqData_vt);
                    req.setAttribute("e01HealthGuarLossData_vt", e01HealthGuarLossData_vt);
                    req.setAttribute("e01HealthGuarHintchData_vt", e01HealthGuarHintchData_vt);
                    req.setAttribute("e01HealthGuarReqsData_vt", new E01HealthGuarReqsRFC().getHealthGuarReqs());

                    req.setAttribute("begda",                     begda);
                    req.setAttribute("ainf_seqn",                 ainf_seqn);

//                  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록/앞화면' 버튼 활성화 여부를 가려주는 부분
                    String ThisJspName = box.get("ThisJspName");
                    req.setAttribute("ThisJspName", ThisJspName);
//  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록/앞화면' 버튼 활성화 여부를 가려주는 부분

                    dest = WebUtil.JspURL+"E/E01Medicare/E01MedicareBuild.jsp";
                    Logger.debug.println(this, dest);

                }
                printJspPage(req, res, dest);

            } else if( jobid.equals("change") ) {

                /* 실제 신청 부분 */
                dest = changeApproval(req, box, E01HealthGuaranteeData.class, e01HealthGuaranteeRFC, new ChangeFunction<E01HealthGuaranteeData>(){

                    public String porcess(E01HealthGuaranteeData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                    	Vector changeE01HealthGuaranteeData_vt  = new Vector();

                        /* 결재 신청 RFC 호출 */
                    	E01HealthGuaranteeRFC changeRFC = new E01HealthGuaranteeRFC();
                        changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        String begda          = "";
                        //  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록/앞화면' 버튼 활성화 여부를 가려주는 부분
                        String ThisJspName = box.get("ThisJspName");
                        //  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록/앞화면' 버튼 활성화 여부를 가려주는 부분

                        /////////////////////////////////////////////////////////////////////////////
                        // 건강보험 피부양자 자격(취득/상실) 신청
                        int rowcount_data = box.getInt("RowCount_data");
                        Logger.debug.println("rowcount_datarowcount_datarowcount_data"+rowcount_data);
                        for( int i = 0; i < rowcount_data; i++) {
                            E01HealthGuaranteeData e01HealthGuaranteeData = new E01HealthGuaranteeData();
                            String idx = Integer.toString(i);

                            e01HealthGuaranteeData.MANDT          = user.clientNo;
                            e01HealthGuaranteeData.PERNR          = firstData.PERNR;
                            e01HealthGuaranteeData.AINF_SEQN      = ainf_seqn;
                            e01HealthGuaranteeData.BEGDA          = DataUtil.removeStructur(box.get("BEGDA"), "."); // 신청일자
                            e01HealthGuaranteeData.INDX_NUMB      = (i+1)+"";                        // 순번
                            e01HealthGuaranteeData.APPL_TYPE      = box.get("APPL_TYPE"+idx);        // 건강보험 피부양자 자격/취득 신청구분
                            e01HealthGuaranteeData.SUBTY          = box.get("SUBTY"+idx);            // 하부유형
                            e01HealthGuaranteeData.OBJPS          = box.get("OBJPS"+idx);            // 오브젝트식별
                            e01HealthGuaranteeData.ACCQ_LOSS_DATE = DataUtil.removeStructur(box.get("ACCQ_LOSS_DATE"+idx), ".");   // 취득/상실일자
                            e01HealthGuaranteeData.ACCQ_LOSS_TYPE = box.get("ACCQ_LOSS_TYPE"+idx);   // 건강보험 피부양자 자격 신청(취득/상실)구분
                            e01HealthGuaranteeData.HITCH_TYPE     = box.get("HITCH_TYPE"+idx);       // 장애인 종별 부호
                            e01HealthGuaranteeData.HITCH_GRADE    = box.get("HITCH_GRADE"+idx);      // 장애등급
                            e01HealthGuaranteeData.HITCH_DATE     = DataUtil.removeStructur(box.get("HITCH_DATE"+idx), ".");       // 장애등록일
                            e01HealthGuaranteeData.APPL_TEXT      = box.get("APPL_TEXT"+idx);        // 건강보험 피부양자 신청구분 텍스트
                            e01HealthGuaranteeData.ACCQ_LOSS_TEXT = box.get("ACCQ_LOSS_TEXT"+idx);   // 건강보험 피부양자 취득 상실 텍스트
                            e01HealthGuaranteeData.HITCH_TEXT     = box.get("HITCH_TEXT"+idx);       // 장애인 종별 부호 취득 텍스트
                            e01HealthGuaranteeData.ENAME          = box.get("ENAME"+idx);            // 대상자 이름
                            e01HealthGuaranteeData.APRT_CODE      = box.get("APRT_CODE"+idx);        // 원격지발급여부
                            e01HealthGuaranteeData.ZPERNR         = firstData.ZPERNR;                // 신청자 사번(대리신청, 본인 신청)
                            e01HealthGuaranteeData.UNAME          = user.empNo;                      // 수정자 사번(대리신청, 본인 신청)
                            e01HealthGuaranteeData.AEDTM          = DataUtil.getCurrentDate();       // 변경일(현재날짜)

                            // 결재 데이터에 저장할 신청일..
                            begda                                 = DataUtil.removeStructur(box.get("BEGDA"), ".");
                            changeE01HealthGuaranteeData_vt.addElement(e01HealthGuaranteeData);
                        }
                        Logger.debug.println(this, "건강보험 피부양자 자격 신청 수정 : " + changeE01HealthGuaranteeData_vt.toString());

                        changeRFC.build(changeE01HealthGuaranteeData_vt, box, req);

                        if(!changeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }
                        Logger.debug.println(this, "inputData.AINF_SEQN : " + inputData.AINF_SEQN);
                        return inputData.AINF_SEQN;
                        /* 개발자 작성 부분 끝 */
                    }
                });

                printJspPage(req, res, dest);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}
