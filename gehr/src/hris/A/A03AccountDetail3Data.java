package	hris.A;

/**
 * A03AccountDetail3Data.java
 * F/B 개인계좌 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRH_RFC_BANK_STOCK_LIST
 * 
 * @author 배민규    
 * @version 1.0, 2004/05/27
 */
public class A03AccountDetail3Data extends com.sns.jdf.EntityData {
    public String MANDT;			// 클라이언트
    public String LIFNR;			// 구매처 또는 채권자 계정번호
    public String BANKS;			// 은행국가키
    public String BANKL;			// 은행 키
    public String BANKN;			// 은행계좌번호(←BANKN+1(17))
    public String BKONT;			// 은행관리키
    public String BVTYP;			// 거래처은행유형
    public String XEZER;			// 지시자: 추심권한이 있습니까?
    public String BKREF;			// 은행명세에 관한 참조명세
    public String KOINH;			// 은행명(←지점명)
    public String EBPP_ACCNAME;		// 은행명세의 사용자정의이름
    public String EBPP_BVSTATUS;	// Biller Direct에서 은행명세 상태
}
