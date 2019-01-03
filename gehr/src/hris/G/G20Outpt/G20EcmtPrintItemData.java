package hris.G.G20Outpt;

/**
 * G20EcmtPrintData.java
 * �ٷμҵ� ��õ¡�� �������� �����ϴ� ������ ������ Data
 * [���� RFC] : ZHRP_RFC_READ_YEA_RESULT_PRIN
 * 
 * @author  
 * @version 
 */
public class G20EcmtPrintItemData extends com.sns.jdf.EntityData {
    					
    public String PERNR;			// �����ȣ	
    public String REGNO;			// ��� ��ȣ(�ѱ�)	
    public String WTM_GROSS;		// Regular pay total	
    public String WTS_GROSS;		//Bonus pay total	
    public String WTI_GROSS;		// Acknowledged bonus total	
    public String GROSS_TOT;		// Gross pay	
    public String NTX_OVS;			// �����-���ܱٷ�
    public String NTX_OVT;			// �����-�߰��ٷμ���
    public String NTX_OTH;			// �����-��Ÿ
    public String NTX_TOT;			// �����-��
    public String NTX_RES;			// �����-����Ȱ����
    public String NTX_OTH07;		// �����-�׹��Ǻ����
    public String NTX_TOT07;		// �����-�ҵ��
    public String NTX_FOR;			// �����-�ܱ��αٷ���
    public String NTX_CLD;			// Childcare non-taxable	�����-��꺸������
    public String MON_GROSS;		// Final monthly pay	
    public String TAX_GROSS;		// �ѱ޿�
    public String DED_EARND;		// �ٷμҵ����
    public String EARND_AMT;		// �ٷμҵ�ݾ�
    public String BASE_EE;			// �⺻����-����
    public String BASE_SPOS;		// �⺻����-�����
    public String BASE_DP;			// Dependant deduction	�⺻����-�ξ簡��
    public String ADD_OLD;			// Deduction for the aged	�߰�����-��ο��
    public String ADD_HAND;			// Deduction for the handi	�߰�����-�����
    public String ADD_WOMAN;		// Ded. for women	�߰�����-�γ���
    public String ADD_WOMAN_N;		// Num of women �߰�����-�γ���
    public String ADD_CHILD;		// Ded. for kids	�߰�����-�ڳ������
    public String FEW_EE_DD;		// Ded. for small depend.	
    public String BAS_DP_N;			// �⺻����-�ξ簡���ο�
    public String ADD_OLD_N;		// �߰�����-��ο���ο�
    public String ADD_HAND_N;		// �߰�����-������ο�
    public String ADD_CHILD_N;		// �߰�����-�ڳ�������ο�
    public String ADD_BACHD_N;		// �߰�����-����Ծ����ο�
    public String ADD_BACHD;		// �߰�����-����Ծ��� 
    public String MUL_CHILD_N;		// ���ڳ��߰������ο�
    public String MUL_CHILD;		// ���ڳ��߰����� 
    public String DEP_TOTAL_N;		// Num of taotal dependents including	
    public String DED_SI;			// Insurance deduction	Ư������-�����
    public String DED_MEDI;			// Medical expense	Ư������-�Ƿ��
    public String DED_EDU;			// Education expense	Ư������-������
    public String DED_HOUS;			// Housing expense	
    public String HOUS_PAID;		// Annual Housing paid	Ư������-�����������ӱݿ����ݻ�ȯ��
    public String HOUS_LOAN;		// Interest Housing loan	Ư������-��������������Ա����ڻ�ȯ��
    public String DED_DONA;			// Donation	Ư������-��α�
    public String DED_TOTAL;		// Total deduction	Ư������-��
    public String AFTER_SPEC;		// Taxable after sepcial	�����ҵ�ݾ�
    public String DED_NP;			// National pension deduct	���ݺ�������-��Ÿ���ݺ����
    public String DED_NPI;			// National pension	���ݺ�������-���ο��ݺ����
    public String DED_INDIV;		// Pension	�׹��Ǽҵ����-���ο�������
    public String DED_PPS;			// Pers. pension saving ded	�׹��Ǽҵ����-��������
    public String HOUS_SAV;			// Housing saving	�׹��Ǽҵ����-���ø�������
    public String DED_BIZ;			// Samll Biz Ins. Funds	�׹��Ǽҵ����-�ұ���һ����
    public String DED_LTSFI;		// Long term stock fund	�׹��Ǽҵ����-����ֽ�������
    public String FLD_ENG;			// Field engineer	
    public String DD_INVEST;		// Venture investment	�׹��Ǽҵ����-������������
    public String DED_CARD;			// Credit card	�׹��Ǽҵ����-�ſ�ī���
    public String DED_STCK;			// company stock	�׹��Ǽҵ����-�츮��������
    public String DED_SPE_TAX_ACT;	// deduction for special tax act	�׹��Ǽҵ����-��
    public String TAX_BASE;			// Tax base	���ռҵ� ����ǥ��
    public String CALC_TAX;			// Calculated tax	���⼼��
    public String EARN_CRET;		// Eanrd-income credit	���װ���-�ٷμҵ�
    public String TAX_ASSOC;		// Association tax	���װ���-��������
    public String PR_SAVING;		// Property saving creidt	
    public String CRET_HOUS;		// House loan credit	���װ���-�������Ա�
    public String ABROD_INC;		// Oversea paid tax	���װ���-�ܱ�����
    public String POLITICAL;		// Political donation      ln	���װ���-�����ġ�ڱ�
    public String CONGR_CON;		// Congr. and Cond. ded.   ln	Ư������-ȥ���̻���ʺ�
    public String Y42;				// Med. Insu /y42          ln	�ǰ�����
    public String Y44;				// emp. Insu /y44          ln	��뺸��
    public String Y43;				// Nat. Pens /y43	���ο���
    public String CRET_STOK;		// Stock saving	
    public String CRET_STOK_LT;		// Long term stock saving	
    public String CRET_TOT;			// Total credit	���װ���-��
    public String FOR_ITAX;			// Exmption by i-tax law	���װ���-�ҵ漼��
    public String FOR_ETAX;			// Exmption by tax exmp	���װ���-����Ư�����ѹ�
    public String FOR_TOT;			// Total exemption	���װ���-��
    public String DTR_ITAX;			// Determined income tax	��������-�ҵ漼
    public String DTR_RTAX;			// Determined s.tax	��������-�ֹμ�
    public String DTR_STAX;			// Determined r.tax	��������-��Ư��
    public String DTR_TOT;			// Determined total tax	��������-��
    public String PRV_ITAX;			// Previous income tax	�ⳳ������-�ҵ漼
    public String PRV_STAX;			// Previous resident tax	�ⳳ������-��Ư��
    public String PRV_RTAX;			// Previous resident tax	�ⳳ������-�ֹμ�
    public String PRV_TOT;			// Previous total	�ⳳ������-��
    public String INC_TAX;			// Pre-paid income tax	�ⳳ������-�ҵ漼
    public String RES_TAX;			// Pre-paid special tax	�ⳳ������-�ֹμ�
    public String SPE_TAX;			// Pre-paid resident tax	�ⳳ������-��Ư��
    public String TAX_TOT;			// Pre-paid total tax	�ⳳ������-��
    public String REM_ITAX;			// Income  tax to be collect	����¡������-�ҵ漼
    public String REM_RTAX;			// R.tax   to be collected	����¡������-�ֹμ�
    public String REM_STAX;			// S.tax   to be collected	����¡������-��Ư��
    public String REM_TOT;			// Total   tax to be collect	����¡������-��
    public String RET_PEN;			// Retirement pension	���ݺ�������-�������ݼҵ�
    public String CASH_TOT;			// Total   Cash receipt	
    public String DL_INNSU;			// ��-����ᱹ��û	
    public String DL_INOSU;			// ��-������Ÿ	
    public String DL_MENSU;			// ��-�Ƿ�񱹼�û	
    public String DL_MEOSU;			// ��-�Ƿ���Ÿ	
    public String DL_EDNSU;			// ��-�����񱹼�û	
    public String DL_EDOSU;			// ��-�������Ÿ	
    public String DL_CRNSU;			// ��-�ſ�ī����û	
    public String DL_CROSU;			// ��-�ſ�ī����Ÿ	
    public String DL_CANSU;			// ��-���ݿ���������û	
    public String DL_CAOSU;			// 	
    public String DL_DONSU;			// ��-��αݱ���û	
    public String DL_DOOSU;			// ��-��αݱ�Ÿ	
    public String DED_SPEC;			// ǥ�ذ���

}