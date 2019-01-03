package hris.E.E19Congra.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E19Congra.*;

/**
 * E19CongCodeNewRFC.java
 * �������� Code�� �������� RFC�� ȣ���ϴ� Class      (����������)
 *
 * @author lsa
 * @version 1.0, 2005/12/29
 * update 20170703 eunha [CSR ID:3423281] ����ȭȯ �����Ļ� �޴� �߰�
 */
public class E19CongCodeNewRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_P_CONGCOND_LIST";
	private String functionName = "ZGHR_RFC_P_CONGCOND_LIST";

    /**
     * �������� Code�� �������� RFC�� ȣ���ϴ� Method
     * @param companyCode java.lang.String ȸ���ڵ�
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
                if ( ! data.code.equals("0006") ) //������������
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
                if ( ! data.code.equals("0006") ) {//������������
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

    //[CSR ID:3423281] ����ȭȯ �����Ļ� �޴� �߰� 20170703 eunha end
    /**
     * �������� Code�� �������� RFC�� ȣ���ϴ� Method(����,�ް� ����-ȭȯ,���� ����)
     * @param companyCode java.lang.String ȸ���ڵ�
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
                if ( ! data.code.equals("0005")&&! data.code.equals("0006")&&! data.code.equals("0007") ) //0005:���� 0006:������ 0007:ȭȯ
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
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String companyCode,String GubnCode) throws GeneralException {
        String fieldName = "I_BUKRS";
        setField( function, fieldName, companyCode );
        String fieldName1 = "I_GUBUN";
        setField( function, fieldName1, GubnCode );
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


