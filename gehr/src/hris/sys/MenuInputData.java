package hris.sys;

import com.sns.jdf.EntityData;

/**
 * Created by manyjung on 2016-08-11.
 */
public class MenuInputData extends EntityData {

    public String 	I_PERNR	;//	 NUMC 	 8 	사원번호
    public String 	I_IP	;//	 CHAR 	 40 	IP
    public String   I_ADMIN;  //	TYPE	CHAR01	                     	전체메뉴 제시
    public String   I_BUKRS;  //	TYPE	BUKRS	                     	회사 코드(전체메뉴시)

    public String menu1;
    public String menu2;
    public String menu3;

    public String getI_PERNR() {
        return I_PERNR;
    }

    public void setI_PERNR(String i_PERNR) {
        I_PERNR = i_PERNR;
    }

    public String getI_IP() {
        return I_IP;
    }

    public void setI_IP(String i_IP) {
        I_IP = i_IP;
    }

    public String getI_ADMIN() {
        return I_ADMIN;
    }

    public void setI_ADMIN(String i_ADMIN) {
        I_ADMIN = i_ADMIN;
    }

    public String getI_BUKRS() {
        return I_BUKRS;
    }

    public void setI_BUKRS(String i_BUKRS) {
        I_BUKRS = i_BUKRS;
    }

    public String getMenu1() {
        return menu1;
    }

    public void setMenu1(String menu1) {
        this.menu1 = menu1;
    }

    public String getMenu2() {
        return menu2;
    }

    public void setMenu2(String menu2) {
        this.menu2 = menu2;
    }

    public String getMenu3() {
        return menu3;
    }

    public void setMenu3(String menu3) {
        this.menu3 = menu3;
    }
}
