/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : ����                                                        		*/
/*   Program Name : ���� ���� ����ǥ                                            		*/
/*   Program ID   : F42DeptMonthWorkConditionData                               */
/*   Description  : �μ��� ���� ���� ����ǥ ��ȸ�� ���� DATA ����               		*/
/*   Note         : ����                                                        		*/
/*   Creation     : 2005-02-17 �����                                           		*/
/*   Update       : 2018-07-19 ��ȯ�� [Worktime52] �ܿ������ް�, �����ް� �ʵ� �߰�	*/
/*                                                                              */
/********************************************************************************/

package hris.F;  

/**
 * F42DeptMonthWorkConditionData
 *  �μ��� ���� ���� ����ǥ ������ ��� ������
 *  
 * @author �����
 * @version 1.0, 
 */
public class F42DeptMonthWorkConditionData extends com.sns.jdf.EntityData {
    public String ORGEH      ;  //�μ��ڵ�     
    public String STEXT      ;  //�μ���       
    public String ENAME      ;  //����         
    public String PERNR      ;  //���  (Total �� ���� 0000000)       
    public String REMA_HUGA  ;	//�ܿ��ް�
    public String REMA_RWHUGA;	//�ܿ������ް�
    public String HUGA       ;  //�ް�         
    public String RWHUGA     ;  //�����ް�         
    public String KHUGA      ;  //�����ް�     
    public String HHUGA      ;  //�ϰ��ް�     
    public String BHUG       ;  //�����ް�       
    public String MHUG       ;  //�𼺺�ȣ�ް� �߰� ��CSR ID:C20111025_86242    
    public String GONGA      ;  //����         
    public String KYULKN     ;  //���         
    public String JIGAK      ;  //����         
    public String JOTAE      ;  //����         
    public String WECHUL     ;  //����         
    public String MUNO       ;  //���뵿 ���ӱ�
    public String GOYUK      ;  //����         
    public String CHULJANG   ;  //����         
    public String HTKGUN     ;  //����Ư��     
    public String TTKGUN     ;  //���Ư��     
    public String MTKGUN     ;  //����Ư��     
    public String MTKGUN_T   ;  //����Ư��(��) 
    public String HYUNJANG   ;  //���Ͽ���     
    public String YUNJANG    ;  //����ٷ�     
    public String YAGAN      ;  //�߰��ٷ�     
    public String DANGJIC    ;  //����         
    public String HYANGUN    ;  //�ⱺ(�ٹ���) 
    public String KOYUK      ;  //����(�ٹ���) 
    public String KONGSU     ;  //����         
    public String KONGSU_HOUR;  //����(�ð�)    
}
