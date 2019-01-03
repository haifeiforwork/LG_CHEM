package hris.common;
/**
 * ManageInfoData.java
 * 경조금,회갑관리담당자/FAQ 관리권한자
 * [관련 RFC] : ZHRA_RFC_GET_MANAGE_INFO
 *
 * @author 손혜영
 * @version 1.0, 2013/09/20
 */
public class ManageInfoData extends com.sns.jdf.EntityData {	public String MANDT;					//클라이언트
    public String ZMANAGER_GUBUN;	//업무구분
    public String PERNR;						//사원번호
    public String ENAME;					//사원 또는 지원자의 포맷된 이름
    public String EMAIL;						//통신: 긴 ID/번호
}
