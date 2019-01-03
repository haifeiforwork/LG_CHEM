package hris.common;

/**
 * SearchAddrData.java
 *  주소 검색 list 를 담아오는 데이터
 *   [관련 RFC] : ZHRH_RFC_GET_PROVINCE
 * 
 * @author 박영락    
 * @version 1.0, 2001/12/18
 */
public class SearchAddrDataHk extends com.sns.jdf.EntityData {

    public String COUNC ;    //Region (State, Province, County)
    public String BEZEI ;    //Description
 

}

