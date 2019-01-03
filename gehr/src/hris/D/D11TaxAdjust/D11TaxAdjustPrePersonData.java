package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustFamilyData.java
 * 연말정산 - 부양가족공제 데이터
 * [관련 RFC] : ZHRP_RFC_YEAR_FAMILY
 *
 * @author lsa
 * @version 1.0, 2005/11/24
 */
public class D11TaxAdjustPrePersonData extends com.sns.jdf.EntityData {
    public String ENAME;  //사원 또는 지원자의 포맷된 이름
    public String REGNO;  //주민등록번호 (한국)           
    public String SUBTY;  //하위 유형                     
    public String OBJPS;  //오브젝트식별                  
    public String KDSVH;  //자녀와의 관계                 
    public String DPTID;  //부양가족 구성원에 대한 지시자 
    public String HNDID;  //장애인에 대한 지시자     
}
  