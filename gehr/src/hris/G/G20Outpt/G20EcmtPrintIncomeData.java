package hris.G.G20Outpt;

/**
 * 근로소득 원천징수 영수증을 발행하는 정보를 가지는 근무처 소득명세 Data
 * [관련 RFC] : ZHRP_RFC_READ_YEA_RESULT_PRIN
 * 
 * @author  
 * @version 
 */
public class G20EcmtPrintIncomeData extends com.sns.jdf.EntityData {
    
    public String PERNR;			// 사원번호	
    public String SEQNO;			// SEQ	
    public String TXPAS;			// 납세조합 구분	
    public String WORKPLACE;		// 이전근무지사업장번호/납세조합사업장번호	
    public String BUZINUM;			// 이전근무지사업장번호/납세조합사업장번호	
    public String RTBEG;			// 근무기간 시작일
    public String RTEND;			// 근무기간 종료일
    public String EXBEG;			// 감면기간 시작일
    public String EXEND;			// 감면기간 종료일    
    public String REGULAR_AMT;		// 정규급여	
    public String BONUS_AMT;		// 상여	
    public String ACKBN_AMT;		// 인정상여	
    public String STKBN_AMT;		// 스톡옵션
    public String ESTOK_AMT;		// 우리사주조합인출금
    public String TOTAL_AMT;		// 계	
    public String INTAX_AMT;		// 소득세	 - 전 근무지
    public String RETAX_AMT;		// 주민세 - 전 근무지
    public String SPTAX_AMT;		// 농어촌특별세 - 전 근무지
    public String TLTAX_AMT;		// 계 - 전 근무지	 
    					
}