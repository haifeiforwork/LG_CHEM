/*
 * �ۼ��� ��¥: 2005. 2. 4.
 *
*/
package hris.G;

import com.sns.jdf.EntityData;

/**
 * @author �̽���
 *
 */
public class ApprovalReturnState extends EntityData {

    public String E_AINF_SEQN;      // �������� �Ϸù�ȣ
    public String E_RETURN;         // CAD: �����ڵ�    
    public String E_MESSAGE;        // CAD ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ   
    public String E_BELNR;          // ȸ����ǥ��ȣ   

    public boolean isSuccess() {
        return "S".equals(E_RETURN);
    }

    public String getE_AINF_SEQN() {
        return E_AINF_SEQN;
    }

    public void setE_AINF_SEQN(String e_AINF_SEQN) {
        E_AINF_SEQN = e_AINF_SEQN;
    }

    public String getE_RETURN() {
        return E_RETURN;
    }

    public void setE_RETURN(String e_RETURN) {
        E_RETURN = e_RETURN;
    }

    public String getE_MESSAGE() {
        return E_MESSAGE;
    }

    public void setE_MESSAGE(String e_MESSAGE) {
        E_MESSAGE = e_MESSAGE;
    }

    public String getE_BELNR() {
        return E_BELNR;
    }

    public void setE_BELNR(String e_BELNR) {
        E_BELNR = e_BELNR;
    }
}
