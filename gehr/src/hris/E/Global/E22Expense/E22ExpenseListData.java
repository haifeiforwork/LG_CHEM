package hris.E.Global.E22Expense;

/**
 * E22ExpenseListData.java
 * 입학축하금/학자금/장학금 조회
 * [관련 RFC] : ZHRW_RFC_SCHOLARSHIP_DISPLAY
 * @author 최영호
 * @version 1.0, 2002/01/04
 */
public class E22ExpenseListData extends com.sns.jdf.EntityData {

	public String  PERNR;            //Personnel number
	public String  BEGDA;            //Start Date
	public String  AINF_SEQN;        //descision number
	public String  CHLD_TYPE;        //Child Type
	public String  CHLD_NAME;        //Child Name
	public String  SCHL_TYPE;        //School Type
	public String  SCHL_NAME;        //School Name
	public String  SCHL_GRAD;        //School Grade
	public String  PAST_CONT;        //Past Reim Count
	public String  REIM_CONT;        //Reimburse Count Limit
	public String  REIM_CNTH;        //Get Reim Count Total
	public String  REIM_AMT;         //Reimburse Limit Betrg
	public String  REIM_AMTH;        //Get Reim Amount Total
	public String  PDATE;            //Payment Date
	public String  REIM_WAERS;       //Currency Key
	public String  ATTC_NORL;        //Normal(N) & Attachment(A)
	public String  REIM_BET1;        //Entrance Fee
	public String  REIM_RAT1;        //Reimburse Rate
	public String  REIM_WAR1;        //Currency Key
	public String  REIM_CAL1;        //Calculation betrg
	public String  REIM_BET2;        //Tuition Fee
	public String  REIM_RAT2;        //Reimburse Rate
	public String  REIM_WAR2;        //Currency Key
	public String  REIM_CAL2;        //Reimburse Rate
	public String  REIM_BET3;        //Lesson Fee
	public String  REIM_RAT3;        //Reimburse Rate
	public String  REIM_WAR3;        //Currency Key
	public String  REIM_CAL3;        //Calculation betrg
	public String  REIM_BET4;        //Attending Fee
	public String  REIM_RAT4;        //Reimburse Rate
	public String  REIM_WAR4;        //Currency Key
	public String  REIM_CAL4;        //Calculation betrg
	public String  REIM_BET5;        //Contribution
	public String  REIM_RAT5;        //Reimburse Rate
	public String  REIM_WAR5;        //Currency Key
	public String  REIM_CAL5;        //Calculation betrg
	public String  REIM_TOTL;        //Total Reimberse
	public String  WAERS;            //Currency Key
	public String  RFDATE;           //Refund Date
	public String  RFREASON;         //Refund Reason
	public String  RFAMT ;           //Refund Amt.
	public String  RFAMT1;           //Refund Amt.(Currency Conversion)
	public String  RFNO;             //Rfd. Account No.
	public String  CERT_FLAG;        //Documentary Evidence
	public String  CERT_DATE;        //Submit Date
	public String  CERT_BETG;        //Damdangja Betrg
	public String  CERT_BETG_C;      //Damdangja Betrg(Currency Conversion)
	public String  REQU_DATE;        //Request Date
	public String  BELNR;            //Accounting Document Number
	public String  REIM_AMTH_REST;   //Reimburse rest balance
	public String  REIM_TOTL_CONV;   //Total Reimburse Conversion Amt
	public String  SUBTY;            //Subtype
	public String  STEXT;            //Name of Subtype
	public String  SCHL_TEXT;        //School Type Text
	public String  PERNR_D;          //Agency Pernr
	public String  ZPERNR;           //Personnel Number
	public String  ZUNAME;           //Orgeh Asistance
	public String  AEDTM;            //Changed on
	public String  UNAME;            //User Name









//    public String SUBF_TYPE ;       // 입학축하금/학자금/장학금 구분 코드
//    public String FAMSA     ;       // 가족유형
//    public String OBJC_CODE ;       // 하부유형
//    public String ATEXT     ;       // 가족유형TEXT
//    public String GESC1     ;       // 성별키
//    public String GESC2     ;       // 성별키
//    public String ACAD_CARE ;       // 학력
//    public String TEXT4     ;       // 학력TEXT
//    public String FASIN     ;       // 교육기관
//    public String REGNO     ;       // 주민등록번호
//    public String ACAD_YEAR ;       // 학년
//    public String PROP_AMNT ;       // 신청액
//    public String ENTR_FIAG ;       // 입학금
//    public String PAY1_TYPE ;       // 지급구분(신규분)
//    public String PAY2_TYPE ;       // 지급구분(추가분)
//    public String PERD_TYPE ;       // 분기
//    public String HALF_TYPE ;       // 반기
//    public String PROP_YEAR ;       // 신청년도
//    public String LNMHG     ;       // 성(한글)
//    public String FNMHG     ;       // 이름(한글)
//    public String PAID_AMNT ;       // 지급액
//    public String PAID_DATE ;       // 신청일자
//    public String ENDDA     ;       // 종료일
//    public String BIGO_TEXT1;       // 비고1
//    public String BIGO_TEXT2;       // 비고2
//    public String RFUN_DATE ;       // 반납일자
//    public String RFUN_RESN ;       // 반납사유
//    public String RFUN_AMNT ;       // 반납액
//    public String RFUN_FLAG ;       // 수혜횟수차감여부
//    public String WAERS1    ;       // 통화키(지원액)
//    public String YTAX_WONX ;       // 연말정산 반영액
//    public String P_COUNT   ;       // 수혜횟수
//    public String POST_DATE ;       // 최종결재일
}