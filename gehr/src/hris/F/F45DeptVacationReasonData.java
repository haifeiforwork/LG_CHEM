/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : ����                                                       		 	*/
/*   Program Name : �μ��� �ް���������Ʈ                                      			*/
/*   Program ID   : F45DeptVacationReasonData                                   */
/*   Description  : �μ��� �ް� ��� ��Ȳ ��ȸ�� ���� DATA ����                 		*/
/*   Note         : ����                                                                 */
/*   Creation     : 2010-03-16 lsa                                           	*/
/*   Update       : 2018-07-31 ��ȯ�� [Worktime52] ���,��Ȯ������ �߰� 			*/
/*                                                                              */
/********************************************************************************/

package hris.F;  

/**
 * F41DeptVacationData
 *  �μ��� �ް���������Ʈ ������ ��� ������
 * 
 * @author lsa
 * @version 1.0, 
 */ 
public class F45DeptVacationReasonData extends com.sns.jdf.EntityData {
    public String PERNR         ;    //��� ��ȣ                         
    public String ENAME         ;    //��� �Ǵ� �������� ���˵� �̸�
    public String AWART         ;    //�ٹ�/�޹� ����                
    public String ATEXT         ;    //�ٹ�/�޹� ���� �ؽ�Ʈ         
    public String BEGDA         ;    //������                        
    public String ENDDA         ;    //������                        
    public String BEGUZ         ;    //���� �ð�                     
    public String ENDUZ         ;    //���� �ð�                     
    public String PBEG1         ;    //�޽� ����                     
    public String PEND1         ;    //�޽� ����                     
    public String STDAZ         ;    //�ʰ��ٹ��ð�                  
    public String REQU_DATE     ;    //��û��                
    public String APPR_DATE     ;    //������                
    public String APPU_NUMB     ;    //������ ���           
    public String CONG_NAME     ;    //���������ڵ��        
    public String REASON        ;    //��û����                      
    public String ORGEH         ;    //���� ����                     
    public String ORGTX         ;    //������Ʈ �̸�      
    public String PERSG         ;    //��� �׷�                                                                                             
    public String PTEXT         ;    //��� �׷� �̸�                                                                                        
    public String PERSK         ;    //��� ���� �׷�                                                                                        
    public String PTEXT1        ;    //��� ���� �׷� �̸�                                                                                   
    public String AINF_SEQN     ;    //�������� �Ϸù�ȣ                                                                             
    public String OVTM_CODE     ;    //�����ڵ�                                                                                      
    public String OVTM_CD_NAME  ;    //������                                                                                        
    public String OVTM_NAME     ;    //�����           
    public String INPUT_PASS    ;    //���           
    public String UNCONFIRM_RESN;    //��Ȯ������           
}
