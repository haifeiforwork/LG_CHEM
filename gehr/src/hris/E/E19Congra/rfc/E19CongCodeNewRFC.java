package hris.E.E19Congra.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E19Congra.*;

/**
 * E19CongCodeNewRFC.java
 * 경조내역 Code를 가져오는 RFC를 호출하는 Class      (돌반지제외)
 *
 * @author lsa
 * @version 1.0, 2005/12/29
 * update 20170703 eunha [CSR ID:3423281] 경조화환 복리후생 메뉴 추가
 */
public class E19CongCodeNewRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_P_CONGCOND_LIST";
	private String functionName = "ZGHR_RFC_P_CONGCOND_LIST";

    /**
     * 경조내역 Code를 가져오는 RFC를 호출하는 Method
     * @param companyCode java.lang.String 회사코드
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCongCode(String companyCode,String GubnCode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, companyCode,GubnCode);
            excute(mConnection, function);
            Vector ret = getOutput(function);
            Vector ret1 = new Vector();
            for ( int i = 0 ; i < ret.size() ; i++ ) {
            	  com.sns.jdf.util.CodeEntity data = (com.sns.jdf.util.CodeEntity)ret.get(i);
                if ( ! data.code.equals("0006") ) //돌반지제외함
                   ret1.addElement(data);
            }
            return ret1;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 eunha start
    public Vector getCongCode(String companyCode,String GubnCode, String isFlower) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, companyCode,GubnCode);
            excute(mConnection, function);
            Vector ret = getOutput(function);
            Vector ret1 = new Vector();
            for ( int i = 0 ; i < ret.size() ; i++ ) {
            	  com.sns.jdf.util.CodeEntity data = (com.sns.jdf.util.CodeEntity)ret.get(i);
                if ( ! data.code.equals("0006") ) {//돌반지제외함
                    if ("Y".equals(isFlower)) {
                	    if (  data.code.equals("0007") ||data.code.equals("0010") )    	  ret1.addElement(data);
                  }else{
                		if (  !data.code.equals("0007") && !data.code.equals("0010") )    	  ret1.addElement(data);
                  }
                }

             }

            return ret1;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    //[CSR ID:3423281] 경조화환 복리후생 메뉴 추가 20170703 eunha end
    /**
     * 경조내역 Code를 가져오는 RFC를 호출하는 Method(근태,휴가 전용-화환,재해 빠짐)
     * @param companyCode java.lang.String 회사코드
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCongCodeForRotaion(String companyCode,String GubnCode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, companyCode,GubnCode);
            excute(mConnection, function);
            Vector ret = getOutput(function);
            Vector ret1 = new Vector();
            for ( int i = 0 ; i < ret.size() ; i++ ) {
            	  com.sns.jdf.util.CodeEntity data = (com.sns.jdf.util.CodeEntity)ret.get(i);
                if ( ! data.code.equals("0005")&&! data.code.equals("0006")&&! data.code.equals("0007") ) //0005:재해 0006:돌반지 0007:화환
                   ret1.addElement(data);
            }
            return ret1;
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
    private void setInput(JCO.Function function, String companyCode,String GubnCode) throws GeneralException {
        String fieldName = "I_BUKRS";
        setField( function, fieldName, companyCode );
        String fieldName1 = "I_GUBUN";
        setField( function, fieldName1, GubnCode );
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String tableName = "T_RESULT";
        return getCodeVector( function, tableName);
    }

}


