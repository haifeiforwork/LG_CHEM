package hris.common.rfc;

import hris.common.PhoneNumData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

public class RepeatCheckRFC extends SAPWrap  {
	//private String functionName = "ZHRA_RFC_APPROVING_CHECK";
	private String functionName = "ZGHR_RFC_APPROVING_CHECK";

    public Vector checkApp(String bukrs,String pernr,String upmutype,String apprtype,String objps) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, bukrs,pernr,upmutype,apprtype,objps);
            excute(mConnection, function);
            Vector ret = getOutput(function);
            return ret;
        }catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function,String bukrs,String pernr,String upmutype,String apprtype,String objps) throws GeneralException {

        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, pernr );
        String fieldName2 = "I_BUKRS";
        setField( function, fieldName2, bukrs );
        String fieldName3 = "I_UPMU_TYPE";
        setField( function, fieldName3, upmutype );
        String fieldName4 = "I_APPR_TYPE";
        setField( function, fieldName4, apprtype );
        String fieldName5 = "I_OBJPS";
        setField( function, fieldName5, objps );

    }

    /**
     * RFC 실행후 Export 값을 Object 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param data java.lang.Object
     * @return java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	Vector sum = new Vector();

    	String APPROVAL   = getField("E_APPROVAL", function) ;
    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;
    	sum.addElement(APPROVAL);
    	sum.addElement(E_RETURN);
    	sum.addElement(E_MESSAGE);
		return sum;
    }
}
