package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustHouseHoleCheckData.java
 * 연말정산 -공제유형별 세대주체크용 조회
 * [관련 RFC] : ZSOLYR_RFC_HOUSEHOLE_REQUIRED
 *
 * @author lsa    2010/12/10   
 */
public class D11TaxAdjustHouseHoleCheckData extends com.sns.jdf.EntityData {       
	
    public String GUBN_CODE ;  //구분코드	                                                                                     
    public String GOJE_CODE ;  //공제코드                                                                                                 
    public String REQ_H;          //세대주 여부        
}
