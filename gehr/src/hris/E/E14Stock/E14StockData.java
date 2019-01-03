package	hris.E.E14Stock;

/**
 * E14StockData.java
 * 우리 사주현황 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRW_RFC_SAJU_DISPLAY
 * 
 * @author 이형석    
 * @version 1.0, 2002/01/27
 */
public class E14StockData extends com.sns.jdf.EntityData {
    public String BOTONG   ;	// 예탁주식수
    public String USUN     ;	// 예탁주식수
    public String SUM      ;    // 예탁주식수 
    public String INCS_NUMB;    // 증자회차
    public String SHAR_TYPE;	// 보통주/우선주구분
    public String SHAR_TEXT;	// 주식구분 
    public String DEPS_QNTY;	//예탁주식수
    public String BEGDA    ;	// 시작일
    public String OUTS_QNTY;	// 인출수량
    public String AFTR_QNTY;	// 인출후 예탁잔여량
    
}
