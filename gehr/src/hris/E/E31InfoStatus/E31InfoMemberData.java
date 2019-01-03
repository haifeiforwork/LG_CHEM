package hris.E.E31InfoStatus ;

/**
 * E31InfoMemberData.java
 * 현재 선택한 인포멀 가입자 전체/가입자/ 탈퇴자를 담는 데이터
 *   [관련 RFC] : ZHRH_RFC_G_INFORMAL_LIST
 *
 * @author 윤정현
 * @version 1.0, 2004/10/22
 */
public class E31InfoMemberData extends com.sns.jdf.EntityData {
    public String MGART    ;  // 인포멀코드
    public String STEXT    ;  // 인포멀명
    public String ORGEH    ;  // 소속부서
    public String ORGTX    ;  // 조직단위텍스트
    public String PERNR    ;  // 사원번호
    public String ENAME    ;  // 사원 또는 지원자의 포맷이름
    public String BETRG    ;  // 회비
    public String WAERS    ;  // 통화키
    public String BEGDA    ;  // 시작일
    public String ENDDA    ;  // 종료일
    public String APPL_DATE;  // 승인일자
    public String MEMBER   ;  // 회원여부(0:비회원, 1:회원)
}
