package hris.D.rfc;

 
import java.util.Vector;

 
import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D03RemainVocationRFC.java
 * ������ �ܿ��ް��ϼ� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/01/21
 */
public class D18HolidayCheckRFC extends SAPWrap {

//    private String functionName = "ZHRW_RFC_HOLIDAY_CHECK";
    private String functionName = "ZGHR_RFC_HOLIDAY_CHECK";
    
    /**
     * ������ �ܿ��ް��ϼ� ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @return hris.D.D03Vocation.D03RemainVocationData
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getRemainVocation(String P_PERNR, String AWART,String APPL_FROM,String APPL_TO,String BEGUZ,String ENDUZ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, P_PERNR, AWART,APPL_FROM,APPL_TO,BEGUZ,ENDUZ);
            
            excute(mConnection, function);
            Vector ret = getOutput(function);
            
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
    private void setInput(JCO.Function function, String P_PERNR, String AWART,String APPL_FROM,String APPL_TO, String BEGUZ , String ENDUZ) throws GeneralException {
        String fieldName1 = "I_PERNR"          ;
        setField(function, fieldName1, P_PERNR);
        String fieldName2 = "I_AWART"          ;
        setField(function, fieldName2, AWART);
        String fieldName3 = "I_BEGDA"          ;
        setField(function, fieldName3, APPL_FROM);
        String fieldName4 = "I_ENDDA"          ;
        setField(function, fieldName4, APPL_TO);
        
//        if(g.getSapType().isLocal()){
	        String fieldName5 = "E_BEGUZ"          ;
	        setField(function, fieldName5, BEGUZ);
	        String fieldName6 = "E_ENDUZ"          ;
	        setField(function, fieldName6, ENDUZ);
//        }
    }
 
	/**
	 * RFC �������� Import ���� setting �Ѵ�. com.sns.jdf.SAPWrap.excute(JCO.Client
	 * mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
	 * 
	 * @param function
	 *            com.sap.mw.jco.JCO.Function
	 * @param entityVector
	 *            java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */

	private Vector getOutput(JCO.Function function) throws GeneralException {
		D03VocationData data = new D03VocationData();
		//Object obj = getStructor(data, function, "ITAB");
		String  E_ABRTG=   getField("E_ABRTG", function);					// E_ABRTG �ϼ�
//		String  E_MESSAGE=   getField("E_MESSAGE", function);
		String  I_STDAZ=   getField("E_STDAZ", function);//I_STDAZ Absence hours
		String  I_ENDUZ=   getField("E_ENDUZ", function);//I_ENDUZ end time
		
		String  E_BEGUZ=   getField("E_BEGUZ", function);// start time
		String  E_VTKEN=   getField("E_VTKEN", function);
		String  E_BREAKS=   getField("E_BREAKS", function);
		Vector v = new Vector();
		v.addElement(E_ABRTG);
//		v.addElement(E_MESSAGE);
		v.addElement(I_STDAZ);
		v.addElement(I_ENDUZ);
		
		v.addElement(E_BEGUZ);
		v.addElement(E_VTKEN);
		v.addElement(E_BREAKS);
		return v;
	}
}