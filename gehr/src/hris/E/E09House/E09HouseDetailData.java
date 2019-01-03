package	hris.E.E09House;

/**
 * E09HouseDetailData.java
 * ������ �ְ����� ���γ��� ������ ��ƿ��� ������
 *   [���� RFC] : ZGHR_RFC_HOUSE_FUND_DETAIL
 *
 * @author �ڿ���
 * @version 1.0, 2002/12/31
 */
public class E09HouseDetailData extends com.sns.jdf.EntityData {
    //�Է��ʵ�
    public String I_BEGDA;	// ��������
    public String I_BETRG;	// �ܿ��ݾ�
    public String I_ENDDA;  // ������
    public String I_PERNR;  // �����ȣ
    public String I_SUBTY;  // �Ϻ�����
    //����ʵ�
    public String E_BETRG         ;	// �ݾ�
    public String E_DARBT         ;	// ��Ȱ��ȯ
    public String E_DARBT_BEGDA   ; // ������
    public String E_DARBT_ENDDA   ; // ������
    public String E_DATBW         ; // ������

    public String E_REMAIN_BETRG  ; // �޿������ݾ�
    public String E_REMAIN_CONT   ; // ��ȯ���

    public String E_TILBT         ;	// ���һ�ȯ
    public String E_TILBT_BETRG   ;	// �ݾ�

    public String E_TOTAL_CONT    ; // ��ȯ���
    public String E_TOTAL_DARBT   ; // ���һ�ȯ
    public String E_TOTAL_INTEREST; // �ݾ�

    public String E_ZZRPAY_CONT   ; // ��ȯ���
    public String E_ZZRPAY_MNTH   ; // �ѻ�ȯ�Ⱓ ������
    public String E_ZZSECU_FLAG   ;	// �����ο���
    public String E_ENDDA         ; // �ѻ�ȯ�Ⱓ ������

}
