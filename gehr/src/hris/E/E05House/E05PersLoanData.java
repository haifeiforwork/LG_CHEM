package hris.E.E05House;

/**
 * E05PersLoanData.java
 * �������ڿ� ���� ������� ����Ÿ
 *   [���� RFC] : ZHRW_RFC_GET_INFTY_0045
 *
 * @author �輺��
 * @version 1.0, 2001/12/13
 */
public class E05PersLoanData extends com.sns.jdf.EntityData
{
    public String PERNR;       // ���
    public String BEGDA;       // ������
    public String ENDDA;       // ������
    public String DLART;       // ��������
    public String DARBT;       // ���ε� ����ݾ�
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getBEGDA() {
		return BEGDA;
	}
	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}
	public String getENDDA() {
		return ENDDA;
	}
	public void setENDDA(String eNDDA) {
		ENDDA = eNDDA;
	}
	public String getDLART() {
		return DLART;
	}
	public void setDLART(String dLART) {
		DLART = dLART;
	}
	public String getDARBT() {
		return DARBT;
	}
	public void setDARBT(String dARBT) {
		DARBT = dARBT;
	}



}
