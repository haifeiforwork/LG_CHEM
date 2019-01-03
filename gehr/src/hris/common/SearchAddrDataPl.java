package hris.common;

/**
 * SearchAddrDataPl.java
 *  주소 검색 list 를 담아오는 데이터[폴란드법인]
 *   [관련 RFC] : ZHRH_RFC_ZIPP_CODE
 * 
 * @author yji 
 * @creation 2010 06 25   
 */
public class SearchAddrDataPl extends com.sns.jdf.EntityData {

    public String ZIP03 ;    //우편번호
    public String STATE ;    //시도명
    public String BEZEI1 ;    //군구명
    public String COUNC ;    //동면명
	public String BEZEI2;    //번지

}
