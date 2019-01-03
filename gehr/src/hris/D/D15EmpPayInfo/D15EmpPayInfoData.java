package hris.D.D15EmpPayInfo;

import com.sns.jdf.EntityData;
import com.sns.jdf.util.DataUtil;

public class D15EmpPayInfoData extends EntityData {
    public String PERNR;    //��� ��ȣ
    public String ENAME;    //��� �Ǵ� �������� ���˵� �̸�
    public String BEGDA;    //������
    public String LGART;    //�ӱ� ����
    public String ANZHL;    //��
    public String BETRG;    //������ �ӱ� ���� �ݾ�
    public String LGTXT;    //�ӱ� ���� ����

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
