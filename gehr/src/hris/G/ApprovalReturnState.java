/*
 * 작성된 날짜: 2005. 2. 4.
 *
*/
package hris.G;

import com.sns.jdf.EntityData;

/**
 * @author 이승희
 *
 */
public class ApprovalReturnState extends EntityData {

    public String E_AINF_SEQN;      // 결재정보 일련번호
    public String E_RETURN;         // CAD: 리턴코드    
    public String E_MESSAGE;        // CAD 다이얼로그 인터페이스에 대한 메세지텍스트   
    public String E_BELNR;          // 회계전표번호   

    public boolean isSuccess() {
        return "S".equals(E_RETURN);
    }

    public String getE_AINF_SEQN() {
        return E_AINF_SEQN;
    }

    public void setE_AINF_SEQN(String e_AINF_SEQN) {
        E_AINF_SEQN = e_AINF_SEQN;
    }

    public String getE_RETURN() {
        return E_RETURN;
    }

    public void setE_RETURN(String e_RETURN) {
        E_RETURN = e_RETURN;
    }

    public String getE_MESSAGE() {
        return E_MESSAGE;
    }

    public void setE_MESSAGE(String e_MESSAGE) {
        E_MESSAGE = e_MESSAGE;
    }

    public String getE_BELNR() {
        return E_BELNR;
    }

    public void setE_BELNR(String e_BELNR) {
        E_BELNR = e_BELNR;
    }
}
