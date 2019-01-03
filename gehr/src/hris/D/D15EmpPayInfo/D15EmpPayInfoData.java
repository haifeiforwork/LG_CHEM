package hris.D.D15EmpPayInfo;

import com.sns.jdf.EntityData;
import com.sns.jdf.util.DataUtil;

public class D15EmpPayInfoData extends EntityData {
    public String PERNR;    //사원 번호
    public String ENAME;    //사원 또는 지원자의 포맷된 이름
    public String BEGDA;    //시작일
    public String LGART;    //임금 유형
    public String ANZHL;    //수
    public String BETRG;    //지급의 임금 유형 금액
    public String LGTXT;    //임금 유형 설명

    public String getLocalBETRG() {
        return DataUtil.changeLocalAmount(BETRG, "KRW");
    }
    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getENAME() {
        return ENAME;
    }

    public void setENAME(String ENAME) {
        this.ENAME = ENAME;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getLGART() {
        return LGART;
    }

    public void setLGART(String LGART) {
        this.LGART = LGART;
    }

    public String getANZHL() {
        return ANZHL;
    }

    public void setANZHL(String ANZHL) {
        this.ANZHL = ANZHL;
    }

    public String getBETRG() {
        return BETRG;
    }

    public void setBETRG(String BETRG) {
        this.BETRG = BETRG;
    }

    public String getLGTXT() {
        return LGTXT;
    }

    public void setLGTXT(String LGTXT) {
        this.LGTXT = LGTXT;
    }
}
