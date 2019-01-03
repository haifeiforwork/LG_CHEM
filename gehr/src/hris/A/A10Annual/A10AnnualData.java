package	hris.A.A10Annual;

/**
 * A10AnnualData.java
 *  연봉계약 List 를 담아오는 데이터
 *   [관련 RFC] : ZHRP_RFC_GET_ANNUAL_SALARY
 * 
 * @author 박영락    
 * @version 1.0, 2002/01/10
 * // [CSR ID:3006173] 임원 연봉계약서 Online화를 위한 시스템 구축 요청 
 */
public class A10AnnualData extends com.sns.jdf.EntityData {

    public String ENAME;    //이름
	  public String BTEXT;    //
    public String ORGTX;    //조직단위텍스트
    public String TITEL;    //직위
    public String TRFGR;    //급여그룹(직급연차)
    public String TITL2;    //직책1
    public String VGLST;    //2번째 급여요소(호봉)
    public String EVLVL;    //평가등급
    public String ZYEAR;    //년도
    public String BETRG;    //급여임금유형금액 예상(기본연봉)
    public String BET01;    //급여임금유형금액  (수당계)
    public String ANSAL;    //급여임금유형금액  (연봉총액)
    public String ZINCR;    //연봉인상율
    public String BEGDA;    //연봉시작일
    public String ENDDA;    //연봉종료일
    public String TRFAR;    //[CSR ID:3006173] 임원 역할급(확정금액)
    public String TITL3;   // [CSR ID:3006173]임원의 경우 직책을 2개 가지고 있음. 두번째 직책(연봉계약서 상에 보여야 함)
}