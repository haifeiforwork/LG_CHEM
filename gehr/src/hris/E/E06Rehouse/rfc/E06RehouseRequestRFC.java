/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �����ڱ� ��ȯ��û                                           */
/*   Program Name : �����ڱ� ��ȯ��û                                           */
/*   Program ID   : E06RehouseRequestRFC                                        */
/*   Description  : ������ �����ڱ� ��ȯ ��û, ��ȸ, ����, ������ �� �� �ִ� Class */
/*   Note         : [���� RFC] : ZHRA_RFC_GET_FUND_REFUND_APP                   */
/*   Creation     : 2005-03-04  ������                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.E.E06Rehouse.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

public class E06RehouseRequestRFC extends SAPWrap {

    private String functionName = "ZHRA_RFC_GET_FUND_REFUND_APP";

    /**
     * ������ �����ڱ� ��ȯ��û ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector detail( String ainf_seqn ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, ainf_seqn, "1");
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
     * �����ڱ� ��ȯ��û RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param ainf_seqn java.lang.String �������� �Ϸù�ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public void build( String ainf_seqn, Vector rehouse_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);
            
            setInput(function, ainf_seqn, "2");
            setInput(function, rehouse_vt, "T_EXPORTA");
            
            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * �����ڱ� ��ȯ��û ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param ainf_seqn java.lang.String �������� �Ϸù�ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public void change(  String ainf_seqn, Vector rehouse_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, ainf_seqn, "3");
            setInput(function, rehouse_vt, "T_EXPORTA");

            excute(mConnection, function);
 
         } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * �����ڱ� ��ȯ��û ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param ainf_seqn java.lang.String �������� �Ϸù�ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public void delete( String ainf_seqn ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, ainf_seqn, "4");
            
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
     * @param ainf_seqn java.lang.String �������� �Ϸù�ȣ
     * @param conf_type java.lang.String ���ʽſ��� ����
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String ainf_seqn, String conf_type ) throws GeneralException {
        String fieldName  = "I_AINF";
        setField( function, fieldName, ainf_seqn );
        String fieldName2 = "I_CONF_TYPE";
        setField( function, fieldName2, conf_type );
    }

    // Import Parameter �� Vector(Table) �� ���
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
        String entityName = "hris.E.E06Rehouse.E06RehouseData";
        return getTable(entityName, function, "T_EXPORTA");
    }
}