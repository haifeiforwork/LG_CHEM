package hris.C.C07Language;

/**
 * C07LangDupCheckData.java
 * 어학지원 중복신청 check
 * [관련 RFC] : ZHRE_RFC_LANGUAGE_DUP_CHECK
 *
 * @author  김도신
 * @version 1.0, 2003/04/15
 */
public class C07LangDupCheckData extends com.sns.jdf.EntityData {
    
    public String SBEG_DATE;        // 학습시작일
    public String SEND_DATE;        // 학습종료일
    public String INFO_FLAG;        // Infotype Data이면 'I', Temp Table Data이면 'T'
    public String AINF_SEQN;        // Temp Table을 Check할때 결재번호가 같은지도 Check한다.(수정시 필요)
    
}