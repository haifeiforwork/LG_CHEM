package	hris.common;

/**
 * TaxAdjustFlagData.java
 *  �α��νÿ� ��������Ⱓ���� �������� ������ ������
 * 
 * @author �輺��  
 * @version 1.0, 2001/02/04
 */
public class TaxAdjustFlagData extends com.sns.jdf.EntityData {

     public boolean canPeriod = false;   // �޴����� ���������� �Ҽ� �ִ� �Ⱓ���� ����
     public boolean canDetail = false;   // �������� ������ȸ�� �Ҽ� �ִ� �Ⱓ���� ����
     public boolean canBuild  = false;   // �������� ��û�� �Ҽ� �ִ� �Ⱓ���� ����
     public boolean canSimul  = false;   // �������� �ùķ��̼��� �Ҽ� �ִ� �Ⱓ���� ����
     public String  targetYear;   // �������� ȸ��⵵(?)
}
