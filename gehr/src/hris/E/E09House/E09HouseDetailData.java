package	hris.E.E09House;

/**
 * E09HouseDetailData.java
 * 개인의 주거지원 세부내역 정보를 담아오는 데이터
 *   [관련 RFC] : ZGHR_RFC_HOUSE_FUND_DETAIL
 *
 * @author 박영락
 * @version 1.0, 2002/12/31
 */
public class E09HouseDetailData extends com.sns.jdf.EntityData {
    //입력필드
    public String I_BEGDA;	// 융자일자
    public String I_BETRG;	// 잔여금액
    public String I_ENDDA;  // 종료일
    public String I_PERNR;  // 사원번호
    public String I_SUBTY;  // 하부유형
    //출력필드
    public String E_BETRG         ;	// 금액
    public String E_DARBT         ;	// 분활상환
    public String E_DARBT_BEGDA   ; // 시작일
    public String E_DARBT_ENDDA   ; // 종료일
    public String E_DATBW         ; // 승인일

    public String E_REMAIN_BETRG  ; // 급여관리금액
    public String E_REMAIN_CONT   ; // 상환년수

    public String E_TILBT         ;	// 분할상환
    public String E_TILBT_BETRG   ;	// 금액

    public String E_TOTAL_CONT    ; // 상환년수
    public String E_TOTAL_DARBT   ; // 분할상환
    public String E_TOTAL_INTEREST; // 금액

    public String E_ZZRPAY_CONT   ; // 상환년수
    public String E_ZZRPAY_MNTH   ; // 총상환기간 시작일
    public String E_ZZSECU_FLAG   ;	// 보증인여부
    public String E_ENDDA         ; // 총상환기간 종료일

}
