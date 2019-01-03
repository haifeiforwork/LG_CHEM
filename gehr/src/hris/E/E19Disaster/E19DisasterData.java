package hris.E.E19Disaster;

/**
 * E19DisasterData.java
 * �������α������� ����Ÿ & ���ش���ڰ��� ����Ÿ & �������ؽŰ���ȸ
 *   [���� RFC] : ZHRW_RFC_P_DISASTER_RATE[1], ZHRW_RFC_P_DISASTER_RELA[2], ZHRW_RFC_DISASTER_DISPLAY[3]
 *                ZHRW_RFC_CONGCOND_REQUEST[4]
 * @author �輺��
 * @version 1.0, 2001/12/18
 */
public class E19DisasterData extends com.sns.jdf.EntityData
{
    public String DISA_RESN ;      // ���س����ڵ� CYH 20030918
    public String DISA_CODE ;      // ���ر����ڵ�          [1,2,  4]
    public String DREL_CODE ;      // ���ش���� �����ڵ�   [1,2,3,4]
    public String DISA_RATE ;      // ������                [1,  3,4]
    public String DREL_NAME ;      // ���ش���� �����ڵ�� [  2    ]
    public String CONG_DATE ;      // �����߻���            [    3,4]
    public String DISA_DESC1;      // ���س���1             [    3,4]
    public String DISA_DESC2;      // ���س���2             [    3,4]
    public String DISA_DESC3;      // ���س���3             [    3,4]
    public String DISA_DESC4;      // ���س���4             [    3,4]
    public String getDISA_RESN() {
		return DISA_RESN;
	}
	public void setDISA_RESN(String dISA_RESN) {
		DISA_RESN = dISA_RESN;
	}
	public String getDISA_CODE() {
		return DISA_CODE;
	}
	public void setDISA_CODE(String dISA_CODE) {
		DISA_CODE = dISA_CODE;
	}
	public String getDREL_CODE() {
		return DREL_CODE;
	}
	public void setDREL_CODE(String dREL_CODE) {
		DREL_CODE = dREL_CODE;
	}
	public String getDISA_RATE() {
		return DISA_RATE;
	}
	public void setDISA_RATE(String dISA_RATE) {
		DISA_RATE = dISA_RATE;
	}
	public String getDREL_NAME() {
		return DREL_NAME;
	}
	public void setDREL_NAME(String dREL_NAME) {
		DREL_NAME = dREL_NAME;
	}
	public String getCONG_DATE() {
		return CONG_DATE;
	}
	public void setCONG_DATE(String cONG_DATE) {
		CONG_DATE = cONG_DATE;
	}
	public String getDISA_DESC1() {
		return DISA_DESC1;
	}
	public void setDISA_DESC1(String dISA_DESC1) {
		DISA_DESC1 = dISA_DESC1;
	}
	public String getDISA_DESC2() {
		return DISA_DESC2;
	}
	public void setDISA_DESC2(String dISA_DESC2) {
		DISA_DESC2 = dISA_DESC2;
	}
	public String getDISA_DESC3() {
		return DISA_DESC3;
	}
	public void setDISA_DESC3(String dISA_DESC3) {
		DISA_DESC3 = dISA_DESC3;
	}
	public String getDISA_DESC4() {
		return DISA_DESC4;
	}
	public void setDISA_DESC4(String dISA_DESC4) {
		DISA_DESC4 = dISA_DESC4;
	}
	public String getDISA_DESC5() {
		return DISA_DESC5;
	}
	public void setDISA_DESC5(String dISA_DESC5) {
		DISA_DESC5 = dISA_DESC5;
	}
	public String getEREL_NAME() {
		return EREL_NAME;
	}
	public void setEREL_NAME(String eREL_NAME) {
		EREL_NAME = eREL_NAME;
	}
	public String getINDX_NUMB() {
		return INDX_NUMB;
	}
	public void setINDX_NUMB(String iNDX_NUMB) {
		INDX_NUMB = iNDX_NUMB;
	}
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getREGNO() {
		return REGNO;
	}
	public void setREGNO(String rEGNO) {
		REGNO = rEGNO;
	}
	public String getSTRAS() {
		return STRAS;
	}
	public void setSTRAS(String sTRAS) {
		STRAS = sTRAS;
	}
	public String getCONG_NAME() {
		return CONG_NAME;
	}
	public void setCONG_NAME(String cONG_NAME) {
		CONG_NAME = cONG_NAME;
	}
	public String getAINF_SEQN() {
		return AINF_SEQN;
	}
	public void setAINF_SEQN(String aINF_SEQN) {
		AINF_SEQN = aINF_SEQN;
	}
	public String getDISA_NAME() {
		return DISA_NAME;
	}
	public void setDISA_NAME(String dISA_NAME) {
		DISA_NAME = dISA_NAME;
	}
	public String getRESN_NAME() {
		return RESN_NAME;
	}
	public void setRESN_NAME(String rESN_NAME) {
		RESN_NAME = rESN_NAME;
	}
	public String DISA_DESC5;      // ���س���5             [    3,4]
    public String EREL_NAME ;      // ������󼺸�          [    3,4]
    public String INDX_NUMB ;      // ����                  [    3  ]
    public String PERNR     ;      // �����ȣ              [    3,4]
    public String REGNO     ;      // �ѱ���Ϲ�ȣ          [    3,4]
    public String STRAS     ;      // �ּ�                  [    3,4]
    public String CONG_NAME ;      // ���������ڵ��        [    3  ]

    public String AINF_SEQN ;      // �������� �Ϸù�ȣ    [      4]
    public String DISA_NAME ;      // ���ر���text
    public String RESN_NAME ;      // ���س���text

}
