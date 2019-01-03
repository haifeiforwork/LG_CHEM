package hris.J.J03JobCreate;

/**
 * J03ObjectCreData.java
 * HRP1000, HRP1001, HRP1002, HRP9618 INFTY�� Object�� �����ϴ� Data
 * [���� RFC] : ZHRH_RFC_CUD_OBJECTS,
 *              ZHRH_RFC_CUD_RELATIONS,
 *              ZHRH_RFC_CUD_CONTENTS,
 *              ZHRH_RFC_CUD_LEVELING
 * 
 * @author  �赵��
 * @version 1.0, 2003/06/13
 */
public class J03ObjectCreData extends com.sns.jdf.EntityData {

//  P_RESULT(ZHRH201S)
    public String OTYPE      ;     // ������Ʈ����
    public String OBJID      ;     // ������Ʈ ID
    public String BEGDA      ;     // ������
    public String ENDDA      ;     // ������
    public String RSIGN      ;     // ������(A, B)
    public String RELAT      ;     // ������Ʈ���� ����
    public String SCLAS      ;     // ���õ� ������Ʈ����
    public String SOBID      ;     // ���ÿ�����Ʈ ID
    public String PROZT      ;     // ���ߺ���
    public String PRIOX      ;     // �켱����
    public String CHARA      ;     // �ڰݻ���/�ʿ��� ���õ�
    public String SHORT      ;     // ������Ʈ���
    public String STEXT      ;     // ������Ʈ�̸�
    public String SUBTY      ;     // �Ϻ�����
    public String LEVEL_CODE ;     // Level ID
    
}    