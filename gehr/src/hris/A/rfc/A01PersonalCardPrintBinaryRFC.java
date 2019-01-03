/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalCardPrintBinaryRFC                                          */
/*   Description  : 인사기록부 조회하는 RFC를 호출하는 Class (기존 A01PersonalCardRFC를 호출하지 않고,  SAP에서 PDF파일로 받아 출력할 수 있도록 수정                   */
/*   Creation     : 2014/05/30 이지은     [CSR ID:2553584] 인사기록부 출력 포맷 변경           */
/*                                                                              */
/********************************************************************************/

package hris.A.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import hris.A.*;

public class A01PersonalCardPrintBinaryRFC extends SAPWrap {

    private  static String functionName = "ZHRA_RFC_GET_PERSONAL_CARD_PDF";

    /**
     * 개인의 인사기록부 PDF정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getData( String empNo ,String screen, String LeaderPernr ) throws GeneralException {
        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo,screen,LeaderPernr);
            excute(mConnection, function);

            Vector ret = null;

            ret = getBinary(function);

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
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo ,String screen, String LeaderPernr ) throws GeneralException {  
        setField(function, "L_PERNR", empNo);
        
        // C20140210_84209 
        setField(function, "LOG_FLAG", screen);
        setField(function, "LOG_PERNR", LeaderPernr);        
    }
    
    /**
     * RFC 실행후 Binary Table을 Vector로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getBinary(JCO.Function function) throws GeneralException {
    	Vector result = new Vector();
    	result = getTable(function, "ET_LINES");
    	return result;
    }
}
