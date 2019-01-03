package hris.D ;

/**
 * D02ConductDisplayData.java
 *  근태 내용을 담는 데이터
 *   [관련 RFC] : ZHRP_RFC_TIME_DISPLAY
 *
 * @author 한성덕
 * @version 1.0, 2002/02/01
 */
public class D02ConductDisplayData extends com.sns.jdf.EntityData {

    public String DATE  ;  // 발생일자
    public String COL1  ;  // 평일 연장 시간
    public String COL2  ;  // 휴일 연장 시간
    public String COL3  ;  // 야간 근무 시간
    public String COL4  ;  // 휴일 근무 시간
    public String COL5  ;  // 휴가 일수
    public String COL6  ;  // 보건 휴가 일수
    public String COL7  ;  // 결근 일수
    public String COL8  ;  // 지각 횟수
    public String COL9  ;  // 조퇴 횟수
    public String COL10 ;  // 향군수당
    public String COL11 ;  // 교육수당
    public String COL12 ;  // 당직
    public String C0140 ;  // 하계휴가 - 석유화학 휴가(일수)에 포함 (2002.12.14)
    public String C0240 ;  // 외출 GERP프로젝트

}