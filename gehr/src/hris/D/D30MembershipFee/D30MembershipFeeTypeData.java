package hris.D.D30MembershipFee;

import com.sns.jdf.EntityData;

/**
 * Created by manyjung on 2016-10-11.
 */
public class D30MembershipFeeTypeData extends EntityData {

    public String	MGART	;//	CHAR	4	Member type
    public String	MGTXT	;//	CHAR	40	Member type name
    public String	LGART	;//	CHAR	4	Wage Type
    public String	BETRG	;//	CURR	9	Amount

    public String getMGART() {
        return MGART;
    }

    public void setMGART(String MGART) {
        this.MGART = MGART;
    }

    public String getMGTXT() {
        return MGTXT;
    }

    public void setMGTXT(String MGTXT) {
        this.MGTXT = MGTXT;
    }

    public String getLGART() {
        return LGART;
    }

    public void setLGART(String LGART) {
        this.LGART = LGART;
    }

    public String getBETRG() {
        return BETRG;
    }

    public void setBETRG(String BETRG) {
        this.BETRG = BETRG;
    }
}
