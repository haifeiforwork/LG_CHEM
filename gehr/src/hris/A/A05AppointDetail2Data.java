package hris.A ;

/**
 * A05AppointDetail2Data.java
 *  ����� �±޻��� ������ ��� ������
 *   [���� RFC] : ZHRH_RFC_GET_IT0008
 * 
 * @author �Ѽ���
 * @version 1.0, 2001/12/17
 */
public class A05AppointDetail2Data extends com.sns.jdf.EntityData {

    public String 	PREAS	;//	CHAR	2	������ ������ ���� ����
    public String 	RTEXT	;//	CHAR	30	�±ޱ���
    public String 	BEGDA	;//	DATS	8	�±�����
    public String 	TRFGR	;//	CHAR	8	����
    public String 	TRFST	;//	CHAR	2	ȣ��
    public String 	VGLGR	;//	CHAR	2	�񱳱׷�
    public String 	VGLST	;//	CHAR	2	�񱳱޿���������
    public String 	G_FLAG	;//	CHAR	1	�Ϲ�ǥ��

    public String getPREAS() {
        return PREAS;
    }

    public void setPREAS(String PREAS) {
        this.PREAS = PREAS;
    }

    public String getRTEXT() {
        return RTEXT;
    }

    public void setRTEXT(String RTEXT) {
        this.RTEXT = RTEXT;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getTRFGR() {
        return TRFGR;
    }

    public void setTRFGR(String TRFGR) {
        this.TRFGR = TRFGR;
    }

    public String getTRFST() {
        return TRFST;
    }

    public void setTRFST(String TRFST) {
        this.TRFST = TRFST;
    }

    public String getVGLGR() {
        return VGLGR;
    }

    public void setVGLGR(String VGLGR) {
        this.VGLGR = VGLGR;
    }

    public String getVGLST() {
        return VGLST;
    }

    public void setVGLST(String VGLST) {
        this.VGLST = VGLST;
    }

    public String getG_FLAG() {
        return G_FLAG;
    }

    public void setG_FLAG(String g_FLAG) {
        G_FLAG = g_FLAG;
    }
}
