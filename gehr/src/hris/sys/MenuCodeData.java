/*
 * �ۼ��� ��¥: 2005. 1. 13.
 *
 *
 */
package hris.sys;

import com.sns.jdf.EntityData;

/**
 * @author �̽���
 * 
 */
public class MenuCodeData extends EntityData {
    public String 	FCODE	;//	CHAR	20	����ڵ�
    public String 	FTEXT	;//	CHAR	40	����ڵ� Text
    public String 	ORDSQ	;//	NUMC	2	���� ����
    public String 	HLFCD	;//	CHAR	20	�������� ����ڵ�
    public String   HLFTX;  // ���� ��
    public String 	EMGUB	;//	CHAR	1	ESS/MSS ������
    public String 	LEVEL	;//	NUMC	2	��巹��
    public String 	FTYPE	;//	CHAR	4	�������
    public String 	RPATH	;//	CHAR	255	Web �ּ�(URL)

    public String getFCODE() {
        return FCODE;
    }

    public void setFCODE(String FCODE) {
        this.FCODE = FCODE;
    }

    public String getFTEXT() {
        return FTEXT;
    }

    public void setFTEXT(String FTEXT) {
        this.FTEXT = FTEXT;
    }

    public String getORDSQ() {
        return ORDSQ;
    }

    public void setORDSQ(String ORDSQ) {
        this.ORDSQ = ORDSQ;
    }

    public String getHLFCD() {
        return HLFCD;
    }

    public void setHLFCD(String HLFCD) {
        this.HLFCD = HLFCD;
    }

    public String getEMGUB() {
        return EMGUB;
    }

    public void setEMGUB(String EMGUB) {
        this.EMGUB = EMGUB;
    }

    public String getLEVEL() {
        return LEVEL;
    }

    public void setLEVEL(String LEVEL) {
        this.LEVEL = LEVEL;
    }

    public String getFTYPE() {
        return FTYPE;
    }

    public void setFTYPE(String FTYPE) {
        this.FTYPE = FTYPE;
    }

    public String getRPATH() {
        return RPATH;
    }

    public void setRPATH(String RPATH) {
        this.RPATH = RPATH;
    }

    public String getHLFTX() {
        return HLFTX;
    }

    public void setHLFTX(String HLFTX) {
        this.HLFTX = HLFTX;
    }
}
