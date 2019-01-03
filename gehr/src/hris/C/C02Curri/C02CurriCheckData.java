package hris.C.C02Curri;

/**
 * C02CurriCheckData .java
 * 선이수과정 이수여부 및 선수자격요건을 가져오는 Data 
 *   [관련 RFC] : ZHRE_RFC_PREVIOUS_EVENT, ZHRE_RFC_PRE_EVENT_CHECK
 * 
 * @author 박영락
 * @version 1.0, 2002/01/16
 */
public class C02CurriCheckData extends com.sns.jdf.EntityData {
    
    public String OTYPE;        //관련 오브젝트 유형  
    public String OBJID;        //관련오브젝트 ID
    public String STEXT;        //어브젝트 이름
    public String BEGDA;        //시작일
    public String ENDDA;        //종료일 
    public String STATE_ID;     //계발계획상태
    public String STATETXT;     //계발계획상태텍스트
    public String CHARA;        //선수자격요건 Level값;

}

