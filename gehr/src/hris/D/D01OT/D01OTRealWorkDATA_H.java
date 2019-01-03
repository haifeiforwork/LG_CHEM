package hris.D.D01OT;

/********************************************************************************/
/*                                                                              															   */
/*   System Name  : ESS                                                                                                             */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 초과근무                                                    */
/*   Program Name : 초과근무                                                    */
/*   Program ID     : D01OTRealWorkDATA_H                                           */
/*   Description     : 실근무시간을 담는 데이터 (현장직)               										*/
/*   Note             : [관련 RFC] : ZGHR_RFC_NTM_REALWORK_LIST                     */
/*   Creation         : 2018-05-18  강동민                                          */
/*   Update           :                                                             */
/*                                                                              															   */
/********************************************************************************/

public class D01OTRealWorkDATA_H extends com.sns.jdf.EntityData {

	public String PERNR;					//사원번호
	//현장직
	public String E_BEGDA;				//기간시작일
	public String E_ENDDA;				//기간종료일

	public String WKLMT;				//근무한도
	public String NORTM;				//정상근무시간
	public String OVRTM;				//초과근무시간
	public String BRKTM;				//휴게시간
	public String NWKTM;				//비근무시간
	public String RWKTM;				//실 근로시간
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getE_BEGDA() {
		return E_BEGDA;
	}
	public void setE_BEGDA(String e_BEGDA) {
		E_BEGDA = e_BEGDA;
	}
	public String getE_ENDDA() {
		return E_ENDDA;
	}
	public void setE_ENDDA(String e_ENDDA) {
		E_ENDDA = e_ENDDA;
	}
	public String getWKLMT() {
		return WKLMT;
	}
	public void setWKLMT(String wKLMT) {
		WKLMT = wKLMT;
	}
	public String getNORTM() {
		return NORTM;
	}
	public void setNORTM(String nORTM) {
		NORTM = nORTM;
	}
	public String getOVRTM() {
		return OVRTM;
	}
	public void setOVRTM(String oVRTM) {
		OVRTM = oVRTM;
	}
	public String getBRKTM() {
		return BRKTM;
	}
	public void setBRKTM(String bRKTM) {
		BRKTM = bRKTM;
	}
	public String getNWKTM() {
		return NWKTM;
	}
	public void setNWKTM(String nWKTM) {
		NWKTM = nWKTM;
	}
	public String getRWKTM() {
		return RWKTM;
	}
	public void setRWKTM(String rWKTM) {
		RWKTM = rWKTM;
	}



}