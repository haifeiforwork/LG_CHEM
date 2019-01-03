package	hris.E.E14Stock;

/**
 * InchulData.java
 * 개인별 인출내역 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRH_RFC_JINGUP_DETAIL
 * 
 * @author 이형석    
 * @version 1.0, 2002/12/23
 */
public class InchulData extends com.sns.jdf.EntityData {
    
    public String CINS_DATS;	// 인출일
    public String DRAW_QNTY;	// 인출주수
    public String DRAW_RESN;    // 인출사유 
    public String DRAW_NAME;    // 인출사유명
    
}
