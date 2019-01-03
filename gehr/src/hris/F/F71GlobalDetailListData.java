/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : Global����POOL                                              */
/*   Program Name : Global����POOL ������ ��ȭ��                              */
/*   Program ID   : F71GlobalDetailListData                                     */
/*   Description  : Global����POOL ������ ��ȭ�� ��ȸ�� ���� DATA ����        */
/*   Note         : ����                                                        */
/*   Creation     : 2006-03-16 LSA                                              */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
  
package hris.F;   
 
/**
 * F71GlobalDetailListData 
 *  Global����POOL ������ ��ȭ�� ������ ��� ������ 
 *  
 * @author �����
 * @version 1.0,  
 */
public class F71GlobalDetailListData extends com.sns.jdf.EntityData {
    public String PERNR        ;  //�����ȣ                   
    public String ENAME        ;  //��� �Ǵ� �������� �����̸�
    public String STEXT        ;  //������Ʈ�̸�               
    public String PTEXT        ;  //�������׷��̸�           
    public String TITEL        ;  //����                       
    public String TITL2        ;  //��å                       
    public String TRFGR        ;  //�޿��׷�                   
    public String TRFST        ;  //�޿�����                   
    public String VGLST        ;  //�񱳱޿���������           
    public String STELL_TEXT   ;  //������                     
    public String DAT          ;  //����                       
    public String GNSOK        ;  //�ټӳ��                   
    public String OLDS         ;  //����                       
    public String HPI_MARK     ;  //HPI ����                   
    public String REGI_MARK    ;  //���������� ����          
    public String HPREG_MARK   ;  //HPI&���������� ����  
    public String UMBA_MARK    ;  //���� MBA ����        
    public String HPUMB_MARK   ;  //HPI&���� MBA ����    
    public String CORP_MARK    ;  //�����屳���̼��� ����
    public String SMBA_MARK    ;  //Ȯ��MBA ����         
    public String DEGR_MARK    ;  //�ؿ������� ����      
    public String RND_MARK     ;  //R&D�ڻ� ����         
    public String FORE_MARK    ;  //�����ܱ��αٹ��� ����
    public String CHIN_MARK    ;  //�߱����������� ����  
    public String NCHIN_MARK   ;  //�߱������������� ����
    public String TOEI_MARK    ;  //TOEIC 800�� �̻���   
    public String HSK_MARK     ;  //HSK 5��� �̻���     
    public String LGAO_MARK    ;  //LGA 3.5�� �̻���     
    public String CN_MARK      ;  //�߱��� ������        
    public String ENCN_MARK    ;  //����&�߱��� ������
    public String LART_TEXT1   ;  //���б���          
    public String FTEXT1       ;  //���б�����        
    public String LART_TEXT2   ;  //���п���          
    public String FTEXT2       ;  //���п�����        
    public String TOEI_SCOR    ;  //TOEIC ��������    
    public String JPT_SCOR     ;  //JPT ��������      
    public String LANG_LEVL    ;  //HSK ���          
    public String LGAX_SCOR    ;  //LGA-LAP Oral      
    public String PERS_APP1    ;  //����1���� ��    
    public String PERS_APP2    ;  //����2���� ��    
    public String PERS_APP3    ;  //����3���� ��    
    public String REGI_SLAND   ;  //��������          
    public String REGI_YEAR    ;  //�����⵵          
    public String MBA_DETAI1   ;  //����MBA����1      
    public String MBA_YEAR1    ;  //����MBA���۳⵵1              
    public String MBA_SCHOO1   ;  //P/G��1          
    public String MBA_DETAI2   ;  //����MBA����2    
    public String MBA_YEAR2    ;  //����MBA���۳⵵2
    public String MBA_SCHOO2   ;  //P/G��2          
    public String MBA_DETAI3   ;  //����MBA����3    
    public String MBA_YEAR3    ;  //����MBA���۳⵵3
    public String MBA_SCHOO3   ;  //P/G��3          
    public String MBA_DETAI4   ;  //����MBA����4    
    public String MBA_YEAR4    ;  //����MBA���۳⵵4
    public String MBA_SCHOO4   ;  //P/G��4          
    public String MBA_DETAI5   ;  //����MBA����5    
    public String MBA_YEAR5    ;  //����MBA���۳⵵5
    public String MBA_SCHOO5   ;  //P/G��5          
    public String CORP_AREA    ;  //���ο�������    
    public String MBA_SLAND    ;  //Ȯ��MBA ����   
    public String DEGR_DETAI1  ;  //�ؿ�����������1
    public String DEGR_SLAND1  ;  //�ؿ������ڱ���1
    public String DEGR_DETAI2  ;  //�ؿ�����������2
    public String DEGR_SLAND2  ;  //�ؿ������ڱ���2
    public String DEGR_DETAI3  ;  //�ؿ�����������3
    public String DEGR_SLAND3  ;  //�ؿ������ڱ���3
    public String RND_DETAI    ;  //R&D����        
    public String RND_SLAND    ;  //R&D����        
    public String FORE_NATIO   ;  //�ܱ��α���     
    public String FORE_GESCH   ;  //�ܱ��μ���     
    public String FORE_STEXT   ;  //�ܱ����з�     
    public String FORE_INFO    ;  //�ܱ��κ��     
    public String CHIN_NAME1   ;  //�߱��λ翵��1  
    public String CHIN_BTEXT1  ;  //�߱��λ���������1
    public String CHIN_YEAR1   ;  //�߱��ٹ����1    
    public String CHIN_NAME2   ;  //�߱��λ翵��2    
    public String CHIN_BTEXT2  ;  //�߱��λ���������2
    public String CHIN_YEAR2   ;  //�߱��ٹ����2    
    public String CHIN_NAME3   ;  //�߱��λ翵��3    
    public String CHIN_BTEXT3  ;  //�߱��λ���������3
    public String CHIN_YEAR3   ;  //�߱��ٹ����3    
    public String CHIN_NAME4   ;  //�߱��λ翵��4    
    public String CHIN_BTEXT4  ;  //�߱��λ���������4
    public String CHIN_YEAR4   ;  //�߱��ٹ����4    
    public String CHIN_NAME5   ;  //�߱��λ翵��5    
    public String CHIN_BTEXT5  ;  //�߱��λ���������5
    public String CHIN_YEAR5   ;  //�߱��ٹ����5    
    public String NCHIN_NAME1  ;  //�߱����λ翵��1  
    public String NCHIN_BTEXT1 ;  //�߱����λ���������1
    public String NCHIN_YEAR1  ;  //�߱��ܱٹ����1    
    public String NCHIN_NAME2  ;  //�߱����λ翵��2    
    public String NCHIN_BTEXT2 ;  //�߱����λ���������2
    public String NCHIN_YEAR2  ;  //�߱��ܱٹ����2    
    public String NCHIN_NAME3  ;  //�߱����λ翵��3    
    public String NCHIN_BTEXT3 ;  //�߱����λ���������3
    public String NCHIN_YEAR3  ;  //�߱��ܱٹ����3    
    public String NCHIN_NAME4  ;  //�߱����λ翵��4    
    public String NCHIN_BTEXT4 ;  //�߱����λ���������4
    public String NCHIN_YEAR4  ;  //�߱��ܱٹ����4    
    public String NCHIN_NAME5  ;  //�߱����λ翵��5    
    public String NCHIN_BTEXT5 ;  //�߱����λ���������5
    public String NCHIN_YEAR5  ;  //�߱��ܱٹ����5    
}
    