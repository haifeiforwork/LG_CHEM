package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustReturnData.java
 *  연말정산공제신청/수정, 소득공제신고서출력용 데이터를 조회해온후 담는 Object
 *   [관련 RFC] : ZHRP_RFC_COLLECT_YEA_DATA
 * 
 * @author 김성일
 * @version 1.0, 2002/01/22
 */
public class D11TaxAdjustReturnData extends com.sns.jdf.EntityData {

    public java.util.Vector personalRed_vt   ;   // ESS 인적공제분
    public java.util.Vector specialRed_vt    ;   // ESS 연말정산 특별공제분
    public java.util.Vector etcRed_vt        ;   // ESS 연말정산 기타/세액공제분
}
