package hris.D.D12Rotation ;

/**
 * D12RotationData.java
 * 일일근태정보(남경PI) 조회
 *   [관련 RFC] :  ZGHR_RFC_GET_DWD_NJ
 * @author
 * @version
 */
public class D12RotationCnData extends com.sns.jdf.EntityData {

    public String ORGEH	    ;    //Organizational Unit
    public String ORGTX		;    //Organizational Unit Text
    public String PERNR		;    //Personnel number
    public String ENAME		;    //Name
    public String TPROG		;    //Daily Work Schedule
    public String PL_BEG	;    //DWS.Begin Time
    public String PL_END	;    //DWS.End Time
    public String AC_BEG	;    //Act.Begin Time
    public String AC_END	;    //Act.End Time
    public String ZC_BEG	;    //Act.Begin Time(Gate)
    public String ZC_END	;    //Act.End Time(Gate)
    public String REMARK	;    //Remark
    public String OT1		    ;    //O/T(Night)
    public String OT2		    ;    //O/T(Workday)
    public String OT3		    ;    //O/T(Offday)
    public String OT4		    ;    //O/T(Holiday)
	public String AB_TEXT	;    //Absence
	public String AT_TEXT	;    //Attendance

	public String getORGEH() {
		return ORGEH;
	}
	public void setORGEH(String oRGEH) {
		ORGEH = oRGEH;
	}
	public String getORGTX() {
		return ORGTX;
	}
	public void setORGTX(String oRGTX) {
		ORGTX = oRGTX;
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
	public String getTPROG() {
		return TPROG;
	}
	public void setTPROG(String tPROG) {
		TPROG = tPROG;
	}
	public String getPL_BEG() {
		return PL_BEG;
	}
	public void setPL_BEG(String pL_BEG) {
		PL_BEG = pL_BEG;
	}
	public String getPL_END() {
		return PL_END;
	}
	public void setPL_END(String pL_END) {
		PL_END = pL_END;
	}
	public String getAC_BEG() {
		return AC_BEG;
	}
	public void setAC_BEG(String aC_BEG) {
		AC_BEG = aC_BEG;
	}
	public String getAC_END() {
		return AC_END;
	}
	public void setAC_END(String aC_END) {
		AC_END = aC_END;
	}
	public String getZC_BEG() {
		return ZC_BEG;
	}
	public void setZC_BEG(String zC_BEG) {
		ZC_BEG = zC_BEG;
	}
	public String getZC_END() {
		return ZC_END;
	}
	public void setZC_END(String zC_END) {
		ZC_END = zC_END;
	}
	public String getREMARK() {
		return REMARK;
	}
	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}
	public String getOT1() {
		return OT1;
	}
	public void setOT1(String oT1) {
		OT1 = oT1;
	}
	public String getOT2() {
		return OT2;
	}
	public void setOT2(String oT2) {
		OT2 = oT2;
	}
	public String getOT3() {
		return OT3;
	}
	public void setOT3(String oT3) {
		OT3 = oT3;
	}
	public String getOT4() {
		return OT4;
	}
	public void setOT4(String oT4) {
		OT4 = oT4;
	}
	public String getAB_TEXT() {
		return AB_TEXT;
	}
	public void setAB_TEXT(String aB_TEXT) {
		AB_TEXT = aB_TEXT;
	}
	public String getAT_TEXT() {
		return AT_TEXT;
	}
	public void setAT_TEXT(String aT_TEXT) {
		AT_TEXT = aT_TEXT;
	}

}
