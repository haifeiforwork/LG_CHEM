package hris.D ;

/**
 * D00TaxAdjustPeriodData.java
 * 연말정산 기간 Data 
 *   [관련 RFC] : ZHRW_RFC_P_ACCURATE_ACCOUNT
 * 
 * @author 김성일 
 * @version 1.0, 2002/02/04
 */
public class D00TaxAdjustPeriodData extends com.sns.jdf.EntityData { 
    public String MANDT       ;  // 클라이언트
    public String BUKRS        ;  // 회사코드
    public String YEA_YEAR   ;  // 연말정산년도
    public String APPL_FROM ;  // 연말정산 신청/수정 시작일
    public String APPL_TOXX ;  // 연말정산 신청/수정 종료일
    public String SIMU_FROM ;  // 연말정산 시물레이션 시작일
    public String SIMU_TOXX ;  // 연말정산 시물레이션 종료일
    public String DISP_FROM ;  // 연말정산 내역조회 시작일
    public String DISP_TOXX ;  // 연말정산 내역조회 종료일
    public String YEAR_OPEN ;  // 근로소득 원천징수신청 시작가능년월일 2012연말정산시추가
}
