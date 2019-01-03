package hris.C.C02Curri;

/**
 * C02CurriEventData.java
 * 이벤트유형안내을 가져오는 Data
 *   [관련 RFC] : ZHRE_RFC_EVENT_INFORM2
 * 
 * @author 박영락
 * @version 1.0, 2002/01/15
 */
public class C02CurriEventData extends com.sns.jdf.EntityData {
    
    public String ZGROUP;     //교육분야
    public String GWAJUNG;    //과정명
    public String GWAID;      //과정ID
    public String PELSU;      //진급필수
    public String JIKMU;      //추천직무
    public String PERNO;      //담당자 사원번호
    public String ENAME;      //담당자 이름
    public String TELNO;      //담당자전화번호

}
