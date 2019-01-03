/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 자격면허등록                                                */
/*   Program Name : 자격면허등록 신청                                           */
/*   Program ID   : D30MembershipFeeBuildSV                                           */
/*   Description  : 자격증면허를 신청할 수 있도록 하는 Class                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-11  최영호                                          */
/*   Update       : 2005-02-15  윤정현                                          */
/*   Update       : 2005-02-23  유용원                                          */
/*   Update		  :  2017-05-15 eunha [CSR ID:3377091] 중국 인사시스템 반려 시 오류 수정  */
/*   Upadate	  :  2017-06-29 eunha [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업*/
/*
 * [한국 신청 중간테이블]
01	ZHRA002T	HR 경조금 신청
02	ZHRA005T	HR 결재 - 개인연금
03	ZHRA006T	HR 결재 - 의료비
04	ZHRA007T	HR 결재 - 종합검진
05	ZHRA008T	입학축하금/학자금/장학금
06	ZHRA008T	입학축하금/학자금/장학금
07	ZHRA013T	가족 수당, 부양가족 수당
08	ZHRA021T	교육 과정신청
09	ZHRA002T	HR 경조금 신청
10	ZHRA011T	은행명세
11	ZHRA009T	증권계좌등록
12	ZHRA014T	주택구입/전세
13	ZHRA015T	주택자금 상환신청
14	ZHRA018T	자격면허 신청
16	ZHRA017T	재직증명서 신청
17	ZHRA022T	초과근무 테이블
18	ZHRA024T	휴가 신청
19	ZHRA019T	인포멀(가입, 탈퇴)
20	ZHRA025T	건강보험 피부양자 자격(취득/상실)
21	ZHRA026T	건강보험증 변경 재발급 신청 테이블
22	ZHRA027T	국민연금 자격변경사항 신청 TABLE
23	ZHRA023T	식대관리 테이블
24	ZHRA013T	가족 수당, 부양가족 수당
26	ZHRA005T	HR 결재 - 개인연금
27	ZHRA019T	인포멀(가입, 탈퇴)
28	ZHRA029T	근로소득 및 갑근세 원천칭수 증명서
29	ZHRA030T	가족 수당 상실신청
34	ZHRA036T	경력증명서신청
35	ZHRA037T	교육/출장 신청
36	ZHRA111T	부서일일근태 신청
37	ZHRA039T	교육차수 취소신청
38	ZHRA039T	교육차수 취소신청
39	ZHRA007T	HR 결재 - 종합검진
40	ZHRA040T	초과근무 결재취소 신청
41	ZHRA040T	휴가 결재취소 신청


[해외 신청 중간테이블]
01	ZHR0045T	Overtime
02	ZHR0046T	Absence Application
021	ZHR0046T	Absence Application
022	ZHR0046T	Absence Application
023	ZHR0046T	Absence Application
03	ZHR0044T	Bank Acount
04	ZHR0043T	License
05	ZHR0036T	Internal Certificate
06	ZHR0037T	Celebration or Condolence
07	ZHR0150T	Duty Allowance
08	ZHR0150T	Duty Allowance_Day Duty
11	ZHR0038T	Medical Fee
12	ZHR0039T	Tuition Fee
13	ZHR0040T	Language Fee
14	ZHR0234T	Address
15	ZHR0237T	Time Sheet
16	ZHR0241T	Contract Extension
17	ZGHR3001TPayments&Deduction
18	ZGHR3001TMembership Fees
 */
/********************************************************************************/

package hris.common.approval;

import com.common.Utils;
import com.google.common.base.Predicate;
import com.google.common.collect.Collections2;
import com.sns.jdf.ConfigurationException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.G.ApprovalReturnState;
import hris.G.rfc.ApprovalHeaderRFC;
import hris.G.rfc.G001ApprovalProcessRFC;
import hris.common.*;
import hris.common.rfc.PersonInfoRFC;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.Collection;
import java.util.Properties;
import java.util.Vector;

public abstract class ApprovalBaseServlet extends EHRBaseServlet {

    public static String APPROVAL_IMPORT = "APPROVAL_IMPORT";

    /**
     * 결재 유형
     *
     * @return 결재유형
     */
    protected abstract String getUPMU_TYPE();

    /**
     * 결재제목
     *
     * @return 결재제목
     */
    protected abstract String getUPMU_NAME();


    /**
     * 01		HR 경조금 신청		ZHRA002T
     02		HR 결재 - 개인연금		ZHRA005T
     03		HR 결재 - 의료비		ZHRA006T
     04		HR 결재 - 종합검진		ZHRA007T
     05		입학축하금/학자금/장학금		ZHRA008T
     06		입학축하금/학자금/장학금		ZHRA008T
     07		가족 수당, 부양가족 수당		ZHRA013T
     08		교육 과정신청		ZHRA021T
     09		HR 경조금 신청		ZHRA002T
     10		은행명세		ZHRA011T
     11		증권계좌등록		ZHRA009T
     12		주택구입/전세		ZHRA014T
     13		주택자금 상환신청		ZHRA015T
     14		자격면허 신청		ZHRA018T
     16		재직증명서 신청		ZHRA017T
     17		초과근무 테이블		ZHRA022T
     18		휴가 신청		ZHRA024T
     19		인포멀(가입, 탈퇴)		ZHRA019T
     20		건강보험 피부양자 자격(취득/상실)		ZHRA025T
     21		건강보험증 변경 재발급 신청 테이블		ZHRA026T
     22		국민연금 자격변경사항 신청 TABLE		ZHRA027T
     23		식대관리 테이블		ZHRA023T
     24		가족 수당, 부양가족 수당		ZHRA013T
     26		HR 결재 - 개인연금		ZHRA005T
     27		인포멀(가입, 탈퇴)		ZHRA019T
     28		근로소득 및 갑근세 원천칭수 증명서		ZHRA029T
     29		가족 수당 상실신청		ZHRA030T
     34		경력증명서신청		ZHRA036T
     35		교육/출장 신청		ZHRA037T
     36		부서일일근태 신청		ZHRA111T
     37		교육 취소신청		ZHRA039T
     38		교육 취소신청		ZHRA039T
     40		초과근무 결재취소 신청		ZHRA040T
     41		휴가 결재취소 신청		ZHRA040T

     ELoffice 연동 여부
     * @return
     */
    protected boolean isEloffice() {

        if(g.getSapType() == SAPType.LOCAL) {

            /* 국내 업무 중 eloffice 연동 안함 [한국] : 종합검진, 이월종합검진, 추가암검진  */
            if(Arrays.asList("04", "39").contains(getUPMU_TYPE())) {
                return false;
            }
        }


        return true;
    }

    /**
     * interface 들은 callback 과 같이 사용하기 위한 만들어짐
     * @param <T>
     */
    public interface RequestFunction<T> {
        /**
         * 넘어온 값을 RFC 호출 결재번호를 리턴 한다
         *
         * @param inputData 화면에서 넘오언 신청 요청된 값 Entity T_RESULT에 등록되는 값
         * @return 결재번호
         */
        String porcess(T inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException;
    }

    public interface ChangeFunction<T> {
        /**
         * 수정시 사용
         * @param inputData
         * @param approvalHeader
         * @param approvalLineDatas
         * @return
         * @throws GeneralException
         */
        String porcess(T inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException;
    }

    public interface DeleteFunction {
        boolean porcess() throws GeneralException;
    }

    public interface ApprovalFunction<T> {
        boolean porcess(T inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException;
    }


    /**
     * 결재 헤더 정보 와 결재라인정보를 request에 셋팅
     * 성공여부 리턴
     * @param req
     * @param PERNR
     * @return
     * @throws GeneralException
     */
    protected boolean getApprovalInfo(HttpServletRequest req, String PERNR) throws GeneralException {
        ApprovalLineInput approvalLineInput = new ApprovalLineInput();
        approvalLineInput.I_UPMU_TYPE = getUPMU_TYPE();
        approvalLineInput.I_PERNR = PERNR;

        req.setAttribute("viewSource", "true");

        return getApprovalInfo(req, PERNR, approvalLineInput);
    }
    protected boolean getApprovalInfo(HttpServletRequest req, String PERNR, String DATUM) throws GeneralException {
        ApprovalLineInput approvalLineInput = new ApprovalLineInput();
        approvalLineInput.I_UPMU_TYPE = getUPMU_TYPE();
        approvalLineInput.I_PERNR = PERNR;
        approvalLineInput.I_DATUM = DATUM;

        return getApprovalInfo(req, PERNR, approvalLineInput);
    }
    protected boolean getApprovalInfo(HttpServletRequest req, String PERNR, ApprovalLineInput approvalLineInput) throws GeneralException {
        PersonInfoRFC personInfoRFC = new PersonInfoRFC();
        ApprovalHeader approvalHeader = personInfoRFC.getApprovalHeader(PERNR);
        approvalHeader.setUPMU_TYPE(getUPMU_TYPE());
        approvalHeader.setUPMU_NAME(getUPMU_NAME());

        approvalHeader.setRQDAT(DataUtil.getCurrentDate(req));
        // header 정보
        req.setAttribute("approvalHeader", approvalHeader);

        //결재 리스트 조회
        req.setAttribute("approvalLine", getApprovalLine(approvalLineInput));

        return true;
    }

    /**
     * 결재라인을 가져온다
     * @param approvalLineInput
     * @return
     * @throws GeneralException
     */
    protected Vector<ApprovalLineData> getApprovalLine(ApprovalLineInput approvalLineInput) throws GeneralException {
        ApprovalLineRFC approvalLineRFC = new ApprovalLineRFC();
        return approvalLineRFC.getApprovalLine(approvalLineInput);
    }

    /**
     * 현재 결재라인 가져오는 부분 - 결재가능일 경우만
     * @param approvalHeader
     * @param approvalLine
     * @return
     */
    protected Vector<ApprovalLineData> getCurrentApprovalLine(ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine) {

        if(Utils.getSize(approvalLine) > 0 && "X".equals(approvalHeader.ACCPFL)) {
            for(ApprovalLineData row : approvalLine) {
                if(StringUtils.isBlank(row.APPR_STAT)) {
                    return Utils.asVector(row);
                }
            }
        }

        return null;

    }

    /**
     * 신청 공통
     * @param req
     * @param box
     * @param requestFunction
     * @param <T>
     * @return
     * @throws GeneralException
     */
    protected <T> String requestApproval(HttpServletRequest req, Box box, RequestFunction<T> requestFunction) throws GeneralException {
        return requestApproval(req, box, null, requestFunction);
    }

    /**
     * 신청 공통
     * @param req request
     * @param box Box
     * @param klass request에서 넘어온 값들을 담을 Entity Class
     * @param requestFunction 신청시 처리를 위한 interface 구현체 callback 처럼 활용
     * @param <T>
     * @return 신청 처리 후 결과 페이지
     * @throws GeneralException
     */
    protected <T> String requestApproval(HttpServletRequest req, Box box, Class<T> klass, RequestFunction<T> requestFunction) throws GeneralException {
        String dest = WebUtil.JspURL + "common/msg.jsp";
        try {
            String PERNR = getPERNR(box, WebUtil.getSessionUser(req));

            WebUserData user = WebUtil.getSessionUser(req);

            /*ApprovalHeader 형태로 사용자 정보 조회*/
            PersonInfoRFC personInfoRFC = new PersonInfoRFC();
            ApprovalHeader approvalHeader = personInfoRFC.getApprovalHeader(PERNR);

            /* 결재자 변경 로직 일부 수정 */
            Vector<ApprovalLineData> approvalLine = box.getVector(ApprovalLineData.class, "APPLINE_");
            for(ApprovalLineData row : approvalLine) {
                row.APPU_NUMB = row.getAPPU_NUMB(); /* 사번 암호화 되엇을 경우 decrypt*/
            }

            /* 결재라인이 없을 경우 check*/
            if(Utils.getSize(approvalLine) == 0) throw new GeneralException(g.getMessage("MSG.APPROVAL.0001")); //승인자 정보가 없습니다.

            //@웹취약성 결재자 인위적 변경 체크 2015-08-25-------------------------------------------------------
            ApprovalLineRFC approvalLineRFC = new ApprovalLineRFC();
            String UPMU_TYPE = getUPMU_TYPE();
            UPMU_TYPE = UPMU_TYPE.equals("41") ? "18" : UPMU_TYPE;  // 휴가취소결재라인의 경우 휴가요청과 동일하게 처리-ksc
            Vector<ApprovalLineData> approvalLineDefault = approvalLineRFC.getApprovalLine(UPMU_TYPE, PERNR);

            if(!"16".equals(UPMU_TYPE)) {
                if (!checkApprovalLine(approvalLine, approvalLineDefault)) {
                    throw new GeneralException("msg020");
                }
            }
//          @웹취약성 결재자 인위적 변경 체크 끝-------------------------------------------------------

            /* 개발자 작성 부분 시작 */
            T inputData = klass == null ? null : box.createEntity(klass);

            Utils.setFieldValue(inputData, "ZPERNR", user.empNo);   //신청자 사번 설정(대리신청 ,본인 신청)
            Utils.setFieldValue(inputData, "UNAME", user.empNo);    //신청자 사번 설정(대리신청 ,본인 신청)
            Utils.setFieldValue(inputData, "AEDTM", DataUtil.getCurrentDate(req));   // 변경일(현재날짜) - 지역시간

            /* 개발자 작성 부분 시작 */
            String AINF_SEQN = requestFunction.porcess(inputData, approvalLine); //null 은 테스트 안해봄 -> 에러시 new Object();
            /* 개발자 작성 부분 끝 */

            /* 실패 시 처리 로직 - AINF_SEQN 값이 NULL 일 경우 */
            if(AINF_SEQN == null) throw new GeneralException(g.getMessage("MSG.APPROVAL.REQUEST.FAIL"));

            /* 결재번호를 approvalHeader에 셋팅*/
            approvalHeader.AINF_SEQN = AINF_SEQN;

            String msg = "msg001";  //신청되었습니다.

            /* 메일 전송 기본 설정 */
            Properties ptMailBody = new Properties();
            ptMailBody.setProperty("FileName", g.getSapType().isLocal() ? "NoticeMail1.html" : "NoticeMail1_GLOBAL.html");


         // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha start
            /* 메일 발송 */
           /* String msg2 = sendMail(user, user.empNo, Utils.indexOf(approvalLine, 0).APPU_NUMB, approvalHeader,
                    g.getMessage("MSG.APPROVAL.0002", approvalHeader.ENAME), ptMailBody); //{0}님이 신청하셨습니다.
            */

            String msg2 = sendMail(user, user.empNo, Utils.indexOf(approvalLine, 0).APPU_NUMB, approvalHeader,
                    g.getMessage("MSG.APPROVAL.0002", getUPMU_NAME()), ptMailBody); //[HR] 결재요청 ({0})
         // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha end

            /* 통합결재 연동 */
            if(isEloffice()) {
                try {
                    DraftDocForEloffice ddfe = new DraftDocForEloffice();

                    ElofficInterfaceData eof = ddfe.makeDocContents(AINF_SEQN, user.SServer, getUPMU_NAME());

                    Vector vcElofficInterfaceData = new Vector();
                    vcElofficInterfaceData.add(eof);
                    req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                    dest = WebUtil.JspURL + "common/ElOfficeInterface.jsp";
                } catch (Exception e) {
                    msg2 = msg2 + "\\n" + " Eloffic fail";
                } // end try
            }
            /* 메일 발송 부분 끝 */

            // [WorkTime52]
            // ESS_OFW_WORK_TIME(근무 시간 입력) 메뉴에서 popup button에 의해 호출된 결재 신청 화면인 경우 결재 신청 완료 후 popup을 닫아 준다.
            if ("Y".equals(box.getString("FROM_ESS_OFW_WORK_TIME"))) {
                req.setAttribute("url", "top.window.close()");
            } else {
                req.setAttribute("url", getDetailPage(req, approvalHeader, true, true));
            }

            req.setAttribute("msg", msg);
            req.setAttribute("msg2", msg2);

        } catch (GeneralException e) {
        	String UPMU_TYPE = getUPMU_TYPE();
        	req.setAttribute("msg", e.getMessage());
        	if("18".equals(UPMU_TYPE)) {
        		StringBuffer sb = new StringBuffer();
        		sb.append("location.href = '")
	                .append(WebUtil.ServletURL+"hris.D.D03Vocation.D03VocationBuildSV")
	                .append("';");
        		req.setAttribute("url", sb.toString());
        	} else {
        		req.setAttribute("url", "history.back();");
        	}
        	
        } catch (Exception e) {
            Logger.debug.println(e.toString());
        	req.setAttribute("msg", g.getMessage("MSG.APPROVAL.REQUEST.FAIL")); //결재 의뢰 실패하였습니다.

            req.setAttribute("url", "history.back();");
        }

        return dest;
    }

    protected <T, V extends ApprovalSAPWrap> String changeApproval(HttpServletRequest req, Box box, Class<T> klass,
                                                                   V approvalRFC, ChangeFunction<T> changeFunction) throws GeneralException {
        T inputData = null;
        try {
            inputData = klass.newInstance();
        } catch (Exception e) {
            Logger.error(e);
        }

        return changeApproval(req, box, inputData, approvalRFC, changeFunction);
    }


    /**
     * 수정 공통
     * @param box Box
     * @param inputData 수정 입력할 대상 데이타
     * @param approvalRFC ApprovalSAPWrap 을 상속받은 상세조회가 실행된 RFC
     * @param changeFunction 수정을 위한 interface
     * @param <T>
     * @param <V>
     * @return 결과 페이지
     * @throws GeneralException
     */
    protected <T, V extends ApprovalSAPWrap> String changeApproval(HttpServletRequest req, Box box, T inputData,
                                                                   V approvalRFC, ChangeFunction<T> changeFunction) throws GeneralException {
        String dest = WebUtil.JspURL + "common/msg.jsp";
        try {
            WebUserData user = WebUtil.getSessionUser(req);

            /* 상세조회에서 ApprovalHeader 조회 */
            ApprovalHeader approvalHeader = approvalRFC.getApprovalHeader();

            /* 결재자 변경 로직 일부 수정 */
            Vector<ApprovalLineData> approvalLine = box.getVector(ApprovalLineData.class, "APPLINE_");
            for(ApprovalLineData row : approvalLine) {
                row.APPU_NUMB = row.getAPPU_NUMB(); /* 사번 암호화 되엇을 경우 decrypt*/
            }

            if(Utils.getSize(approvalLine) == 0) throw new GeneralException(g.getMessage("MSG.APPROVAL.0001")); //승인자 정보가 없습니다.

             /* 수정 가능 여부 확인 */
            /*if(!"X".equals(approvalHeader.MODFL)) {
                req.setAttribute("msg", g.getMessage("MSG.APPROVAL.UPDATE.DISABLE"));   //현재 수정이 가능한 상태가 아닙니다.
                return dest;
            }*/

            /* RFC 에서 처리 변경 */
            /*
            for(ApprovalLineData approvalLineData : approvalLine) {
//                approvalLineData.PERNR     = approvalHeader.PERNR;
//                approvalLineData.BEGDA     = tempData.BEGDA;
            }
            */

            /*
            // 수정에는 기존에는 없었음
            ApprovalLineRFC approvalLineRFC = new ApprovalLineRFC();
            Vector<ApprovalLineData> approvalLineDefault = approvalLineRFC.getApprovalLine(getUPMU_TYPE(), PERNR);

            //@웹취약성 결재자 인위적 변경 체크 2015-08-25-------------------------------------------------------
            if(!checkApprovalLine(approvalLine, approvalLineDefault)) {
                moveMsgPage(req, res, "msg020", "history.back();"); //기존 caution.jsp
                return dest;
            }
//          @웹취약성 결재자 인위적 변경 체크 끝-------------------------------------------------------
            */

            /* 기존 결재데이타 중 수정시 다시 셋팅 */
            box.copyToEntity(inputData);

            Utils.setFieldValue(inputData, "PERNR", approvalHeader.ITPNR);     //신청자 사번 설정(대리신청 ,본인 신청) - 대상자 사번
            Utils.setFieldValue(inputData, "ZPERNR", approvalHeader.RQPNR);   //신청자 사번 설정(대리신청 ,본인 신청) - 로그인 사번
            Utils.setFieldValue(inputData, "UNAME", user.empNo);    //신청자 사번 설정(대리신청 ,본인 신청)
            Utils.setFieldValue(inputData, "AEDTM", DataUtil.getCurrentDate(req));   // 변경일(현재날짜) - 지역시간
            Utils.setFieldValue(inputData, "AINF_SEQN", approvalHeader.AINF_SEQN);   //기존 결재 번호


            if ("X".equals(approvalHeader.MODFL)) {
                throw new GeneralException(g.getMessage("MSG.APPROVAL.UPDATE.DISABLE"));
            }

            /* 개발자 작성 부분 시작 */
            String AINF_SEQN = changeFunction.porcess(inputData, approvalHeader, approvalLine); //null 은 테스트 안해봄 -> 에러시 new Object();
            /* 개발자 작성 부분 끝 */

            if(AINF_SEQN == null) {
                throw new GeneralException(g.getMessage("MSG.APPROVAL.UPDATE.FAIL"));   // 수정에 실패 하였습니다.
            }

            String msg = "msg002";  //수정되었습니다.
            String msg2 = "";

            Vector<ApprovalLineData> oldAppLine = approvalRFC.getApprovalLine();
            ApprovalLineData oldAppLineFirst = Utils.indexOf(oldAppLine, 0);
            ApprovalLineData approvalLineFirst = Utils.indexOf(approvalLine, 0);

            /* 결재라인 1번쨰가 기존 결재라인과 동일하지 않을 경우 메일 발송 및 전자결재 반영  */
            if (!StringUtils.equals(oldAppLineFirst.APPU_NUMB, approvalLineFirst.APPU_NUMB)) {

                Properties ptMailBody = new Properties();
                //ptMailBody.setProperty("FileName", "NoticeMail5.html"); //기존에는 없던 로직
             // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha start
                /*String deleteMsg = sendMail(user, user.empNo, oldAppLineFirst.APPU_NUMB, approvalHeader,
                        g.getMessage("MSG.APPROVAL.0003", approvalHeader.ENAME), ptMailBody);   //+ "님이 신청을 삭제하셨습니다."*/
                String deleteMsg = sendMail(user, user.empNo, oldAppLineFirst.APPU_NUMB, approvalHeader,
                        g.getMessage("MSG.APPROVAL.0003", getUPMU_NAME()), ptMailBody);
             // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha send
                if (StringUtils.isNotBlank(deleteMsg)) msg2 = g.getMessage("BUTTON.COMMON.DELETE") + " " + deleteMsg;

                // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha start
                /* 메일 발송 */
               /* String sendMsg = sendMail(user, user.empNo, approvalLineFirst.APPU_NUMB, approvalHeader,
                        g.getMessage("MSG.APPROVAL.0002", approvalHeader.ENAME), null);*/

                String sendMsg = sendMail(user, user.empNo, approvalLineFirst.APPU_NUMB, approvalHeader,
                        g.getMessage("MSG.APPROVAL.0002", getUPMU_NAME()), null);
              /// [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha end

                if (StringUtils.isNotBlank(sendMsg)) msg2 = "\\n " + g.getMessage("BUTTON.COMMON.REQUEST") + " " + sendMsg;

            /* 통합결재 */
                if(isEloffice()) {
                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof = ddfe.makeDocForChange(AINF_SEQN, user.SServer, approvalHeader.PERNR, getUPMU_NAME(), oldAppLineFirst.PERNR);
                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);

                        ElofficInterfaceData eofD = ddfe.makeDocContents(AINF_SEQN, user.SServer, getUPMU_NAME());
                        vcElofficInterfaceData.add(eofD);

                        req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        dest = WebUtil.JspURL + "common/ElOfficeInterface.jsp";
                    } catch (Exception e) {
                        msg2 = msg2 + "\\n" + " Eloffic fail";
                    } // end try
                }
            /* 메일 발송 부분 끝 */
            }

             /* 신청 후 msg 처리 후 이동 페이지 지정 - 공통 처리*/
            req.setAttribute("url", getDetailPage(req, approvalHeader, false, false));

            req.setAttribute("msg", msg);
            req.setAttribute("msg2", msg2);

        } catch (GeneralException e) {
        	req.setAttribute("msg", e.getMessage());
    		req.setAttribute("url", "history.back();");
        } catch (Exception e) {
            req.setAttribute("msg", g.getMessage("MSG.APPROVAL.UPDATE.FAIL"));
            req.setAttribute("url", "history.back();");
        }

        return dest;
    }

    /**
     * 수정 및 신청등 이후 이동할 상세페이지 - 결재진행중 문서
     * @param req
     * @param approvalHeader
     * @param isMoveMenu
     * @param isRequest
     * @return
     */
    private String getDetailPage(HttpServletRequest req, ApprovalHeader approvalHeader, boolean isMoveMenu, boolean isRequest) {
        StringBuffer sb = new StringBuffer();
        StringBuffer sburl = new StringBuffer();

        String I_APGUB = req.getParameter("I_APGUB");

        String url = "hris.G.G002ApprovalIngDetailSV";

        String menuCode = "ESS_APP_ING_DOC";

        /* MSS 결재함 메뉴로 이동할 결재유형 */
        if(!g.getSapType().isLocal() && "16".equals(getUPMU_TYPE())) menuCode = "MSS_APP_ING_DOC";

        /* 상세.. ING, FINISH, DOC */
        if("1".equals(I_APGUB)) {
            url = "hris.G.G000ApprovalDetailSV";
            menuCode = "ESS_APP_TO_DO_DOC";
        } else if("3".equals(I_APGUB)) {
            url = "hris.G.G003ApprovalFinishDetailSV";
            menuCode = "ESS_APP_VED_DOC";
        }


        /* URL 작성 */
        sburl.append(WebUtil.ServletURL).append(url)
            .append("?AINF_SEQN=").append(approvalHeader.AINF_SEQN)
            .append("&UPMU_TYPE=").append(getUPMU_TYPE());

        if(isRequest) sburl.append("&afterRequest=true");

        /* 만약 요청 페이지(뒤로가기시 이동할 페이지) 가 존재할 경우 페이지 셋팅*/
        try {
            if(StringUtils.isNotBlank(g.getRequestPageName(req)))
                sburl.append("&RequestPageName=").append(URLEncoder.encode(g.getRequestPageName(req), "UTF-8"));
        } catch (UnsupportedEncodingException e) {
            Logger.error(e);
        }

        if(isMoveMenu) {
        /* 메뉴이동 */
            sb.append("moveMenu(")
                    .append("'").append(menuCode).append("'")
                    .append(",")
                    .append("'").append(sburl).append("'")
                    .append(");");
        } else {
        /* URL 페이지 이동  */
            sb.append("location.href = '")
                    .append(sburl)
                    .append("';");
        }

        Logger.debug("------ move url ------ " + sb);

        return sb.toString();
    }

    /**
     * 결재 삭제
     * @param req request
     * @param box BOx
     * @param approvalRFC ApprovalSAPWrap 을 상속받은 상세조회가 실행된 RFC
     * @param deleteFunction 삭제를 위한 interface
     * @param <V>
     * @return
     * @throws GeneralException
     */
    protected <V extends ApprovalSAPWrap> String deleteApproval(HttpServletRequest req, Box box,
                                                                V approvalRFC, DeleteFunction deleteFunction) throws GeneralException {

        String dest = WebUtil.JspURL + "common/msg.jsp";
        try {
            WebUserData user = WebUtil.getSessionUser(req);

            /*ApporvalHeader 조회*/
            ApprovalHeader approvalHeader = approvalRFC.getApprovalHeader();

            if ("X".equals(approvalHeader.CANCFL)) {
                throw new GeneralException(g.getMessage("MSG.APPROVAL.CANCEL.DISABLE"));  //현재 취소가 가능한 상태가 아닙니다.
            }

            /* 개발자 작성 부분 시작 */
            if(!deleteFunction.porcess()) throw new GeneralException(g.getMessage("MSG.APPROVAL.CANCEL.FAIL")); //"취소에 실패 하였습니다."
            /* 개발자 작성 부분 끝 */


            String msg = "msg003";  //식제되었습니다.
            String msg2 = "";

            /* 결재라인 첫번째 대상자에게 메일 발송 통합결재 삭제 처리 */
            ApprovalLineData oldAppLineFirst = Utils.indexOf(approvalRFC.getApprovalLine(), 0);

            if(oldAppLineFirst != null) {

                Properties ptMailBody = new Properties();
                ptMailBody.setProperty("FileName", g.getSapType().isLocal() ? "NoticeMail5.html" : "NoticeMail5_GLOBAL.html");
                // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha start
                /*String deleteMsg = sendMail(user, user.empNo, oldAppLineFirst.APPU_NUMB, approvalHeader,
                        g.getMessage("MSG.APPROVAL.0003", approvalHeader.ENAME), ptMailBody);   //+ "님이 신청을 삭제하셨습니다."*/

                String deleteMsg = sendMail(user, user.empNo, oldAppLineFirst.APPU_NUMB, approvalHeader,
                		g.getMessage("MSG.APPROVAL.0003", getUPMU_NAME()), ptMailBody);

             // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha end

                if (StringUtils.isNotBlank(deleteMsg)) msg2 = " delete " + deleteMsg;

                if(isEloffice()) {
                    try {
                        DraftDocForEloffice ddfe = new DraftDocForEloffice();
                        ElofficInterfaceData eof = ddfe.makeDocForRemove(approvalHeader.AINF_SEQN, user.SServer, getUPMU_NAME()
                                , approvalHeader.PERNR, oldAppLineFirst.APPU_NUMB);

                        Vector vcElofficInterfaceData = new Vector();
                        vcElofficInterfaceData.add(eof);
                        req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                        dest = WebUtil.JspURL + "common/ElOfficeInterface.jsp";

                    } catch (Exception e) {
                        msg2 = msg2 + "\\n" + " Eloffic fail";
                    } // end try
                }

            }

            String url = "location.href = '" + g.getRequestPageName(req) + "';";
            req.setAttribute("url", url);

            req.setAttribute("msg", msg);
            req.setAttribute("msg2", msg2);

        } catch (GeneralException e) {
            req.setAttribute("msg", e.getMessage());
            req.setAttribute("url", "history.back();");
        } catch (Exception e) {
            req.setAttribute("msg", g.getMessage("MSG.APPROVAL.CANCEL.FAIL"));  //"취소에 실패 하였습니다."
            req.setAttribute("url", "history.back();");
        }
        return dest;
    }

    /**
     * 승인 반려 공통
     * @param req
     * @param box
     * @param detailImportTableName 승인시 등록될 table명
     * @param detailData    승인시 등록 데이타
     * @param approvalRFC ApprovalSAPWrap 을 상속받은 상세조회가 실행된 RFC
     * @param approvalFunction interface
     * @param isAccept 승인/반려 여부
     * @param <T>
     * @param <V>
     * @return 결과 페이지
     * @throws GeneralException
     */
    protected <T, V extends ApprovalSAPWrap> String approval(HttpServletRequest req, Box box, String detailImportTableName, T detailData,
                                                                   V approvalRFC, ApprovalFunction<T> approvalFunction, boolean isAccept) throws GeneralException {

        String dest = WebUtil.JspURL + "common/msg.jsp";
        String msg = g.getMessage("MSG.APPROVAL." + (isAccept ? "ACCEPT" : "REJECT") + ".FAIL");
        String msg2 = "";

        try{
            WebUserData user = WebUtil.getSessionUser(req);

            ApprovalHeader approvalHeader = approvalRFC.getApprovalHeader();
            Vector<ApprovalLineData> approvalLine = approvalRFC.getApprovalLine();

            /* 결재 가능 여부 확인 */
            if(!"X".equals(approvalHeader.ACCPFL)) {
                req.setAttribute("msg", g.getMessage("MSG.APPROVAL." + (isAccept ? "ACCEPT" : "REJECT") + ".DISABLE"));   //"결재 가능한 상태가 아닙니다."
                return dest;
            }

            if(approvalFunction != null) {
                /* 개발자 영역 시작 */
                if(!approvalFunction.porcess(detailData, approvalHeader, approvalLine)) {
                    return dest;
                }
                /* 개발자 영역 끝 */
            }

                    /* 승인 / 반려 공통 */
            ApprovalLineData approvalCurrent = null;

                /* 현재 결재자 가져오기 */
            for(ApprovalLineData approvalLineData : approvalLine) {
                if(StringUtils.isBlank(approvalLineData.APPR_STAT)) {
                    approvalCurrent = approvalLineData;
                    break;
                }
            }

                /* 승인/반려 시 사용될 결재 정보 */
            AppLineData appLine        = new AppLineData();

            appLine.APPL_BUKRS = user.companyCode;
            appLine.APPL_PERNR = approvalHeader.PERNR;
            appLine.APPL_BEGDA = Utils.getFieldValue(detailData, "BEGDA", box.get("BEGDA"));
            appLine.APPL_AINF_SEQN = approvalHeader.AINF_SEQN;
            appLine.APPL_APPU_TYPE = approvalCurrent.APPU_TYPE;
            appLine.APPL_APPR_SEQN = approvalCurrent.APPR_SEQN;
            appLine.APPL_APPU_NUMB = user.empNo;
            appLine.APPL_APPR_STAT = box.getString("APPR_STAT");
            appLine.APPL_BIGO_TEXT = box.getString("BIGO_TEXT");
//            appLine.APPL_CMMNT = box.getString("BIGO_TEXT");  //결재 의견
            appLine.APPL_APPR_DATE = DataUtil.getCurrentDate(req);
            appLine.APPL_APPR_TIME = DataUtil.getDate(req);

            /* 만약 기본 테이블 외 추가 테이블이 존재 할 경우 - box.put(APPROVAL_IMPORT, ApprovalImport) 사용*/
            G001ApprovalProcessRFC approvalProcessRFC = new G001ApprovalProcessRFC();
            ApprovalImport approvalImport = (ApprovalImport) box.getObject(APPROVAL_IMPORT);

            if(approvalImport != null) {
                approvalProcessRFC.setApprovalImport(approvalImport);
            }

            /* 승인 반려 RFC 처리 */
            ApprovalReturnState approvalReturn = approvalProcessRFC.setApproval(Utils.asVector(appLine), detailImportTableName, Utils.asVector(detailData));

            msg = isAccept ? "msg009" : "msg010";

            if(!approvalReturn.isSuccess()) throw new GeneralException(approvalReturn.E_MESSAGE);

            /* 멜 전송을 위한 프로퍼티 */
            Properties ptMailBody = new Properties();
            ptMailBody.setProperty("UPMU_NAME", getUPMU_NAME());

            // 멜 제목
            StringBuffer sbSubject = new StringBuffer(512);

            String to_empNo = approvalHeader.PERNR;

            try {
                if (isAccept) {
            /* 승인일 경우 최종 승인자 여부 확인 후 메일 구분 */
                    for (int i = 0; i < approvalLine.size(); i++) {
                        ApprovalLineData tempAppLine = approvalLine.get(i);

                        if (tempAppLine.APPU_TYPE.equals(approvalCurrent.APPU_TYPE) && tempAppLine.APPR_SEQN.equals(approvalCurrent.APPR_SEQN)) {
                            if (i == approvalLine.size() - 1) {
                                // 마직막 결재자
                                ptMailBody.setProperty("FileName", g.getSapType().isLocal() ? "NoticeMail2.html" : "NoticeMail2_GLOBAL.html");
                                // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha start
                                //[HR] 결재완료 통보(업무명)
                                sbSubject.append(g.getMessage("MSG.APPROVAL.0004",  getUPMU_NAME()));
                             // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha end
                            } else {
                                // 이후 결재자
                                tempAppLine = approvalLine.get(i + 1);
                                to_empNo = tempAppLine.APPU_NUMB;
                                //{0}님이 결재를 요청 하셨습니다.
                                ptMailBody.setProperty("FileName", g.getSapType().isLocal() ? "NoticeMail1.html" : "NoticeMail1_GLOBAL.html");
                             // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha start
                                //sbSubject.append(g.getMessage("MSG.APPROVAL.0005", user.ename));
                                sbSubject.append(g.getMessage("MSG.APPROVAL.0005",  getUPMU_NAME()));
                             // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha end
                                break;
                            } // end if
                        }
                    } // end for
                } else {
            /* 반려일 경우 */
            /* 결재유형이 02 인 결재자 중 2번쨰 이상인 결재가 반려 할 경우 02의 첫번쨰 결재자한테 메일 발송 - 국내일 경우만 */
                    if(g.getSapType().isLocal()) {
                        if ("02".equals(approvalCurrent.APPU_TYPE) && Integer.parseInt(approvalCurrent.APPR_SEQN) > 1) {
                            for (int i = 0; i < approvalLine.size(); i++) {
                                ApprovalLineData tempAppLine = approvalLine.get(i);
                                if (tempAppLine.APPU_TYPE.equals("02") && tempAppLine.APPR_SEQN.equals("01")) {
                                    tempAppLine = approvalLine.get(i);
                                    to_empNo = tempAppLine.APPU_NUMB;
                                } // end if
                            } // end for
                        } // end if
                    }

                    ptMailBody.setProperty("FileName", g.getSapType().isLocal() ? "NoticeMail3.html" : "NoticeMail3_GLOBAL.html");
                    // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha start
                    //[HR] 결재반려 통보(업무명)
                    //{0}님이 {1}를 반려 하셨습니다.
                    //sbSubject.append(g.getMessage("MSG.APPROVAL.0006", user.ename, getUPMU_NAME()));
                    sbSubject.append(g.getMessage("MSG.APPROVAL.0006", getUPMU_NAME()));
                 // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha end
                }

                String sendMsg = sendMail(user, user.empNo, to_empNo, approvalHeader, sbSubject.toString(), ptMailBody);


                if (StringUtils.isNotBlank(sendMsg)) msg2 = sendMsg + "\\n";
            } catch (Exception e) {
                msg2 = g.getMessage("COMMON.APPROVAL.MAIL.FAIL") ;
            }

            /* 통합 결재 전송 */
            if(isEloffice()) {
                try {
                    DraftDocForEloffice ddfe = new DraftDocForEloffice();
                    ElofficInterfaceData eof;
                    Vector vcElofficInterfaceData = new Vector();
                    if (!approvalCurrent.APPU_NUMB.equals(user.empNo)) {
                        //결재올려진 결재자 외의 테스크를 가지고 있는 결재자가 결재할때 처리:현재 전자결재에 들어가있는 DATA를 삭제후 다시 처리
                        ElofficInterfaceData eofD = ddfe.makeDocForDelete(approvalHeader.AINF_SEQN, user.SServer, approvalHeader.PERNR, ptMailBody.getProperty("UPMU_NAME"), approvalCurrent.APPU_NUMB);
                        vcElofficInterfaceData.add(eofD);
                        ElofficInterfaceData eofI = ddfe.makeDocForInsert(approvalHeader.AINF_SEQN, user.SServer, approvalHeader.PERNR, ptMailBody.getProperty("UPMU_NAME"));
                        vcElofficInterfaceData.add(eofI);
                    }
//                    if (appLine.APPL_APPR_STAT.equals("A")) {
                /* 승인 시 ?*/
                    if (isAccept) {
                        eof = ddfe.makeDocContents(approvalHeader.AINF_SEQN, user.SServer, ptMailBody.getProperty("UPMU_NAME"));
                    } else {
                        //[CSR ID:3377091] 중국 인사시스템 반려 시 오류 수정
                    	//if (approvalCurrent.APPU_TYPE.equals("02") && Integer.parseInt(approvalCurrent.APPR_SEQN) > 1) {
                    	if (g.getSapType().isLocal() && approvalCurrent.APPU_TYPE.equals("02") && Integer.parseInt(approvalCurrent.APPR_SEQN) > 1) {
                            eof = ddfe.makeDocForMangerReject(approvalHeader.AINF_SEQN, user.SServer, ptMailBody.getProperty("UPMU_NAME"), approvalLine);
                        /* 최종 결재 반려 일 경우 */
                            //eof.R_EMP_NO = DataUtil.fixEndZero( user.empNo ,8);  /* 반려 요청자는 현재 로그인 사번 - 이송렬차장 확인 후 추가함함  */ //???? 추가 해야 되는건가?
                        } else {
                            int nRejectLength = 0;

                            for (int i = approvalLine.size() - 1; i >= 0; i--) {
                                ApprovalLineData tempAppLine = approvalLine.get(i);
                                if (tempAppLine.APPU_TYPE.equals(approvalCurrent.APPU_TYPE) && tempAppLine.APPR_SEQN.equals(approvalCurrent.APPU_TYPE)) {
                                    nRejectLength = i + 1;
                                    break;
                                } // end if
                            } // end for

                            String approvers[] = new String[nRejectLength];
                            for (int i = 0; i < approvers.length; i++) {
                                ApprovalLineData tempAppLine = approvalLine.get(i);
                                approvers[i] = tempAppLine.APPU_NUMB;
                            } // end for
                            if (!approvalCurrent.APPU_NUMB.equals(user.empNo)) {
                                approvers[approvers.length - 1] = user.empNo; //ESB 오류 수정
                            }
                            eof = ddfe.makeDocForReject(approvalHeader.AINF_SEQN, user.SServer, ptMailBody.getProperty("UPMU_NAME"), approvalHeader.PERNR, approvers);

                            eof.R_EMP_NO = DataUtil.fixEndZero(user.empNo, 8);  /* 반려 요청자는 현재 로그인 사번 - 이송렬차장 확인 후 추가함함  */
                        } // end if

                    /*
                    1차 00202350
                    2차 00219665
                    3차 00202350
                    일 경우
                    R_EMP_NO - A_EMP_NO
                1차 00202350 - 00219665   R
                2차 00219665 - 00202350  M
                3차 00202350  - 의미없음C반려, F승인

                     */
                    } // end if
                    vcElofficInterfaceData.add(eof);
                    req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                    dest = WebUtil.JspURL + "common/ElOfficeInterface.jsp";
                } catch (Exception e) {
                    Logger.error(e);
                    msg2 = msg2 + " Eloffic fail";
                } // end try
            }

            String url = "location.href = \"" + g.getRequestPageName(req) + "\";";
            req.setAttribute("url", url);
            req.setAttribute("msg", msg);

        } catch (GeneralException e) {
            Logger.error(e);
            req.setAttribute("msg", e.getMessage());
            req.setAttribute("url", "history.back();");
        } catch (Exception e) {
            Logger.error(e);
            req.setAttribute("msg", g.getMessage("MSG.APPROVAL." + (isAccept ? "ACCEPT" : "REJECT") + ".FAIL"));  //결재에 실패 하였습니다.
            req.setAttribute("url", "history.back();");
        }

        return dest;
    }

    /**
     * 승인시
     * @param req
     * @param box
     * @param detailImportTableName
     * @param detailData
     * @param approvalRFC
     * @param approvalFunction
     * @param <T>
     * @param <V>
     * @return
     * @throws GeneralException
     */
    protected <T, V extends ApprovalSAPWrap> String accept(HttpServletRequest req, Box box, String detailImportTableName, T detailData,
                                                             V approvalRFC, ApprovalFunction<T> approvalFunction) throws GeneralException {
        return approval(req, box, detailImportTableName, detailData, approvalRFC, approvalFunction, true);
    }

    /**
     * 반려시
     * @param req
     * @param box
     * @param detailImportTableName
     * @param detailData
     * @param approvalRFC
     * @param approvalFunction
     * @param <T>
     * @param <V>
     * @return
     * @throws GeneralException
     */
    protected <T, V extends ApprovalSAPWrap> String reject(HttpServletRequest req, Box box, String detailImportTableName, T detailData,
                                                           V approvalRFC, ApprovalFunction<T> approvalFunction) throws GeneralException {
        return approval(req, box, detailImportTableName, detailData, approvalRFC, approvalFunction, false);
    }

    protected <T, V extends ApprovalSAPWrap> String cancel(HttpServletRequest req, Box box, String detailImportTableName, T detailData,
                                                           V approvalRFC, ApprovalFunction<T> approvalFunction) throws GeneralException {
        String dest = WebUtil.JspURL + "common/msg.jsp";
        String msg = g.getMessage("MSG.APPROVAL.CANCEL.FAIL");
        String msg2 = "";

        try{
            WebUserData user = WebUtil.getSessionUser(req);

            ApprovalHeaderRFC approvalHeaderRFC = new ApprovalHeaderRFC();

            ApprovalHeader approvalHeader = approvalRFC.getApprovalHeader();
            Vector<ApprovalLineData> approvalLine = approvalRFC.getApprovalLine();


            ApprovalHeader cancelHeader = approvalHeaderRFC.getApprovalHeader(approvalHeader.AINF_SEQN, user.empNo, "2");

            /* 결재 가능 여부 확인 */
            if(!"X".equals(cancelHeader.CANCFL)) {
                req.setAttribute("msg", g.getMessage("MSG.APPROVAL.CANCEL.DISABLE"));   //"취소 가능한 상태가 아닙니다."
                return dest;
            }

            if(approvalFunction != null) {
                /* 개발자 영역 시작 */
                if(!approvalFunction.porcess(detailData, approvalHeader, approvalLine)) {
                    return dest;
                }
                /* 개발자 영역 끝 */
            }

                    /* 승인 / 반려 공통 */
            ApprovalLineData approvalCurrent = null;

                /* 마지막 승인자 가져오기 */
            for(ApprovalLineData approvalLineData : approvalLine) {
                if(StringUtils.isBlank(approvalLineData.APPR_STAT)) {
                    break;
                }
                approvalCurrent = approvalLineData;
            }

                /* 승인/반려 시 사용될 결재 정보 */
            AppLineData appLine        = new AppLineData();

            appLine.APPL_BUKRS = user.companyCode;
            appLine.APPL_PERNR = approvalHeader.PERNR;
            appLine.APPL_BEGDA = Utils.getFieldValue(detailData, "BEGDA", box.get("BEGDA"));
            appLine.APPL_AINF_SEQN = approvalHeader.AINF_SEQN;
            appLine.APPL_APPU_TYPE = approvalCurrent.APPU_TYPE;
            appLine.APPL_APPR_SEQN = approvalCurrent.APPR_SEQN;
            appLine.APPL_APPU_NUMB = user.empNo;
            appLine.APPL_APPR_STAT = box.getString("APPR_STAT");
            appLine.APPL_BIGO_TEXT = "";    //box.getString("BIGO_TEXT");
//            appLine.APPL_CMMNT = box.getString("BIGO_TEXT");  //결재 의견
            appLine.APPL_APPR_DATE = null;  //DataUtil.getCurrentDate(req);
            appLine.APPL_APPR_TIME = null;  //DataUtil.getDate(req);

            G001ApprovalProcessRFC approvalProcessRFC = new G001ApprovalProcessRFC();
            ApprovalImport approvalImport = (ApprovalImport) box.getObject(APPROVAL_IMPORT);

            if(approvalImport != null) {
                approvalProcessRFC.setApprovalImport(approvalImport);
            }

            ApprovalReturnState approvalReturn = approvalProcessRFC.setApproval(Utils.asVector(appLine), detailImportTableName, Utils.asVector(detailData));

            msg = "msg011";

            if(!approvalReturn.isSuccess()) throw new GeneralException(approvalReturn.E_MESSAGE);

            Properties ptMailBody = new Properties();
            ptMailBody.setProperty("UPMU_NAME", getUPMU_NAME());

            // 멜 제목
            StringBuffer sbSubject = new StringBuffer(512);

            String to_empNo = approvalHeader.PERNR;

            try {
                ptMailBody.setProperty("FileName" ,"NoticeMail5.html");

                msg = "msg011";

                for (int i = 0; i < approvalLine.size(); i++) {
                    ApprovalLineData tempAppLine = approvalLine.get(i);

                    if (tempAppLine.APPU_TYPE.equals(approvalCurrent.APPU_TYPE) && tempAppLine.APPR_SEQN.equals(approvalCurrent.APPR_SEQN)) {
                        // 이후 결재자
                        tempAppLine = approvalLine.get(i + 1);
                        to_empNo = tempAppLine.APPU_NUMB;
                        //{0}님이 결재를 요청 하셨습니다.
                     // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha start
                        //sbSubject.append(g.getMessage("MSG.APPROVAL.0005", user.ename));
                        sbSubject.append(g.getMessage("MSG.APPROVAL.0005", getUPMU_NAME()));
                     // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha end
                        break;
                    }
                } // end for

                sbSubject.append("삭제 하셨습니다.");

                ptMailBody.setProperty("to_empNo" ,to_empNo);                   // 멜 수신자 사번
                ptMailBody.setProperty("subject"  ,sbSubject.toString());       // 멜 제목 설정

                String sendMsg = sendMail(user, user.empNo, to_empNo, approvalHeader, sbSubject.toString(), ptMailBody);

                if (StringUtils.isNotBlank(sendMsg)) msg2 = sendMsg + "\\n";

                try {
                    DraftDocForEloffice ddfe = new DraftDocForEloffice();

                    ElofficInterfaceData eof = ddfe.makeDocForCancel(approvalHeader.AINF_SEQN ,user.SServer,ptMailBody.getProperty("UPMU_NAME") ,to_empNo);

                    Vector vcElofficInterfaceData = new Vector();
                    vcElofficInterfaceData.add(eof);
                    req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                    dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";
                } catch (Exception e) {
                    dest = WebUtil.JspURL+"common/msg.jsp";
                    msg2 = msg2 +  " Eloffic 연동 실패 " ;
                } // end try
                if (StringUtils.isNotBlank(sendMsg)) msg2 = sendMsg + "\\n";
            } catch (Exception e) {
                msg2 = g.getMessage("COMMON.APPROVAL.MAIL.FAIL") ;
            }

            String url = "location.href = \"" + g.getRequestPageName(req) + "\";";
            req.setAttribute("url", url);
            req.setAttribute("msg", msg);

        } catch (GeneralException e) {
            Logger.error(e);
            req.setAttribute("msg", e.getMessage());
            req.setAttribute("url", "history.back();");
        } catch (Exception e) {
            Logger.error(e);
            req.setAttribute("msg", g.getMessage("MSG.APPROVAL.CANCEL.FAIL"));  //결재에 실패 하였습니다.
            req.setAttribute("url", "history.back();");
        }

        return dest;

    }


    /**
     * 보안 점검 인위적으로 변경 불가능한 결재라인 변경 체크
     *
     * @param approvalLine
     * @param approvalLineDefault
     * @return
     */
    private boolean checkApprovalLine(Vector<ApprovalLineData> approvalLine, Vector<ApprovalLineData> approvalLineDefault) {
        for (final ApprovalLineData row : approvalLineDefault) {
            if ("01".equals(row.APPU_TYPE)) continue;

            //같은 APPR_SEQN APPU_TYPE 관 같은 PERNR 이 존재하는지 확인 한다. 1 row 여야 정상
            Collection<ApprovalLineData> changeList = Collections2.filter(approvalLine, new Predicate<ApprovalLineData>() {
                public boolean apply(ApprovalLineData approvalLineData) {
                    return StringUtils.equals(row.APPR_SEQN, approvalLineData.APPR_SEQN) && StringUtils.equals(row.APPU_TYPE, approvalLineData.APPU_TYPE) &&
                            StringUtils.equals(row.APPU_NUMB, approvalLineData.APPU_NUMB);
                }
            });

            if (Utils.getSize(changeList) != 1) {
                return false;
            }
        }
        return true;
    }

    protected String sendMail(WebUserData user, String sender, String receiver, ApprovalHeader approvalHeader, String subjectSuffix, Properties ptMailBody) throws ConfigurationException {

        String returnMsg = "";

         /* 메일 발송 부분 시작 */
        if (ptMailBody == null) ptMailBody = new Properties();

        ptMailBody.setProperty("SServer", user.SServer);              // ElOffice 접속 서버
        ptMailBody.setProperty("from_empNo", sender);            // 멜 발송자 사번
        ptMailBody.setProperty("to_empNo", receiver);  // 멜 수신자 사번

        ptMailBody.setProperty("ename", approvalHeader.ENAME);       // (피)신청자명
        ptMailBody.setProperty("empno", approvalHeader.PERNR);       // (피)신청자 사번

        ptMailBody.setProperty("UPMU_NAME", getUPMU_NAME());              // 문서 이름
        ptMailBody.setProperty("AINF_SEQN", approvalHeader.AINF_SEQN);
        ptMailBody.setProperty("USER_AREA", user.area.toString());
        // 신청서 순번
        //멜 제목
        StringBuffer sbSubject = new StringBuffer(512);

        // [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha start
        //sbSubject.append("[" + getUPMU_NAME() + "] ");
      /// [CSR ID:3420113] 인사시스템 신청 및 결재 메일 UI 표준작업  2017-06-29 eunha end
        sbSubject.append(subjectSuffix);

        ptMailBody.setProperty("subject", sbSubject.toString());

        MailSendToEloffic maTe = new MailSendToEloffic(ptMailBody);

        if (!maTe.process()) {
            returnMsg = maTe.getMessage();
        }

        return returnMsg;
    }

    /**
     * 상세 공통
     *
     * @param request           HttpServletRequest
     * @param response          HttpServletResponse
     * @param approvalRFC       ApprovalSAPWrap 을 상속 받은 RFC
     * @param <T>
     * @throws GeneralException
     */
    protected <T extends ApprovalSAPWrap> boolean detailApporval(HttpServletRequest request, HttpServletResponse response,
                                                                 T approvalRFC) throws GeneralException {

        ApprovalHeader approvalHeader = approvalRFC.getApprovalHeader();  //헤더
        Vector<ApprovalLineData> approvalLine = approvalRFC.getApprovalLine();    //결재라인

            /* 페이지 조회 가능 확인 */
        if (approvalHeader==null) {
            //해당 페이지에 권한이 없습니다.
			moveMsgPage(request, response, g.getMessage("MSG.COMMON.0060"), "document.location.href='" + g.getRequestPageName(request) + "'");
			return false;
		}

        if (!"X".equals(approvalHeader.DISPFL)) {
                            //해당 페이지에 권한이 없습니다.
            moveMsgPage(request, response, g.getMessage("MSG.COMMON.0060"), "document.location.href='" + g.getRequestPageName(request) + "'");
            return false;
        }

        /* width 값 */
       // if ("X".equals(approvalHeader.ACCPFL) && WebUtil.isDev(request)) {
        //if ("true".equals(request.getSession().getAttribute("mail"))) {
        //	request.setAttribute("buttonWidth", "width:740px;");
         //   request.setAttribute("bodyWidth", "width:760px");
         //   request.setAttribute("subWrappwidth", "min-width:760px");
        //}

        request.setAttribute("approvalHeader", approvalHeader);
        request.setAttribute("approvalLine", approvalLine);
        if(request.getAttribute("RequestPageName") == null)
            request.setAttribute("RequestPageName", g.getRequestPageName(request));

        return true;
    }


}
