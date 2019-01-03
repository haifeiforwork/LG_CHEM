package hris.C.C02Curri;

/**
 * C02CurriData .java
 * 선이수과정/선수자격요건/자격요건획득을 가져오는 Data 
 *   [관련 RFC] : ZHRE_RFC_PREVIOUS_EVENT, ZHRE_RFC_PRE_EVENT_CHECK
 * 
 * @author 박영락
 * @version 1.0, 2002/01/15
 */
public class C02CurriData extends com.sns.jdf.EntityData {
    
    public String GWAID;        //과정ID
    public String PREID;        //선이수 ID  
    public String PRE_TEXT;     //선이수과정
    public String PRE_LEVEL;    //LEVEL 텍스트
    public String CHARA;        //LEVEL ID;

}

