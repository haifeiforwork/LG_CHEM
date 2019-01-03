package hris.A;

import com.sns.jdf.EntityData;

/**
 * Created by manyjung on 2016-12-19.
 */
public class PersonalCardInterfacePersonData extends EntityData {

    public String 	PERNR	;//	NUMC	8	��� ��ȣ	�����
    public String 	WB01	=   "X";//	CHAR	1	�λ�⺻		ZGHR_RFC_PERSONEL_HEADER
    public String 	WB02	=   "X";//	CHAR	1	�з»���		ZGHR_RFC_EDUCATION_LIST
    public String 	WB02GRAD	;//	CHAR	1	�������� ǥ��		ZGHR_RFC_EDUCATION_LIST		I_GRAD
    public String 	WB03	=   "X";//	CHAR	1	���дɷ�		ZGHR_RFC_LANGUAGE_ABILITY
    public String 	WB04	=   "X";//	CHAR	1	�ڰݸ���		ZGHR_RFC_LICENSE_LIST
    public String 	WB05	=   "X";//	CHAR	1	��»���		ZGHR_RFC_CAREER_LIST
    public String 	WS01	=   "X";//	CHAR	1	�򰡻���		ZGHR_RFC_APPRAISAL_LIST
    public String 	WS02	=   "X";//	CHAR	1	�߷ɻ���		ZGHR_RFC_ACTION_LIST
    public String 	WS02ORG	;//	CHAR	1	�߷ɴ�ü������Ī		ZGHR_RFC_ACTION_LIST		I_CFORG
    public String 	WS03	=   "X";//	CHAR	1	�ؿܰ���		ZGHR_RFC_GET_TRIP_FORMS
    public String 	WS04	=   "X";//	CHAR	1	�ٽ�����		ZGHR_RFC_CORE_TALENTED
    public String 	WS05	=   "X";//	CHAR	1	�����̷�		ZGHR_RFC_TRAINING_LIST
    public String 	WS05MAN	;//	CHAR	1	�ֿ䱳���̷�		ZGHR_RFC_TRAINING_LIST		I_CFMAN
    public String 	WS06	=   "X";//	CHAR	1	����		ZGHR_RFC_AWARD_LIST
    public String 	WS06MAN	;//	CHAR	1	�ֿ�����		ZGHR_RFC_AWARD_LIST		I_CFMAN
    public String 	WS06REC	;//	CHAR	1	�ֱ�����		ZGHR_RFC_AWARD_LIST		I_CFREC
    public String 	WS07	=   "X";//	CHAR	 1 	¡��		ZGHR_RFC_DISCIPLINARY_LIST
    public String 	WS07FLG	;//	CHAR	 1 	¡����� FLAG		ZGHR_RFC_DISCIPLINARY_LIST		IM_FLAG
    public String 	WS08	=   "X";//	CHAR	 1 	�ּ� �� �Ż�		ZGHR_RFC_PERSON_ADDINFO_KR				ZGHR_RFC_PERSONEL_EXTRA(�ؿ�)
    public String 	WS09	=   "X";//	CHAR	 1 	��������		ZGHR_RFC_FAMILY_LIST
    public String 	WS09EDU	;//	CHAR	 1 	�����з»���		ZGHR_RFC_FAMILY_LIST		I_CFEDU
    public String 	WS10	=   "X";//	CHAR	 1 	��������		ZGHR_RFC_MILITARY_LIST_KR

    public String ENAME;

    public String getENAME() {
        return ENAME;
    }

    public void setENAME(String ENAME) {
        this.ENAME = ENAME;
    }

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getWB01() {
        return WB01;
    }

    public void setWB01(String WB01) {
        this.WB01 = WB01;
    }

    public String getWB02() {
        return WB02;
    }

    public void setWB02(String WB02) {
        this.WB02 = WB02;
    }

    public String getWB02GRAD() {
        return WB02GRAD;
    }

    public void setWB02GRAD(String WB02GRAD) {
        this.WB02GRAD = WB02GRAD;
    }

    public String getWB03() {
        return WB03;
    }

    public void setWB03(String WB03) {
        this.WB03 = WB03;
    }

    public String getWB04() {
        return WB04;
    }

    public void setWB04(String WB04) {
        this.WB04 = WB04;
    }

    public String getWB05() {
        return WB05;
    }

    public void setWB05(String WB05) {
        this.WB05 = WB05;
    }

    public String getWS01() {
        return WS01;
    }

    public void setWS01(String WS01) {
        this.WS01 = WS01;
    }

    public String getWS02() {
        return WS02;
    }

    public void setWS02(String WS02) {
        this.WS02 = WS02;
    }

    public String getWS02ORG() {
        return WS02ORG;
    }

    public void setWS02ORG(String WS02ORG) {
        this.WS02ORG = WS02ORG;
    }

    public String getWS03() {
        return WS03;
    }

    public void setWS03(String WS03) {
        this.WS03 = WS03;
    }

    public String getWS04() {
        return WS04;
    }

    public void setWS04(String WS04) {
        this.WS04 = WS04;
    }

    public String getWS05() {
        return WS05;
    }

    public void setWS05(String WS05) {
        this.WS05 = WS05;
    }

    public String getWS05MAN() {
        return WS05MAN;
    }

    public void setWS05MAN(String WS05MAN) {
        this.WS05MAN = WS05MAN;
    }

    public String getWS06() {
        return WS06;
    }

    public void setWS06(String WS06) {
        this.WS06 = WS06;
    }

    public String getWS06MAN() {
        return WS06MAN;
    }

    public void setWS06MAN(String WS06MAN) {
        this.WS06MAN = WS06MAN;
    }

    public String getWS06REC() {
        return WS06REC;
    }

    public void setWS06REC(String WS06REC) {
        this.WS06REC = WS06REC;
    }

    public String getWS07() {
        return WS07;
    }

    public void setWS07(String WS07) {
        this.WS07 = WS07;
    }

    public String getWS07FLG() {
        return WS07FLG;
    }

    public void setWS07FLG(String WS07FLG) {
        this.WS07FLG = WS07FLG;
    }

    public String getWS08() {
        return WS08;
    }

    public void setWS08(String WS08) {
        this.WS08 = WS08;
    }

    public String getWS09() {
        return WS09;
    }

    public void setWS09(String WS09) {
        this.WS09 = WS09;
    }

    public String getWS09EDU() {
        return WS09EDU;
    }

    public void setWS09EDU(String WS09EDU) {
        this.WS09EDU = WS09EDU;
    }

    public String getWS10() {
        return WS10;
    }

    public void setWS10(String WS10) {
        this.WS10 = WS10;
    }
}
