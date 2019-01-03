package hris.A;

import com.sns.jdf.EntityData;

/**
 * Created by manyjung on 2016-10-26.
 */
public class A01SelTalentData extends EntityData {

    public String 	PERNR	;//	NUMC	8	사원 번호
    public String 	SUBTY	;//	CHAR	4	하위 유형
    public String 	STEXT	;//	CHAR	40	하위 유형 이름
    public String 	ENDDA	;//	DATS	8	종료일
    public String 	BEGDA	;//	DATS	8	시작일
    public String 	RES_DEVE	;//	CHAR	10	육성결과
    public String 	LANDX	;//	CHAR	15	국가 이름
    public String 	SORT	;//	NUMC	2	SORT 순서

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getSUBTY() {
        return SUBTY;
    }

    public void setSUBTY(String SUBTY) {
        this.SUBTY = SUBTY;
    }

    public String getSTEXT() {
        return STEXT;
    }

    public void setSTEXT(String STEXT) {
        this.STEXT = STEXT;
    }

    public String getENDDA() {
        return ENDDA;
    }

    public void setENDDA(String ENDDA) {
        this.ENDDA = ENDDA;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getRES_DEVE() {
        return RES_DEVE;
    }

    public void setRES_DEVE(String RES_DEVE) {
        this.RES_DEVE = RES_DEVE;
    }

    public String getLANDX() {
        return LANDX;
    }

    public void setLANDX(String LANDX) {
        this.LANDX = LANDX;
    }

    public String getSORT() {
        return SORT;
    }

    public void setSORT(String SORT) {
        this.SORT = SORT;
    }
}
