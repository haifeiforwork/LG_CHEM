package hris.E.E19Congra.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E19Congra.*;

/**
 * E19CongCodeRFC.java
 * �������� Code�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2001/12/18
 * update 20170703 eunha [CSR ID:3423281] ����ȭȯ �����Ļ� �޴� �߰�
 */
public class E19CongCodeRFC extends SAPWrap {

   // private String functionName = "ZHRW_RFC_P_CONGCOND_LIST";
	private String functionName = "ZGHR_RFC_P_CONGCOND_LIST";

    /**
     * �������� Code�� �������� RFC�� ȣ���ϴ� Method
     * @param companyCode java.lang.String ȸ���ڵ�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCongCode(String companyCode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, companyCode);
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
     * �������� Code�� �������� RFC�� ȣ���ϴ� Method
     * @param companyCode java.lang.String ȸ���ڵ�
     * @param companyCode java.lang.String ������
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCongCode(String companyCode , String cong_data) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, companyCode);
            Logger.sap.println(this, "bumgeun cong_data : "+cong_data.toString());

            if ( cong_data != "") {
            	setField( function, "I_CONG_DATE", cong_data );
            	Logger.sap.println(this, "bumgeun_ex cong_data : "+cong_data.toString());

            }
            excute(mConnection, function);
            Vector ret = getOutput(function);
            Vector ret1 = new Vector();
            for ( int i = 0 ; i < ret.size() ; i++ ) {
            	  com.sns.jdf.util.CodeEntity data = (com.sns.jdf.util.CodeEntity)ret.get(i);
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

    //[CSR ID:3423281] ����ȭȯ �����Ļ� �޴� �߰� 20170703 eunha start
    public Vector getCongCode(String companyCode , String cong_data,  String isFlower) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, companyCode);
            Logger.sap.println(this, "bumgeun cong_data : "+cong_data.toString());

            if ( cong_data != "") {
            	setField( function, "I_CONG_DATE", cong_data );
            	Logger.sap.println(this, "bumgeun_ex cong_data : "+cong_data.toString());

            }
            excute(mConnection, function);
            Vector ret = getOutput(function);
            Vector ret1 = new Vector();
            for ( int i = 0 ; i < ret.size() ; i++ ) {
            	  com.sns.jdf.util.CodeEntity data = (com.sns.jdf.util.CodeEntity)ret.get(i);
                 // ret1.addElement(data);
                  if ("Y".equals(isFlower)) {
                	    if (  data.code.equals("0007") ||data.code.equals("0010") )    	  ret1.addElement(data);
                  }else{
                		if (  !data.code.equals("0007") && !data.code.equals("0010") )    	  ret1.addElement(data);
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
    //[CSR ID:3423281] ����ȭȯ �����Ļ� �޴� �߰� 20170703 eunha end
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String companyCode) throws GeneralException {
        String fieldName = "I_BUKRS";
        setField( function, fieldName, companyCode );
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String tableName = "T_RESULT";
        return getCodeVector( function, tableName);
    }
}


