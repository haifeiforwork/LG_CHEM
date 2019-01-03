package hris.A.A13Address;

/**
 * A13AddressInputData.java
 * ������ �ּ� ������ ��ƿ��� ������
 *   [���� RFC] : ZGHR_RFC_ADDRESS_LIST
 *
 * @author �赵��
 * @version 1.0, 2016/08/09
 */
public class A13AddressInputData extends com.sns.jdf.EntityData {

    public String 	I_PERNR	 ;// 	 NUMC 	 8 	�����ȣ
    public String 	I_MOLGA	 ;// 	CHAR	 2 	�����׷���
    public String 	I_DATUM	 ;// 	 DATS 	 8 	��������
    public String 	I_SPRSL	 ;// 	 DATS 	 8 	���
    public String 	I_GTYPE	 ;// 	 CHAR 	 1 	ó��������
    public String 	I_SUBTY	 ;// 	 CHAR 	 4 	��������

    public String getI_PERNR() {
        return I_PERNR;
    }

    public void setI_PERNR(String i_PERNR) {
        I_PERNR = i_PERNR;
    }

    public String getI_MOLGA() {
        return I_MOLGA;
    }

    public void setI_MOLGA(String i_MOLGA) {
        I_MOLGA = i_MOLGA;
    }

    public String getI_DATUM() {
        return I_DATUM;
    }

    public void setI_DATUM(String i_DATUM) {
        I_DATUM = i_DATUM;
    }

    public String getI_SPRSL() {
        return I_SPRSL;
    }

    public void setI_SPRSL(String i_SPRSL) {
        I_SPRSL = i_SPRSL;
    }

    public String getI_GTYPE() {
        return I_GTYPE;
    }

    public void setI_GTYPE(String i_GTYPE) {
        I_GTYPE = i_GTYPE;
    }

    public String getI_SUBTY() {
        return I_SUBTY;
    }

    public void setI_SUBTY(String i_SUBTY) {
        I_SUBTY = i_SUBTY;
    }
}
