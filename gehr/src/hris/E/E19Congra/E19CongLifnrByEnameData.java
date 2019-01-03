package hris.E.E19Congra;

/**
 * E19CongLifnrByEnameData.java
 * 성명에 해당하는 부서계좌정보 GET
 * [관련 RFC] : ZHRA_RFC_GET_LIFNR_BY_ENAME
 *
 * @author  lsa
 * @version 1.0, 2005/12/07
 */
public class E19CongLifnrByEnameData extends com.sns.jdf.EntityData {
   
    public String LIFNR;            // 구매처 또는 채권자 계정번호
    public String NAME1;            // 성명 문자45                     
    public String BANKS;            // 은행국가키                 
    public String BANKL;            // 은행 키                    
    public String BANKN;            // 은행계좌번호               
    public String BANKA;            // 은행명      
                   
    public String BVTYP;           // 거래처은행유형
    public String BVTXT;           // 계좌유형    
}