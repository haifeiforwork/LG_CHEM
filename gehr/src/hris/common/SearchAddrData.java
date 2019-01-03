package	hris.common;

/**
 * SearchAddrData.java
 *  주소 검색 list 를 담아오는 데이터
 *   [관련 RFC] : ZHRH_RFC_ZIPP_CODE
 * 
 * @author 박영락    
 * @version 1.0, 2001/12/18
 */
public class SearchAddrData extends com.sns.jdf.EntityData {

    public String ZIPP_CODE ;    //우편번호
    public String SIDO_NAME ;    //시도명
    public String GNGU_NAME ;    //군구명
    public String DONG_NAME ;    //동면명
	public String NUMB_TEXT ;    //번지

}
