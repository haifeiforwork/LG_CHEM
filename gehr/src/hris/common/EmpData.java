package hris.common;

import com.sns.jdf.EntityData;

/**
 * Created by manyjung on 2016-08-10.
 */
public class EmpData extends EntityData {

    public String 	PERNR	;//	NUMC	8	��� ��ȣ
    public String 	ENAME	;//	CHAR	40	����
    public String 	ORGEH	;//	NUMC	8	���� ����
    public String 	ORGTX	;//	CHAR	40	�ҼӸ�
    public String 	MOLGA	;//	CHAR	2	���� �׷���
    public String 	MLGTX	;//	CHAR	25	HR �����׷��� �̸�
    public String 	PFLAG	;//	CHAR	1	�Է� �����ȣ FLAG  ����RFC : "1" ����,  �ؿ� RFC : "2" : �ؿܻ��

}
