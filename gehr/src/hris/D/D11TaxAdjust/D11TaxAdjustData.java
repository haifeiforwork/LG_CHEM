package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustData.java
 *  �������������û/����, �ҵ�����Ű���¿� ������
 *   [���� RFC] : ZHRP_RFC_COLLECT_YEA_DATA
 *   table name : ESS ����������[1 ZHRPI01S], ESS �������� Ư�������� & ESS �������� ��Ÿ/���װ�����[2 ZHRPI02S]
 * @author �輺��
 * @version 1.0, 2002/01/22
 */
public class D11TaxAdjustData extends com.sns.jdf.EntityData {

    public String RELA      ;   // ����         [1,2]
    public String ENAME     ;   // ����         [1,2]
    public String REGNO     ;   // �ֹε�Ϲ�ȣ [1,2]

    public String BASIC_RED ;   // �⺻����     [1  ]
    public String OLD_RED   ;   // ��ο��     [1  ]
    public String HANDY_RED ;   // �����       [1  ]
    public String WOMEN_RED ;   // �γ���       [1  ]
    public String CHILD_RED ;   // �ڳ������   [1  ]    
                                                
    public String GUBUN     ;   // ��������     [  2]
    public String FASAR     ;   // ������������ �з�[  2]
    public String STEXT     ;   // �б������ؽ�Ʈ[  2]
    public String ADD_AMT   ;   // �����߰���   [  2]
    public String AUTO_AMT  ;   // �ڵ��ݿ���   [  2]
    public String AUTO_TEXT ;   // �ڵ��г���   [  2]     
}                                              
