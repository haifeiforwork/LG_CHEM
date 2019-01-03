/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ����                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : ������ �Ϻ����� �˻�                                        */
/*   Program ID   : OrganInsertData                                             */
/*   Description  : ������ �Ϻ����� �˻��� ���� DATA ����                       */
/*   Note         : ����                                                        */
/*   Creation     : 2005-02-20 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package	hris.common;

/**
 * OrganInsertData
 * ���(����)���� ��ȸ�� �Ϻ����� ������ ���� ������
 *  
 * @author �����  
 * @version 1.0, 
 */
public class OrganInsertData extends com.sns.jdf.EntityData {
	
    public String OBJID     ;    //����ID

    public String getOBJID() {
        return OBJID;
    }

    public void setOBJID(String OBJID) {
        this.OBJID = OBJID;
    }
}

