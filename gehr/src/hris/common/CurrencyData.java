package hris.common;
/**
 * CurrencyData.java
 * 통화.화페
 *   [관련 RFC] : ZHRW_RFC_P_CURRENCY
 *               
 * @author 김성일
 * @version 1.0, 2002/01/05
 */
public class CurrencyData extends com.sns.jdf.EntityData
{
    public String MANDT;       // 클라이언트
    public String LAND1;       // 국가키
    public String ENDDA;       // 종료일
    public String BEGDA;       // 시작일
    public String WAERS;       // 통화키
}