/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 사원평가                                                    */
/*   Program Name : 평가사항 조회                                               */
/*   Program ID   : B01ValuateDetailData                                        */
/*   Description  : 사원의 평가 사항을 담는 데이터                              */
/*   Note         : [관련 RFC] : ZHRD_RFC_APPRAISAL_LIST                        */
/*   Creation     : 2002-01-14  한성덕                                          */
/*   Update       : 2005-01-10  윤정현                                          */
/*                  2005-12-29  lsa                                           */
/*                     2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 */
/********************************************************************************/

package hris.B ;

import com.sns.jdf.util.DataUtil;

public class B01ValuateDetailData extends com.sns.jdf.EntityData {

    /* 해외 */
    public String 	ZYEAR	;//	CHAR	4	Year
    public String 	BEGDA	;//	DATS	8	Earliest appraisal date
    public String 	ENDDA	;//	DATS	8	Latest appraisal date
    public String 	PERIOD	;//	CHAR	25	Year end Evaluation
    public String 	ORGEH	;//	NUMC	8	Organizational Unit
//  공통 필드    public String 	ORGTX	;//	CHAR	40	Object Name
    public String 	JILVL	;//	CHAR	20	Level + Annual
    public String 	RTEXT	;//	CHAR	40	Rating text of an appraisal element
    public String 	RATING	;//	DEC	 15,2 	rating

    public String JIKCT;

    /* 국내 */
    public String L_FLAG   ;      // ESS 년도에 링크를 걸어줄 것인지 여부

    public String 	YEAR1	;//	CHAR	10	년도
    public String 	ORGTX	;//	CHAR	40	오브젝트 이름
    public String 	PTEXT	;//	CHAR	20	사원 하위 그룹 이름
    public String 	TITEL	;//	CHAR	15	제목
    public String 	TRFGR	;//	CHAR	8	호봉 그룹
    public String 	RATING4	;//	CHAR	20	본인업적평가
    public String 	RATING5	;//	CHAR	20	상사업적평가
    public String 	RATING6	;//	CHAR	20	난이도/기여도
    public String 	RATING8	;//	CHAR	 20 	노경
    public String 	RATING9	;//	CHAR	 20 	안전환경
    public String 	RATING7	;//	CHAR	 20 	계
    public String 	RATING1	;//	CHAR	 20 	능력
    public String 	RATING2	;//	CHAR	 20 	태도
    public String 	RATING3	;//	CHAR	 20 	부하육성
    public String 	TOTL	;//	CHAR	 20 	종합
    public String 	RTEXT1	;//	CHAR	 19 	평가요소평가
    public String 	BOSS_NAME	;//	CHAR	 40 	오브젝트 이름
    public String 	RATING10	;//	CHAR	 20 	우수인재 확보/유지 KPI
    public String 	RATING11	;//	CHAR	 20 	역량
    public String 	RATING12	;//	CHAR	 20 	HR INDEX 계

   //[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 START
    public String   TITL2		;// 직책

    public String getTITL2() {
		return TITL2;
	}

	public void setTITL2(String tITL2) {
		TITL2 = tITL2;
	}
	//[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 END
	public String getL_FLAG() {
        return L_FLAG;
    }

    public void setL_FLAG(String l_FLAG) {
        L_FLAG = l_FLAG;
    }

    public String getYEAR1() {
        return YEAR1;
    }

    public void setYEAR1(String YEAR1) {
        this.YEAR1 = YEAR1;
    }

    public String getORGTX() {
        return ORGTX;
    }

    public void setORGTX(String ORGTX) {
        this.ORGTX = ORGTX;
    }

    public String getPTEXT() {
        return PTEXT;
    }

    public void setPTEXT(String PTEXT) {
        this.PTEXT = PTEXT;
    }

    public String getTITEL() {
        return TITEL;
    }

    public void setTITEL(String TITEL) {
        this.TITEL = TITEL;
    }

    public String getTRFGR() {
        return TRFGR;
    }

    public void setTRFGR(String TRFGR) {
        this.TRFGR = TRFGR;
    }

    public String getRATING4() {
        return RATING4;
    }

    public void setRATING4(String RATING4) {
        this.RATING4 = RATING4;
    }

    public String getRATING5() {
        return RATING5;
    }

    public void setRATING5(String RATING5) {
        this.RATING5 = RATING5;
    }

    public String getRATING6() {
        return RATING6;
    }

    public void setRATING6(String RATING6) {
        this.RATING6 = RATING6;
    }

    public String getRATING8() {
        return RATING8;
    }

    public void setRATING8(String RATING8) {
        this.RATING8 = RATING8;
    }

    public String getRATING9() {
        return RATING9;
    }

    public void setRATING9(String RATING9) {
        this.RATING9 = RATING9;
    }

    public String getRATING7() {
        return RATING7;
    }

    public void setRATING7(String RATING7) {
        this.RATING7 = RATING7;
    }

    public String getRATING1() {
        return RATING1;
    }

    public void setRATING1(String RATING1) {
        this.RATING1 = RATING1;
    }

    public String getRATING2() {
        return RATING2;
    }

    public void setRATING2(String RATING2) {
        this.RATING2 = RATING2;
    }

    public String getRATING3() {
        return RATING3;
    }

    public void setRATING3(String RATING3) {
        this.RATING3 = RATING3;
    }

    public String getTOTL() {
        return TOTL;
    }

    public void setTOTL(String TOTL) {
        this.TOTL = TOTL;
    }

    public String getRTEXT1() {
        return RTEXT1;
    }

    public void setRTEXT1(String RTEXT1) {
        this.RTEXT1 = RTEXT1;
    }

    public String getBOSS_NAME() {
        return BOSS_NAME;
    }

    public void setBOSS_NAME(String BOSS_NAME) {
        this.BOSS_NAME = BOSS_NAME;
    }

    public String getRATING10() {
        return RATING10;
    }

    public void setRATING10(String RATING10) {
        this.RATING10 = RATING10;
    }

    public String getRATING11() {
        return RATING11;
    }

    public void setRATING11(String RATING11) {
        this.RATING11 = RATING11;
    }

    public String getRATING12() {
        return RATING12;
    }

    public void setRATING12(String RATING12) {
        this.RATING12 = RATING12;
    }


    public double getRating5Value() {
        if (Integer.parseInt(YEAR1) > 1998 &&Integer.parseInt(YEAR1) < 2006 )
            return DataUtil.nelim(Double.parseDouble(RATING5)/0.8/1.125,1);
        else
            return Double.parseDouble(RATING5);
    }

    public String getZYEAR() {
        return ZYEAR;
    }

    public void setZYEAR(String ZYEAR) {
        this.ZYEAR = ZYEAR;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getENDDA() {
        return ENDDA;
    }

    public void setENDDA(String ENDDA) {
        this.ENDDA = ENDDA;
    }

    public String getPERIOD() {
        return PERIOD;
    }

    public void setPERIOD(String PERIOD) {
        this.PERIOD = PERIOD;
    }

    public String getORGEH() {
        return ORGEH;
    }

    public void setORGEH(String ORGEH) {
        this.ORGEH = ORGEH;
    }

    public String getJILVL() {
        return JILVL;
    }

    public void setJILVL(String JILVL) {
        this.JILVL = JILVL;
    }

    public String getRTEXT() {
        return RTEXT;
    }

    public void setRTEXT(String RTEXT) {
        this.RTEXT = RTEXT;
    }

    public String getRATING() {
        return RATING;
    }

    public void setRATING(String RATING) {
        this.RATING = RATING;
    }
}
