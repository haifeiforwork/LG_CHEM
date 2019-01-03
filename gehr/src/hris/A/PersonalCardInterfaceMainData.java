package hris.A;

import com.sns.jdf.EntityData;

/**
 * Created by manyjung on 2016-12-19.
 */
public class PersonalCardInterfaceMainData extends EntityData {

    public String 	LOGPER	;//	CHAR	12	사용자	접속자 사번
    public String 	PCH1    = "X"	;//	CHAR	1	1 page 출력
    public String 	PCH2    = "X"	;//	CHAR	1	2 page 출력
    public String 	PCH3    = "X"	;//	CHAR	1	3 page 출력
    public String 	PCH4    = "X"	;//	CHAR	1	4 page 출력

    public String getLOGPER() {
        return LOGPER;
    }

    public void setLOGPER(String LOGPER) {
        this.LOGPER = LOGPER;
    }

    public String getPCH1() {
        return PCH1;
    }

    public void setPCH1(String PCH1) {
        this.PCH1 = PCH1;
    }

    public String getPCH2() {
        return PCH2;
    }

    public void setPCH2(String PCH2) {
        this.PCH2 = PCH2;
    }

    public String getPCH3() {
        return PCH3;
    }

    public void setPCH3(String PCH3) {
        this.PCH3 = PCH3;
    }

    public String getPCH4() {
        return PCH4;
    }

    public void setPCH4(String PCH4) {
        this.PCH4 = PCH4;
    }
}
