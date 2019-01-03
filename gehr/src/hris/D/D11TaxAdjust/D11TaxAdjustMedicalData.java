package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustMedicalData.java
 * 연말정산 - 특별공제 의료비 데이타
 * [관련 RFC] : ZSOLYR_RFC_MEDI_YEA
 *
 * @author 윤정현
 * @version 1.0, 2004/11/24
 * @version 1.1, 2005/11/23 lsa 수정
 */
public class D11TaxAdjustMedicalData extends com.sns.jdf.EntityData {

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
    public String BIZNO   ;  // 사업자등록번호
    public String BIZ_NAME;  // 상호
    public String CNT     ;  // 건수
    public String BETRG   ;  // 금액
    public String CC_BETRG;  // @v1.2신용카드분
    public String CR_BETRG;  // @v1.2현금영수증분
    public String CA_BETRG;  // @v1.2현금
    public String CC_CNT;  // @v1.2신용카드분
    public String CR_CNT;  // @v1.2현금영수증분
    public String CA_CNT;  // @v1.2현금
    public String OLDD    ;  // 경로우대 대상자여부
    public String OBST    ;  // 장애자여부
    public String CONTENT ;  // 의료비내용
    public String CHNTS;	//국세청증빙여부
    public String METYP;	//의료증빙코드
    public String METYP_NAME;	//의료증빙코드명
    public String OMIT_FLAG;	//삭제 플래그
    public String GLASS_CHK;	//안경콘택트렌즈공제 2011
    public String DIFPG_CHK; //난임시술비 공제 추가 @2015 연말정산

}
