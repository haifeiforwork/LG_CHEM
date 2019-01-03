package	hris.A.A12Family.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.A.A12Family.A12FamilyListData;

import java.util.Vector;

/**
 * A12FamilyListRFC.java
 * �������� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/01/28
 */
public class A12FamilyListRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_FAMILY_LIST";

    private String functionName1 = "HR_GET_ESS_SUBTYPES";

    /**
     * �������� ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<A12FamilyListData> getFamilyList(String empNo, String subty, String objps) throws GeneralException {
    
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, subty, objps, "1");
            excute(mConnection, function);

            return getTable(A12FamilyListData.class, function, "T_LIST");

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
       
    /**
     * �������� ���� �Է� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */ 
    public String build(String empNo, String subty, String objps, Vector familyListVector) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, subty, objps, "2");

            setInput(function, familyListVector, "T_LIST");

            excute(mConnection, function);
            
        	return getField("E_OBJPS", function) ;

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * �������� ���� ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void change(String empNo, String subty, String objps, Vector familyListVector) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, subty, objps, "3");

            setInput(function, familyListVector, "T_LIST");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * �������� ���� ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void delete(String empNo, String subty, String objps, Vector familyListVector) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, subty, objps, "4");
            
            setInput(function, familyListVector, "T_LIST");
            
            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String subty, String objps, String gubun) throws GeneralException {
        setField(function, "I_PERNR", empNo);
        setField(function, "I_SUBTY", subty);
        setField(function, "I_OBJPS", objps);
        setField(function, "I_GTYPE", gubun);
    }
    
// Import Parameter �� Vector(Table) �� ���
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }



    public Vector getFamilySubType(String molge) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName1) ;

            setField( function, "INFTY", "0021" );
            setField( function, "MOLGA", molge );
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

    private Vector getOutput1(JCO.Function function) throws GeneralException {
        String tableName = "SUBTYTAB";
        Vector ret       = new Vector();
        Vector temp_vt   = getCodeVector(function, tableName);

        for( int i=0 ; i < temp_vt.size() ; i++ ) {
            com.sns.jdf.util.CodeEntity ck = (com.sns.jdf.util.CodeEntity)temp_vt.get(i);

            if( ck.code.equals("8") ) {
                // ������ ���ܽ�Ų��.
            } else {
                ret.addElement(ck);
            }
        }

        Logger.sap.println(this, "��������(��������) : " + ret.toString());

        return ret;
    }
}