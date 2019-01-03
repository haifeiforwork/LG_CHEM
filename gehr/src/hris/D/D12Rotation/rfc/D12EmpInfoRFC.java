package hris.D.D12Rotation.rfc ;

import java.util.HashMap;
import java.util.Map;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D12EmpInfoRFC.java
 * ���������ȸ RFC�� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2009/02/10
 */
public class D12EmpInfoRFC extends SAPWrap {

   // private String functionName = "ZHRW_RFC_PERNR" ;
	 private String functionName = "ZGHR_RFC_PERNR" ;

    /**
     * ���������ȸ - �����ȣ�� RFC ȣ���ϴ� Method
     * @return java.util.Map
     * @exception com.sns.jdf.GeneralException
     */
    public Map  getEmpInfo( String pernr, String ename, String orgeh, String datum ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        	Logger.info.println("pernr : "+pernr);
        	Logger.info.println("ename : "+ename);
        	Logger.info.println("orgeh : "+orgeh);
        	Logger.info.println("datum : "+datum);
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;
            setInput( function, pernr, ename, orgeh, datum );

            excute( mConnection, function );

            Map ret = new HashMap();

        	// Export ���� ��ȸ

        	String E_RETURN   = getField("E_RETURN", function); //�����ڵ�
        	String E_MESSAGE  = getField("E_MESSAGE", function); // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
        	ret.put("E_RETURN",E_RETURN);
        	ret.put("E_MESSAGE",E_MESSAGE);

        	String E_PERNR   = getField("E_PERNR", function) ;
        	String E_ENAME  = getField("E_ENAME", function) ;
        	ret.put("E_PERNR",E_PERNR);
        	ret.put("E_ENAME",E_ENAME);

        	Logger.info.println("E_RETURN : "+E_RETURN);
        	Logger.info.println("E_MESSAGE : "+E_MESSAGE);
        	Logger.info.println("E_PERNR : "+E_PERNR);
        	Logger.info.println("E_ENAME : "+E_ENAME);

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
    private void setInput(JCO.Function function, String pernr, String ename, String orgeh, String datum) throws GeneralException {
    	setField(function, "I_ORGEH", orgeh);
        setField(function, "I_DATUM", datum);
        setField(function, "I_PERNR", pernr);
    	setField(function, "I_ENAME", ename);
    }



}