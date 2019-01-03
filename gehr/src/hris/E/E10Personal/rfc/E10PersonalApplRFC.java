package	hris.E.E10Personal.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E10Personal.*;

/**
 * E10PersonalApplRFC.java
 * ���ο���/���̶����� ��û,����,��ȸ �ϴ� RFC�� ȣ���ϴ� class
 *
 * @author ������
 * @version 1.0, 2002/01/04
 */
public class E10PersonalApplRFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_PENTION_APPLICATION";

    /**
     * ���ο���/���̶����� ��û,����,��ȸ �ϴ� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �����Ϸù�ȣ 
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getPersList(String p_ainf_seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, p_ainf_seqn, "1", "1");
            
            excute(mConnection, function);
            
            Vector ret = getOutput(function);
            
            if( ret.size() > 0 ) {
                E10PersonalData data = (E10PersonalData)ret.get(0);
                
                data.MNTH_AMNT = Double.toString(Double.parseDouble(data.MNTH_AMNT) * 100.0 );
                data.PERL_AMNT = Double.toString(Double.parseDouble(data.PERL_AMNT) * 100.0 );
                data.CMPY_AMNT = Double.toString(Double.parseDouble(data.CMPY_AMNT) * 100.0 );
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
     * ���дɷ°�����û�� insert�ϴ� Method
     * @param java.lang.String �����Ϸù�ȣ java.util.Vector 
     * @exception com.sns.jdf.GeneralException
     */ 
    public void build(String p_ainf_seqn, Vector personal_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, p_ainf_seqn, "2" , "1");

            E10PersonalData data = (E10PersonalData)personal_vt.get(0);
            
            data.MNTH_AMNT = Double.toString(Double.parseDouble(data.MNTH_AMNT) / 100.0 );
            data.PERL_AMNT = Double.toString(Double.parseDouble(data.PERL_AMNT) / 100.0 );
            data.CMPY_AMNT = Double.toString(Double.parseDouble(data.CMPY_AMNT) / 100.0 );
            
            setInput(function, personal_vt, "IT");

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
     * @param java.lang.String �����Ϸù�ȣ java.util.Vector 
     * @exception com.sns.jdf.GeneralException
     */ 
    public void change(String p_ainf_seqn, Vector personal_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
                                    
            setInput(function, p_ainf_seqn,"3" ,"1");

            E10PersonalData data = (E10PersonalData)personal_vt.get(0);
            
            data.MNTH_AMNT = Double.toString(Double.parseDouble(data.MNTH_AMNT) / 100.0 );
            data.PERL_AMNT = Double.toString(Double.parseDouble(data.PERL_AMNT) / 100.0 );
            data.CMPY_AMNT = Double.toString(Double.parseDouble(data.CMPY_AMNT) / 100.0 );
            
            setInput(function, personal_vt, "IT");

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
     * @param java.lang.String �����Ϸù�ȣ 
     * @exception com.sns.jdf.GeneralException
     */ 
    public void delete( String p_ainf_seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
                        
            setInput(function, p_ainf_seqn,"4", "1" );

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
     * @param value java.lang.String �����Ϸù�ȣ java.lang.String �۾����� java.lang.String ���� �� Ż�𿩺� �ڵ� 
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function,String p_ainf_seqn, String jobcode, String p_appl_type ) throws GeneralException {
        String fieldName1 = "P_AINF_SEQN"          ;
        setField(function, fieldName1, p_ainf_seqn);
        
        String fieldName2 = "P_CONT_TYPE"          ;
        setField(function, fieldName2, jobcode)  ;
                
        String fieldName3 = "P_APPL_TYPE"      ;
        setField(function, fieldName3, p_appl_type);


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
        String entityName = "hris.E.E10Personal.E10PersonalData";
        String tableName  = "IT";
        return getTable(entityName, function, tableName);
    }
}


