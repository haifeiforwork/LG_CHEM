package hris.B.B04Promotion ;

import java.util.Vector;

/**
 * B04PromotionLangData.java
 *  ���б������� ������, ���޴������� �� �������� ������
 *   [���� RFC] : ZHRH_RFC_JINGUP_SIMUL
 *   2015.03.11 ������D [CSR ID:2724630] �λ����� ȭ�� �Ϻ� ���� ��
 *    update [CSR ID:3525660] ���� �ùķ��̼� Logic ���� �� ȭ�鱸�� ��û ��  20171115 eunha
 * @author ������
 * @version 1.0, 2002/01/14
 */
public class B04PromotionCData extends com.sns.jdf.EntityData {
    /*
    public String 	E_RETURN	;//	TYPE	ZGHR0020S	[GEHR] RFC �޼���
    public String 	E_PROM_NAME	;//	TYPE	ZPROM_NAME	���ޱ��и�
    public String 	E_SCPM_AMNT	;//	TYPE	ZSCPM_AMNT	���޴�������
    public String 	E_GIJUN_AMNT	;//	TYPE	ZSCPM_AMNT	���ޱ�������
    public String 	E_EDU_FLAG	;//	TYPE	FLAG	�Ϲ�ǥ��
    public String 	E_LANG_FLAG	;//	TYPE	FLAG	�Ϲ�ǥ��
    public String 	E_EXTDT	;//	TYPE	DATS	Ư���±����� ��¥           <-- DATUM
    public String 	E_CFLAG	;//	TYPE	CHAR1	���, ���Ի�, ������ȭ�� flag <-- E_CFLAG
    public String 	E_SFLAG	;//	TYPE	CHAR1	6sigma �������� flag    <-- E_SFLAG


     */

    //fields
    public String E_PROM_NAME;   // ���ޱ��и�
    public String E_SCPM_AMNT;   // ���޴�����������
    public String E_GIJUN_AMNT;   // ���޴�����������
    public String E_EDU_FLAG;   // �Ϲ��÷���
    public String E_LANG_FLAG;   // �Ϲ��÷���
	public String E_EXTDT     ;   // Ư���±����� ��¥
	public String E_CFLAG;   // ���, ���Ի�, ������ȭ�� flag
	public String E_SFLAG;   // 6sigma �������� flag

	//update [CSR ID:3525660] ���� �ùķ��̼� Logic ���� �� ȭ�鱸�� ��û ��   start
	public String E_PROM_CODE;   // ���ޱ��и�
	public String E_EDU_YN;   // ���ޱ����̼�����
	//update [CSR ID:3525660] ���� �ùķ��̼� Logic ���� �� ȭ�鱸�� ��û ��   end


    //ZHRS068S ����������ȸ
    public String LANG_TYPE ;      // ���з��ڵ� ����
    public String LANG_NAME ;      // �Ϻ������̸�
    public String LANG_AMNT ;       // ��������/���
    public String LANG_AMNT1 ;       // ��������/���2��° ���� CSR ID:2724630


    public Vector<B04PromotionAData> PYUNGA_TAB;    // = getTable(B04PromotionAData.class, function, "ET_PYUNGA");
    public Vector<B04PromotionAData> EDU_TAB;   // = getTable(B04PromotionAData.class, function, "ET_EDU");
    public Vector<B04PromotionBData> PYUNGGA_SCORE_TAB; // = getTable(B04PromotionBData.class, function, "ET_PYUNGA_SCORE");
    public Vector<B04PromotionBData> LANG_TAB;  // = getTable(B04PromotionBData.class, function, "ET_LANG");
    public Vector<B04PromotionCData> LANG_GIJUN_TAB;    // = getTable(B04PromotionCData.class, function, "ET_LANG_GIJUN");

}