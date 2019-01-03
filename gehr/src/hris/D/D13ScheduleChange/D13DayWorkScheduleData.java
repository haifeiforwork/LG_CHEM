package hris.D.D13ScheduleChange;

import com.sns.jdf.EntityData;

public class D13DayWorkScheduleData extends EntityData {
	public String TPROG;	//일일 근무 일정
	public String VARIA;	//일간근무일정 변형
	public String TTEXT;	//일일근무일정 텍스트
	public String SOLLZ;	//계획근무시간
	public String SOBEG;	//계획근무시간 시작
	public String SOEND;	//개획근무시간 종료
	public String getTPROG() {
		return TPROG;
	}
	public void setTPROG(String tPROG) {
		TPROG = tPROG;
	}
	public String getVARIA() {
		return VARIA;
	}
	public void setVARIA(String vARIA) {
		VARIA = vARIA;
	}
	public String getTTEXT() {
		return TTEXT;
	}
	public void setTTEXT(String tTEXT) {
		TTEXT = tTEXT;
	}
	public String getSOLLZ() {
		return SOLLZ;
	}
	public void setSOLLZ(String sOLLZ) {
		SOLLZ = sOLLZ;
	}
	public String getSOBEG() {
		return SOBEG;
	}
	public void setSOBEG(String sOBEG) {
		SOBEG = sOBEG;
	}
	public String getSOEND() {
		return SOEND;
	}
	public void setSOEND(String sOEND) {
		SOEND = sOEND;
	}
	
	
}
