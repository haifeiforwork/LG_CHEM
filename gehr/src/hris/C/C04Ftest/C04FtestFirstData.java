/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �系���а���                                                */
/*   Program Name : ���дɷ°�������������                                      */
/*   Program ID   : C04FtestFirstData                                           */
/*   Description  : ���дɷ°�������������                                      */
/*   Note         : [���� RFC] : ZHRE_RFC_LANGUAGE_FIRST                        */
/*   Creation     : 2002-01-04  ������                                          */
/*   Update       : 2005-02-15  ������                                          */
/*                                                                              */
/********************************************************************************/
package	hris.C.C04Ftest;

public class C04FtestFirstData extends com.sns.jdf.EntityData {

    public String BUKRS     ;   // ȸ���ڵ�
    public String EXAM_DATE ;   // ������
    public String EXIM_DTIM ;   // ����
    public String FROM_DATE ;   // ��û�ⰣFROM
    public String FROM_TIME ;   // �������
    public String LANG_CODE ;   // ��������
    public String LANG_NAME ;   // ���� �̸�
    public String TOXX_DATE ;   // ��û�ⰣTO
    public String TOXX_TIME ;   // ��������
    public String REQS_DATE ;   // ��û��
    public String AREA_CODE ;   // ��û���������ڵ�
    public String AREA_DESC ;   // ��û����������
    public String AREA_CODE2;   // Ȯ�����������ڵ�
    public String AREA_DESC2;   // Ȯ������������
    public String REQS_FLAG ;   // ��û���ɿ��� --> ��û�����ϸ� "Y", �������� ������ "N"
    public String CONF_FLAG ;   // Ȯ������     --> ��û�Ϸ� "X", Ȯ�� "Y", ��� "N"
    public String REQS_CONT ;   // ��û�ο��� - ȸ�系
    public String CONF_CONT ;   // Ȯ���ο��� - ȸ�系
    public String PERNR     ;   // ���
}
