/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   �μ�����													*/
/*   2Depth Name		:   ����														*/
/*   Program Name	:   ������ �Ϻ����� �˻� 									*/
/*   Program ID		: D40OrganInsertData.java								*/
/*   Description		: ������ �Ϻ����� �˻� 									*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  ������                                          	*/
/*   Update				: 2017-12-08  ������                                          	*/
/*                                                                              			*/
/********************************************************************************/

package	hris.D.D40TmGroup;

/**
 * D40OrganInsertData.java
 * ������ �Ϻ����� ������ ���� ������
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40OrganInsertData extends com.sns.jdf.EntityData {

    public String OBJID     ;    //����ID
    public String E_CHECK ;


    public String getE_CHECK() {
		return E_CHECK;
	}

	public void setE_CHECK(String E_CHECK) {
		this.E_CHECK = E_CHECK;
	}

	public String getOBJID() {
        return OBJID;
    }

    public void setOBJID(String OBJID) {
        this.OBJID = OBJID;
    }
}

