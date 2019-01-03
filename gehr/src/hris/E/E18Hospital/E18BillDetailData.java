package hris.E.E18Hospital ;

/**
 * E18BillDetailData.java
 *  사원의 진료비 계산서 내역을 담는 데이터
 *   [관련 RFC] : ZHRW_RFC_MEDIC_BILL
 * 
 * @author 한성덕
 * @version 1.0, 2002/01/03
 */
public class E18BillDetailData extends com.sns.jdf.EntityData {
    public String TOTL_WONX ;      // 총 진료비
    public String ASSO_WONX ;      // 조합 부담금
    public String EMPL_WONX ;      // 본인 부담금
    public String MEAL_WONX ;      // 식대
    public String APNT_WONX ;      // 지정 진료비
    public String ROOM_WONX ;      // 상급 병실료 차액
    public String CTXX_WONX ;      // C T
    public String MRIX_WONX ;      // M R I
    public String SWAV_WONX ;      // 초음파
    public String DISC_WONX ;      // 할인금액 
    public String ETC1_WONX ;      // 기타1 의 금액
    public String ETC1_TEXT ;      // 기타1 의 항목명
    public String ETC2_WONX ;      // 기타2 의 금액
    public String ETC2_TEXT ;      // 기타2 의 항목명
    public String ETC3_WONX ;      // 기타3 의 금액
    public String ETC3_TEXT ;      // 기타3 의 항목명
    public String ETC4_WONX ;      // 기타4 의 금액
    public String ETC4_TEXT ;      // 기타4 의 항목명
    public String ETC5_WONX ;      // 기타5 의 금액
    public String ETC5_TEXT ;      // 기타5 의 항목명
    public String WAERS     ;      // 통화키
}
