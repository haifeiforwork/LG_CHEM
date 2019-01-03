package hris.D.D01OT;

/********************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 초과근무                                                    */
/*   Program Name : 초과근무                                                    */
/*   Program ID   : D01OTRealWorkDATA                                           */
/*   Description  : 실근무시간을 담는 데이터 ( 사무직 )                                                      */
/*   Note         : [관련 RFC] : ZGHR_RFC_NTM_REALWORK_LIST                     */
/*   Creation     : 2018-05-18  강동민                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

@SuppressWarnings("serial")
public class D01OTRealWorkDATA extends com.sns.jdf.EntityData {

    public String PERNR;    // 사원번호

    public String BASTM;    // 기본근무시간
    public String MAXTM;    // 법정최대근무시간
    public String PWDWK;    // 평일 근무시간
    public String PWEWK;    // 평일 근무시간_회사
    public String CWDWK;    // 주말/휴일 근무시간
    public String CWEWK;    // 주말/휴일 근무시간_회사
    public String PWTOT;    // 계
    public String CWTOT;    // 계_회사
    public String RWKTM;    // 실근무시간

    // 현장직
    public String WKLMT;    // 근무한도
    public String NORTM;    // 정상근무시간
    public String OVRTM;    // 초과근무시간
    public String BRKTM;    // 휴게시간
    public String NWKTM;    // 비근무시간

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