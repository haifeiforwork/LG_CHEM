package	hris.C.C04Ftest.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.C.C04Ftest.*;

/**
 * C04FtestFirstRFC.java
 * ������ ��û�� ���дɷ� ���� ������ �������� class
 *
 * @author ������
 * @version 1.0, 2002/01/04
 */
public class C04FtestListRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_LANGUAGE_LIST";

    /**
     * ������ ���дɷ°��� ��û ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �����ȣ java.lang.String �����ڵ� java.lang.String ������
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getFtestList(String empNo, String lang_code, String exam_date) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo,lang_code,exam_date, "1");
            
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
    
    /**
     * ���дɷ°�����û�� insert�ϴ� Method
     * @param java.lang.String �����ȣ java.lang.String �����ڵ� java.lang.String ������ java.util.Vector 
     * @exception com.sns.jdf.GeneralException
     */ 
    public void build(String empNo, String lang_code, String exam_date, Vector Language_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, lang_code, exam_date ,"2");

            setInput(function, Language_vt, "P_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
     /**
     * ��û�� �����͸� �����ϴ� Method
     * @param java.lang.String �����ȣ java.lang.String �����ڵ� java.lang.String ������ java.util.Vector 
     * @exception com.sns.jdf.GeneralException
     */ 
    public void change(String empNo, String lang_code, String exam_date, Vector Language_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            Logger.sap.println(this, "[[[lang_code : "+lang_code+" exam_date : "+exam_date);
            
            setInput(function, empNo, lang_code, exam_date,"3");

            setInput(function, Language_vt, "P_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
     /**
     * ��û�� �����͸� �����ϴ� Method
     * @param java.lang.String �����ȣ java.lang.String �����ڵ� java.lang.String ������ 
     * @exception com.sns.jdf.GeneralException
     */ 
    public void delete(String empNo, String lang_code, String exam_date) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
                        
            setInput(function, empNo, lang_code, exam_date,"4");

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
     * @param value java.lang.String ��� java.lang.String �����ڵ� java.lang.String ������ java.lang.String �۾�����
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function,String empNo, String LANG_CODE, String EXAM_DATE, String jobcode) throws GeneralException {
        String fieldName1 = "P_PERNR"          ;
        setField(function, fieldName1, empNo);
        
        String fieldName2 = "P_LANG_CODE"          ;
        setField(function, fieldName2, LANG_CODE)  ;
        
        String fieldName3 = "P_EXAM_DATE"      ;
        setField(function, fieldName3, EXAM_DATE);

        String fieldName4 = "P_COND_TYPE"      ;
        setField(function, fieldName4, jobcode);


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

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C04Ftest.C04FtestFirstData";
        String tableName  = "P_RESULT";
        return getTable(entityName, function, tableName);
    }
}
