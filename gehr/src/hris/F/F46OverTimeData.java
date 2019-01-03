package hris.F;  

/**
 * F46OverTimeData
 * 연장근로실적정보 내용을 담는 데이터
 * 
 * @author 손혜영
 * @version 1.0, 
 */ 
public class F46OverTimeData extends com.sns.jdf.EntityData {
    public String ORGEH;  //부서코드     
    public String STEXT;  //부서명 
	public String PERNR; 					//사번
	public String ENAME; 					//사원 또는 지원자의 포맷된 이름
	public String PTEXT; 					//신분
	public String TITEL; 					//직위
	public String TITL2; 					//직책
	public String HTKGUN; 					//휴일특근
	public String HYUNJANG; 				//휴일연장
	public String YUNJANG; 				//평일연장
	public String SUB_TOTAL; 			//평일연장 + 휴일연장
	public String WEEK_AVG; 				//주당평균연장근로
	public String TOTAL; 					//평일연장 + 휴일연장 + 휴일특근
	public String WEEK_AVG_INCL_H; 	//휴일근로포함 주당평균연장근로
	
	public String I_ORGEH; 				//조직코드
	public String I_TODAY; 				//시작일
	public String I_GUBUN; 				//조회구분
	public String I_LOWERYN; 			//하위조직여부
	public String I_OVERYN; 				//연장근로해당여부
	
	public String month;
	public String year;
	public String yymmdd;
	public String sortId;
	public String sortField;
	public String sortValue;
}
