/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : 인원현황
*   Program Name : 부서별 연명부
*   Program ID   : F21DeptEntireEmpInfoData.java
*   Description  : 부서별 연명부 검색을 위한 DATA 파일
*   Note         : 없음
*   Creation     :
*   Update       :
********************************************************************************/

package hris.F;

/**
 * F21DeptEntireEmpInfoData.java
 *  부서별 연명부 내용을 담는 데이터
 *   [관련 RFC] :
 * @author
 * @version 1.0
 */
public class F21DeptEntireEmpInfoData extends com.sns.jdf.EntityData {
	public String PERNR	;	    //사원 번호
	public String ORGTX	;	    //소속명
	public String CNAME1;		//성명(조합)
	public String CNAME2;		//성명(조합)
	public String NAME1	;	    //회사
	public String BTEXT	;	 	//근무지
	public String PGTXT	;	 	//신분그룹PERSK
	public String PKTXT	;	 	//신분
	public String STLTX	;	 	//직무명
	public String DAT01	;		//그룹입사일
	public String DAT02	;		//회사입사일
	public String DAT03	;		//현직위승진일
	public String DAT04	;		//근속기준일
	public String JIKWT	;	 	//직위명
	public String JIKKT	;	 	//직책명
	public String VGLST	;	 	//직급/년차
	public String MGTXT	;	 	//발령 사유 이름
	public String SLABS	;	 	//입사시학력
	public String NATIO	;	 	//국적
	public String LANDX	;	 	//국적명
	public String GBDAT	;		//생년월일
	public String AGECN	;		//연령
	public String TRFGR	;		//호봉 그룹
	public String TRFST	;		//호봉 단계
	public String VGLST2;	  	//비교급여범위레벨
	public String BUKRS	;		//회사코드
	public String PHOTO	;		//사진URL
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getORGTX() {
		return ORGTX;
	}
	public void setORGTX(String oRGTX) {
		ORGTX = oRGTX;
	}
	public String getCNAME1() {
		return CNAME1;
	}
	public void setCNAME1(String cNAME1) {
		CNAME1 = cNAME1;
	}
	public String getCNAME2() {
		return CNAME2;
	}
	public void setCNAME2(String cNAME2) {
		CNAME2 = cNAME2;
	}
	public String getNAME1() {
		return NAME1;
	}
	public void setNAME1(String nAME1) {
		NAME1 = nAME1;
	}
	public String getBTEXT() {
		return BTEXT;
	}
	public void setBTEXT(String bTEXT) {
		BTEXT = bTEXT;
	}
	public String getPGTXT() {
		return PGTXT;
	}
	public void setPGTXT(String pGTXT) {
		PGTXT = pGTXT;
	}
	public String getPKTXT() {
		return PKTXT;
	}
	public void setPKTXT(String pKTXT) {
		PKTXT = pKTXT;
	}
	public String getSTLTX() {
		return STLTX;
	}
	public void setSTLTX(String sTLTX) {
		STLTX = sTLTX;
	}
	public String getDAT01() {
		return DAT01;
	}
	public void setDAT01(String dAT01) {
		DAT01 = dAT01;
	}
	public String getDAT02() {
		return DAT02;
	}
	public void setDAT02(String dAT02) {
		DAT02 = dAT02;
	}
	public String getDAT03() {
		return DAT03;
	}
	public void setDAT03(String dAT03) {
		DAT03 = dAT03;
	}
	public String getDAT04() {
		return DAT04;
	}
	public void setDAT04(String dAT04) {
		DAT04 = dAT04;
	}
	public String getJIKWT() {
		return JIKWT;
	}
	public void setJIKWT(String jIKWT) {
		JIKWT = jIKWT;
	}
	public String getJIKKT() {
		return JIKKT;
	}
	public void setJIKKT(String jIKKT) {
		JIKKT = jIKKT;
	}
	public String getVGLST() {
		return VGLST;
	}
	public void setVGLST(String vGLST) {
		VGLST = vGLST;
	}
	public String getMGTXT() {
		return MGTXT;
	}
	public void setMGTXT(String mGTXT) {
		MGTXT = mGTXT;
	}
	public String getSLABS() {
		return SLABS;
	}
	public void setSLABS(String sLABS) {
		SLABS = sLABS;
	}
	public String getNATIO() {
		return NATIO;
	}
	public void setNATIO(String nATIO) {
		NATIO = nATIO;
	}
	public String getLANDX() {
		return LANDX;
	}
	public void setLANDX(String lANDX) {
		LANDX = lANDX;
	}
	public String getGBDAT() {
		return GBDAT;
	}
	public void setGBDAT(String gBDAT) {
		GBDAT = gBDAT;
	}
	public String getAGECN() {
		return AGECN;
	}
	public void setAGECN(String aGECN) {
		AGECN = aGECN;
	}
	public String getTRFGR() {
		return TRFGR;
	}
	public void setTRFGR(String tRFGR) {
		TRFGR = tRFGR;
	}
	public String getTRFST() {
		return TRFST;
	}
	public void setTRFST(String tRFST) {
		TRFST = tRFST;
	}
	public String getVGLST2() {
		return VGLST2;
	}
	public void setVGLST2(String vGLST2) {
		VGLST2 = vGLST2;
	}
	public String getBUKRS() {
		return BUKRS;
	}
	public void setBUKRS(String bUKRS) {
		BUKRS = bUKRS;
	}
	public String getPHOTO() {
		return PHOTO;
	}
	public void setPHOTO(String pHOTO) {
		PHOTO = pHOTO;
	}
}
