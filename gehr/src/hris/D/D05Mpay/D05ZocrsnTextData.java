package	hris.D.D05Mpay;

/**
 * D05ZocrsnTextData.java
 * 급여사유등급 코드, 명을 담아오는 데이터
 *   [관련 RFC] : ZGHR_RFC_GET_ZOCRSN_TEXT
 * 
 * @author 최영호    
 * @version 1.0, 2002/01/29
 */
public class D05ZocrsnTextData extends com.sns.jdf.EntityData {

    public String ZOCRSN;   // 급여사유코드
    public String ZOCRTX;   // 급여사유코드text
    public String SEQNR;    // 순번  5월 21일 추가.

}
