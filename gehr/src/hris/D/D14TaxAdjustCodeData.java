package hris.D ;
/**
 * D14TaxAdjustCodeData.java
 * 연말정산 시뮬레이션 Data 및 결과내역조회 화면에 뿌려질 데이타
 * [RFC] ,ZHRP_RFC_READ_YEA_RESULT
 *  
 * @version 1.0 2014/01/17  C20140106_63914 ABART : 국내 *, ''  해외  S 해외근무기간(1~6월), T 해외근무기간(7~12월) L 국내근무기간  항목 추가되어 
 *                                     넘길 data구조  
 * @version 3.0 2015/05/18 [CSR ID:2778743] 연말정산 내역조회 화면 수정                                    
 *  
 */

public class D14TaxAdjustCodeData extends com.sns.jdf.EntityData {

    public String code ;    
    public String value ;    
    public String gubn ; 
    public String subCode; //@2014연말정산 추가
    public String subCode2; //@2014연말정산 추가
    public String reTax2014; //2014연말정산 재정산

    public String ABART ;    //급여 계산 규칙에 대한 사원 하위 그룹 그루핑
    public String LGART ;    //임금 유형
    public String BETRG ;    //HR 급여관리: 금액
    public String CNTR1 ;	 //LGART의 second 유형 @2014 연말정산 추가 20150126
    public String VOZNR;    //LGART의 second 유형2 @2014 연말정산 추가 20150126
    
    public String BTZNR;    //[CSR ID:2778743] 연말정산시 전/후 가 다른것 체크 77이면 (전)//2014연말정산 재정산
}
