/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : �����Ļ�                                                    */
/*   Program Name : �μ��� �����Ļ� ��Ȳ                                        */
/*   Program ID   : F51DeptWelfareData                                          */
/*   Description  : �μ��� �����Ļ� ��Ȳ ��ȸ�� ���� DATA ����                  */
/*   Note         : ����                                                        */
/*   Creation     : 2005-02-21 �����                                           */
/*   Update       :  2017/08/28 eunha [CSR ID:3456352] ����ü�谳�� �� ����/��å ǥ�� ���� ���濡 ���� �ý��� ���� ��û ��
/*                                                                              */
/********************************************************************************/

package hris.F;

/**
 * F51DeptWelfareData
 *  �μ��� �����Ļ� ��Ȳ ������ ��� ������
 *
 * @author �����
 * @version 1.0,
 */
public class F51DeptWelfareData extends com.sns.jdf.EntityData {
    public String STEXT;        //�μ��̸�
    public String PERNR;        //�����ȣ
    public String KNAME;        //�ѱ��̸�
    public String TITEL;        //����
    public String GUBUN;        //��������
    public String DESCRIPTION;  //��û����
    public String RELA_CODE;    //��󱸺�
    public String EREL_NAME;    //����ڼ���
    public String WAERS;   		 //��ȭŰ
    public String PAID_AMNT;    //������
    public String APPL_DATE;    //��û����
    public String APPR_DATE;    //������
    //2017/08/28 eunha [CSR ID:3456352] ����ü�谳�� �� ����/��å ǥ�� ���� ���濡 ���� �ý��� ���� ��û �� start
    public String TITL2;        //��å
    public String TITEL_T;        //�����ڵ�
  //2017/08/28 eunha [CSR ID:3456352] ����ü�谳�� �� ����/��å ǥ�� ���� ���濡 ���� �ý��� ���� ��û �� end
}
