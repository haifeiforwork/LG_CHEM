package hris.A.A15Certi;

import com.sns.jdf.EntityData;

/**
 * Created by manyjung on 2016-09-20.
 */
public class A15CertiData2 extends EntityData{

    public String	ORGEH	;//	NUMC	 8 	���� ����
    public String	BEGDA	;//	 DATS 	 8 	������
    public String	ENDDA	;//	 DATS 	 8 	������
    public String	ORGTX	;//	 CHAR 	 25 	���� ���� ����
    public String	STELL	;//	 NUMC 	 8 	����
    public String	STLTX	;//	 CHAR 	 25 	������
    public String	TITEL	;//	 CHAR 	 15 	����
    public String	BTRTL	;//	 CHAR 	 4 	�λ� ���� ����
    public String	BTEXT	;//	 CHAR 	 15 	�λ� ���� ���� �ؽ�Ʈ

    public String getORGEH() {
        return ORGEH;
    }

    public void setORGEH(String ORGEH) {
        this.ORGEH = ORGEH;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getENDDA() {
        return ENDDA;
    }

    public void setENDDA(String ENDDA) {
        this.ENDDA = ENDDA;
    }

    public String getORGTX() {
        return ORGTX;
    }

    public void setORGTX(String ORGTX) {
        this.ORGTX = ORGTX;
    }

    public String getSTELL() {
        return STELL;
    }

    public void setSTELL(String STELL) {
        this.STELL = STELL;
    }

    public String getSTLTX() {
        return STLTX;
    }

    public void setSTLTX(String STLTX) {
        this.STLTX = STLTX;
    }

    public String getTITEL() {
        return TITEL;
    }

    public void setTITEL(String TITEL) {
        this.TITEL = TITEL;
    }

    public String getBTRTL() {
        return BTRTL;
    }

    public void setBTRTL(String BTRTL) {
        this.BTRTL = BTRTL;
    }

    public String getBTEXT() {
        return BTEXT;
    }

    public void setBTEXT(String BTEXT) {
        this.BTEXT = BTEXT;
    }
}
