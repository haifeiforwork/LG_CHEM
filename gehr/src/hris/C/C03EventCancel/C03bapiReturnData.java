/*
 * 작성된 날짜: 2005. 2. 4.
 *
*/
package  hris.C.C03EventCancel; 
import com.sns.jdf.EntityData;

/**
 * @author 이승희
 *
 */
public class C03bapiReturnData extends EntityData
{
    public String TYPE;          // 메시지 유형: S 성공, E 오류, W 경고, I 정보, A 중단 
    public String CODE;         // 리턴코드    
    public String MESSAGE;        //  메세지텍스트   

}
