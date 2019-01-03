/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : ��������                                               */
/*   2Depth Name  : �������� ������ȯ                                       */
/*   Program Name : �������� ������ȯ                        */
/*   Program ID   : E03RetireTransRFC                                         */
/*   Description  : ��������  ������ȯ ��û/��ȸ/����/����                       */
/*   Note         : [���� RFC] : ZSOLRP_RFC_PENS_CHANGE_REQ                                                 */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire.rfc;

import hris.E.E03Retire.E03RetireTransInfoData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

public class E03RetireTransRFC extends SAPWrap {

    private String functionName = "ZSOLRP_RFC_PENS_CHANGE_REQ";   

    /**
     * ������ȯ ��û������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     * ��ȸ�� ��û���� ����� �Է����� ���� - ����ȭ�鿡���� ��û���� ����� �𸣹Ƿ�..
     */
    public Vector detail(String ainf_seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, ainf_seqn, "", "1");
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
     * ������ȯ ������ ���� ��û�ϴ� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void build(String empNo, String ainf_seqn, Vector TransData_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

//            Logger.sap.println(this, "%%%%%%%%%%%%%%%%%%%%%%setRetireTrans%%%%%%%%%%%%%%%%%%%%%%");
//            Logger.sap.println(this, "ainf_seqn%%%%%%%%%%%%%%%%%%%%%%%%%%%%"+ainf_seqn);
//            Logger.sap.println(this, "empNo%%%%%%%%%%%%%%%%%%%%%%%%%%%%"+empNo);
//            Logger.sap.println(this, "TransData_vt%%%%%%%%%%%%%%%%%%%%%%%%%%%%"+TransData_vt.toString());
            
            setInput(function, ainf_seqn, empNo, "2");
            setInput(function, TransData_vt, "E_RESULT");
            excute(mConnection, function);
            E03RetireTransInfoData data = (E03RetireTransInfoData)getOutput(function, new E03RetireTransInfoData());
        	
        	//�����޽����� ���� üũ�ؼ� create �ȵǰ� �Ѵ�.
        	if(data.RETEXT.length() > 0){
        		throw new GeneralException(data.RETEXT);
        	}            
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * ������ȯ ������ ���� ��û �� �����ϴ� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void change(String empNo, String ainf_seqn, Vector TransData_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

//            Logger.sap.println(this, "%%%%%%%%%%%%%%%%%%%%%%setRetireTrans%%%%%%%%%%%%%%%%%%%%%%");
//            Logger.sap.println(this, "ainf_seqn%%%%%%%%%%%%%%%%%%%%%%%%%%%%"+ainf_seqn);
//            Logger.sap.println(this, "empNo%%%%%%%%%%%%%%%%%%%%%%%%%%%%"+empNo);
//            Logger.sap.println(this, "TransData_vt%%%%%%%%%%%%%%%%%%%%%%%%%%%%"+TransData_vt.toString());
            
            setInput(function, ainf_seqn, empNo, "3");
            setInput(function, TransData_vt, "E_RESULT");
            excute(mConnection, function);
            E03RetireTransInfoData data = (E03RetireTransInfoData)getOutput(function, new E03RetireTransInfoData());
        	
        	//�����޽����� ���� üũ�ؼ� create �ȵǰ� �Ѵ�.
        	if(data.RETEXT.length() > 0){
        		throw new GeneralException(data.RETEXT);
        	}            
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }    
    
    /**
     * ������ȯ ���� ��û������ �����ϴ� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector delete(String empNo, String ainf_seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, ainf_seqn, empNo, "4");

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
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String ainf_seqn, String empNo, String cont_type ) throws GeneralException {
        String fieldName1  = "I_AINF_SEQN";
        setField( function, fieldName1, ainf_seqn );
        String fieldName2 = "I_PERNR";
        setField( function, fieldName2, empNo );
        String fieldName3 = "I_CONT_TYPE";
        setField( function, fieldName3, cont_type );          
        
//        Logger.sap.println(this, "ainf_seqn===================="+ainf_seqn);
//        Logger.sap.println(this, "empNo===================="+empNo);
//        Logger.sap.println(this, "cont_type===================="+cont_type);
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
        String entityName = "hris.E.E03Retire.E03RetireTransInfoData";
        return getTable(entityName, function, "E_RESULT");
    }
    
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
        
    private Object getOutput(JCO.Function function, E03RetireTransInfoData data) throws GeneralException {
    	return getFields(data, function);
    }    
}