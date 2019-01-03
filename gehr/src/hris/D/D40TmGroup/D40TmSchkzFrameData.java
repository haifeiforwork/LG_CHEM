/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   계획근무일정												*/
/*   Program Name	:   계획근무일정												*/
/*   Program ID		: D40TmSchkzFrameData.java							*/
/*   Description		: 계획근무일정												*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup;
/**
 * D40TmSchkzFrameData.java
 * 현장직근태-계획근무일정 조회/저장/Excel Template
 * [관련 RFC] :  ZGHR_RFC_TM_SCHKZ
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40TmSchkzFrameData extends com.sns.jdf.EntityData {

	public String PERNR; //사원 번호
	public String ENAME; //성명
	public String BEGDA; //시작일
	public String ENDDA; //종료일
	public String SCHKZ; //계획근무일정(코드)
	public String SCHKZ_TX; //계획근무일정(텍스트)
	public String NBEGDA; //변경-시작일
	public String NENDDA; //변경-종료일
	public String NSCHKZ; //변경-계획근무일정(코드)
	public String NSCHKZ_TX; //변경-계획근무일정(텍스트)
	public String ORGEH; //조직코드
	public String PERSG; //사원그룹
	public String SHORT; //조직약어(SORT용)
	public String ETC; //비고
	public String MSG; //오류메세지

	public String  OBJID;
	public String  CODE;
	public String  TEXT;

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
	public String getSCHKZ() {
		return SCHKZ;
	}
	public void setSCHKZ(String sCHKZ) {
		SCHKZ = sCHKZ;
	}
	public String getSCHKZ_TX() {
		return SCHKZ_TX;
	}
	public void setSCHKZ_TX(String sCHKZ_TX) {
		SCHKZ_TX = sCHKZ_TX;
	}
	public String getNBEGDA() {
		return NBEGDA;
	}
	public void setNBEGDA(String nBEGDA) {
		NBEGDA = nBEGDA;
	}
	public String getNENDDA() {
		return NENDDA;
	}
	public void setNENDDA(String nENDDA) {
		NENDDA = nENDDA;
	}
	public String getNSCHKZ() {
		return NSCHKZ;
	}
	public void setNSCHKZ(String nSCHKZ) {
		NSCHKZ = nSCHKZ;
	}
	public String getNSCHKZ_TX() {
		return NSCHKZ_TX;
	}
	public void setNSCHKZ_TX(String nSCHKZ_TX) {
		NSCHKZ_TX = nSCHKZ_TX;
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
	public String getOBJID() {
		return OBJID;
	}
	public void setOBJID(String oBJID) {
		OBJID = oBJID;
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




}

