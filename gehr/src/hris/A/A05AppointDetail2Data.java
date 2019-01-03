package hris.A ;

/**
 * A05AppointDetail2Data.java
 *  사원의 승급사항 내역을 담는 데이터
 *   [관련 RFC] : ZHRH_RFC_GET_IT0008
 * 
 * @author 한성덕
 * @version 1.0, 2001/12/17
 */
public class A05AppointDetail2Data extends com.sns.jdf.EntityData {

    public String 	PREAS	;//	CHAR	2	마스터 데이터 변경 사유
    public String 	RTEXT	;//	CHAR	30	승급구분
    public String 	BEGDA	;//	DATS	8	승급일자
    public String 	TRFGR	;//	CHAR	8	직급
    public String 	TRFST	;//	CHAR	2	호봉
    public String 	VGLGR	;//	CHAR	2	비교그룹
    public String 	VGLST	;//	CHAR	2	비교급여범위레벨
    public String 	G_FLAG	;//	CHAR	1	일반표시

    public String getPREAS() {
        return PREAS;
    }

    public void setPREAS(String PREAS) {
        this.PREAS = PREAS;
    }

    public String getRTEXT() {
        return RTEXT;
    }

    public void setRTEXT(String RTEXT) {
        this.RTEXT = RTEXT;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getTRFGR() {
        return TRFGR;
    }

    public void setTRFGR(String TRFGR) {
        this.TRFGR = TRFGR;
    }

    public String getTRFST() {
        return TRFST;
    }

    public void setTRFST(String TRFST) {
        this.TRFST = TRFST;
    }

    public String getVGLGR() {
        return VGLGR;
    }

    public void setVGLGR(String VGLGR) {
        this.VGLGR = VGLGR;
    }

    public String getVGLST() {
        return VGLST;
    }

    public void setVGLST(String VGLST) {
        this.VGLST = VGLST;
    }

    public String getG_FLAG() {
        return G_FLAG;
    }

    public void setG_FLAG(String g_FLAG) {
        G_FLAG = g_FLAG;
    }
}
