package hris.D.D12Rotation ;

/**
 * D12OrgehData.java
 * 계장 근태 입력 데이터 - T_ORGEH(ZHRS116S)
 *   [관련 RFC] : ZHRH_RFC_GET_ROTATION_LIST
 * @author 김도신
 * @version 1.0, 2004/03/14
 */
public class D12OrgehData extends com.sns.jdf.EntityData {

	public String PERNR	; //사원 번호
	public String ENAME	; //사원 또는 지원자의 포맷된 이름
	public String BEGDA	; //신청일
	public String AWART; //근무/휴무 유형
	public String BEGUZ	; //시간 데이타 엘리먼트(CHAR 6)
	public String ENDUZ;  //시간 데이타 엘리먼트(CHAR 6)
	public String VTKEN;  //전일 지시자
	public String STDAZ; //초과근무시간
	public String PBEG1	; //시간 데이타 엘리먼트(CHAR 6)
	public String PEND1;  //시간 데이타 엘리먼트(CHAR 6)
	public String PBEZ1;  //유급휴식기간
	public String PUNB1;  //무급휴식기간
	public String REASON;         //신청사유                  
	public String A002_SEQN;    //경조신청 일련번호         
	public String CONG_DATE;   //경조발생일                
	public String HOLI_CONT;    //경조휴가일수              
	public String CONG_CODE;   //경조내역      
}                                  