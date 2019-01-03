/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 주택자금 신규신청 부서장 결재                               */
/*   Program Name : 주택자금 신규신청 부서장 결재                               */
/*   Program ID   : LoanRFC                                                     */
/*   Description  : 결재시 대출상세내역 가져오기                                */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_LOAN_DETAIL                       */
/*   Creation     : 2005-03-10  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
package hris.G.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.G.*;

public class LoanRFC extends SAPWrap
{
    //private String functionName = "ZHRA_RFC_GET_LOAN_DETAIL";
    private String functionName = "ZGHR_RFC_GET_LOAN_DETAIL";

    /**
     * 대출상세내역 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector returnDetail( String pernr, String dlart, String darbt, String zahld ) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, pernr, dlart, darbt, zahld);
            excute(mConnection, function);

            Vector ret = null;

            ret = getOutput(function);

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * 대출상세내역 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Object getLoanDetail( String pernr, String dlart, String darbt, String zahld ) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, pernr, dlart, darbt, zahld);
            excute(mConnection, function);

            Object ret = null;
            ret = getStructor( new LoanData(), function, "S_EXPORT"); //.getOutput2(function,( new LoanData() ));
            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String 사원번호
     * @param value java.lang.String 대출유형
     * @param value java.lang.String 승인된 대출금액
     * @param value java.lang.String 지급일
     * @param value java.lang.String 상환년수
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String pernr, String dlart, String darbt, String zahld) throws GeneralException {
        String fieldName1  = "I_PERNR";
        setField(function, fieldName1, pernr);
        String fieldName2  = "I_DLART";
        setField(function, fieldName2, dlart);
        String fieldName3  = "I_DARBT";
        setField(function, fieldName3, darbt);
        String fieldName4  = "I_ZAHLD";
        setField(function, fieldName4, zahld);
        String fieldName5  = "I_ZZRPAY_CONT";
        setField(function, fieldName5, "");
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();

        // Export 변수 조회
        String fieldName1 = "E_RETURN";      // 리턴코드
        String E_RETURN   = getField(fieldName1, function) ;

        String fieldName2 = "E_MESSAGE";     // 다이얼로그 인터페이스에 대한 메세지텍스트
        String E_MESSAGE  = getField(fieldName2, function) ;

        ret.addElement(E_RETURN);
        ret.addElement(E_MESSAGE);

        return ret;
    }

    
}

