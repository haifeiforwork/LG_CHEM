package hris.common;

/**
 * PdfParseData.java
 *  연말정산 국세청 PDF 정보
 *   [관련 RFC] : ZSOLYR_RFC_PDF_UPLOAD
 *
 * @author 손혜영
 * @version 1.0, 2013/07/01
 */
public class PdfParseData extends com.sns.jdf.EntityData {
    //공통부
	public String FORM_CD     ;    //서식코드
    public String F_REGNO;    //주민등록번호
    public String F_ENAME ;    //성명
    public String DAT_CD      ;    //자료코드
    public String FILE_SEQ     ;    //파일 순번

	//보험료
    public String INSU_REGNO     ;    //주민등록번호_주피보험자
    public String INSU_NAME     ;    //성명_주피보험자
    public String BETRG     ;    //금액

    //의료비
    public String BIZNO     ;    //사업자번호
    public String BIZ_NAME  ;    //상호
    public String CA_BETRG     ;    //금액

    //교육비
    public String EDU_TYPE     ;    //교육비종류
    //public String BETRG     ;    //금액

    //특별공제
    //public String START_DT   ;    //최초차입일
    public String BEGDA; //최초차입일
    public String REPAY_YEARS   ;    //상환기간연수
    public String DEBT     ;    //차입금
    public String FIXED_RATE_DEBT     ;    //고정금리차입금
    public String NOT_DEFER_DEBT     ;    //비거치식상환차입금
    public String THIS_YEAR_REDE_AMT     ;    //당해년도 원금상환액
    public String SUM     ;    //연간합계액

    //기부금
    public String DONA_CODE     ;    //기부유형
    //public String BIZNO     ;    //사업자번호
    //public String BIZ_NAME     ;    //상호
    //public String BETRG     ;    //연간합계액

    //연금저축공제
    public String SAVING_GUBN ;    //저축구분
    public String FINCO     ;    //금융회사 등 코드
    public String PENSION_CD     ;    // 연금구분코드
    public String ACCNO;  // 통장/증권번호
    //public String BETRG;   // 연간합계액

    //신용카드
    public String USE_PLACE_CD;   // 종류
    //public String BETRG     ;    // 연간합계액    //@2014 연말정산 신용카드 부분 변경사항    public String PRE_TOT_AMT;//직전년_일반공제 대상금액합계    public String PRE_MARKET_TOT_AMT;//직전년_전통시장공제대상금액합계    public String PRE_TMONEY_TOT_AMT;//직전년_대중교통공제대상금액합계    public String FIRST_TOT_AMT;//상반기_대상금액합계    public String SECOND_TOT_AMT;//하반기 대상금액합계

    //OUTPUT
    //public String F_REGNO;
    //public String F_ENAME;
    //public String DAT_CD;
    public String ITEM;
    public String MESSAGE;

    //PDF파일저장용
    public String MANDT;	//클라이언트
    public String WORK_YEAR;	//카운트 매개변수
    public String PERNR;	//사원 번호
    public String SEQNR;	//동일한 키를 가진 인포타입 레코드 번호
    public String FILE_NAME;	//PDF File 명    public String XML_TEXT; //@2015  연말정산 신규
}
