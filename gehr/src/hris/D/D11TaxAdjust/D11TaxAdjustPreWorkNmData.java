package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustPreWorkData.java
 * 연말정산 - 전근무지 헤더명 데이타
 * [관련 RFC] : ZHRP_RFC_YEAR_PRE_WORK
 *
 * @author  김도신
 * @version 1.0, 2005/12/01
 */
public class D11TaxAdjustPreWorkNmData extends com.sns.jdf.EntityData {       
	
 
    public String     MANDT;	//클라이언트
    public String     SPRSL;	    //언어 키
    public String     MOLGA;	//국가 그루핑
    public String     LGART;	//임금 유형
    public String     LGTXT;	//임금 유형 설명
    public String     KZTXT;	//임금 유형 내역 
}
