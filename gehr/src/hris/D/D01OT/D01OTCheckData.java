package hris.D.D01OT;

/**
 * D01OTCheckData.java
 *  �Ѱ������ �ð� ������ ��ƿ��� ������ ����
 *   [���� RFC] : ZHRW_RFC_IS_AVAIL_OVERTIME
 *
 * @author �赵��
 * @version 1.0, 2002/07/04
 */
public class D01OTCheckData extends com.sns.jdf.EntityData {
    public String ERRORTEXTS;      //���� text
    public String BEGUZ     ;      //���۽ð�
    public String ENDUZ     ;      //����ð�
    public String STDAZ     ;      //�ʰ��ٹ��ð�

    //Global
    public String PERNR ;
    public String BEGZT ;
    public String ENDZT ;
    public String ZMODN ;
    public String FTKLA ;
    public String DATUM ;
}
