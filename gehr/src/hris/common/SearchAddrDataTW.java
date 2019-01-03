package hris.common;

/**
 * SearchAddrData.java
 *  주소 검색 list 를 담아오는 데이터
 *   [관련 RFC] : ZHRH_RFC_ZIPP_CODE
 * 
 * @author 박영락    
 * @version 1.0, 2001/12/18
 */
public class SearchAddrDataTW extends com.sns.jdf.EntityData {

    public String ZIP03 ;    //우편번호
    public String STATE ;    //시도명
    public String BEZEI1 ;    //군구명
    public String COUNC ;    //동면명
	public String BEZEI2;    //번지

}
