package hris.J.J01JobMatrix;

/**
 * J01LevelingSheetData.java
 * Job Leveling Sheet Data format
 * [���� RFC] : ZHRH_RFC_GET_LEVELING_SHEET
 * 
 * @author  �赵��
 * @version 1.0, 2003/05/13
 */
public class J01LevelingSheetData extends com.sns.jdf.EntityData {

//  P_RESULT(ZHRH107S)
    public String DSORT_CODE ;     // ��з�ID
    public String DSORT_NAME ;     // ��з���
    public String ELEME_CODE ;     // �򰡿��ID
    public String ELEME_NAME ;     // �򰡿�Ҹ�
    public String LEVEL_CODE0;     // Level ID
    public String TDNAME     ;     // ��з�ID + �򰡿��ID

//  P_RESULT_D(ZHRH103S)
    public String OBJID      ;     // ���� ID
    public String SUBTY      ;     // �󼼳��� �Ϻ�����
    public String SEQNO      ;     // �󼼳��� ����
    public String TLINE      ;     // �� DATA
    
//  P_RESULT_L(ZHRH082T)
    public String LEVEL_CODE ;     // Level ID
    public String LEVEL_NAME ;     // Level ��
    public String LEVEL_GRAD ;     // Level ��
    
}   
    
    