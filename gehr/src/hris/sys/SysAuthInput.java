/********************************************************************************/
/*   System Name  : 
/*   1Depth Name  : 
/*   2Depth Name  : 
/*   Program Name : 
/*   Program ID   : SysAuthInput.java
/*   Description  : 
/*   Note         : 
/*   Creation     : 2016-08-19 manyjung
/*   Update       : 2018-07-03 유정우 [WorkTime52]
/********************************************************************************/
package hris.sys;

public class SysAuthInput {

    public String I_CHKGB;  // CHAR 1 체크 구분자
    public String I_DEPT;   // NUMC 8 관리자 사원번호
    public String I_PERNR;  // NUMC 8 대상자 사원번호
    public String I_ORGEH;  // NUMC 8 대상 조직
    public String I_AUTHOR; // CHAR 1 권한그룹
    public String I_RETIR;  // CHAR 1 퇴직자 포함
    public String I_GUBUN;  // CHAR 1 조직선택 구분자
    public String I_NTM;    // CHAR 1 [WorkTime52] 신규 로직 여부

    public SysAuthInput() {}

    public SysAuthInput(String I_CHKGB, String I_DEPT, String I_PERNR, String I_ORGEH, String I_AUTHOR, String I_RETIR, String I_GUBUN, String I_NTM) {
        this.I_CHKGB = I_CHKGB;
        this.I_DEPT = I_DEPT;
        this.I_PERNR = I_PERNR;
        this.I_ORGEH = I_ORGEH;
        this.I_AUTHOR = I_AUTHOR;
        this.I_RETIR = I_RETIR;
        this.I_GUBUN = I_GUBUN;
        this.I_NTM = I_NTM;
    }

    public String getI_CHKGB() {
        return I_CHKGB;
    }
    public void setI_CHKGB(String i_CHKGB) {
        I_CHKGB = i_CHKGB;
    }
    public String getI_DEPT() {
        return I_DEPT;
    }
    public void setI_DEPT(String i_DEPT) {
        I_DEPT = i_DEPT;
    }
    public String getI_PERNR() {
        return I_PERNR;
    }
    public void setI_PERNR(String i_PERNR) {
        I_PERNR = i_PERNR;
    }
    public String getI_ORGEH() {
        return I_ORGEH;
    }
    public void setI_ORGEH(String i_ORGEH) {
        I_ORGEH = i_ORGEH;
    }
    public String getI_AUTHOR() {
        return I_AUTHOR;
    }
    public void setI_AUTHOR(String i_AUTHOR) {
        I_AUTHOR = i_AUTHOR;
    }
    public String getI_RETIR() {
        return I_RETIR;
    }
    public void setI_RETIR(String i_RETIR) {
        I_RETIR = i_RETIR;
    }
    public String getI_GUBUN() {
        return I_GUBUN;
    }
    public void setI_GUBUN(String i_GUBUN) {
        I_GUBUN = i_GUBUN;
    }

}