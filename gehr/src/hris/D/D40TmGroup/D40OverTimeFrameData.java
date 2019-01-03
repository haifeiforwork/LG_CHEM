/********************************************************************************/
/*																				*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:  부서근태												*/
/*   2Depth Name		:  초과근무												*/
/*   Program Name	:  초과근무													*/
/*   Program ID		:  D40OrganInsertData.java									*/
/*   Description		:  초과근무 												*/
/*   Note				:             											*/
/*   Creation			:  2017-12-08  정준현                                         */
/*   Update				:  2017-12-08  정준현                                         */
/* 						:  2018-04-17 cykim  [CSR ID:3660625] 현장직 Web 근태 시스템 수정 요청  */
/* 						:  2018-06-18 성환희  [Worktime52] 						*/
/*                                                                              */
/********************************************************************************/

package hris.D.D40TmGroup;
/**
 * D40OverTimeFrameData.java
 * 현장직근태-초과근무
 * [관련 RFC] :  ZGHR_RFC_TM_OVERTIME
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40OverTimeFrameData extends com.sns.jdf.EntityData {

	public String EDIT;	//수정가능 'X'
	public String SELECT;	//	선택된 데이터
	public String PERNR;	//사원 번호
	public String ENAME;	//성명
	public String BEGDA;	//시작일
	public String ENDDA;	//종료일
	public String BEGUZ;	//시작시간
	public String ENDUZ;	//종료시간
	public String STDAZ;	//근무시간
	public String PBEG1;	//휴식시작1
	public String PEND1;	//휴식종료1
	public String PBEG2;	//휴식시작2
	public String PEND2;	//휴식종료2
	public String VTKEN;	//일전일
	public String TPROG;	//일일 근무 일정
	public String REASON;	//근태사유-코드
	public String REASON_TX;	//근태사유-텍스트
	public String DETAIL;	//상세사유 텍스트 입력
	public String REASON_YN;	//근태사유 필수여부
	public String DETAIL_YN;	//상세사유 필수여부
	public String ORGEH;	//조직단위
	public String PERSG;	//사원그룹
	public String SHORT;	//오브젝트 약어
	public String ETC;	//비고
	public String MSG;	//메시지
	public String WWKTM;	// 총근무시간(주)

	public String OSEQNR;
	public String OBEGDA;
	public String OENDDA;
	public String OBEGUZ;
	public String OENDUZ;
	public String OPBEG1;
	public String OPEND1;
	public String OPBEG2;
	public String OPEND2;
	//[CSR ID:3660625] 현장직 Web 근태 시스템 수정 요청 start
	public String OVTKEN;
	//[CSR ID:3660625] 현장직 Web 근태 시스템 수정 요청 end
	public String ACTIO;
	public String OREASON;	//근태사유-코드
	public String ODETAIL;	//상세사유 텍스트 입력

	public String  OBJID;
	public String  CODE;
	public String  TEXT;
	public String  PKEY;
	public String  USEYN;	//사유코드 필수여부
	public String  USECYN;	//상세사유 필수여부

	public String  A;
	public String  B;
	public String  C;
	public String  D;
	public String  E;
	public String  F;
	public String  G;
	public String  H;
	public String  I;
	public String  J;
	public String  K;
	public String  L;
	public String  M;
	public String  N;
	public String  O;
	public String  P;
	public String  Q;
	public String  R;
	public String  S;
	public String  T;
	public String  U;
	public String  V;
	public String  W;
	public String  X;
	public String  Y;
	public String  Z;
	public String getEDIT() {
		return EDIT;
	}
	public void setEDIT(String eDIT) {
		EDIT = eDIT;
	}
	public String getSELECT() {
		return SELECT;
	}
	public void setSELECT(String sELECT) {
		SELECT = sELECT;
	}
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getENAME() {
		return ENAME;
	}
	public void setENAME(String eNAME) {
		ENAME = eNAME;
	}
	public String getBEGDA() {
		return BEGDA;
	}
	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}
	public String getENDDA() {
		return ENDDA;
	}
	public void setENDDA(String eNDDA) {
		ENDDA = eNDDA;
	}
	public String getBEGUZ() {
		return BEGUZ;
	}
	public void setBEGUZ(String bEGUZ) {
		BEGUZ = bEGUZ;
	}
	public String getENDUZ() {
		return ENDUZ;
	}
	public void setENDUZ(String eNDUZ) {
		ENDUZ = eNDUZ;
	}
	public String getSTDAZ() {
		return STDAZ;
	}
	public void setSTDAZ(String sTDAZ) {
		STDAZ = sTDAZ;
	}
	public String getPBEG1() {
		return PBEG1;
	}
	public void setPBEG1(String pBEG1) {
		PBEG1 = pBEG1;
	}
	public String getPEND1() {
		return PEND1;
	}
	public void setPEND1(String pEND1) {
		PEND1 = pEND1;
	}
	public String getPBEG2() {
		return PBEG2;
	}
	public void setPBEG2(String pBEG2) {
		PBEG2 = pBEG2;
	}
	public String getPEND2() {
		return PEND2;
	}
	public void setPEND2(String pEND2) {
		PEND2 = pEND2;
	}
	public String getVTKEN() {
		return VTKEN;
	}
	public void setVTKEN(String vTKEN) {
		VTKEN = vTKEN;
	}
	public String getTPROG() {
		return TPROG;
	}
	public void setTPROG(String tPROG) {
		TPROG = tPROG;
	}
	public String getREASON() {
		return REASON;
	}
	public void setREASON(String rEASON) {
		REASON = rEASON;
	}
	public String getREASON_TX() {
		return REASON_TX;
	}
	public void setREASON_TX(String rEASON_TX) {
		REASON_TX = rEASON_TX;
	}
	public String getDETAIL() {
		return DETAIL;
	}
	public void setDETAIL(String dETAIL) {
		DETAIL = dETAIL;
	}
	public String getREASON_YN() {
		return REASON_YN;
	}
	public void setREASON_YN(String rEASON_YN) {
		REASON_YN = rEASON_YN;
	}
	public String getDETAIL_YN() {
		return DETAIL_YN;
	}
	public void setDETAIL_YN(String dETAIL_YN) {
		DETAIL_YN = dETAIL_YN;
	}
	public String getORGEH() {
		return ORGEH;
	}
	public void setORGEH(String oRGEH) {
		ORGEH = oRGEH;
	}
	public String getPERSG() {
		return PERSG;
	}
	public void setPERSG(String pERSG) {
		PERSG = pERSG;
	}
	public String getSHORT() {
		return SHORT;
	}
	public void setSHORT(String sHORT) {
		SHORT = sHORT;
	}
	public String getETC() {
		return ETC;
	}
	public void setETC(String eTC) {
		ETC = eTC;
	}
	public String getMSG() {
		return MSG;
	}
	public void setMSG(String mSG) {
		MSG = mSG;
	}
	public String getWWKTM() {
		return WWKTM;
	}
	public void setWWKTM(String wWKTM) {
		WWKTM = wWKTM;
	}
	public String getOSEQNR() {
		return OSEQNR;
	}
	public void setOSEQNR(String oSEQNR) {
		OSEQNR = oSEQNR;
	}
	public String getOBEGDA() {
		return OBEGDA;
	}
	public void setOBEGDA(String oBEGDA) {
		OBEGDA = oBEGDA;
	}
	public String getOENDDA() {
		return OENDDA;
	}
	public void setOENDDA(String oENDDA) {
		OENDDA = oENDDA;
	}
	public String getOBEGUZ() {
		return OBEGUZ;
	}
	public void setOBEGUZ(String oBEGUZ) {
		OBEGUZ = oBEGUZ;
	}
	public String getOENDUZ() {
		return OENDUZ;
	}
	public void setOENDUZ(String oENDUZ) {
		OENDUZ = oENDUZ;
	}
	public String getOPBEG1() {
		return OPBEG1;
	}
	public void setOPBEG1(String oPBEG1) {
		OPBEG1 = oPBEG1;
	}
	public String getOPEND1() {
		return OPEND1;
	}
	public void setOPEND1(String oPEND1) {
		OPEND1 = oPEND1;
	}
	public String getOPBEG2() {
		return OPBEG2;
	}
	public void setOPBEG2(String oPBEG2) {
		OPBEG2 = oPBEG2;
	}
	public String getOPEND2() {
		return OPEND2;
	}
	public void setOPEND2(String oPEND2) {
		OPEND2 = oPEND2;
	}
	public String getOVTKEN() {
		return OVTKEN;
	}
	public void setOVTKEN(String oVTKEN) {
		OVTKEN = oVTKEN;
	}
	public String getACTIO() {
		return ACTIO;
	}
	public void setACTIO(String aCTIO) {
		ACTIO = aCTIO;
	}
	public String getOREASON() {
		return OREASON;
	}
	public void setOREASON(String oREASON) {
		OREASON = oREASON;
	}
	public String getODETAIL() {
		return ODETAIL;
	}
	public void setODETAIL(String oDETAIL) {
		ODETAIL = oDETAIL;
	}
	public String getOBJID() {
		return OBJID;
	}
	public void setOBJID(String oBJID) {
		OBJID = oBJID;
	}
	public String getCODE() {
		return CODE;
	}
	public void setCODE(String cODE) {
		CODE = cODE;
	}
	public String getTEXT() {
		return TEXT;
	}
	public void setTEXT(String tEXT) {
		TEXT = tEXT;
	}
	public String getPKEY() {
		return PKEY;
	}
	public void setPKEY(String pKEY) {
		PKEY = pKEY;
	}
	public String getA() {
		return A;
	}
	public void setA(String a) {
		A = a;
	}
	public String getB() {
		return B;
	}
	public void setB(String b) {
		B = b;
	}
	public String getC() {
		return C;
	}
	public void setC(String c) {
		C = c;
	}
	public String getD() {
		return D;
	}
	public void setD(String d) {
		D = d;
	}
	public String getE() {
		return E;
	}
	public void setE(String e) {
		E = e;
	}
	public String getF() {
		return F;
	}
	public void setF(String f) {
		F = f;
	}
	public String getG() {
		return G;
	}
	public void setG(String g) {
		G = g;
	}
	public String getH() {
		return H;
	}
	public void setH(String h) {
		H = h;
	}
	public String getI() {
		return I;
	}
	public void setI(String i) {
		I = i;
	}
	public String getJ() {
		return J;
	}
	public void setJ(String j) {
		J = j;
	}
	public String getK() {
		return K;
	}
	public void setK(String k) {
		K = k;
	}
	public String getL() {
		return L;
	}
	public void setL(String l) {
		L = l;
	}
	public String getM() {
		return M;
	}
	public void setM(String m) {
		M = m;
	}
	public String getN() {
		return N;
	}
	public void setN(String n) {
		N = n;
	}
	public String getO() {
		return O;
	}
	public void setO(String o) {
		O = o;
	}
	public String getP() {
		return P;
	}
	public void setP(String p) {
		P = p;
	}
	public String getQ() {
		return Q;
	}
	public void setQ(String q) {
		Q = q;
	}
	public String getR() {
		return R;
	}
	public void setR(String r) {
		R = r;
	}
	public String getS() {
		return S;
	}
	public void setS(String s) {
		S = s;
	}
	public String getT() {
		return T;
	}
	public void setT(String t) {
		T = t;
	}
	public String getU() {
		return U;
	}
	public void setU(String u) {
		U = u;
	}
	public String getV() {
		return V;
	}
	public void setV(String v) {
		V = v;
	}
	public String getW() {
		return W;
	}
	public void setW(String w) {
		W = w;
	}
	public String getX() {
		return X;
	}
	public void setX(String x) {
		X = x;
	}
	public String getY() {
		return Y;
	}
	public void setY(String y) {
		Y = y;
	}
	public String getZ() {
		return Z;
	}
	public void setZ(String z) {
		Z = z;
	}
	public String getUSEYN() {
		return USEYN;
	}
	public void setUSEYN(String uSEYN) {
		USEYN = uSEYN;
	}
	public String getUSECYN() {
		return USECYN;
	}
	public void setUSECYN(String uSECYN) {
		USECYN = uSECYN;
	}





}

