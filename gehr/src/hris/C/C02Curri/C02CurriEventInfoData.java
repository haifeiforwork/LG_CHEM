package hris.C.C02Curri;

/**
 * C02CurriEventInfoData.java
 * 이벤트유형을 가져오는 Data
 *   [관련 RFC] : ZHRE_RFC_EVENT_INFORM2
 * 
 * @author 박영락
 * @version 1.0, 2002/01/15
 */
public class C02CurriEventInfoData extends com.sns.jdf.EntityData {
    
    public String GWAID;    //과정ID
    public String SUBTY;    //하부유형
    public String SEQNO;    //테이블정보유형
    public String TLINE;    //정보유형

}
             
