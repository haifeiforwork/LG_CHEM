package hris.D.D25WorkTime;

/**
 * D25WorkTimeAgreeData.java
 * 2018-06-05  이지은   CSR ID:3704184] 유연근로제 동의 관련 기능 추가 건 - Global HR Portal 
 * @author 이지은
 * @version 1.0, 2018/06/05
 */
public class D25WorkTimeAgreeData extends com.sns.jdf.EntityData {

	public String MANDT; // 클라이언트
	public String BUKRS; // 회사 코드
	public String NUMB_YEAR;//년도
	public String PERNR;//사번
	public String AGRE_TYPE;//유형 (01:2018 근로유형합의)
	public String AGRE_FLAG;//합의여부(Y/N)
	public String APPR_DATE;//합의 일
	public String APPR_TIME;//합의 시간

	

}
