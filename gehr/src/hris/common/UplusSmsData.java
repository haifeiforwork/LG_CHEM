package hris.common;
/**
 * UplusSmsData.java
 *  
 * [R3 table] : 경조금 화환신청시 SMS발송
 *
 * @author lsa
 * @version 1.0, 2014/04/28
 */
public class UplusSmsData extends com.sns.jdf.EntityData {
	public String TR_SENDSTAT;		//발송상태 0:발송대기,1: 전송완료,2:결과수신완료	
    public String TR_MSGTYPE;		//문자전송형태 0:일반,1:콜백URL 메세지
    public String TR_PHONE;			//수신할 핸드폰번호
    public String TR_CALLBACK;		//송신자 전화번호
    public String TR_MSG;				//메세지 
    
}
