/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 경조금                                                      */
/*   Program Name : 경조금                                                      */
/*   Program ID   : E19CongLifnrRFC                                             */
/*   Description  : 부서계좌정보를 가져오는  Class                              */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_LIFNR                             */
/*   Creation     : 2005-03-25  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.E.E19Congra.rfc;

import hris.E.E19Congra.E19CongcondData;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sap.mw.jco.*;

public class E19CongLifnrRFC extends SAPWrap {

    //private String functionName = "ZHRA_RFC_GET_LIFNR";
	private String functionName = "ZGHR_RFC_GET_LIFNR";

    /**
     * 부서계좌정보를 가져오는 RFC를 호출하는 Method
     * @param companyCode java.lang.String 회사코드
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getLifnr(String companyCode,  String empNo, String gubun) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, companyCode, empNo);
            excute(mConnection, function);
            Vector ret = new Vector();
            if( gubun == "2" ) {            // 부서공통은행코드,은행명
              ret = getTable(E19CongcondData.class, function, "T_RESULT");
			} else {
              ret = getCodeVector( function, "T_RESULT");
			}
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
    private void setInput(JCO.Function function, String companyCode, String empNo) throws GeneralException {
        String fieldName = "I_BUKRS";
        setField( function, fieldName, companyCode );
		fieldName = "I_PERNR";
		setField( function, fieldName, empNo );
    }

}
