/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 의료비                                                      */
/*   Program Name : 의료비 수정                                                 */
/*   Program ID   : E17HospitalChangeSV                                         */
/*   Description  : 의료비를 수정할 수 있도록 하는 Class                        */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08  김성일                                          */
/*   Update       : 2005-02-23  윤정현                                          */
/*                  2005-12-27  @v1.1 C2005121301000001097 신용카드/현금구분추가*/
/*                  2014-08-26  이지은D [CSR ID:2598080] 의료비 지원한도 적용 수정 배우자, 자녀 합산 1000만원 */
/*                  2015-07-31  이지은D [CSR ID:2839626] 의료비 신청 시 사내커플 여부 체크 로직 추가 */
/*					 2018-04-20  cykim  [CSR ID:3658652] 의료비지원 신청 메뉴 개발 요청의 건 */
/********************************************************************************/

package servlet.hris.E.E17Hospital;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.CodeEntity;
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
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.CurrencyCodeRFC;
import hris.common.rfc.PersonInfoRFC;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;
import java.util.Vector;


public class E17HospitalChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="03";  // 결재 업무타입(의료비)
    private String UPMU_NAME = "의료비";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest;

            String jobid = box.get("jobid", "first");
            final String AINF_SEQN = box.get("AINF_SEQN");

            //**********수정 끝.****************************

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            /*  정보 조회 */
            final E17HospitalRFC hospitalRFC = new E17HospitalRFC();
            hospitalRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);
            E17HospitalResultData resultData = hospitalRFC.detail(); //결과 데이타

            final Vector<E17SickData> E17SickData_vt     = resultData.T_ZHRA006T;
            Vector<E17HospitalData> E17HospitalData_vt = resultData.T_ZHRW005A;
            Vector<E17BillData> E17BillData_vt     = resultData.T_ZHRW006A;

            final E17SickData e17SickData = Utils.indexOf(E17SickData_vt, 0);

            if(e17SickData == null) {
                moveMsgPage(req, res, "수정될 항목의 데이터를 읽어들이던 중 오류가 발생했습니다.", "history.back();");
            }

            final String PERNR = e17SickData.PERNR;
            final String CTRL_NUMB = e17SickData.CTRL_NUMB;

            /**
             * 기본 조회 값
             */
            if(jobid.equals("first") || jobid.equals("change_guen") || jobid.equals("AddOrDel")) {
                req.setAttribute("isUpdate", true); //등록 수정 여부

                //결재라인, 결재 헤더 정보 조회
                detailApporval(req, res, hospitalRFC);

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

                Vector<CodeEntity> currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
                for(CodeEntity codeEnt : currency_vt) {
                    if( e17SickData.WAERS.equals(codeEnt.code) ){
                        req.setAttribute("currencyValue"          , Double.parseDouble(codeEnt.value));
                        break;
                    }
                }
            }

            if( jobid.equals("first") ) {     //제일처음 신청 화면에 들어온경우.

//                String P_Flag         = ""; <-- 2005.05.30(KDS) : 지원 기준 변경사항 반영

                E18HospitalListRFC func_E18 = new E18HospitalListRFC();

                Vector E18HospitalData_vt = new Vector();
                String l_CTRL_NUMB        = "";
                double COMP_sum          = 0.0;
                double totEMPL_WONX = 0;

                // 영수증항목 벡터와 진료비계산서 벡터의 데이터를 메치 시킴
                Vector new_vt = new Vector();
                for( int i = 0 ; i < E17HospitalData_vt.size(); i++ ){
                    E17HospitalData e17HospitalData = (E17HospitalData)E17HospitalData_vt.get(i);
                    boolean isExist = false;
                    for( int k = 0 ; k < E17BillData_vt.size(); k++ ){
                        E17BillData e17BillData = (E17BillData)E17BillData_vt.get(k);
                        if(e17HospitalData.RCPT_NUMB.equals(e17BillData.RCPT_NUMB)){
                            new_vt.addElement(e17BillData);
                            isExist = true;
                            break;
                        }
                    }
                    if( ! isExist ){
                        E17BillData temp_data = new E17BillData();
                        DataUtil.fixNull(temp_data);
                        new_vt.addElement(temp_data);
                    }
                }
                E17BillData_vt = new_vt;

                // -------------본인, 배우자, 자녀일 경우 회사지원총액을 보여주기 위해서 총액을 계산한다.
                E18HospitalData_vt = func_E18.getHospitalList( e17SickData.PERNR ) ;

                for ( int i = 0 ; i < E18HospitalData_vt.size() ; i++ ) {
                    E18HospitalListData data_18 = ( E18HospitalListData ) E18HospitalData_vt.get( i ) ;
                    l_CTRL_NUMB = data_18.CTRL_NUMB.substring(0, 4);
                    //@v1.5 2008.07.01 한도체크시 data가 달라수정함
                    //if( data_18.GUEN_CODE.equals(e17SickData.GUEN_CODE) && l_CTRL_NUMB.equals(DataUtil.getCurrentYear()) ) {
                    //    COMP_sum = COMP_sum + Double.parseDouble( data_18.COMP_WONX );
                    //}
//                      [CSR ID:2598080] 의료비 지원한도 적용 수정
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
                    totEMPL_WONX += Double.parseDouble(data_18.EMPL_WONX);
                }
                //  -----------------------------------------------------------------------------------------

                req.setAttribute("last_RCPT_NUMB"    , "");
                req.setAttribute("e17SickData"       , e17SickData);
                req.setAttribute("E17HospitalData_vt", E17HospitalData_vt);
                req.setAttribute("E17BillData_vt"    , E17BillData_vt);
//                    req.setAttribute("P_Flag"            , P_Flag);
                req.setAttribute("COMP_sum"          , COMP_sum );
                req.setAttribute("totEMPL_WONX"      , totEMPL_WONX);


                // 대리 신청 추가
                PersonInfoRFC numfunc = new PersonInfoRFC();
                PersonData personInfo = numfunc.getPersonInfo(e17SickData.PERNR);

                req.setAttribute("personInfo" , personInfo );


                dest = WebUtil.JspURL+"E/E17Hospital/E17HospitalBuild.jsp";

                printJspPage(req, res, dest);
            } else if( jobid.equals("change") ) { // DB update 로직부분

                /* 실제 신청 부분 */
                dest = changeApproval(req, box, e17SickData, hospitalRFC, new ChangeFunction<E17SickData>(){

                    public String porcess(E17SickData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        e17SickData.CTRL_NUMB = CTRL_NUMB;

                        Vector E17HospitalData_vt = new Vector();
                        Vector E17BillData_vt     = new Vector();
                        Vector E17SickData_vt     = new Vector();
                        E17SickRFC sick_rfc       = new E17SickRFC();

                        String PROOF          = box.get("PROOF");
                        int    new_RCPT_NUMB  = 0;
                        String new_CTRL_NUMB  = null;
                        String old_CTRL_NUMB  = null;

                        new_RCPT_NUMB = Integer.parseInt(sick_rfc.getRCPT_NUMB(inputData.PERNR, inputData.GUEN_CODE, inputData.OBJPS_21, inputData.REGNO));

                        inputData.MANDT     = user.clientNo;
                        inputData.PROOF     = PROOF;
                        inputData.CTRL_NUMB     = e17SickData.CTRL_NUMB;
                        old_CTRL_NUMB = e17SickData.CTRL_NUMB;

                        // 의료비
                        //int rowcount_hospital = box.getInt("RowCount_hospital");
                        int rowcount_hospital = box.getInt("medi_count");
                        for( int i = 0; i < rowcount_hospital; i++) {
                            E17HospitalData e17HospitalData = new E17HospitalData();

                            e17HospitalData.MANDT     = user.clientNo;
                            //e17HospitalData.BEGDA     = box.get("BEGDA")        ;    // 시작일
                            e17HospitalData.PERNR    = e17SickData.PERNR              ;    // 사원번호
                            e17HospitalData.CTRL_NUMB = old_CTRL_NUMB           ;    // 관리번호
                            //if( e17SickData.is_new_num.equals("Y") ){
                            //    e17HospitalData.RCPT_NUMB = Integer.toString(i+1);   // 영수증번호
                            //}else if( e17SickData.is_new_num.equals("N") ){
                            e17HospitalData.RCPT_NUMB = new_RCPT_NUMB + (i + 1) + ""  ;// 영수증번호
                            //}else{
                            //    Logger.debug.println(this, "E17HospitalBuild.jsp 파일에서 Field 'is_new_num' 의 값이 'Y'또는 'N'여야 한다");
                            //}
                            e17HospitalData.AINF_SEQN = AINF_SEQN               ;    // 결재정보 일련번호
                            e17HospitalData.MEDI_NAME = box.get("MEDI_NAME"+i);    // 의료기관
                            e17HospitalData.TELX_NUMB = box.get("TELX_NUMB"+i);    // 전화번호
                            e17HospitalData.EXAM_DATE = box.get("EXAM_DATE"+i);    // 진료일
                            e17HospitalData.MEDI_CODE = box.get("MEDI_CODE"+i);    // 입원/외래
                            e17HospitalData.MEDI_TEXT = box.get("MEDI_TEXT"+i);    // 입원/외래
                            e17HospitalData.RCPT_CODE = box.get("RCPT_CODE"+i);    // 영수증 구분
                            e17HospitalData.RCPT_TEXT = box.get("RCPT_TEXT"+i);    // 영수증 구분
                            //e17HospitalData.RCPT_NUMB = box.get("RCPT_NUMB"+i);  // No. 영수증번호
                            e17HospitalData.EMPL_WONX = box.get("EMPL_WONX"+i);    // 본인 실납부액
                            e17HospitalData.WAERS     = box.get("WAERS");            // 통화키
//                  2004년 연말정산 이후 사업자등록번호 필드 추가 (3.7)
                            e17HospitalData.MEDI_NUMB = box.get("MEDI_NUMB"+i);    // 의료기관 사업자등록번호
                            e17HospitalData.MEDI_MTHD = box.get("MEDI_MTHD"+i);    // @v1.1 결재수단 (1:현금, 2:신용카드)
                            e17HospitalData.YTAX_WONX = box.get("YTAX_WONX"+i);    // @v1.2 연말정산반영액

                            //                  빈 의료비항목은 벡터에 넣지 않는다.
                            if(e17HospitalData.EMPL_WONX == null || e17HospitalData.EMPL_WONX.equals("")){ continue; }
                            //                  빈 의료비항목은 벡터에 넣지 않는다.

                            E17HospitalData_vt.addElement(e17HospitalData);
                        }
                        Logger.debug.println(this, "E17HospitalData : " + E17HospitalData_vt.toString());

                        // 진료비
                        //int rowcount_report = box.getInt("RowCount_report");
                        int rowcount_report = box.getInt("medi_count");
                        for( int i = 0; i < rowcount_report; i++) {
                            // 빈 의료비항목은 벡터에 넣지 않는다.
                            if(StringUtils.isBlank(box.get("EMPL_WONX"+i)))  continue;
                            // 빈 의료비항목은 벡터에 넣지 않는다.


                            E17BillData e17BillData = new E17BillData();

                            e17BillData.MANDT     = user.clientNo;
                            //e17BillData.BEGDA    = box.get("BEGDA")        ;    // 시작일
                            e17BillData.PERNR    = e17SickData.PERNR              ;    // 사원번호
                            e17BillData.CTRL_NUMB = old_CTRL_NUMB           ;    // 관리번호
                            //if( e17SickData.is_new_num.equals("Y") ){
                            //e17BillData.CTRL_NUMB = new_CTRL_NUMB       ;    // 관리번호
                            //    e17BillData.RCPT_NUMB = Integer.toString(i+1);   // 영수증번호
                            //}else if( e17SickData.is_new_num.equals("N") ){
                            //e17BillData.CTRL_NUMB = old_CTRL_NUMB       ;    // 관리번호
                            e17BillData.RCPT_NUMB = new_RCPT_NUMB + (i + 1) + ""  ;// 영수증번호
                            //}else{
                            //    Logger.debug.println(this, "E17HospitalBuild.jsp 파일에서 Field 'is_new_num' 의 값이 'Y'또는 'N'여야 한다");
                            //}
                            //e17BillData.RCPT_NUMB = new_RCPT_NUMB + i + "";    // 영수증번호
                            e17BillData.AINF_SEQN = AINF_SEQN               ;    // 결재정보 일련번호
                            e17BillData.TOTL_WONX = box.get("TOTL_WONX"+i);    // 총 진료비
                            e17BillData.ASSO_WONX = box.get("ASSO_WONX"+i);    // 조합 부담금
                            e17BillData.EMPL_WONX = box.get("x_EMPL_WONX"+i);  // 본인 부담금
                            // 빈 의료비항목은 벡터에 넣지 않는다.
                            // if(e17BillData.EMPL_WONX == null || e17BillData.EMPL_WONX.equals("")) continue;
                            e17BillData.MEAL_WONX = box.get("MEAL_WONX"+i);    // 식대
                            e17BillData.APNT_WONX = box.get("APNT_WONX"+i);    // 지정 진료비
                            e17BillData.ROOM_WONX = box.get("ROOM_WONX"+i);    // 상급 병실료 차액
                            e17BillData.CTXX_WONX = box.get("CTXX_WONX"+i);    // C T 검사비
                            e17BillData.MRIX_WONX = box.get("MRIX_WONX"+i);    // M R I 검사비
                            e17BillData.SWAV_WONX = box.get("SWAV_WONX"+i);    // 초음파 검사비
                            e17BillData.DISC_WONX = box.get("DISC_WONX"+i);    // 할인금액
                            e17BillData.ETC1_WONX = box.get("ETC1_WONX"+i);    // 기타1 의 금액
                            e17BillData.ETC1_TEXT = box.get("ETC1_TEXT"+i);    // 기타1 의 항목명
                            e17BillData.ETC2_WONX = box.get("ETC2_WONX"+i);    // 기타2 의 금액
                            e17BillData.ETC2_TEXT = box.get("ETC2_TEXT"+i);    // 기타2 의 항목명
                            e17BillData.ETC3_WONX = box.get("ETC3_WONX"+i);    // 기타3 의 금액
                            e17BillData.ETC3_TEXT = box.get("ETC3_TEXT"+i);    // 기타3 의 항목명
                            e17BillData.ETC4_WONX = box.get("ETC4_WONX"+i);    // 기타4 의 금액
                            e17BillData.ETC4_TEXT = box.get("ETC4_TEXT"+i);    // 기타4 의 항목명
                            e17BillData.ETC5_WONX = box.get("ETC5_WONX"+i);    // 기타5 의 금액
                            e17BillData.ETC5_TEXT = box.get("ETC5_TEXT"+i);    // 기타5 의 항목명
                            e17BillData.WAERS     = box.get("WAERS");            // 통화키


                            E17BillData_vt.addElement(e17BillData);
                        }
                        Logger.debug.println(this, "E17BillData : " + E17BillData_vt.toString());


                        E17HospitalResultData resultData = new E17HospitalResultData();
                        resultData.T_ZHRA006T = Utils.asVector(inputData);
                        resultData.T_ZHRW005A = E17HospitalData_vt;
                        resultData.T_ZHRW006A = E17BillData_vt;

 /* 결재 신청 RFC 호출 */
                        E17HospitalRFC changeRFC = new E17HospitalRFC();
                        changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        changeRFC.build(resultData, box, req);

                        if(!changeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }

                        return inputData.AINF_SEQN;
                        /* 개발자 작성 부분 끝 */
                    }
                });
                printJspPage(req, res, dest);

            } else if( jobid.equals("AddOrDel") ) {     // 의료비 항목 입력 행 추가

                E17HospitalData_vt = new Vector();
                E17BillData_vt     = new Vector();
                Vector AppLineData_vt = new Vector();

                // 의료비 상병자료  *신청시에 추가되어야 할 항목들
                box.copyToEntity(e17SickData);
                Logger.debug.println(this, e17SickData.toString());

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
                    e17HospitalData.MEDI_MTHD = box.get("MEDI_MTHD"+idx);    // @v1.1 결재수단 (1:현금, 2:신용카드)
                    e17HospitalData.YTAX_WONX = box.get("YTAX_WONX"+idx);    // @v1.2 연말정산반영액

                    E17HospitalData_vt.addElement(e17HospitalData);
                }
                Logger.debug.println(this, E17HospitalData_vt.toString());

                // 진료비
                //int rowcount_report = box.getInt("RowCount_report");
                int rowcount_report = box.getInt("RowCount_hospital");
                for( int i = 0; i < rowcount_report; i++) {
                    E17BillData e17BillData = new E17BillData();
                    String      idx         = Integer.toString(i);

                    if( box.get("use_flag"+idx).equals("N") ) continue;
                    e17BillData.CTRL_NUMB = box.get("CTRL_NUMB"    );    // 관리번호
                    e17BillData.RCPT_NUMB = box.get("x_RCPT_NUMB"+idx);  // 영수증번호
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

                    E17BillData_vt.addElement(e17BillData);
                }
                Logger.debug.println(this, E17BillData_vt.toString());

                Logger.debug.println(this, AppLineData_vt.toString());

                req.setAttribute("e17SickData"       , e17SickData);
                req.setAttribute("E17HospitalData_vt", E17HospitalData_vt);
                req.setAttribute("E17BillData_vt"    , E17BillData_vt);
                req.setAttribute("AppLineData_vt"    , AppLineData_vt);

//  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록/앞화면' 버튼 활성화 여부를 가려주는 부분
//                    String ThisJspName = box.get("ThisJspName");
//                    req.setAttribute("ThisJspName", ThisJspName);
//  XxxDetailSV.java 와 XxxDetail.jsp 에 '목록/앞화면' 버튼 활성화 여부를 가려주는 부분

                printJspPage(req, res, WebUtil.JspURL+"E/E17Hospital/E17HospitalBuild.jsp");
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }


        } catch(Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        } finally {
        }
    }
}
