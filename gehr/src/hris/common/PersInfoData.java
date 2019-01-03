package	hris.common;

/**
 * PersInfoData.java
 *  사번이나 이름으로 조회된 사원의 정보에 관한 데이터
 *   [관련 RFC] : ZHRA_RFC_GET_PERNR_INFORMATION , ZHRA_RFC_GET_ENAME_INFORMATION
 * 
 * @author 김성일  
 * @version 1.0, 2001/12/13
 */
public class PersInfoData extends com.sns.jdf.EntityData {
	
    public String PERNR     ; // 사원번호
    public String ENAME     ; // 사원 이름
    public String ORGEH     ; // 소속부서
    public String ORGTX     ; // 조직단위텍스트
    public String TITEL     ; // 직위
    public String TITL2     ; // 직책
    public String TELNUMBER ; // 담당자의 전화번호
    public String TRFGR     ; // 급여그룹
    public String VGLST     ; // 비교급여범위레벨
    public String PERSK     ; // 사원서브그룹
    public String PTEXT     ; // 사원서브그룹이름
    public String STELL     ; // 직무
    public String STLTX     ; // 직무명
    public String BTRTL     ; // 인사하위영역
    public String BTEXT     ; // 인사하위영역 텍스트
    public String STAT2     ; // 고용상태

 }
