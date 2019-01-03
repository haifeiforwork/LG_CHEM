package hris.D.D01OT;

/********************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ʰ��ٹ�                                                    */
/*   Program Name : �ʰ��ٹ�                                                    */
/*   Program ID   : D01OTRealWorkDATA                                           */
/*   Description  : �Ǳٹ��ð��� ��� ������ ( �繫�� )                                                      */
/*   Note         : [���� RFC] : ZGHR_RFC_NTM_REALWORK_LIST                     */
/*   Creation     : 2018-05-18  ������                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

@SuppressWarnings("serial")
public class D01OTRealWorkDATA extends com.sns.jdf.EntityData {

    public String PERNR;    // �����ȣ

    public String BASTM;    // �⺻�ٹ��ð�
    public String MAXTM;    // �����ִ�ٹ��ð�
    public String PWDWK;    // ���� �ٹ��ð�
    public String PWEWK;    // ���� �ٹ��ð�_ȸ��
    public String CWDWK;    // �ָ�/���� �ٹ��ð�
    public String CWEWK;    // �ָ�/���� �ٹ��ð�_ȸ��
    public String PWTOT;    // ��
    public String CWTOT;    // ��_ȸ��
    public String RWKTM;    // �Ǳٹ��ð�

    // ������
    public String WKLMT;    // �ٹ��ѵ�
    public String NORTM;    // ����ٹ��ð�
    public String OVRTM;    // �ʰ��ٹ��ð�
    public String BRKTM;    // �ްԽð�
    public String NWKTM;    // ��ٹ��ð�

    public String getPERNR() {
        return PERNR;
    }
    public void setPERNR(String pERNR) {
        PERNR = pERNR;
    }
    public String getBASTM() {
        return BASTM;
    }
    public void setBASTM(String bASTM) {
        BASTM = bASTM;
    }
    public String getMAXTM() {
        return MAXTM;
    }
    public void setMAXTM(String mAXTM) {
        MAXTM = mAXTM;
    }
    public String getPWDWK() {
        return PWDWK;
    }
    public void setPWDWK(String pWDWK) {
        PWDWK = pWDWK;
    }
    public String getPWEWK() {
        return PWEWK;
    }
    public void setPWEWK(String pWEWK) {
        PWEWK = pWEWK;
    }
    public String getCWDWK() {
        return CWDWK;
    }
    public void setCWDWK(String cWDWK) {
        CWDWK = cWDWK;
    }
    public String getCWEWK() {
        return CWEWK;
    }
    public void setCWEWK(String cWEWK) {
        CWEWK = cWEWK;
    }
    public String getPWTOT() {
        return PWTOT;
    }
    public void setPWTOT(String pWTOT) {
        PWTOT = pWTOT;
    }
    public String getCWTOT() {
        return CWTOT;
    }
    public void setCWTOT(String cWTOT) {
        CWTOT = cWTOT;
    }
    public String getRWKTM() {
        return RWKTM;
    }
    public void setRWKTM(String rWKTM) {
        RWKTM = rWKTM;
    }
    public String getWKLMT() {
        return WKLMT;
    }
    public void setWKLMT(String wKLMT) {
        WKLMT = wKLMT;
    }
    public String getNORTM() {
        return NORTM;
    }
    public void setNORTM(String nORTM) {
        NORTM = nORTM;
    }
    public String getOVRTM() {
        return OVRTM;
    }
    public void setOVRTM(String oVRTM) {
        OVRTM = oVRTM;
    }
    public String getBRKTM() {
        return BRKTM;
    }
    public void setBRKTM(String bRKTM) {
        BRKTM = bRKTM;
    }
    public String getNWKTM() {
        return NWKTM;
    }
    public void setNWKTM(String nWKTM) {
        NWKTM = nWKTM;
    }

}