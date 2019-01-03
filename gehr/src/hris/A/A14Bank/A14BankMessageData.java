/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �޿���������                                                */
/*   Program Name : �޿����� ��û                                               */
/*   Program ID   : A14BankStockFeeData                                         */
/*   Description  : �޿����� ��û ������ ��ƿ��� ������                        */
/*   Note         : [���� RFC] : ZHRH_RFC_BANK_STOCK_FEE_LIST                   */
/*   Creation     : 2002-01-08  �赵��                                          */
/*   Update       : 2005-03-03  ������                                          */
/*                                                                              */
/********************************************************************************/

package hris.A.A14Bank;

public class A14BankMessageData extends com.sns.jdf.EntityData {

    public String TYPE      ;      //�޽��� ����: S ����, E ����, W ���, I ����, A �ߴ�         
    public String CODE      ;      //�޽��� �ڵ�                                                 
    public String MESSAGE   ;      //�޽��� �ؽ�Ʈ                                               
    public String LOG_NO    ;      //���ø����̼� �α�: �α� ��ȣ                                
    public String LOG_MSG_NO;      //���ø����̼� �α�: ���� �޽��� �Ϸ� ��ȣ                    
    public String MESSAGE_V1;                                                                  
    public String MESSAGE_V2;                                                                  
    public String MESSAGE_V3;                                                                  
    public String MESSAGE_V4;                 

}
