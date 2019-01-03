package hris.D.D12Rotation ;

/**
 * D12ZHRA112TData.java
 * 부서근태결재요청 기간 정보 
 *   [관련 RFC] : ZHRW_RFC_DAY_OFF
 * @author 김종서
 * @version 1.0, 2009/02/17
 */
public class D12ZHRA112TData extends com.sns.jdf.EntityData {

	public String MANDT;       //클라이언트     
	public String ORGEH;       //조직 단위      
	public String FROMDA;      //승인요청 시작일
	public String TODA;        //승인요청 종료일
	public String AINF_SEQN;   //승인요청 결재번호
}
