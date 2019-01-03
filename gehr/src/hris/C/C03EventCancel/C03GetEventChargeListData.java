package hris.C.C03EventCancel;

/**
 * C03GetEventChargeListData.java
 * 교육취소신청 결재완료시 이벤트담당자에게 메일통보를 위한 통보자리스트 가져오는 RFC
 *   [관련 RFC] : ZHRP_GET_NO_OF_WORKDAY
 * 
 * @author 배민규
 * @version 1.0, 2004/07/13
 */
public class C03GetEventChargeListData extends com.sns.jdf.EntityData {
	public String CHPERNR	;  // 사원 번호                     
	public String CHENAME	;  // 사원 또는 지원자의 포맷된 이름
	public String CHORGTX	;  // 조직 단위 내역                
	public String CHTITEL	;  // 제목                          
	public String CHPHONE	;  // 통신 ID/번호                  
	public String CHEMAIL	;  // 통신: 긴 ID/번호              


}
