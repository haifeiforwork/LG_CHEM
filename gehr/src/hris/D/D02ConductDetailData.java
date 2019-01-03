package hris.D ;

/**
 * D02ConductDetailData.java
 *  근태 내용을 담는 데이터
 *   [관련 RFC] : ZHRP_RFC_TIME_DISPLAY
 * 
 * @author 한성덕
 * @version 1.0, 2002/02/01
 */
public class D02ConductDetailData extends com.sns.jdf.EntityData {
    public String DATUM ;      // 발생일자
    public String LGART ;      // 구분코드
    public String ANZHL ;      // 추가할 시간
    public String ABRTG ;      // 추가할 일수
}
