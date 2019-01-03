/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   �μ�����													*/
/*   2Depth Name		:   ����														*/
/*   Program Name	:   ������													*/
/*   Program ID		: D40OrganInfoData.java								*/
/*   Description		: ������														*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  ������                                          	*/
/*   Update				: 2017-12-08  ������                                          	*/
/*                                                                              			*/
/********************************************************************************/

package	hris.D.D40TmGroup;

/**
 * D40OrganInfoData.java
 * ������ ������ ���� ������
 * [���� RFC] :  ZHRA_RFC_GET_ORGEH_LIST
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40OrganInfoData extends com.sns.jdf.EntityData {

    public String   OBJID;        //����ID
    public String   OBJTXT;       //������
    public String   UPOBJID;      //��������
    public String   LOWERYN ;     //��������.
    public String   STOPHERE;     //���õ���ġ.
    public boolean  isOpen = false; //����� open/close ����.

    public String getOBJID() {
        return OBJID;
    }

    public void setOBJID(String OBJID) {
        this.OBJID = OBJID;
    }

    public String getOBJTXT() {
        return OBJTXT;
    }

    public void setOBJTXT(String OBJTXT) {
        this.OBJTXT = OBJTXT;
    }

    public String getUPOBJID() {
        return UPOBJID;
    }

    public void setUPOBJID(String UPOBJID) {
        this.UPOBJID = UPOBJID;
    }

    public String getLOWERYN() {
        return LOWERYN;
    }

    public void setLOWERYN(String LOWERYN) {
        this.LOWERYN = LOWERYN;
    }

    public String getSTOPHERE() {
        return STOPHERE;
    }

    public void setSTOPHERE(String STOPHERE) {
        this.STOPHERE = STOPHERE;
    }

    public boolean isOpen() {
        return isOpen;
    }

    public void setOpen(boolean open) {
        isOpen = open;
    }
}

