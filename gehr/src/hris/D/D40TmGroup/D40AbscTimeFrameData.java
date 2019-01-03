/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   비근무/근무												*/
/*   Program Name	:   비근무/근무												*/
/*   Program ID		: D40RemeInfoEachRFCV.java							*/
/*   Description		: 비근무/근무												*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup;
/**
 * D40AbscTimeFrameData.java
 * 현장직근태-비근무/근무
 * [관련 RFC] :  ZGHR_RFC_TM_AWART
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40AbscTimeFrameData extends com.sns.jdf.EntityData {

	public String EDIT;	//수정가능 레코드 여부
	public String SELECT;	//행 삭제시 선택된 레코드
	public String PERNR;	//사원 번호
	public String ENAME;	//성명
	public String ACTIO;	//인포타입운영
	public String OBEGDA;	//	오리지널-시작일
	public String OENDDA;	//	오리지널-종료일
	public String OWTMCODE;	//	오리지널-근태유형
	public String OAWART;	//	오리지널-근무/휴무 유형
	public String OINFTY;	//	오리지널-인포타입
	public String OBEGUZ;	//	오리지널-시작시간
	public String OENDUZ;	//	오리지널-종료시간
	public String OREASON;	//	오리지널-사유코드
	public String ODETAIL;	//오리지널-상세사유
	public String BEGDA;	//	시작일
	public String ENDDA;	//종료일
	public String WTMCODE;	//근태유형
	public String WTMCODE_TX;	//근태유형명
	public String AWART;	//근무/휴무 유형
	public String AWART_TX;	//근무/휴무 유형 텍스트
	public String INFTY;	//	인포타입
	public String TPROG;	//	일일 근무 일정
	public String BEGUZ;	//시작시간
	public String ENDUZ;	//	종료시간
	public String REASON;	//사유코드
	public String REASON_TX;	//사유코드명
	public String DETAIL;	//상세사유
	public String REASON_YN;	//사유코드 필수여부
	public String DETAIL_YN;	//상세사유 필수여부
	public String TIME_YN;	//	시간입력 필수여부
	public String ORGEH;	//조직 단위
	public String PERSG;	//사원 그룹
	public String SHORT;	//오브젝트 약어
	public String ETC	;	//Char255
	public String MSG;	//메시지 텍스트
	public String OSEQNR;	//

	public String OBJID;
	public String PKEY;	//CODE
	public String CODE;	//CODE
	public String TEXT;	//TEXT
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
	public String getACTIO() {
		return ACTIO;
	}
	public void setACTIO(String aCTIO) {
		ACTIO = aCTIO;
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
	public String getOWTMCODE() {
		return OWTMCODE;
	}
	public void setOWTMCODE(String oWTMCODE) {
		OWTMCODE = oWTMCODE;
	}
	public String getOAWART() {
		return OAWART;
	}
	public void setOAWART(String oAWART) {
		OAWART = oAWART;
	}
	public String getOINFTY() {
		return OINFTY;
	}
	public void setOINFTY(String oINFTY) {
		OINFTY = oINFTY;
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
	public String getWTMCODE() {
		return WTMCODE;
	}
	public void setWTMCODE(String wTMCODE) {
		WTMCODE = wTMCODE;
	}
	public String getWTMCODE_TX() {
		return WTMCODE_TX;
	}
	public void setWTMCODE_TX(String wTMCODE_TX) {
		WTMCODE_TX = wTMCODE_TX;
	}
	public String getAWART() {
		return AWART;
	}
	public void setAWART(String aWART) {
		AWART = aWART;
	}
	public String getAWART_TX() {
		return AWART_TX;
	}
	public void setAWART_TX(String aWART_TX) {
		AWART_TX = aWART_TX;
	}
	public String getINFTY() {
		return INFTY;
	}
	public void setINFTY(String iNFTY) {
		INFTY = iNFTY;
	}
	public String getTPROG() {
		return TPROG;
	}
	public void setTPROG(String tPROG) {
		TPROG = tPROG;
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
	public String getTIME_YN() {
		return TIME_YN;
	}
	public void setTIME_YN(String tIME_YN) {
		TIME_YN = tIME_YN;
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
	public String getPKEY() {
		return PKEY;
	}
	public void setPKEY(String pKEY) {
		PKEY = pKEY;
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
	public String getOBJID() {
		return OBJID;
	}
	public void setOBJID(String oBJID) {
		OBJID = oBJID;
	}
	public String getOSEQNR() {
		return OSEQNR;
	}
	public void setOSEQNR(String oSEQNR) {
		OSEQNR = oSEQNR;
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

