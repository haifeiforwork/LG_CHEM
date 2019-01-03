/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ���ο��� �ڰݺ���                                           */
/*   Program Name : ���ο��� �ڰݺ���                                           */
/*   Program ID   : E04PensionChngData                                          */
/*   Description  : ���ο��� �ڰݺ��� ������ ��ƿ��� ������                    */
/*   Note         : [���� RFC] : ZHRW_RFC_NATIONAL_PENSION                      */
/*   Creation     : 2002-01-25  �ֿ�ȣ                                          */
/*   Update       : 2005-03-01  ������                                          */
/*                                                                              */
/********************************************************************************/

package hris.E.E04Pension;

public class E04PensionChngData extends com.sns.jdf.EntityData {

    public String MANDT      ;   // Ŭ���̾�Ʈ
    public String BEGDA      ;   // ������
    public String AINF_SEQN  ;   // �������� �Ϸù�ȣ
    public String PERNR      ;   // �����ȣ
    public String CHNG_TYPE  ;   // ���ο��� �ڰݺ������ �׸� �ڵ�
    public String CHNG_BEFORE;   // ������ ����Ÿ
    public String CHNG_AFTER ;   // ������ ����Ÿ
    public String PUBLIC_DTE ;   // ������
    public String ZPERNR     ;   // �븮��û�� ���
    public String ZUNAME     ;   // �μ����� �̸�
    public String AEDTM      ;   // ������
    public String UNAME      ;   // ������̸�
    public String CHNG_TEXT  ;   // ���ο��� �ڰݺ������ �׸��ڵ� TEXT
}
