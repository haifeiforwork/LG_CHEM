package hris.G.G20Outpt;

/**
 * G20EcmtPrintData.java
 * 근로소득 원천징수 영수증을 발행하는 정보를 가지는 Data
 * [관련 RFC] : ZHRP_RFC_READ_YEA_RESULT_PRIN
 * 
 * @author  
 * @version 
 */
public class G20EcmtPrintItemData extends com.sns.jdf.EntityData {
    					
    public String PERNR;			// 사원번호	
    public String REGNO;			// 등록 번호(한국)	
    public String WTM_GROSS;		// Regular pay total	
    public String WTS_GROSS;		//Bonus pay total	
    public String WTI_GROSS;		// Acknowledged bonus total	
    public String GROSS_TOT;		// Gross pay	
    public String NTX_OVS;			// 비과세-국외근로
    public String NTX_OVT;			// 비과세-야간근로수당
    public String NTX_OTH;			// 비과세-기타
    public String NTX_TOT;			// 비과세-계
    public String NTX_RES;			// 비과세-연구활동비
    public String NTX_OTH07;		// 비과세-그밖의비과세
    public String NTX_TOT07;		// 비과세-소득계
    public String NTX_FOR;			// 비과세-외국인근로자
    public String NTX_CLD;			// Childcare non-taxable	비과세-출산보육수당
    public String MON_GROSS;		// Final monthly pay	
    public String TAX_GROSS;		// 총급여
    public String DED_EARND;		// 근로소득공제
    public String EARND_AMT;		// 근로소득금액
    public String BASE_EE;			// 기본공제-본인
    public String BASE_SPOS;		// 기본공제-배우자
    public String BASE_DP;			// Dependant deduction	기본공제-부양가족
    public String ADD_OLD;			// Deduction for the aged	추가공제-경로우대
    public String ADD_HAND;			// Deduction for the handi	추가공제-장애인
    public String ADD_WOMAN;		// Ded. for women	추가공제-부녀자
    public String ADD_WOMAN_N;		// Num of women 추가공제-부녀자
    public String ADD_CHILD;		// Ded. for kids	추가공제-자녀양육비
    public String FEW_EE_DD;		// Ded. for small depend.	
    public String BAS_DP_N;			// 기본공제-부양가족인원
    public String ADD_OLD_N;		// 추가공제-경로우대인원
    public String ADD_HAND_N;		// 추가공제-장애인인원
    public String ADD_CHILD_N;		// 추가공제-자녀양육비인원
    public String ADD_BACHD_N;		// 추가공제-출산입양자인원
    public String ADD_BACHD;		// 추가공제-출산입양자 
    public String MUL_CHILD_N;		// 다자녀추가공제인원
    public String MUL_CHILD;		// 다자녀추가공제 
    public String DEP_TOTAL_N;		// Num of taotal dependents including	
    public String DED_SI;			// Insurance deduction	특별공제-보험료
    public String DED_MEDI;			// Medical expense	특별공제-의료비
    public String DED_EDU;			// Education expense	특별공제-교육비
    public String DED_HOUS;			// Housing expense	
    public String HOUS_PAID;		// Annual Housing paid	특별공제-주택임차차임금원리금상환액
    public String HOUS_LOAN;		// Interest Housing loan	특별공제-장기주택저당차입금이자상환액
    public String DED_DONA;			// Donation	특별공제-기부금
    public String DED_TOTAL;		// Total deduction	특별공제-계
    public String AFTER_SPEC;		// Taxable after sepcial	차감소득금액
    public String DED_NP;			// National pension deduct	연금보험료공제-기타연금보험료
    public String DED_NPI;			// National pension	연금보험료공제-국민연금보험료
    public String DED_INDIV;		// Pension	그밖의소득공제-개인연금저축
    public String DED_PPS;			// Pers. pension saving ded	그밖의소득공제-연금저축
    public String HOUS_SAV;			// Housing saving	그밖의소득공제-주택마련저축
    public String DED_BIZ;			// Samll Biz Ins. Funds	그밖의소득공제-소기업소상공인
    public String DED_LTSFI;		// Long term stock fund	그밖의소득공제-장기주식형저축
    public String FLD_ENG;			// Field engineer	
    public String DD_INVEST;		// Venture investment	그밖의소득공제-투자조합출자
    public String DED_CARD;			// Credit card	그밖의소득공제-신용카드등
    public String DED_STCK;			// company stock	그밖의소득공제-우리사주조합
    public String DED_SPE_TAX_ACT;	// deduction for special tax act	그밖의소득공제-계
    public String TAX_BASE;			// Tax base	종합소득 과세표준
    public String CALC_TAX;			// Calculated tax	산출세액
    public String EARN_CRET;		// Eanrd-income credit	세액공제-근로소득
    public String TAX_ASSOC;		// Association tax	세액공제-납세조합
    public String PR_SAVING;		// Property saving creidt	
    public String CRET_HOUS;		// House loan credit	세액공제-주택차입금
    public String ABROD_INC;		// Oversea paid tax	세액공제-외국납부
    public String POLITICAL;		// Political donation      ln	세액공제-기부정치자금
    public String CONGR_CON;		// Congr. and Cond. ded.   ln	특별공제-혼인이사장례비
    public String Y42;				// Med. Insu /y42          ln	건강보험
    public String Y44;				// emp. Insu /y44          ln	고용보험
    public String Y43;				// Nat. Pens /y43	국민연금
    public String CRET_STOK;		// Stock saving	
    public String CRET_STOK_LT;		// Long term stock saving	
    public String CRET_TOT;			// Total credit	세액공제-계
    public String FOR_ITAX;			// Exmption by i-tax law	세액감면-소득세법
    public String FOR_ETAX;			// Exmption by tax exmp	세액감면-조세특례제한법
    public String FOR_TOT;			// Total exemption	세액감면-계
    public String DTR_ITAX;			// Determined income tax	결정세액-소득세
    public String DTR_RTAX;			// Determined s.tax	결정세액-주민세
    public String DTR_STAX;			// Determined r.tax	결정세액-농특세
    public String DTR_TOT;			// Determined total tax	결정세액-계
    public String PRV_ITAX;			// Previous income tax	기납부종전-소득세
    public String PRV_STAX;			// Previous resident tax	기납부종전-농특세
    public String PRV_RTAX;			// Previous resident tax	기납부종전-주민세
    public String PRV_TOT;			// Previous total	기납부종전-계
    public String INC_TAX;			// Pre-paid income tax	기납부주현-소득세
    public String RES_TAX;			// Pre-paid special tax	기납부주현-주민세
    public String SPE_TAX;			// Pre-paid resident tax	기납부주현-농특세
    public String TAX_TOT;			// Pre-paid total tax	기납부주현-계
    public String REM_ITAX;			// Income  tax to be collect	차감징수세액-소득세
    public String REM_RTAX;			// R.tax   to be collected	차감징수세액-주민세
    public String REM_STAX;			// S.tax   to be collected	차감징수세액-농특세
    public String REM_TOT;			// Total   tax to be collect	차감징수세액-계
    public String RET_PEN;			// Retirement pension	연금보험료공제-퇴직연금소득
    public String CASH_TOT;			// Total   Cash receipt	
    public String DL_INNSU;			// 계-보험료국세청	
    public String DL_INOSU;			// 계-보험료기타	
    public String DL_MENSU;			// 계-의료비국세청	
    public String DL_MEOSU;			// 계-의료비기타	
    public String DL_EDNSU;			// 계-교육비국세청	
    public String DL_EDOSU;			// 계-교육비기타	
    public String DL_CRNSU;			// 계-신용카드등국세청	
    public String DL_CROSU;			// 계-신용카드등기타	
    public String DL_CANSU;			// 계-현금영수증국세청	
    public String DL_CAOSU;			// 	
    public String DL_DONSU;			// 계-기부금국세청	
    public String DL_DOOSU;			// 계-기부금기타	
    public String DED_SPEC;			// 표준공제

}