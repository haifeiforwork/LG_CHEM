/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalCardRFC                                          */
/*   Description  : 인사기록부 조회하는 RFC를 호출하는 Class                    */
/*   Note         :                                                             */
/*   Creation     : 2005-01-12  윤정현                                          */
/*   Update       :  구분추가 C20140210_84209                            */
/*                                                                              */
/********************************************************************************/

package hris.A.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import hris.A.*;

public class A01PersonalCardRFC extends SAPWrap {

    private  static String functionName = "ZHRA_RFC_GET_PERSONAL_CARD";

    /**
     * 개인의 인사기록부 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     * @ 구분추가 CSR2014_9999
     */
    public Vector getPersonalDetail( String empNo ,String screen, String LeaderPernr ) throws GeneralException {
        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo,screen,LeaderPernr);
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
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo ,String screen, String LeaderPernr ) throws GeneralException {  // 5월 21일 순번 추가
        setField(function, "PERNR", empNo);
        
        // C20140210_84209 
        setField(function, "LOG_FLAG", screen);
        setField(function, "LOG_PERNR", LeaderPernr);

        
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

        A01PersonalZHRH001SData a01ZHRH001SData = new A01PersonalZHRH001SData();  // 인적사항
        A01PersonalZHRH010SData a01ZHRH010SData = new A01PersonalZHRH010SData();  // 인적사항
        A01PersonalZHRH012SData a01ZHRH012SData = new A01PersonalZHRH012SData();  // 병역사항

        Vector T_ZHRH002S = getTable( "hris.A.A01PersonalZHRH002SData", function, "T_ZHRH002S" );
        Vector T_ZHRH003S = getTable( "hris.A.A01PersonalZHRH003SData", function, "T_ZHRH003S" );
        Vector T_ZHRH004S = getTable( "hris.A.A01PersonalZHRH004SData", function, "T_ZHRH004S" );
        Vector T_ZHRH013S = getTable( "hris.A.A01PersonalZHRH013SData", function, "T_ZHRH013S" );
        Vector T_ZHRH014S = getTable( "hris.A.A01PersonalZHRH014SData", function, "T_ZHRH014S" );
        Vector T_ZHRH005S = getTable( "hris.A.A01PersonalZHRH005SData", function, "T_ZHRH005S" );
        Vector T_ZHRH006S = getTable( "hris.A.A01PersonalZHRH006SData", function, "T_ZHRH006S" );
        Vector T_ZHRH007S = getTable( "hris.A.A01PersonalZHRH007SData", function, "T_ZHRH007S" );
        Vector T_ZHRH008S = getTable( "hris.A.A01PersonalZHRH008SData", function, "T_ZHRH008S" );
       Vector T_ZHRH009S = getTable( "hris.A.A01PersonalZHRH009SData", function, "T_ZHRH009S" );
        Vector T_ZHRH011S = getTable( "hris.A.A01PersonalZHRH011SData", function, "T_ZHRH011S" ); 

        ret.addElement(T_ZHRH002S);
        ret.addElement(T_ZHRH003S);
        ret.addElement(T_ZHRH004S);
        ret.addElement(T_ZHRH013S);
        ret.addElement(T_ZHRH014S);
        ret.addElement(T_ZHRH005S);
        ret.addElement(T_ZHRH006S);
        ret.addElement(T_ZHRH007S);
        ret.addElement(T_ZHRH008S);
        ret.addElement(T_ZHRH009S);
        ret.addElement(T_ZHRH011S);

        // RFC Export Structor
        getStructor( a01ZHRH001SData, function, "E_ZHRH001S");
        getStructor( a01ZHRH010SData, function, "E_ZHRH010S");
        getStructor( a01ZHRH012SData, function, "E_ZHRH012S");

        ret.add(a01ZHRH001SData);
        ret.add(a01ZHRH010SData);
        ret.add(a01ZHRH012SData);

        
        // Export 변수 조회
        String E_BUKRS    = getField("E_BUKRS",    function);  // 회사코드
        String E_ISSUENUM = getField("E_ISSUENUM", function);  // 발행번호
        String E_ISSUDATE = getField("E_ISSUDATE", function);  // 발행일자
        String E_RETURN   = getField("E_RETURN",   function);  //  리턴코드
        String E_MESSAGE  = getField("E_MESSAGE",  function);  // 에러메시지

        ret.addElement(E_BUKRS);
        ret.addElement(E_ISSUENUM);
        ret.addElement(E_ISSUDATE);
        ret.addElement(E_RETURN);
        ret.addElement(E_MESSAGE); 

        return ret;
    }
}
