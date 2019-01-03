/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 경조금                                                      */
/*   Program Name : 경조금                                                      */
/*   Program ID   : E19CongLifnrByEnameRFC                                      */
/*   Description  : 성명에 해당하는 부서계좌정보를 가져오는  Class              */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_LIFNR_BY_ENAME                    */
/*   Creation     : 2005-12-07  lsa                                             */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.E.E19Congra.rfc;

import hris.E.E19Congra.E19CongLifnrByEnameData;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sap.mw.jco.*;

public class E19CongLifnrByEnameRFC extends SAPWrap {

    //private String functionName = "ZHRA_RFC_GET_LIFNR_BY_ENAME";
	private String functionName = "ZGHR_RFC_GET_LIFNR_BY_ENAME";

    /**
     * 부서계좌정보를 가져오는 RFC를 호출하는 Method
     * @param companyCode java.lang.String 회사코드
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getLifnr(String companyCode,  String empName, String BANKN, String SWITCH, String PERNR) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, companyCode, empName,BANKN,SWITCH,PERNR);
            excute(mConnection, function);
            Vector ret = new Vector();
            ret =  getTable(E19CongLifnrByEnameData.class, function, "T_RESULT");

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String companyCode, String empName, String BANKN, String SWITCH, String PERNR) throws GeneralException {
        String fieldName = "I_BUKRS";
        setField( function, fieldName, companyCode );
	fieldName = "I_ENAME";
	setField( function, fieldName, empName );
	fieldName = "I_BANKN";
	setField( function, fieldName, BANKN );
	fieldName = "I_SWITCH";     //1.이름으로 계정번호 찾기, 2.계정번호로 이름 찾기
	setField( function, fieldName, SWITCH );
	fieldName = "I_PERNR";     //로그인사번
	setField( function, fieldName, PERNR );

    }

}
