package	hris.E.E04Pension;

/**
 * E04PensionChngGradeData.java
 * 국민연금 변경항목 코드, 명을 담아오는 데이터
 *   [관련 RFC] : ZHRW_RFC_P_PENSION_CHNG
 * 
 * @author 최영호    
 * @version 1.0, 2002/01/25
 */
public class E04PensionChngGradeData extends com.sns.jdf.EntityData {

    public String CHNG_TYPE ;   // 국민연금 자격변경사항 항목 코드
    public String CHNG_TEXT ;   // 국민연금 자격변경사항 항목 text

}
