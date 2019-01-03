package hris.D.D11TaxAdjust ;
/**
 * D11TaxAdjustGibuData.java
 * 연말정산 - 이월기부금 데이타
 * [관련 RFC] : ZSOLYR_RFC_YEAR_DON_CARRIED
 *
 * @author rdcamel
 * @version 1.0, 2018/01/05 [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건
 */
public class D11TaxAdjustGibuCarriedData extends com.sns.jdf.EntityData {
    public String DOCOD     ;   //기부 코드            
    public String CRVYR ;   //연말정산 연도         
    public String BETPE     ;   //금액                
    public String ANZHL     ;   //금액                
    public String V0ZNR     ;   //번호              
    public String BETRG     ;   //이월 기부금액
    public String DOCOD_TEXT     ;   //기부 텍스트            
    public String DON_TOT;	//기부총액
    public String DON_MID;	//작년까지 공제 총액
}
