package	hris.D.D03Vocation.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D03Vocation.D03RemainVocationData;

/**
 * D03RemainVocationRFC.java
 * ������ �ܿ��ް��ϼ� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/01/21
 */
public class D03RemainVocationGlobalRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_REMAIN_HOLIDAY";//ZHRW_RFC_GET_REMAIN_HOLIDAY

    /**
     * ������ �ܿ��ް��ϼ� ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @return hris.D.D03Vocation.D03RemainVocationData
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getRemainVocation(String P_PERNR, String reqdate, String I_AWART) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, P_PERNR, reqdate, I_AWART);
            excute(mConnection, function);
            D03RemainVocationData data = new D03RemainVocationData();
    		Object obj = getStructor(data, function, "S_ITAB");//ITAB
    		Vector ret = new Vector();
    		ret.addElement(obj);
        	
          //  D03RemainVocationData ret = (D03RemainVocationData)getRemainOutput(function, (new D03RemainVocationData()));
          //  Logger.debug.println(this, ret.toString());

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
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String keycode, String reqdate, String I_AWART) throws GeneralException {
        
        setField(function, "I_PERNR", keycode);
        if (!reqdate.equals("")){
	        setField(function, "I_BEGDA" , reqdate);
        }
        setField(function,  "I_AWART"  , I_AWART);
    }

    /**
     * RFC ������ Export ���� String �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Object getRemainOutput(JCO.Function function, Object data) throws GeneralException {
        return getFields( data, function );
    }
	
}