package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustDeductData.java
 * 연말정산 - 특별공제, 특별공제 교육비, 기타/세액공제 데이터
 * [관련 RFC] : ZHRP_RFC_YEAR_SPECIAL, ZHRP_RFC_YEAR_EDU, ZHRP_RFC_YEAR_TAX
 *
 * @author 김도신
 * @version 1.0, 2002/11/20
 */
public class D11TaxAdjustDeductData extends com.sns.jdf.EntityData {

    public String GUBN_CODE  ;   // 연말정산 구분
    public String GOJE_CODE  ;   // 공제코드
    public String GUBN_TEXT  ;   // 구분 텍스트
    //public String SUBTY      ;   // 하부유형
    public String STEXT      ;   // 하부유형이름
    //public String ENAME      ;   // 사원 또는 지원자의 포맷이름
    //public String REGNO      ;   // 주민등록번호
    //public String FASAR      ;   // 가족구성원의 학력
    public String FATXT      ;   // 학력명
    public String ADD_BETRG  ;   // HR 급여관리: 금액
    public String ACT_BETRG  ;   // HR 급여관리: 금액
    public String AUTO_BETRG ;   // HR 급여관리: 금액
    public String AUTO_TEXT  ;   // 자동분내역
    public String GOJE_FLAG  ;   // 플래그
    public String FTEXT      ;   // 필드텍스트
    public String FLAG       ;   //
    //public String CHNTS;	 //국세청증빙여부
    public String REQ_H;	 //세대주 여부 체크
    //public String OMIT_FLAG;	//삭제 플래그
    //public String EXSTY;	//@2011 교복구입비용


    public String MANDT    ; //@v1.1 클라이언트
    public String WORK_YEAR; //@v1.1 카운트 매개변수
    public String BEGDA    ; //@v1.1 시작일
    public String ENDDA    ; //@v1.1 종료일
    public String PERNR    ; //@v1.1 사원번호
    public String GUBUN    ; //@v1.1 회사지원분 1,  eHR신청 2
    public String SEQNR    ; //@v1.1 동일한 키를 가진 정보유형 레코드번호
    public String REGNO    ; //@v1.1 주민등록번호
    public String ENAME    ; //@v1.1 사원 또는 지원자의 포맷이름

    public String SUBTY   ;  // 가족 관계
    public String F_ENAME ;  // 성명
    public String F_REGNO ;  // 주민등록번호
    public String FASAR ; //학력
    public String BETRG; //금액
    public String CHNTS;	 //국세청증빙여부
    public String ACT_CHECK;	//장애인 교육비 지시자
    public String OMIT_FLAG;	//삭제 플래그
    public String EXSTY;	//@2011 교복구입비용    //[CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건    public String LOAN;	//@2017 학자금상환
}