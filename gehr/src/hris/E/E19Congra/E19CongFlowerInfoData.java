package hris.E.E19Congra;

/**
 * E19CongFlowerInfoData.java
 * �ֹ���ü����
 *   [���� RFC] : ZHRA_RFC_GET_FLOWER_INFO
 * @author lsa
 * @version 1.0, 2014/04/18
 */
public class E19CongFlowerInfoData extends com.sns.jdf.EntityData
{
    public String MANDT		;//Ŭ���̾�Ʈ
    public String ZTRANS_SEQ	;//0��ü SEQ
    public String ZTRANS_PSEQ	;//0����� SEQ
    public String ZTRANS_NAME	;//��ü��
    public String ZTRANS_UNAME	;//��ü ����ڸ�
    public String ZTRANS_ADDR	;//��ü �ּ�
    public String ZPHONE_NUM	;//������ȭ
    public String ZCELL_NUM	;//�޴���ȭ
    public String ZFAX_NUM	;//FAX
    public String ZUSE_FAGE	;//��뿩��
    public String ZEMAIL	;//��ü����
	public String getMANDT() {
		return MANDT;
	}
	public void setMANDT(String mANDT) {
		MANDT = mANDT;
	}
	public String getZTRANS_SEQ() {
		return ZTRANS_SEQ;
	}
	public void setZTRANS_SEQ(String zTRANS_SEQ) {
		ZTRANS_SEQ = zTRANS_SEQ;
	}
	public String getZTRANS_PSEQ() {
		return ZTRANS_PSEQ;
	}
	public void setZTRANS_PSEQ(String zTRANS_PSEQ) {
		ZTRANS_PSEQ = zTRANS_PSEQ;
	}
	public String getZTRANS_NAME() {
		return ZTRANS_NAME;
	}
	public void setZTRANS_NAME(String zTRANS_NAME) {
		ZTRANS_NAME = zTRANS_NAME;
	}
	public String getZTRANS_UNAME() {
		return ZTRANS_UNAME;
	}
	public void setZTRANS_UNAME(String zTRANS_UNAME) {
		ZTRANS_UNAME = zTRANS_UNAME;
	}
	public String getZTRANS_ADDR() {
		return ZTRANS_ADDR;
	}
	public void setZTRANS_ADDR(String zTRANS_ADDR) {
		ZTRANS_ADDR = zTRANS_ADDR;
	}
	public String getZPHONE_NUM() {
		return ZPHONE_NUM;
	}
	public void setZPHONE_NUM(String zPHONE_NUM) {
		ZPHONE_NUM = zPHONE_NUM;
	}
	public String getZCELL_NUM() {
		return ZCELL_NUM;
	}
	public void setZCELL_NUM(String zCELL_NUM) {
		ZCELL_NUM = zCELL_NUM;
	}
	public String getZFAX_NUM() {
		return ZFAX_NUM;
	}
	public void setZFAX_NUM(String zFAX_NUM) {
		ZFAX_NUM = zFAX_NUM;
	}
	public String getZUSE_FAGE() {
		return ZUSE_FAGE;
	}
	public void setZUSE_FAGE(String zUSE_FAGE) {
		ZUSE_FAGE = zUSE_FAGE;
	}
	public String getZEMAIL() {
		return ZEMAIL;
	}
	public void setZEMAIL(String zEMAIL) {
		ZEMAIL = zEMAIL;
	}


}