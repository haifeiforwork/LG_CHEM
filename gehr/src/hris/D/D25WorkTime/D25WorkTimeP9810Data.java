package hris.D.D25WorkTime;

/**
 * D25WorkTimeP9810Data.java 2018-08-03 성환희 [WorkTime52] 실 근로시간 레포트
 * 
 * @author 성환희
 * @version 1.0, 2018/08/03
 */
public class D25WorkTimeP9810Data extends com.sns.jdf.EntityData {

	public String PERNR; // 사원 번호
	public String INFTY; // 인포타입
	public String SUBTY; // 하위 유형
	public String OBJPS; // 오브젝트식별
	public String SPRPS; // HR 마스터 데이터 레코드의 잠금 지시자
	public String ENDDA; // 종료일
	public String BEGDA; // 시작일
	public String SEQNR; // 동일한 키를 가진 인포타입 레코드 번호
	public String AEDTM; // 변경일
	public String UNAME; // 오브젝트 변경자 이름
	public String HISTO; // 이력 레코드 표시
	public String ITXEX; // 인포타입에 대한 텍스트가 있습니다
	public String REFEX; // 참조필드가 있습니다 (1차/2차 원가)
	public String ORDEX; // 확정필드있음
	public String ITBLD; // 인포타입 화면 제어
	public String PREAS; // 마스터 데이터 변경 사유
	public String FLAG1; // 예약된 필드/사용하지 않는 필드
	public String FLAG2; // 예약된 필드/사용하지 않는 필드
	public String FLAG3; // 예약된 필드/사용하지 않는 필드
	public String FLAG4; // 예약된 필드/사용하지 않는 필드
	public String RESE1; // 예약된 필드/사용하지 않는 길이 2의 필드
	public String RESE2; // 예약된 필드/사용하지 않는 길이 2의 필드
	public String GRPVL; // 사원 지정에 대한 그루핑 값
	public String WTCAT; // 유연근무 구분
	public String ADJPRD; // 정산기간
	public String ADJUNT; // 정산기간 단위
	public String TWTYP; // 총근로시간 유형
	public String FXTIM; // 고정시간
	public String MAXTIM; // 주 법정최대한도
	public String CTBEG01; // Core Time 시작시간
	public String CTEND01; // Core Time 종료시간
	public String CTBEG02; // Core Time 시작시간
	public String CTEND02; // Core Time 종료시간
	public String GRUP_NUMB; // 사업장
	public String WSQNR; // 근무제유형 순번

	public String getPERNR() {
		return PERNR;
	}

	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}

	public String getINFTY() {
		return INFTY;
	}

	public void setINFTY(String iNFTY) {
		INFTY = iNFTY;
	}

	public String getSUBTY() {
		return SUBTY;
	}

	public void setSUBTY(String sUBTY) {
		SUBTY = sUBTY;
	}

	public String getOBJPS() {
		return OBJPS;
	}

	public void setOBJPS(String oBJPS) {
		OBJPS = oBJPS;
	}

	public String getSPRPS() {
		return SPRPS;
	}

	public void setSPRPS(String sPRPS) {
		SPRPS = sPRPS;
	}

	public String getENDDA() {
		return ENDDA;
	}

	public void setENDDA(String eNDDA) {
		ENDDA = eNDDA;
	}

	public String getBEGDA() {
		return BEGDA;
	}

	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}

	public String getSEQNR() {
		return SEQNR;
	}

	public void setSEQNR(String sEQNR) {
		SEQNR = sEQNR;
	}

	public String getAEDTM() {
		return AEDTM;
	}

	public void setAEDTM(String aEDTM) {
		AEDTM = aEDTM;
	}

	public String getUNAME() {
		return UNAME;
	}

	public void setUNAME(String uNAME) {
		UNAME = uNAME;
	}

	public String getHISTO() {
		return HISTO;
	}

	public void setHISTO(String hISTO) {
		HISTO = hISTO;
	}

	public String getITXEX() {
		return ITXEX;
	}

	public void setITXEX(String iTXEX) {
		ITXEX = iTXEX;
	}

	public String getREFEX() {
		return REFEX;
	}

	public void setREFEX(String rEFEX) {
		REFEX = rEFEX;
	}

	public String getORDEX() {
		return ORDEX;
	}

	public void setORDEX(String oRDEX) {
		ORDEX = oRDEX;
	}

	public String getITBLD() {
		return ITBLD;
	}

	public void setITBLD(String iTBLD) {
		ITBLD = iTBLD;
	}

	public String getPREAS() {
		return PREAS;
	}

	public void setPREAS(String pREAS) {
		PREAS = pREAS;
	}

	public String getFLAG1() {
		return FLAG1;
	}

	public void setFLAG1(String fLAG1) {
		FLAG1 = fLAG1;
	}

	public String getFLAG2() {
		return FLAG2;
	}

	public void setFLAG2(String fLAG2) {
		FLAG2 = fLAG2;
	}

	public String getFLAG3() {
		return FLAG3;
	}

	public void setFLAG3(String fLAG3) {
		FLAG3 = fLAG3;
	}

	public String getFLAG4() {
		return FLAG4;
	}

	public void setFLAG4(String fLAG4) {
		FLAG4 = fLAG4;
	}

	public String getRESE1() {
		return RESE1;
	}

	public void setRESE1(String rESE1) {
		RESE1 = rESE1;
	}

	public String getRESE2() {
		return RESE2;
	}

	public void setRESE2(String rESE2) {
		RESE2 = rESE2;
	}

	public String getGRPVL() {
		return GRPVL;
	}

	public void setGRPVL(String gRPVL) {
		GRPVL = gRPVL;
	}

	public String getWTCAT() {
		return WTCAT;
	}

	public void setWTCAT(String wTCAT) {
		WTCAT = wTCAT;
	}

	public String getADJPRD() {
		return ADJPRD;
	}

	public void setADJPRD(String aDJPRD) {
		ADJPRD = aDJPRD;
	}

	public String getADJUNT() {
		return ADJUNT;
	}

	public void setADJUNT(String aDJUNT) {
		ADJUNT = aDJUNT;
	}

	public String getTWTYP() {
		return TWTYP;
	}

	public void setTWTYP(String tWTYP) {
		TWTYP = tWTYP;
	}

	public String getFXTIM() {
		return FXTIM;
	}

	public void setFXTIM(String fXTIM) {
		FXTIM = fXTIM;
	}

	public String getMAXTIM() {
		return MAXTIM;
	}

	public void setMAXTIM(String mAXTIM) {
		MAXTIM = mAXTIM;
	}

	public String getCTBEG01() {
		return CTBEG01;
	}

	public void setCTBEG01(String cTBEG01) {
		CTBEG01 = cTBEG01;
	}

	public String getCTEND01() {
		return CTEND01;
	}

	public void setCTEND01(String cTEND01) {
		CTEND01 = cTEND01;
	}

	public String getCTBEG02() {
		return CTBEG02;
	}

	public void setCTBEG02(String cTBEG02) {
		CTBEG02 = cTBEG02;
	}

	public String getCTEND02() {
		return CTEND02;
	}

	public void setCTEND02(String cTEND02) {
		CTEND02 = cTEND02;
	}

	public String getGRUP_NUMB() {
		return GRUP_NUMB;
	}

	public void setGRUP_NUMB(String gRUP_NUMB) {
		GRUP_NUMB = gRUP_NUMB;
	}

	public String getWSQNR() {
		return WSQNR;
	}

	public void setWSQNR(String wSQNR) {
		WSQNR = wSQNR;
	}

}
