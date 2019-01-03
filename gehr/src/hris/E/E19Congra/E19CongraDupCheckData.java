package hris.E.E19Congra;

/**
 * E19CongraDupCheckData.java
 * ������ �ߺ���û check
 * [���� RFC] : ZHRW_RFC_CONGRA_DUP_CHECK
 *
 * @author  �赵��
 * @version 1.0, 2003/03/04
 */
public class E19CongraDupCheckData extends com.sns.jdf.EntityData {

    public String CONG_CODE;        // ��������
    public String RELA_CODE;        // ��������ڰ����ڵ�
    public String EREL_NAME;        // ������󼺸�
    public String INFO_FLAG;        // Infotype Data�̸� 'I', Temp Table Data�̸� 'T'
    public String AINF_SEQN;        // Temp Table�� Check�Ҷ� �����ȣ�� �������� Check�Ѵ�.(������ �ʿ�)
	public String getCONG_CODE() {
		return CONG_CODE;
	}
	public void setCONG_CODE(String cONG_CODE) {
		CONG_CODE = cONG_CODE;
	}
	public String getRELA_CODE() {
		return RELA_CODE;
	}
	public void setRELA_CODE(String rELA_CODE) {
		RELA_CODE = rELA_CODE;
	}
	public String getEREL_NAME() {
		return EREL_NAME;
	}
	public void setEREL_NAME(String eREL_NAME) {
		EREL_NAME = eREL_NAME;
	}
	public String getINFO_FLAG() {
		return INFO_FLAG;
	}
	public void setINFO_FLAG(String iNFO_FLAG) {
		INFO_FLAG = iNFO_FLAG;
	}
	public String getAINF_SEQN() {
		return AINF_SEQN;
	}
	public void setAINF_SEQN(String aINF_SEQN) {
		AINF_SEQN = aINF_SEQN;
	}



}