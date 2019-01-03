package hris.G.G20Outpt;

/**
 * 근로소득 원천징수 영수증을 발행하는 정보를 가지는 가족 Data
 * [관련 RFC] : ZHRP_RFC_READ_YEA_RESULT_PRIN
 * 
 * @author  
 * @version 
 */
public class G20EcmtPrintFamilyData extends com.sns.jdf.EntityData {
    					
    public String PERNR;			// 사원번호	
    public String SEQNR;			// 동일한 키가 있는 인포타입 레코드 번호	
    public String RELAT;			// relationship	관계
    public String REGNO;			// 등록 번호(한국)	주민번호
    public String FNAME;			// 사원 또는 지원자의 포맷이름	성명
    public String FOREI;			// Foreigner	내외국인코드
    public String ADDRE;			// Address	
    public String OLDID;			// 경로 부양자 추가공제	
    public String OLDII;			// 70세 이상의 부양가족	
    public String HNDID;			// 장애인에 대한 지시자	
    public String WOMEE;			// 부녀자세대주/맞벌이 여부	
    public String CHDID;			// 자녀보호비용을 위한 면제지시자	
    public String DPTID;			// 부양가족 구성원에 대한 지시자	
    public String INSID;			// 보험 지시자	
    public String MEDID;			// 의료비 지시자	
    public String EDUID;			// 교육비 지시자	
    public String CREID;			// 신용카드 등의 지시자	
    public String AGEID;			// 경로 부양자 추가공제	
    public String MULID;			// 자녀보호비용을 위한 면제지시자	
    public String BACHD;			// 자녀의 출산 및 입양에 대한 추가 공제	
    public String SUBTY;			// 하위유형	
    public String OBJPS;			// 오브젝트 ID	
    public String INSNA;			// 비용 정보(NTS)	
    public String INSOT;			// 비용 정보(기타 소스)	
    public String MEDNA;			// 의료비 금액(현금)	
    public String MEDOT;			// 의료비 금액(현금)	
    public String EDUNA;			// 비용 정보(NTS)	
    public String EDUOT;			// 비용 정보(기타 소스)	
    public String CRENA;			// 비용 정보(NTS)	
    public String CREOT;			// 비용 정보(기타 소스)	
    public String CASNA;			// 비용 정보(NTS)	
    public String CASOT;			// 비용 정보(기타 소스)	
    public String DONNA;			// 기부 금액	
    public String DONOT;			// 기부 금액	

}