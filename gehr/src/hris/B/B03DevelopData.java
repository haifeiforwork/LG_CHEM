package hris.B ;

/**
 * B03DevelopData.java
 *  인재개발협의결과를 담는 데이터
 *   [관련 RFC] : ZHRE_RFC_DEVELOP_LIST
 * 
 * @author 배민규
 * @version 1.0, 2003/06/09
 * @author 최영호
 * @version 2.0, 2003/06/23
 */
public class B03DevelopData extends com.sns.jdf.EntityData {
    public String BEGDA      ;	// 시작일
    public String SEQNR      ;	// 순번
	public String COMM_NUMB  ;  // 위원장
    public String COMM_NAME  ;	// 위원장 이름
    public String SELF_FLAG  ;  // 본인 F/B 여부
    public String COMM_TYPE  ;	// 인재위 구분 
    public String UPBR_NUMB  ;  // 육성책임자
	public String PDEV_COMM  ;  // 인재위
    public String PDEV_TEXT  ;	// 인재위 이름
	public String SECT_COMM  ;  // 분과위
    public String SECT_TEXT  ;  // 분과위 이름
    public String EXL1_PONT  ;  // 우수한 점 1  
    public String EXL2_PONT  ;  // 우수한 점 2 
    public String SPL1_PONT  ;  // 보완할 점 1
    public String SPL2_PONT  ;  // 보완할 점 2
    public String UPBR_POST  ;  // 육성 POST
    public String UPB1_CRSE  ;  // 육성방향 1
    public String UPB2_CRSE  ;  // 육성방향 2
    public String CMT1_TEXT  ;  // 종합 COMMENT 1
    public String CMT2_TEXT  ;  // 종합 COMMENT 2
	public String CMT3_TEXT  ;  // 종합 COMMENT 3
	public String CMT4_TEXT  ;  // 종합 COMMENT 3
	public String CMT5_TEXT  ;  // 종합 COMMENT 3
	public String CMT6_TEXT  ;  // 종합 COMMENT 3
	public String ETC1_TEXT  ;  // 기타사항 1
	public String ETC2_TEXT  ;  // 기타사항 2
	public String FUP1_TEXT  ;  // 육성책협의결과 F/U 1
	public String FUP2_TEXT  ;  // 육성책협의결과 F/U 2
	public String COM1_NUMB  ;  // 위원 사번1
	public String COM2_NUMB  ;  // 위원 사번2
	public String COM3_NUMB  ;  // 위원 사번3
	public String COM4_NUMB  ;  // 간사 사번 
	public String ENAME      ;  // 육성대상자
	public String TITEL      ;  // 직책 
	public String COM1_NAME  ;  // 위원 이름 1
	public String COM2_NAME  ;  // 위원 이름 2
	public String COM3_NAME  ;  // 위원 이름 3
	public String COM4_NAME  ;  // 간사 이름 
	public String command    ;  // detail 조회 시 순서값
}
