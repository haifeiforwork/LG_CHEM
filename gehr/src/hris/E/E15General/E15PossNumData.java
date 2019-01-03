package	hris.E.E15General;

/**
 * E15PossNumData.java
 * 검진병원별 년월별 예약가능인원 및 예약인원수에 대한 데이터
 *   [관련 RFC] : ZHRH_RFC_REQU_POSS_NUM
 * 
 * @author  Lsa
 * @version 1.0, 2008/01/30
 */
public class E15PossNumData extends com.sns.jdf.EntityData {
		 
    public String DATUM ;       // 년월 
    public String EXAM_NUM;     // 검진신청가능자수 
    public String EXAM_NUM1;    // 대장검진신청가능자수
    public String EXAM_POSS;    // 검진가능여부('X'- 불가)
    
}
