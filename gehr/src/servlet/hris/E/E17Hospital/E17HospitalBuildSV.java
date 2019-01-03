/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 의료비                                                      */
/*   Program Name : 의료비 신청                                                 */
/*   Program ID   : E17HospitalBuildSV                                          */
/*   Description  : 의료비를 신청할 수 있도록 하는 Class                        */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08  김성일                                          */
/*   Update       : 2005-02-16  윤정현                                          */
/*                  2005-12-26  @v1.1 C2005121301000001097 신용카드/현금구분추가*/
/*                  2014-08-26  이지은D [CSR ID:2598080] 의료비 지원한도 적용 수정 배우자, 자녀 합산 1000만원 */
/*                  2015-07-31  이지은D [CSR ID:2839626] 의료비 신청 시 사내커플 여부 체크 로직 추가 */
/*                  2015-08-25  이지은D 웹취약성 수정 : 결재자 임의 변경 금지
/*					 2018-04-20  cykim  [CSR ID:3658652] 의료비지원 신청 메뉴 개발 요청의 건 */
/********************************************************************************/

package servlet.hris.E.E17Hospital;

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
import hris.E.E17Hospital.rfc.*;
import hris.E.E18Hospital.E18HospitalListData;
import hris.E.E18Hospital.rfc.E18HospitalListRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.CurrencyCodeRFC;
import hris.common.rfc.PersonInfoRFC;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;
import java.util.Vector;

public class E17HospitalBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="03";  // 결재 업무타입(의료비)
    private String UPMU_NAME = "의료비";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException {

        try {
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest;

            String jobid = box.get("jobid", "first");

            final String PERNR = getPERNR(box, user); //신청대상자 사번


            PersonInfoRFC personInfoRFC = new PersonInfoRFC();
            PersonData personInfo = personInfoRFC.getPersonInfo(PERNR);

            //  의료비 신청을 계약직(자문/고문)인 사람들은 못하도록 한다. 2004.09.17 재수정 jsp 로직을 servlet으로 이동
            if("14".equals (user.e_persk)){
                moveMsgPage(req, res, g.getMessage("MSG.COMMON.0060"), "history.back();");
            }

            /*// 2005.04.13 수정 - 해외법인(EC00)일 경우는 본인신청, 대리신청 못하도록 함.
            if("EC00".equals(personInfo.E_WERKS) || "EB00".equals(personInfo.E_WERKS)) {
                moveCautionPage(req, res, g.getMessage("MSG.E.E05.0004"), "");  //해외법인의 경우 해당 인사부서를 통해 신청하시기 바랍니다.
            }*/

            final String ORG_CTRL = box.get("ORG_CTRL"    );  //2009.01.CSR ID:1361257
            final String LAST_CTRL = box.get("LAST_CTRL"    );  //동일진료선택시선택한관리번호의마지막번호2009.01.CSR ID:1361257//////////////////////////////////////////////////////////////////////////////////////////////////// 2005.05.31


            /**
             * 기본 조회 값
             */
            if(jobid.equals("first") || jobid.equals("change_guen") || jobid.equals("AddOrDel")) {

                //결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);


                req.setAttribute("ORG_CTRL"    , ORG_CTRL );  //2009.01.CSR ID:1361257
                req.setAttribute("LAST_CTRL"    , LAST_CTRL );  //2009.01.CSR ID:1361257
                req.setAttribute("last_RCPT_NUMB"    , box.get("last_RCPT_NUMB") );

                req.setAttribute("personInfo", personInfo);

                //[CSR ID:2839626] 의료비 신청 시 사내커플 여부 체크 로직 추가 시작
                E17CompanyCoupleRFC  cc_rfc           = new E17CompanyCoupleRFC();
                String      companyCoupleYN = cc_rfc.getData(PERNR);
                req.setAttribute("companyCoupleYN"    , companyCoupleYN);	//[CSR ID:2839626] 의료비 신청 시 사내커플 여부 체크 로직 추가

                req.setAttribute("currencyList", (new CurrencyCodeRFC()).getCurrencyCode());


                req.setAttribute("MediCode_vt", (new E17MediCodeRFC()).getMediCode());  //"code", "desc"
                req.setAttribute("RcptCode_vt", (new E17RcptCodeRFC()).getRcptCode());

                req.setAttribute("MedicTrea_vt", (new E17MedicTreaRFC()).getMedicTrea());

                Map<String, Vector> guenMap = (new E17GuenCodeRFC()).getGuenCode(PERNR);

                //  2003.03.14 배우자 공제한도 예외자 CHECK 로직 추가 - 예외자(E_FLAG = 'Y')는 공제한도를 CHECK하지 않는다.
                req.setAttribute("E_FLAG", (new E17MedicCheckYNRFC()).getE_FLAG(DataUtil.getCurrentYear(), PERNR));

                req.setAttribute("guenCodeList", guenMap.get("T_RESULT"));
                req.setAttribute("E17ChildData_vt", guenMap.get("T_CHILD"));
                //[CSR ID:3658652] 의료비지원 신청 메뉴 개발 요청의 건 @ T_DATE :: 결혼기념일, 입사일자 받아옴.
                req.setAttribute("E17FAMDate", guenMap.get("T_DATE"));
            }

            if (jobid.equals("first")) {   //제일처음 신청 화면에 들어온경우.



                // 의료비 상병자료
                E17SickRFC  sick_rfc           = new E17SickRFC();
                sick_rfc.getDetailData(PERNR, "0001", "", "");

                // -------------본인일 경우 회사지원총액을 보여주기 위해서 총액을 계산한다.
                E18HospitalListRFC func_E18           = new E18HospitalListRFC();
                Vector<E18HospitalListData> hospitalDataVt = func_E18.getHospitalList( PERNR ) ;

                double compSum           = 0.0;

                if(hospitalDataVt != null) {
                    String currYear = DataUtil.getCurrentYear();
                    for(E18HospitalListData row : hospitalDataVt) {
                        if("0001".equals(row.GUEN_CODE) && StringUtils.isBlank(row.OBJPS_21)
                                && StringUtils.isBlank(row.REGNO) && StringUtils.indexOf(row.CTRL_NUMB, currYear) == 0)
                            compSum = compSum + NumberUtils.toDouble(row.COMP_WONX);
                    }
                }


                req.setAttribute("last_RCPT_NUMB"    , sick_rfc.getRCPT_NUMB());
                req.setAttribute("hidden_e17SickData", Utils.indexOf(sick_rfc.getReturn_vt(), 0));
                req.setAttribute("COMP_sum"          ,  compSum );

                E17SickData e17SickData = new E17SickData();
                e17SickData.setPERNR(PERNR);
                e17SickData.setWAERS("KRW");
                req.setAttribute("e17SickData", e17SickData);

                dest = WebUtil.JspURL+"E/E17Hospital/E17HospitalBuild.jsp";

            } else if (jobid.equals("create")) {

                /* 실제 신청 부분 */
                dest = requestApproval(req, box, E17SickData.class, new RequestFunction<E17SickData>() {
                    public String porcess(E17SickData e17SickData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
                        /**** 신청된금액이 입금될 계좌정보가 있는지 체크 **********************************************/
                        hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                        if( ! accountInfoRFC.hasPersAccount(PERNR) ){
                            throw new GeneralException("msg006");
                        }
                        /**** 신청된금액이 입금될 계좌정보가 있는지 체크 **********************************************/
                        E17HospitalRFC   rfc         = new E17HospitalRFC();
                        E17SickRFC       sick_rfc    = new E17SickRFC();

                        Vector<E17HospitalData> E17HospitalData_vt = new Vector();
                        Vector<E17BillData> E17BillData_vt     = new Vector();
                        int    new_RCPT_NUMB      = 0;
                        String new_CTRL_NUMB      = null;
                        String old_CTRL_NUMB      = null;

                        // 의료비 상병자료
                        Vector<E17SickData> E17SickData_vt = sick_rfc.getSickData(PERNR, e17SickData.GUEN_CODE, e17SickData.OBJPS_21, e17SickData.REGNO);

                        new_RCPT_NUMB = NumberUtils.toInt(sick_rfc.getRCPT_NUMB(PERNR, e17SickData.GUEN_CODE, e17SickData.OBJPS_21, e17SickData.REGNO));

                        // 2002.06.28. 관리번호가 CTRL_NUMB.substring(5,6).equals("Z")일때 더이상 new는 발생시킬수가 없다.
                        if( !E17SickData_vt.get(0).CTRL_NUMB.equals("") && E17SickData_vt.get(0).CTRL_NUMB.substring(5,6).equals("Z") ) {
                            new_CTRL_NUMB = "max_CTRL_NUMB";
                        } else {
                            new_CTRL_NUMB  = getNewCTRL_NUMB( E17SickData_vt.get(0).CTRL_NUMB ,"new");
                        }
                        // 2002.06.28. 관리번호가 CTRL_NUMB.substring(5,6).equals("Z")일때 더이상 new는 발생시킬수가 없다.

                        Logger.debug.println(this, "##### e17SickData.CTRL_NUMB : " + e17SickData.CTRL_NUMB);
                        //old_CTRL_NUMB         = getNewCTRL_NUMB( e17SickData.CTRL_NUMB ,"old");

                        e17SickData.MANDT     = user.clientNo;
                        e17SickData.PERNR     = PERNR;
                        e17SickData.ZPERNR    = user.empNo;  // 신청자 사번 설정(대리신청 ,본인 신청)

                        if( e17SickData.is_new_num.equals("Y") ){
                            e17SickData.CTRL_NUMB = new_CTRL_NUMB ;      // 관리번호
                        }else if( e17SickData.is_new_num.equals("N") ){
                            old_CTRL_NUMB         = getNewCTRL_NUMB( e17SickData.LAST_CTRL ,"old");   //[CSR ID:1357074]
                            e17SickData.CTRL_NUMB = old_CTRL_NUMB ;      // 관리번호
                        }else{
                            Logger.debug.println(this, "E17HospitalBuild.jsp 파일에서 Field 'is_new_num' 의 값이 'Y'또는 'N'여야 한다");
                        }
                        //old_CTRL_NUMB = e17SickData.CTRL_NUMB;
                        Logger.debug.println(this, "##### e17SickData.ORG_CTRL : " + e17SickData);

                        e17SickData.ORG_CTRL     = ORG_CTRL; //2009.01.CSR ID:1361257
                        e17SickData.LAST_CTRL    = LAST_CTRL; //2009.01.CSR ID:1361257
                        e17SickData.BEGDA   =   box.get("BEGDA");

                        Logger.debug.println(this, "e17SickData : " + e17SickData.toString());

                        // 의료비
                        //int rowcount_hospital = box.getInt("RowCount_hospital");
                        int rowcount_hospital = box.getInt("medi_count");
                        for( int i = 0; i < rowcount_hospital; i++) {
                            E17HospitalData e17HospitalData = new E17HospitalData();
                            String          idx             = Integer.toString(i);

                            e17HospitalData.MANDT     = user.clientNo;
                            e17HospitalData.PERNR    = PERNR;                        // 사원번호
                            if( e17SickData.is_new_num.equals("Y") ){
                                e17HospitalData.CTRL_NUMB = new_CTRL_NUMB ;          // 관리번호
                                e17HospitalData.RCPT_NUMB = Integer.toString(i+1);   // 영수증번호
                            }else if( e17SickData.is_new_num.equals("N") ){
                                e17HospitalData.CTRL_NUMB = old_CTRL_NUMB ;          // 관리번호
                                e17HospitalData.RCPT_NUMB = new_RCPT_NUMB + (i + 1) + ""; // 영수증번호
                            }else{
                                Logger.debug.println(this, "E17HospitalBuild.jsp 파일에서 Field 'is_new_num' 의 값이 'Y'또는 'N'여야 한다");
                            }
                            e17HospitalData.MEDI_NAME = box.get("MEDI_NAME"+idx);   // 의료기관
                            e17HospitalData.TELX_NUMB = box.get("TELX_NUMB"+idx);   // 전화번호
                            e17HospitalData.EXAM_DATE = box.get("EXAM_DATE"+idx);   // 진료일
                            e17HospitalData.MEDI_CODE = box.get("MEDI_CODE"+idx);   // 입원/외래
                            e17HospitalData.MEDI_TEXT = box.get("MEDI_TEXT"+idx);   // 입원/외래
                            e17HospitalData.RCPT_CODE = box.get("RCPT_CODE"+idx);   // 영수증 구분
                            e17HospitalData.RCPT_TEXT = box.get("RCPT_TEXT"+idx);   // 영수증 구분
                            //e17HospitalData.RCPT_NUMB = box.get("RCPT_NUMB"+idx); // No. 영수증번호
                            e17HospitalData.EMPL_WONX = box.get("EMPL_WONX"+idx);   // 본인 실납부액
                            e17HospitalData.WAERS     = box.get("WAERS");           // 통화키
//                  2004년 연말정산 이후 사업자등록번호 필드 추가 (3.7)
                            e17HospitalData.MEDI_NUMB = box.get("MEDI_NUMB"+idx);    // 의료기관 사업자등록번호
                            e17HospitalData.MEDI_MTHD = box.get("MEDI_MTHD"+idx);  //@v1.1 05.12.26 add 결재수단 (1:현금, 2:신용카드)

                            //  빈 의료비항목은 벡터에 넣지 않는다.
                            if(e17HospitalData.EMPL_WONX == null || e17HospitalData.EMPL_WONX.equals("")){ continue; }
                            //  빈 의료비항목은 벡터에 넣지 않는다.

                            E17HospitalData_vt.addElement(e17HospitalData);
                        }
                        Logger.debug.println(this, "E17HospitalData : " + E17HospitalData_vt.toString());

                        // 진료비
                        //int rowcount_report = box.getInt("RowCount_report");
                        int rowcount_report = box.getInt("medi_count");
                        for( int i = 0; i < rowcount_report; i++) {
                            E17BillData e17BillData = new E17BillData();
                            String      idx         = Integer.toString(i);

                            e17BillData.MANDT     = user.clientNo;
                            //e17BillData.BEGDA     = box.get("BEGDA");           // 시작일
                            e17BillData.PERNR    = PERNR;                         // 사원번호
                            if( e17SickData.is_new_num.equals("Y") ){
                                e17BillData.CTRL_NUMB = new_CTRL_NUMB       ;     // 관리번호
                                e17BillData.RCPT_NUMB = Integer.toString(i+1);    // 영수증번호
                            }else if( e17SickData.is_new_num.equals("N") ){
                                e17BillData.CTRL_NUMB = old_CTRL_NUMB       ;     // 관리번호
                                e17BillData.RCPT_NUMB = new_RCPT_NUMB + (i + 1) + ""  ;// 영수증번호
                            }else{
                                Logger.debug.println(this, "E17HospitalBuild.jsp 파일에서 Field 'is_new_num' 의 값이 'Y'또는 'N'여야 한다");
                            }
                            e17BillData.TOTL_WONX = box.get("TOTL_WONX"+idx);    // 총 진료비
                            e17BillData.ASSO_WONX = box.get("ASSO_WONX"+idx);    // 조합 부담금
                            e17BillData.EMPL_WONX = box.get("x_EMPL_WONX"+idx);  // 본인 부담금
                            e17BillData.MEAL_WONX = box.get("MEAL_WONX"+idx);    // 식대
                            e17BillData.APNT_WONX = box.get("APNT_WONX"+idx);    // 지정 진료비
                            e17BillData.ROOM_WONX = box.get("ROOM_WONX"+idx);    // 상급 병실료 차액
                            e17BillData.CTXX_WONX = box.get("CTXX_WONX"+idx);    // C T 검사비
                            e17BillData.MRIX_WONX = box.get("MRIX_WONX"+idx);    // M R I 검사비
                            e17BillData.SWAV_WONX = box.get("SWAV_WONX"+idx);    // 초음파 검사비
                            e17BillData.DISC_WONX = box.get("DISC_WONX"+idx);    // 할인금액
                            e17BillData.ETC1_WONX = box.get("ETC1_WONX"+idx);    // 기타1 의 금액
                            e17BillData.ETC1_TEXT = box.get("ETC1_TEXT"+idx);    // 기타1 의 항목명
                            e17BillData.ETC2_WONX = box.get("ETC2_WONX"+idx);    // 기타2 의 금액
                            e17BillData.ETC2_TEXT = box.get("ETC2_TEXT"+idx);    // 기타2 의 항목명
                            e17BillData.ETC3_WONX = box.get("ETC3_WONX"+idx);    // 기타3 의 금액
                            e17BillData.ETC3_TEXT = box.get("ETC3_TEXT"+idx);    // 기타3 의 항목명
                            e17BillData.ETC4_WONX = box.get("ETC4_WONX"+idx);    // 기타4 의 금액
                            e17BillData.ETC4_TEXT = box.get("ETC4_TEXT"+idx);    // 기타4 의 항목명
                            e17BillData.ETC5_WONX = box.get("ETC5_WONX"+idx);    // 기타5 의 금액
                            e17BillData.ETC5_TEXT = box.get("ETC5_TEXT"+idx);    // 기타5 의 항목명
                            e17BillData.WAERS     = box.get("WAERS");            // 통화키

                            //  빈 의료비항목은 벡터에 넣지 않는다.
                            if( box.get("EMPL_WONX"+idx) == null || box.get("EMPL_WONX"+idx).equals("") ) { continue; }
                            //  빈 의료비항목은 벡터에 넣지 않는다.

                            E17BillData_vt.addElement(e17BillData);
                        }
                        Logger.debug.println(this, "E17BillData : " + E17BillData_vt.toString());


                        rfc.setRequestInput(user.empNo, UPMU_TYPE);

                        E17HospitalResultData inputData = new E17HospitalResultData();

                        inputData.T_ZHRA006T = Utils.asVector(e17SickData);
                        inputData.T_ZHRW005A = E17HospitalData_vt;
                        inputData.T_ZHRW006A = E17BillData_vt;

                        String AINF_SEQN = rfc.build(inputData, box, req);

                        if(!rfc.getReturn().isSuccess()) {
                            throw new GeneralException(rfc.getReturn().MSGTX);
                        };

                        return AINF_SEQN;

                        /* 개발자 작성 부분 끝 */
                    }
                });


            } else if( jobid.equals("change_guen") ) {   //본인, 배우자 구분이 변경될경우

                E17SickData e17SickData        = new E17SickData();
                E17SickData hidden_e17SickData = new E17SickData();
                E17SickRFC  sick_rfc           = new E17SickRFC();
                Vector      E17HospitalData_vt = new Vector();
                Vector      E17BillData_vt     = new Vector();
                Vector      E17SickData_vt     = null;
                String      last_RCPT_NUMB     = "";
                // 의료비 상병자료  *신청시에 추가되어야 할 항목들
                box.copyToEntity(e17SickData);
                Logger.debug.println(this, "SV => e17SickData : " + e17SickData.toString());

                // 의료비 상병자료
                last_RCPT_NUMB = sick_rfc.getRCPT_NUMB(PERNR, e17SickData.GUEN_CODE, e17SickData.OBJPS_21, e17SickData.REGNO);
                E17SickData_vt = sick_rfc.getSickData(PERNR, e17SickData.GUEN_CODE, e17SickData.OBJPS_21, e17SickData.REGNO);
                if ( E17SickData_vt != null && E17SickData_vt.size() > 0 ) {
                    hidden_e17SickData = (E17SickData)E17SickData_vt.get(0);
                }
                Logger.debug.println(this, "SV => hidden_e17SickData : " + hidden_e17SickData.toString());

                // 동일진료 상태에서 구분 변경시 동일진료 내역을 재 설정해준다.
                if( e17SickData.is_new_num.equals("N") ) {
                    //CSR ID:1357074 로 구분변경시는 무조건 다시 동일진료선택해야함
//                	CSR ID:1357074if( hidden_e17SickData.CTRL_NUMB.equals("") ) {
                    //  동일진료 신청을 할수 없는 경우 최초진료로 변경해준다.
                    e17SickData.is_new_num = "Y";
                    e17SickData.CTRL_NUMB  = "" ;
                    e17SickData.SICK_NAME  = "" ;
                    e17SickData.SICK_DESC  = "" ;
//                      CSR ID:1357074} else {
//                      CSR ID:1357074    e17SickData.CTRL_NUMB = hidden_e17SickData.CTRL_NUMB;
//                      CSR ID:1357074    e17SickData.SICK_NAME = hidden_e17SickData.SICK_NAME;
//                      CSR ID:1357074    e17SickData.SICK_DESC = hidden_e17SickData.SICK_DESC1 +"\n"+
//                      CSR ID:1357074     hidden_e17SickData.SICK_DESC2 +"\n"+
//                      CSR ID:1357074     hidden_e17SickData.SICK_DESC3 +"\n"+
//                      CSR ID:1357074     hidden_e17SickData.SICK_DESC4 ;
//                      CSR ID:1357074 }
                }

                // -------------본인, 배우자, 자녀일 경우 회사지원총액을 보여주기 위해서 총액을 계산한다.
                E18HospitalListRFC func_E18           = new E18HospitalListRFC();
                Vector E18HospitalData_vt = new Vector();
                String l_CTRL_NUMB        = "";
                double COMP_sum           = 0.0;

                E18HospitalData_vt = func_E18.getHospitalList( PERNR ) ;

                //[CSR ID:2598080] 의료비 지원한도 적용 수정
                for ( int i = 0 ; i < E18HospitalData_vt.size() ; i++ ) {
                    E18HospitalListData data_18 = ( E18HospitalListData ) E18HospitalData_vt.get( i ) ;

                    l_CTRL_NUMB = data_18.CTRL_NUMB.substring(0, 4);
                    //[CSR ID:2598080] 의료비 지원한도 적용 수정
                    if(e17SickData.GUEN_CODE.equals("0001")){//본인신청
                        if( data_18.GUEN_CODE.equals(e17SickData.GUEN_CODE)    && l_CTRL_NUMB.equals(DataUtil.getCurrentYear()) ) {
                            COMP_sum = COMP_sum + Double.parseDouble( data_18.COMP_WONX );
                        }
                        Logger.debug.println(this, "data_18.OBJPS_21 : " + data_18.OBJPS_21+"e17SickData.OBJPS_21:"+e17SickData.OBJPS_21+"COMP_sum:"+COMP_sum);
                    }else{//배우자 or 자녀
                        if( (data_18.GUEN_CODE.equals("0002") || data_18.GUEN_CODE.equals("0003"))    && l_CTRL_NUMB.equals(DataUtil.getCurrentYear()) ) {
                            COMP_sum = COMP_sum + Double.parseDouble( data_18.COMP_WONX );
                        }
                    }
                }// for end -----------------------------------------------------------------------------------------

                E17HospitalData_vt = getHospitalList(box);

                // 진료비
                E17BillData_vt = getBillingData(box);
                Logger.debug.println(this, "E17BillData : " + E17BillData_vt.toString());


                e17SickData.PERNR = PERNR;

                req.setAttribute("last_RCPT_NUMB"    , last_RCPT_NUMB );
                req.setAttribute("e17SickData"       , e17SickData);
                req.setAttribute("hidden_e17SickData", hidden_e17SickData);
                req.setAttribute("E17HospitalData_vt", E17HospitalData_vt);
                req.setAttribute("E17BillData_vt"    , E17BillData_vt);
                req.setAttribute("COMP_sum"          , COMP_sum);
//                req.setAttribute("P_Flag"            , box.get("P_Flag") );

                dest = WebUtil.JspURL+"E/E17Hospital/E17HospitalBuild.jsp";

            } else if( jobid.equals("AddOrDel") ) {       // 의료비 항목 입력 행 추가

                E17SickData e17SickData        = new E17SickData();
                E17SickData hidden_e17SickData = new E17SickData();
                Vector      E17HospitalData_vt = new Vector();
                Vector      E17BillData_vt     = new Vector();

                // 의료비 상병자료  *신청시에 추가되어야 할 항목들
                box.copyToEntity(e17SickData);
                Logger.debug.println(this, "e17SickData : " + e17SickData.toString());

                hidden_e17SickData.CTRL_NUMB  = box.get("hidden_CTRL_NUMB");
                hidden_e17SickData.SICK_NAME  = box.get("hidden_SICK_NAME");
                hidden_e17SickData.SICK_DESC1 = box.get("hidden_SICK_DESC1");
                hidden_e17SickData.SICK_DESC2 = box.get("hidden_SICK_DESC2");
                hidden_e17SickData.SICK_DESC3 = box.get("hidden_SICK_DESC3");
                hidden_e17SickData.SICK_DESC4 = box.get("hidden_SICK_DESC4");

                E17HospitalData_vt = getHospitalList(box);

                Logger.debug.println(this, "E17HospitalData : " + E17HospitalData_vt.toString());

                // 진료비
                E17BillData_vt = getBillingData(box);
                Logger.debug.println(this, "E17BillData : " + E17BillData_vt.toString());


                e17SickData.PERNR = PERNR;

                req.setAttribute("e17SickData"       , e17SickData);
                req.setAttribute("hidden_e17SickData", hidden_e17SickData);
                req.setAttribute("E17HospitalData_vt", E17HospitalData_vt);
                req.setAttribute("E17BillData_vt"    , E17BillData_vt);
                req.setAttribute("COMP_sum"          , box.get("COMP_sum") );

                dest = WebUtil.JspURL+"E/E17Hospital/E17HospitalBuild.jsp";

            } else {
                throw new GeneralException(g.getMessage("MSG.COMMON.0016"));
            }



            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }

    }


    private Vector<E17HospitalData> getHospitalList(Box box) {
        Vector<E17HospitalData> resultList = new Vector<E17HospitalData>();
        // 의료비
        int rowcount_hospital = box.getInt("RowCount_hospital");

        for( int i = 0; i < rowcount_hospital; i++) {
            E17HospitalData e17HospitalData = new E17HospitalData();
            String          idx             = Integer.toString(i);

            if( box.get("use_flag"+idx).equals("N") ) continue;
            e17HospitalData.CTRL_NUMB = box.get("CTRL_NUMB"    );  // 관리번호
            e17HospitalData.MEDI_NAME = box.get("MEDI_NAME"+idx);  // 의료기관
            e17HospitalData.TELX_NUMB = box.get("TELX_NUMB"+idx);  // 전화번호
            e17HospitalData.EXAM_DATE = box.get("EXAM_DATE"+idx);  // 진료일
            e17HospitalData.MEDI_CODE = box.get("MEDI_CODE"+idx);  // 입원/외래
            e17HospitalData.MEDI_TEXT = box.get("MEDI_TEXT"+idx);  // 입원/외래
            e17HospitalData.RCPT_CODE = box.get("RCPT_CODE"+idx);  // 영수증 구분
            e17HospitalData.RCPT_TEXT = box.get("RCPT_TEXT"+idx);  // 영수증 구분
            e17HospitalData.RCPT_NUMB = box.get("RCPT_NUMB"+idx);  // No. 영수증번호
            e17HospitalData.EMPL_WONX = box.get("EMPL_WONX"+idx);  // 본인 실납부액
            e17HospitalData.WAERS     = box.get("WAERS");          // 통화키
//                  2004년 연말정산 이후 사업자등록번호 필드 추가 (3.7)
            e17HospitalData.MEDI_NUMB = box.get("MEDI_NUMB"+idx);    // 의료기관 사업자등록번호
            e17HospitalData.MEDI_MTHD = box.get("MEDI_MTHD"+idx);  //@v1.1 05.12.26 add 결재수단 (1:현금, 2:신용카드)

            resultList.addElement(e17HospitalData);
        }

        return resultList;
    }

    private Vector<E17BillData> getBillingData(Box box) {
        Vector<E17BillData> resultList = new Vector<E17BillData>();
        // 의료비
        int rowcount_report = box.getInt("RowCount_hospital");

        for( int i = 0; i < rowcount_report; i++) {
            E17BillData e17BillData = new E17BillData();
            String      idx         = Integer.toString(i);

            if( box.get("use_flag"+idx).equals("N") ) continue;
            e17BillData.CTRL_NUMB = box.get("CTRL_NUMB"    );   // 관리번호
            e17BillData.RCPT_NUMB = box.get("x_RCPT_NUMB"+idx); // 영수증번호
            e17BillData.TOTL_WONX = box.get("TOTL_WONX"+idx);   // 총 진료비
            e17BillData.ASSO_WONX = box.get("ASSO_WONX"+idx);   // 조합 부담금
            e17BillData.EMPL_WONX = box.get("x_EMPL_WONX"+idx); // 본인 부담금
            e17BillData.MEAL_WONX = box.get("MEAL_WONX"+idx);   // 식대
            e17BillData.APNT_WONX = box.get("APNT_WONX"+idx);   // 지정 진료비
            e17BillData.ROOM_WONX = box.get("ROOM_WONX"+idx);   // 상급 병실료 차액
            e17BillData.CTXX_WONX = box.get("CTXX_WONX"+idx);   // C T 검사비
            e17BillData.MRIX_WONX = box.get("MRIX_WONX"+idx);   // M R I 검사비
            e17BillData.SWAV_WONX = box.get("SWAV_WONX"+idx);   // 초음파 검사비

            e17BillData.DISC_WONX = box.get("DISC_WONX"+idx);   // 할인금액

            e17BillData.ETC1_WONX = box.get("ETC1_WONX"+idx);   // 기타1 의 금액
            e17BillData.ETC1_TEXT = box.get("ETC1_TEXT"+idx);   // 기타1 의 항목명
            e17BillData.ETC2_WONX = box.get("ETC2_WONX"+idx);   // 기타2 의 금액
            e17BillData.ETC2_TEXT = box.get("ETC2_TEXT"+idx);   // 기타2 의 항목명
            e17BillData.ETC3_WONX = box.get("ETC3_WONX"+idx);   // 기타3 의 금액
            e17BillData.ETC3_TEXT = box.get("ETC3_TEXT"+idx);   // 기타3 의 항목명
            e17BillData.ETC4_WONX = box.get("ETC4_WONX"+idx);   // 기타4 의 금액
            e17BillData.ETC4_TEXT = box.get("ETC4_TEXT"+idx);   // 기타4 의 항목명
            e17BillData.ETC5_WONX = box.get("ETC5_WONX"+idx);   // 기타5 의 금액
            e17BillData.ETC5_TEXT = box.get("ETC5_TEXT"+idx);   // 기타5 의 항목명
            e17BillData.WAERS     = box.get("WAERS");           // 통화키

            resultList.addElement(e17BillData);
        }

        return resultList;
    }

    private String getNewCTRL_NUMB(String CTRL_NUMB, String stat) throws GeneralException{   // 새로운 관리번호가져오기   "new" 또는 "old"

        try{
            Logger.debug.println(this,"구 관리번호 : "+CTRL_NUMB);

            int cur_year = NumberUtils.toInt(DataUtil.getCurrentDate().substring(0,4));
            if(CTRL_NUMB.equals("")){
                Logger.debug.println(this,"NEW 관리번호 : "+ cur_year+"-A-01");
                return (cur_year+"-A-01");
            }

            if( CTRL_NUMB.length() != 9 || !CTRL_NUMB.substring(4,5).equals("-") || !CTRL_NUMB.substring(6,7).equals("-") ){     //ex) 2001-A-01
                throw new BusinessException("관리번호 형식이 올바르지 않습니다. ex)2001-A-01");
            }

            String year = CTRL_NUMB.substring(0,4);
            String alpabet = CTRL_NUMB.substring(5,6);
            String numb = CTRL_NUMB.substring(7,9);
            int int_year = NumberUtils.toInt(year);
            int int_numb = NumberUtils.toInt(numb);
            if( cur_year != int_year ){
                if( stat.equals("new") ){
                    Logger.debug.println(this,"해당년도의 진료가 없고 과거 진료가 있을시 최초진료신청 -> NEW 관리번호 : "+(cur_year+"-A-01"));
                    return (cur_year+"-A-01");
                }else{
                    // 2002.12.03. 동일진료신청시 과거년도의 진료내역만 존재할경우
                    //             ex) 2002년에 동일진료를 신청하는데 과거진료내역이 2000-P-05라면 현재 진료내역은 2002-A-06임.
                    if( (int_numb+1) < 10 ){
                        numb = "0"+(int_numb+1);
                    }else{
                        numb = ""+(int_numb+1);
                    }

                    Logger.debug.println(this,"해당년도의 진료가 없고 과거 진료가 있을시 동일진료신청 -> NEW 관리번호 : "+(cur_year+"-A-"+numb));
                    //return (cur_year+"-A-"+numb);
                    return (cur_year+"-"+alpabet+"-"+numb);
                    // 2002.12.03. 동일진료신청시 과거년도의 진료내역만 존재할경우
                }
            }else{
                if( stat.equals("new") ){
                    String[] alpa = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
                    String new_alpa = "a";
                    for( int i = 0 ; i < alpa.length ; i++ ){
                        if( alpabet.equals(alpa[i]) ){
                            new_alpa = alpa[i+1];
                            break;
                        }
                    }
                    alpabet = new_alpa;
                    numb = "01";
                }else{
                    if( (int_numb+1) < 10 ){
                       numb = "0"+(int_numb+1);
                    }else{
                        numb = ""+(int_numb+1);
                    }
                }
                Logger.debug.println(this,"NEW 관리번호 : "+ (year+"-"+alpabet+"-"+numb));
                return (year+"-"+alpabet+"-"+numb);
            }
        }catch(Exception e){
            throw new GeneralException(e,"관리번호 형식이 올바르지 않습니다. ex)2001-A-01");
        }
    }
}
