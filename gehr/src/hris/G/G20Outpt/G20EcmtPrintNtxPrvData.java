package hris.G.G20Outpt;

/**
 * 근로소득 원천징수 영수증을 발행하는 정보를 가지는 NTX_INCOME Data
 * [관련 RFC] : ZHRP_RFC_READ_YEA_RESULT_PRIN
 * 
 * @author  
 * @version 
 */
public class G20EcmtPrintNtxPrvData extends com.sns.jdf.EntityData {
   
    public String PERNR;			// 
    public String BIZNO;			// 이전근무지사업장번호/납세조합사업장번호
    public String NTCOD;			// 비과세 코드
    public String INDIC;			// 
    public String AMT;			//  비과세금액
}