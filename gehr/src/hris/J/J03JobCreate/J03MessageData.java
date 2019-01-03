package hris.J.J03JobCreate;

/**
 * J03MessageData.java
 * ������ ���ϵǴ� �۾� Message Data
 * [���� RFC] : ZHRH_RFC_CUD_OBJECTS,
 *              ZHRH_RFC_CUD_RELATIONS,
 *              ZHRH_RFC_CUD_CONTENTS,
 *              ZHRH_RFC_CUD_LEVELING
 * 
 * @author  �赵��
 * @version 1.0, 2003/06/13
 */
public class J03MessageData extends com.sns.jdf.EntityData {

//  P_MESSTAB(ZHRH200S)
    public String MSGSPRA ;     // �޼��� ��� ID
    public String MSGID   ;     // Batch �Է� �޼��� ID
    public String MSGNR   ;     // Batch �Է� �޼�����ȣ
    public String MSGTEXT ;     // BDC MESSAGE TEXT

}   
    
    