package hris.E.E05House;

/**
 * E05PersInfoData.java
 *  ����� �ּҿ� �ټӳ���� ��� ������
 *   [���� RFC] : ZHRA_RFC_GET_PERS_INFO
 *
 * @author �輺��
 * @version 1.0, 2001/12/13
 */
public class E05PersInfoData extends com.sns.jdf.EntityData
{
    public String E_STRAS;      //�ּ�
    public String E_YEARS;      //�ټӳ��
	public String getE_STRAS() {
		return E_STRAS;
	}
	public void setE_STRAS(String e_STRAS) {
		E_STRAS = e_STRAS;
	}
	public String getE_YEARS() {
		return E_YEARS;
	}
	public void setE_YEARS(String e_YEARS) {
		E_YEARS = e_YEARS;
	}
}
