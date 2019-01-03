package hris.common.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.A.A01PersonalZHRH012SData;
import hris.common.*;

/**
 * DecisionerRFC.java
 * 결재정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2001/12/13
 */
public class DecisionerRFC extends SAPWrap {

    private static String functionName = "ZGHR_RFC_FIND_DECISIONER";

    /**
     * 결재정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.Object hris.common.AppLineKey Object.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDecisioner( Object entity ) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, entity);
            excute(mConnection, function);
            Vector ret = getOutput(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    public Vector getDecisionerExt( Object entity ) throws GeneralException {
    	JCO.Client mConnection = null;
    	try{
    		mConnection = getClient();
    		JCO.Function function = createFunction(functionName) ;

    		setInput(function, entity);
    		excute(mConnection, function);
    		Vector ret = getOutputExt(function);

    		return ret;
    	} catch(Exception ex){
    		Logger.sap.println(this, "SAPException : "+ex.toString());
    		throw new GeneralException(ex);
    	} finally {
    		close(mConnection);
    	}
    }
    public Vector getDecisionerA( Object entity ) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, entity);
            excute(mConnection, function);
            Vector ret = getOutput1(function);

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
     * @param entity java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Object entity) throws GeneralException {
        setFields(function, entity);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.common.AppLineData";
        String tableName = "T_APPRLINE";
        return getTable(entityName, function, tableName, "APPL_");
    }

    private Vector getOutput1(JCO.Function function) throws GeneralException {
        String entityName = "hris.common.AppLineData";
        String tableName = "T_APPRLINE";
        Vector T_APPLINE = getTable(entityName, function, tableName, "APPL_");
        String E_PERNR  = getField("E_PERNR",  function);  // 신청자사번

        Vector ret = new Vector();

        ret.add(T_APPLINE);
        ret.addElement(E_PERNR);
        return ret;
    }
    private Vector getOutputExt(JCO.Function function) throws GeneralException {
    	String tableName = "T_APPRLINE";
    	Vector appLine_vt = getTable(AppLineData.class, function, tableName, "APPL_");
    	String shift =  getField("E_SHIFT", function);
    	Vector ret = new Vector();
    	ret.add(appLine_vt);
    	ret.add(shift);
    	return ret;
    }

}


