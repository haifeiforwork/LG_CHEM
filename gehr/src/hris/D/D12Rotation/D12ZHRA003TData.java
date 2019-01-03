package hris.D.D12Rotation ;

/**
 * D12ZHRA003TData.java
 * 결재정보 데이터
 *   [관련 RFC] : ZHRW_RFC_DAY_OFF
 * @author 김종서
 * @version 1.0, 2009/02/17
 */
public class D12ZHRA003TData extends com.sns.jdf.EntityData {
	public String MANDT    ;	//클라이언트          
	public String BUKRS    ;	//회사 코드           
	public String PERNR    ;	//사원 번호           
	public String BEGDA    ;	//신청일              
	public String AINF_SEQN;	//결재정보 일련번호   
	public String UPMU_FLAG;	//업무구분 그룹 지시자
	public String UPMU_TYPE;	//업무구분            
	public String APPR_TYPE;	//결재형태            
	public String APPU_TYPE;	//결재자 구분         
	public String APPR_SEQN;	//결재순서            
	public String OTYPE    ;	//오브젝트 유형       
	public String OBJID    ;	//오브젝트 ID         
	public String APPU_NUMB;	//결재자 사번         
	public String APPR_DATE;	//승인일              
	public String APPR_STAT;	//승인상태
	public String BIGO_TEXT;	//비고 텍스트
}
