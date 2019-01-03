package hris.E.E21Entrance;

/**
 * E21EntranceDupCheckData.java
 * 입학축하금 중복신청 check
 * [관련 RFC] : ZHRW_RFC_ENTRANCE_DUP_CHECK
 *
 * @author  김도신
 * @version 1.0, 2003/03/18
 */
public class E21EntranceDupCheckData extends com.sns.jdf.EntityData {
    
    public String SUBF_TYPE;        // 입학축하금의 서브타입
    public String ACAD_CARE;        // 학력
    public String REGNO    ;        // 주민등록번호
    public String INFO_FLAG;        // Infotype Data이면 'I', Temp Table Data이면 'T'
    public String AINF_SEQN;        // Temp Table을 Check할때 결재번호가 같은지도 Check한다.(수정시 필요)
    
}