package hris.common;

/**
 * SchoolData.java
 *   대학교 리스트
 *   [관련 RFC] : ZHRW_RFC_SCHOOL_SELECT_LIST
 *   [CSR ID:2634836] 학자금 신청 시스템 개발 요청            
 * @author SJY
 * @version 1.0, 2014/10/23
 */
public class SchoolData extends com.sns.jdf.EntityData
{
    public String SCHCODE;      	// 학교코드
    public String SCHTYPE;       	// 학교타입
    public String SCHNAME;       	// 학교이름
    public String SCHBR;       		// 본분교
    public String SCHEST;       	// 설립구분
    public String SCHREG;       	// 지역
    public String SCHBEGDA;      	// 시작일
    public String SCGENDDA;      // 종료일
}