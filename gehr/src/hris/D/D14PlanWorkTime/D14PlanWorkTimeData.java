package hris.D.D14PlanWorkTime;

import com.sns.jdf.EntityData;

public class D14PlanWorkTimeData extends EntityData {
	public String PERNR;	//사원 번호                     
	public String ENAME;	//사원 또는 지원자의 포맷된 이름
	public String BEGDA;	//시작일                        
	public String ENDDA;	//종료일                        
	public String SCHKZ;	//근무 일정 규칙                
	public String RTEXT;	//근무 일정 규칙에 대한 텍스트(계획 근무 시간 인포타입)
}
