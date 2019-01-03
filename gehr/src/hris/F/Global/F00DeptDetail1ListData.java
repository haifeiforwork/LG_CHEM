/******************************************************************************/
/*   System Name  	: g-HR
/*   1Depth Name  	: Organization & Staffing
/*   2Depth Name  	: Headcount
/*   Program Name 	: Org.Unit/Level (Staff Present State Detail)
/*   Program ID   		: F00DeptDetail1ListData.java
/*   Description  		: �ο���Ȳ ������ ��ȭ��
/*   Note         		: ����
/*   Creation     		: 2005-03-07 �����
/*   Update				: 2008-01-21 jungin @v1.0 ORGTX_SP, POSIX_SP �߰�.
/*   						: 2008-01-29 jungin @v1.1 HPI_DATE �߰�.
/*   						: 2008-02-15 jungin @v1.2 POSIX, PTEXT �߰�.
/******************************************************************************/

package hris.F.Global;

/**
 * F00DeptDetailListData
 *  �ο���Ȳ ������ ��ȭ�� ������ ��� ������
 *
 * @author �����
 * @version 1.0,
 */
public class F00DeptDetail1ListData extends com.sns.jdf.EntityData {
	public String PBTXT     	;    	//���
    public String PERNR     		;    	//���
    public String ENAME     	;    	//����
    public String ORGEH     	;    	//�Ҽ��ؽ�Ʈ
    public String ORGTX     	;    	//�ҼӾ��
    public String JIKKB     		;    	//����
    public String JIKKT     		;    	//����
    public String JIKWE     		;    	//����
    public String JIKWT     		;    	//����
    public String JIKCH     		;    	//����
    public String JIKCT     		;    	//����
    public String ANNUL     	;
    public String JIKCT_ANN 	;
    public String STELL     		;
    public String STLTX     	;
    public String DAT01     	;
    public String GUNSOK    	;
    public String OLDS      		;
    public String UNIV_TXT  	;
    public String UNIV_BR   	;
    public String UNIV   	    	;     // add by liukuo 2010.12.01
    public String MAST_TXT  	;
    public String MAST_BR   	;
    public String MAST   	    ;      // add by liukuo 2010.12.01
    public String CET       		;
    public String TOEIC     		;
    public String JLPT      		;
    public String NSS       		;
    public String KPT       		;
    public String RTEXT1       ;
    public String RTEXT2       ;
    public String RTEXT3       ;

    public String ORGTX_SP	;		//SP-Org.Unit
    public String POSIX_SP		;		//SP-Position
    public String HPI_DATE		;		//HPI-Start Date
    public String POSIX			;		//Position
    public String PTEXT			;		//Emp.Subgroup

}
