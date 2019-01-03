package	hris.common;

/**
 * DeptPersInfoData.java
 * 부서원을 조회해서 정보를 담는 데이터 구조
 * [관련 RFC] : ZHRA_RFC_GET_DEPT_PERSONS
 *
 * @author 김성일
 * @version 1.0, 2001/12/13
 */
public class DeptPersInfoData extends com.sns.jdf.EntityData {

    public String PERNR     ;    //사원번호
    public String ENAME     ;    //사원 또는 지원자의 포맷이름
    public String ORGEH     ;    //조직단위코드
    public String ORGTX     ;    //조직단위텍스트
    public String TITEL     ;    //제목
    public String TITL2     ;    //직책 2
    public String TELNUMBER ;    //담당자의 전화번호
    public String TRFGR     ;    //급호
    public String VGLST     ;    //년차
    public String PERSK     ;    //신분코드
    public String PTEXT     ;    //신분명
    public String STELL     ;    //직무코드
    public String STLTX     ;    //직무명
    public String BTRTL     ;    //근무지코드
    public String BTEXT     ;    //근무지명
    public String STAT2     ;    //재직자, 퇴직자(STAT2=0) 구분


   //해외추가
    public String JIKWE     ;    //제목
    public String JIKWT     ;    //직책 2
    public String JIKKB;    //담당자의 전화번호
    public String JIKKT     ;    //급호
    public String STAT_EXP  ;    //EXP구분


}
