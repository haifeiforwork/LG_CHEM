package hris.D.D03Vocation;

/**
 * D03CondolHolidaysData.java
 * �������� ��ȸ
 * [���� RFC] : ZHRW_RFC_GET_CONDOL_HOLIDAYS
 * @author �̼���
 * @version 1.0, 2008/03/11
 */
public class D03CondolHolidaysData extends com.sns.jdf.EntityData
{
    public String PERNR    ;       // �����ȣ            
    public String AINF_SEQN;       // �������� �Ϸù�ȣ   
    public String BEGDA    ;       // ��û��              
    public String CONG_CODE;       // ��������            
    public String CONG_NAME;       // ���������ڵ��      
    public String RELA_CODE;       // ��������ڰ����ڵ�  
    public String RELA_NAME;       // ��������ڰ����ڵ��
    public String CONG_DATE;       // �����߻���          
    public String HOLI_CONT;       // �����ް�  
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getAINF_SEQN() {
		return AINF_SEQN;
	}
	public void setAINF_SEQN(String aINF_SEQN) {
		AINF_SEQN = aINF_SEQN;
	}
	public String getBEGDA() {
		return BEGDA;
	}
	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}
	public String getCONG_CODE() {
		return CONG_CODE;
	}
	public void setCONG_CODE(String cONG_CODE) {
		CONG_CODE = cONG_CODE;
	}
	public String getCONG_NAME() {
		return CONG_NAME;
	}
	public void setCONG_NAME(String cONG_NAME) {
		CONG_NAME = cONG_NAME;
	}
	public String getRELA_CODE() {
		return RELA_CODE;
	}
	public void setRELA_CODE(String rELA_CODE) {
		RELA_CODE = rELA_CODE;
	}
	public String getRELA_NAME() {
		return RELA_NAME;
	}
	public void setRELA_NAME(String rELA_NAME) {
		RELA_NAME = rELA_NAME;
	}
	public String getCONG_DATE() {
		return CONG_DATE;
	}
	public void setCONG_DATE(String cONG_DATE) {
		CONG_DATE = cONG_DATE;
	}
	public String getHOLI_CONT() {
		return HOLI_CONT;
	}
	public void setHOLI_CONT(String hOLI_CONT) {
		HOLI_CONT = hOLI_CONT;
	}
    
}